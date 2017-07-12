
module Lib.ToQuery.ToDmlClause (
    module Lib.ToQuery.ToDmlClause
  ) where

import Model.ModelBase
import Model.SubQuery
import Model.Format
import Command.CommandBase
import Command.FromSubQuery
import Command.FromFormat
import Lib.ToQuery.ToString

-- |
-- >>> toSelectColumns User SelectKSS ["1","name","address"]
-- "name, address"
-- >>> toSelectColumns Test SelectKSS ["1","id","name"]
-- "id_test, name"
-- >>> toSelectColumns Test UpdateKU ["1","name_test=AAA"]
-- "/**/"
--
toSelectColumns :: SubQuery -> Format -> StringList -> String
toSelectColumns sbq fmt ls = case lsS of
  [] -> "/**/"
  _ -> conLsCsp . fmap (toPrKey sbq) $ lsS
  where
    lsS = toInputValueLs [S] fmt ls

-- |
-- >>> toSelectForColumns Test UpdateKU ["1","name_test=AAA"]
-- "id_test, name_test"
-- >>> toSelectForColumns Test UpdateKU ["1","name_test = AAA"]
-- "id_test, name_test"
-- >>> toSelectForColumns Test UpdateKUU ["1","name_test=AAA","address_test=AAA"]
-- "id_test, name_test, address_test"
--
toSelectForColumns :: SubQuery -> Format -> StringList -> String
toSelectForColumns sbq fmt ls = case lsU of
  [] -> "/**/"
  _ -> conLsCsp . ((++) lsP) . fmap toColumnLs $ lsU
  where
    lsU = toInputValueLs [U] fmt ls
    lsP = toPrKeyLs sbq
    toColumnLs = (!! 0) . fmap unpack . splitOn (pack "=") . pack . filter ( /= ' ')

-- |
-- >>> toSetColumns Test UpdateKU ["1","name_test=AAA"]
-- "SET name_test = \"AAA\""
-- >>> toSetColumns Test SelectKS ["1","name"]
-- "/**/"
--
toSetColumns :: SubQuery -> Format -> StringList -> String
toSetColumns _ fmt ls = case lsU of
  [] -> "/**/"
  _ -> conLsSp [ "SET", conLsCsp . fmap toColumnEq $ lsU ]
  where lsU = toInputValueLs [U] fmt ls


