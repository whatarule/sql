
module Lib.ToQuery (module Lib.ToQuery
  ) where

import Model.ModelBase
import Model.SubQuery
import Model.Format
import Model.Query

import Command.CommandBase
import Command.FromSubQuery
import Command.FromFormat
import Lib.ToQuery.ToDmlClause
import Lib.ToQuery.ToWhereClause


-- |
-- >>> toQuery Test SelectKS ["1","name"]
-- "SELECT DISTINCT name FROM ( SELECT DISTINCT id_test, code_test, name_test AS name FROM TestTb ) AS Test WHERE id_test = \"1\" ORDER BY name ASC"
-- >>> toQuery Test UpdateKU ["1","name_test=AAA"]
-- "UPDATE TestTb SET name_test = \"AAA\"  WHERE id_test = \"1\""
-- >>> toQuery Test SelectForKU ["1","name_test=AAA"]
-- "SELECT DISTINCT id_test, name_test FROM TestTb WHERE id_test = \"1\" FOR UPDATE"
--
toQuery :: SubQuery -> Format -> StringList -> Query
toQuery sbq fmt ls = fromString . conLsSp $ [
    toDmlClause sbq fmt ls
  , toFromClause sbq fmt ls
  , toWhereClause sbq fmt ls
  ]


toDmlClause :: SubQuery -> Format -> StringList -> String
toDmlClause sbq fmt = conLsSp . toDmlClauseLs . toClauseInfo sbq fmt

-- |
-- >>> toFromClause Test SelectKS ["1","name"]
-- "FROM ( SELECT DISTINCT id_test, code_test, name_test AS name FROM TestTb ) AS Test"
--
toFromClause :: SubQuery -> Format -> StringList -> String
toFromClause sbq fmt = conLsSp . toFromClauseLs . toClauseInfo sbq fmt

toWhereClause:: SubQuery -> Format -> StringList -> String
toWhereClause sbq fmt ls = case lsKW of
  [] -> "/**/"
  _ -> conLsSp . toWhereClauseLs . toClauseInfo sbq fmt $ ls
  where lsKW = toInputValueLs [K,W] fmt ls



toClauseInfo :: SubQuery -> Format -> StringList -> ClauseInfo
toClauseInfo sbq fmt ls = case dml of
  Select -> ToClauseInfo [
      "SELECT DISTINCT"
    , toSelectColumns sbq fmt ls
    ] [ "FROM", toSbqString sbq
    ] [
      toWhereColumns sbq fmt ls
    , toOrderByString sbq fmt ls
    ]
  SelectForUpdate -> ToClauseInfo [
      "SELECT DISTINCT"
    , toSelectForColumns sbq fmt ls
    ] [ "FROM", show tbl
    ] [
      toWhereColumns sbq fmt ls
    , "FOR UPDATE"
    ]
  Update -> ToClauseInfo [
      "UPDATE", show tbl
    , toSetColumns sbq fmt ls
    ] [] [
      toWhereColumns sbq fmt ls
    ]
  NoDmlType -> ToClauseInfo [] [] []
  where
    dml = toDmlType fmt
    tbl = toTable sbq


