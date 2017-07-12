
module Command.FromSubQuery (module Command.FromSubQuery
  ) where

import Model.ModelBase
import Model.SubQuery
import Command.CommandBase

toColumnAs :: SubQuery -> String
toColumnAs = conLsCsp . toColumnAsLs . toSbqClauseInfo

toTableJoin :: SubQuery -> String
toTableJoin = conLsSp . toTableJoinLs . toSbqClauseInfo

-- |
-- >>> toSubQueryInfo Test
-- ToSubQueryInfo {toDB' = TestDB, toTable' = TestTb, toPrKeyLs' = ["id_test"], toSbqJoinLs' = []}
-- >>> toSubQueryInfo FriendObj
-- ToSubQueryInfo {toDB' = TestDB, toTable' = NoTable, toPrKeyLs' = ["id_obj_friend"], toSbqJoinLs' = [("id_sbj_friend",FriendFriend)]}
--
toSubQueryInfo :: SubQuery -> SubQueryInfo
toSubQueryInfo sbq = case sbq of
  Test -> ToSubQueryInfo TestDB
    TestTb ["id_test"] []
  User -> ToSubQueryInfo TestDB
    UserTb ["id_user"] [("code_gender", Gender)]
  Gender -> ToSubQueryInfo TestDB
    GenderTb ["code_ref_gender"] []
  Friend -> ToSubQueryInfo TestDB
    NoTable ["id_sbj_friend"] [("id_sbj_friend", FriendFriend)]
  FriendObj -> ToSubQueryInfo TestDB
    NoTable ["id_obj_friend"] [("id_sbj_friend", FriendFriend)]
  FriendFriend-> ToSubQueryInfo TestDB
    FriendFriendTb ["id_sbj_friend", "id_obj_friend"] []
  Student -> ToSubQueryInfo TestDB
    StudentTb ["id_student"] [("code_class", StudentClass)
    , ("id_student", TeacherStudent)]
  StudentObj -> ToSubQueryInfo TestDB
    StudentTb ["id_sbj_teacher"] [("code_class", StudentClass)
    , ("id_student", TeacherStudent)]
  StudentClass -> ToSubQueryInfo TestDB
    StudentClassTb ["code_ref_class"] []
  Teacher -> ToSubQueryInfo TestDB
    TeacherTb ["id_teacher"] [("code_subject", Subject)
    , ("id_teacher", TeacherStudent)]
  Subject -> ToSubQueryInfo TestDB
    SubjectTb ["code_ref_subject"] []
  TeacherStudent -> ToSubQueryInfo TestDB
    TeacherStudentTb ["id_sbj_teacher", "id_obj_student"] []
  NoSubQuery -> ToSubQueryInfo TestDB
    NoTable [] []
--  -> ToSubQueryInfo TestDB


toDB :: SubQuery -> DB
toDB = toDB' . toSubQueryInfo

toTable :: SubQuery -> Table
toTable = toTable' . toSubQueryInfo

toPrKeyLs :: SubQuery -> StringList
toPrKeyLs = toPrKeyLs' . toSubQueryInfo

toSbqJoinLs :: SubQuery -> ColumnSbqSetList
toSbqJoinLs = toSbqJoinLs' . toSubQueryInfo


-- |
-- >>> toSbqString Test
-- "( SELECT DISTINCT id_test, code_test, name_test AS name FROM TestTb ) AS Test"
-- >>> toSbqString User
-- "( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb INNER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User"
-- >>> toSbqString Friend
-- "( SELECT DISTINCT id_sbj_friend, id_obj_friend AS id_friend, name, gender, address, date_add, date_update FROM ( SELECT DISTINCT id_sbj_friend, id_obj_friend FROM FriendFriendTb UNION SELECT DISTINCT id_obj_friend AS id_sbj_friend, id_sbj_friend AS id_obj_friend FROM FriendFriendTb ) AS FriendFriend LEFT OUTER JOIN ( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb INNER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User ON id_sbj_friend = id_user ) AS Friend"
-- >>> toSbqString FriendObj
-- "( SELECT DISTINCT id_obj_friend, id_sbj_friend AS id_friend, name, gender, address, date_add, date_update FROM ( SELECT DISTINCT id_sbj_friend, id_obj_friend FROM FriendFriendTb UNION SELECT DISTINCT id_obj_friend AS id_sbj_friend, id_sbj_friend AS id_obj_friend FROM FriendFriendTb ) AS FriendFriend LEFT OUTER JOIN ( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb INNER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User ON id_sbj_friend = id_user ) AS FriendObj"
-- >>> toSbqString Student
-- "( SELECT DISTINCT id_student, name_class AS class, id_sbj_teacher AS id_teacher, name, gender, address, date_add, date_update FROM StudentTb INNER JOIN ( SELECT DISTINCT code_ref_class, name_class FROM StudentClassTb WHERE active_class = \"ACTIVE\" ) AS StudentClass ON code_class = code_ref_class LEFT OUTER JOIN ( SELECT DISTINCT id_sbj_teacher, id_obj_student FROM TeacherStudentTb ) AS TeacherStudent ON id_student = id_obj_student LEFT OUTER JOIN ( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb INNER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User ON id_student = id_user ) AS Student"
--
toSbqString :: SubQuery -> String
toSbqString sbq = conLsSp [
    "(", "SELECT DISTINCT", toColumnAs sbq
  , "FROM", toTableJoin sbq
  , ")", "AS", show sbq
  ]
  where tbl = toTable $ sbq

toSbqClauseInfo :: SubQuery -> SbqClauseInfo
toSbqClauseInfo sbq = case sbq of
  Test -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "code_test"
    , "name_test AS name"
    ] [toTableString sbq]
  User -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "name_user AS name"
    , "name_gender AS gender"
    , "address AS address"
    , "date_add AS date_add"
    , "date_update AS date_update"
    ] [
      toTableString sbq
    , "INNER JOIN", toSbqString Gender
    ,   "ON code_gender = code_ref_gender"
    ]
  Gender -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "name_gender"
    ] [toTableString sbq]
  Friend -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "id_obj_friend AS id_friend"
    , "name", "gender", "address", "date_add", "date_update"
    ] [
      toSbqString FriendFriend
    , "LEFT OUTER JOIN", toSbqString User
    ,   "ON id_sbj_friend = id_user"
    ]
  FriendObj -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "id_sbj_friend AS id_friend"
    , "name", "gender", "address", "date_add", "date_update"
    ] [
      toSbqString FriendFriend
    , "LEFT OUTER JOIN", toSbqString User
    ,   "ON id_sbj_friend = id_user"
    ]
  FriendFriend -> ToSbqClauseInfo [
      toPrKeyString sbq
    ] [
      toTableString sbq, "UNION"
    , "SELECT DISTINCT"
    , conLsCsp [
        "id_obj_friend AS id_sbj_friend"
      , "id_sbj_friend AS id_obj_friend"
      ]
    , "FROM", toTableString sbq
    ]
  Student -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "name_class AS class"
    , "id_sbj_teacher AS id_teacher"
    , "name", "gender", "address", "date_add", "date_update"
    ] [
      toTableString sbq
    , "INNER JOIN", toSbqString StudentClass
    ,   "ON code_class = code_ref_class"
    , "LEFT OUTER JOIN", toSbqString TeacherStudent
    ,   "ON id_student = id_obj_student"
    , "LEFT OUTER JOIN", toSbqString User
    ,   "ON id_student = id_user"
    ]
  StudentObj -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "id_obj_student AS id_student"
    , "name_class AS class"
    , "name", "gender", "address", "date_add", "date_update"
    ] [
      toTableString sbq
    , "INNER JOIN", toSbqString StudentClass
    ,   "ON code_class = code_ref_class"
    , "LEFT OUTER JOIN", toSbqString TeacherStudent
    ,   "ON id_student = id_obj_student"
    , "LEFT OUTER JOIN", toSbqString User
    ,   "ON id_student = id_user"
    ]
  StudentClass -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "name_class"
    ] [
      toTableString sbq
    , "WHERE active_class = \"ACTIVE\""
    ]
  Teacher -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "name_subject"
    , "id_obj_student AS id_student"
    , "name", "gender", "address", "date_add", "date_update"
    ] [
      toTableString sbq
    , "INNER JOIN", toSbqString Subject
    ,   "ON code_subject = code_ref_subject"
    , "LEFT OUTER JOIN", toSbqString TeacherStudent
    ,   "ON id_teacher = id_sbj_teacher"
    , "LEFT OUTER JOIN", toSbqString User
    ,   "ON id_teacher = id_user"
    ]
  Subject -> ToSbqClauseInfo [
      toPrKeyString sbq
    , "name_subject"
    ] [toTableString sbq]
  TeacherStudent -> ToSbqClauseInfo [
      toPrKeyString sbq
    ] [toTableString sbq]
  NoSubQuery -> ToSbqClauseInfo [] []
  where
    toPrKeyString = conLsCsp . toPrKeyLs
    toTableString = show . toTable

