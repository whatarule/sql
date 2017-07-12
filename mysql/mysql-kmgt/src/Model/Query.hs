
module Model.Query (module Model.Query
  , Query
  ) where

import Model.ModelBase
import Model.Format
import Database.MySQL.Simple (Query)

data ClauseInfo = ToClauseInfo {
    toDmlClauseLs :: StringList
  , toFromClauseLs :: StringList
  , toWhereClauseLs :: StringList
  }
  deriving (Show)


type DmlQuerySet = (DmlType, Query)
type DmlQuerySetList = [(DmlType, Query)]


