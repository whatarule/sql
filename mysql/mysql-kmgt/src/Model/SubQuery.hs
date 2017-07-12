
module Model.SubQuery (module Model.SubQuery
  ) where

import Model.ModelBase

data SubQuery = NoSubQuery | Test
  | User | Gender
  | Friend | FriendObj | FriendFriend
  | Student | TeacherObj | StudentClass
  | Teacher | StudentObj | Subject
  | TeacherStudent
  deriving (Show, Read)
type SubQueryList = [SubQuery]

data SubQueryInfo = ToSubQueryInfo {
    toDB' :: DB
  , toTable' :: Table
  , toPrKeyLs' :: ColumnList
  , toSbqJoinLs' :: ColumnSbqSetList
  }
  deriving (Show)
type Column = String
type ColumnList = [String]
type ColumnSbqSet = (Column, SubQuery)
type ColumnSbqSetList = [(Column, SubQuery)]

data DB = TestDB
  deriving (Show, Read)
data Table = NoTable | TestTb
  | UserTb | GenderTb
  | FriendFriendTb
  | StudentTb | StudentClassTb
  | TeacherTb | SubjectTb
  | TeacherStudentTb
  deriving (Show, Read)

data SbqClauseInfo = ToSbqClauseInfo {
    toColumnAsLs :: StringList
  , toTableJoinLs :: StringList
  } deriving (Show)


