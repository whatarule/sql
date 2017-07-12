
module Lib.ToQuery.ToWhereClause (
    module Lib.ToQuery.ToWhereClause
  ) where

import Model.ModelBase
import Model.SubQuery
import Model.Format
import Command.CommandBase
import Command.FromSubQuery
import Command.FromFormat
import Lib.ToQuery.ToString


-- |
-- >>> toWhereColumns Test SelectKS ["1","name"]
-- "WHERE id_test = \"1\""
-- >>> toWhereColumns Test SelectS ["name"]
-- "/**/"
--
-- >>> toWhereColumns Student SelectKWS ["1","class=3-B", "name"]
-- "WHERE id_student = \"1\" AND class = \"3-B\""
-- >>> toWhereColumns Student SelectWWS ["id_teacher=1","class=3-B", "name"]
-- "WHERE id_teacher = \"1\" AND class = \"3-B\""
-- >>> toWhereColumns Test UpdateKU ["1","name_test=AAA"]
-- "WHERE id_test = \"1\""
--
toWhereColumns :: SubQuery -> Format -> StringList -> String
toWhereColumns sbq fmt ls = case lsKW of
  [] -> "/**/"
  _ -> conLsSp [ "WHERE", conLsAnd [
        conLsAnd . fmap toEqual . zip lsP $ lsK
      , conLsAnd . fmap toColumnEq $ lsW
      ] ]
  where
    lsKW = toInputValueLs [K,W] fmt ls
    lsK = toInputValueLs [K] fmt ls
    lsW = toInputValueLs [W] fmt ls
    lsP = toPrKeyLs $ sbq
    toEqual (x, y) = conLsSp [x, "=", show y]

-- |
-- >>> toOrderByString Test SelectKS ["1","name"]
-- "ORDER BY name ASC"
--
toOrderByString :: SubQuery -> Format -> StringList -> String
toOrderByString sbq fmt ls = case lsS of
  [] -> "/**/"
  _ -> conLsSp ["ORDER BY", conLsCsp lsS, "ASC"]
  where lsS = fmap (toPrKey sbq) . toInputValueLs [S] fmt $ ls




