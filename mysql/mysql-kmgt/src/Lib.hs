
module Lib (module Lib
  , toValueLs
  , module Model
  , module Command
  ) where

import Model
import Command
import Lib.ToQuery
import Lib.ToValueList


-- |
-- >>> toInputInfoEi "Test; SelectKS; (1,name)"
-- Right (InputInfo {toSubQuery = Test, toFormat = SelectKS, toInputString = "(1,name)"})
--
toInputInfoEi :: String -> Either ErrMsg InputInfo
toInputInfoEi str = InputInfo <$> sbqEi <*> fmtEi <*> strInEi where
  sbqEi = (read <$>) . (lookupEi SubQuery =<<) $ lsEi :: Either ErrMsg SubQuery
  fmtEi = (read <$>) . (lookupEi Format =<<) $ lsEi :: Either ErrMsg Format
  strInEi = lookupEi InputString =<< lsEi
  lsEi = (zip (toInfoFormatFieldList InputInfoFormat) <$>) .  toInputLsEi $ str
  toInputLsEi = fromEitherParseError
    . parse (semiSep $ many (alphaNum <|> oneOf "(,)_-=")) ""

-- |
-- >>> toSubQueryR Test SelectKS ["1","name"]
-- Test
-- >>> toSubQueryR NoSubQuery SelectKRS ["8","friends","name"]
-- FriendObj
--
toSubQueryR :: SubQuery -> Format -> StringList -> SubQuery
toSubQueryR sbq fmt lsV = case rel of
  "friends" -> FriendObj
  "students" -> StudentObj
  "teachers" -> TeacherObj
  _ -> sbq
  where
    rel = conLsSp . toInputValueLs [R] fmt $ lsV
    lsR = toInputValueLs []
    lsT = toInputFieldTypeLs $ fmt

-- |
-- >>> toValidInputValueLsEi SelectKS "(1,name)"
-- Right ["1","name"]
-- >>> toValidInputValueLsEi SelectKS "(1,name!)"
-- Left ["(line 1, column 8):\nunexpected \"!\"\nexpecting \",\" or \")\""]
-- >>> toValidInputValueLsEi SelectKS "(1,name,address)"
-- Left ["list length"]
--
toValidInputValueLsEi :: Format -> InputString -> Either ErrMsg StringList
toValidInputValueLsEi fmt str =
  lengthEi (length . toInputFieldTypeLs $ fmt)
  <=< parseInputStringEi $ str


-- |
-- >>> (mapM_ print $) . toDmlQuerySetList Test SelectKS $ ["1","name"]
-- (Select,"SELECT DISTINCT name FROM ( SELECT DISTINCT id_test, code_test, name_test AS name FROM TestTb ) AS Test WHERE id_test = \"1\" ORDER BY name ASC")
-- >>> (mapM_ print $) . toDmlQuerySetList Test UpdateKU $ ["1","name_test=AAA"]
-- (SelectForUpdate,"SELECT DISTINCT id_test, name_test FROM TestTb WHERE id_test = \"1\" FOR UPDATE")
-- (Update,"UPDATE TestTb SET name_test = \"AAA\"  WHERE id_test = \"1\"")
-- >>> (mapM_ print $) . toDmlQuerySetList Test SelectForKU $ ["1","name_test=AAA"]
-- (NoDmlType,"/**/")
--
toDmlQuerySetList :: SubQuery -> Format -> StringList -> DmlQuerySetList
toDmlQuerySetList sbq fmt ls = case dml of
  Select -> [ (dml, toQuery sbq fmt ls) ]
  Update -> [ (dmlF, toQuery sbq fmtF ls)
            , (dml, toQuery sbq fmt ls) ]
  _ -> [ (NoDmlType, fromString "/**/")]
  where
    dml = toDmlType fmt
    fmtF = toFormatSelectFor fmt
    dmlF = toDmlType fmtF


toQuantSelect :: SubQuery -> Format -> StringList -> Int
toQuantSelect sbq fmt ls = case toDmlType fmt of
  Select -> length $ lsS
  Update -> length . ((++) lsP) $ lsU
  SelectForUpdate -> length . ((++) lsP) $ lsS
  where
    lsS = toInputValueLs [S] fmt ls
    lsU = toInputValueLs [U] fmt ls
    lsP = toPrKeyLs sbq


