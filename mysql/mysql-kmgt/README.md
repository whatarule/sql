Database management system for MySQL
=
- Able to execute SQL-select and update with a string input along the format

### Examples
```
- "Test; SelectS; (name)"
  -> [["aaa"],["bbb"],["ccc"]]
- "Test; SelectKS; (1,name)"
  -> [["aaa"]]
- "User; SelectKSS; (1,id,name)"
  -> [["1","aaa"]]
- "Friend; SelectWS; (id_friend=8,name)"
  -> [["friend_b"],["friend_c"]]
- "Friend; SelectWSS; (id_friend=8,id,name)"
  -> [["9","friend_b"],["10","friend_c"]]
- "Student; SelectWSS; (id_teacher=11,name,class)"
  -> [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
- "Student; SelectWWS; (id_teacher=11,class=3-B,name)"
  -> [["student_b"]]
- "Student; SelectWWSS; (id_teacher=11,class=3-B,id,name)"
  -> [["13","student_b"]]

- "FriendObj; SelectKS; (8,name)"
  -> [["friend_b"],["friend_c"]]
- "FriendObj; SelectKSS; (8,id_friend,name)"
  -> [["9","friend_b"],["10","friend_c"]]
- "StudentObj; SelectKSS; (11,name,class)"
  -> [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
- "StudentObj; SelectKWS; (11,class=3-B,name)"
  -> [["student_b"]]
- "StudentObj; SelectKWSS; (11,class=3-B,id_student,name)"
  -> [["13","student_b"]]

- "NoSubQuery; SelectKRS; (8,friends,name)"
  -> [["friend_b"],["friend_c"]]
- "NoSubQuery; SelectKRSS; (8,friends,id_friend,name)"
  -> [["9","friend_b"],["10","friend_c"]]
- "NoSubQuery; SelectKRSS; (11,students,name,class)"
  -> [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
- "NoSubQuery; SelectKRWS; (11,students,class=3-B,name)"
  -> [["student_b"]]
- "NoSubQuery; SelectKRWSS; (11,students,class=3-B,id_student,name)"
  -> [["13","student_b"]]

- "Test; SelectKSS; (1,name,code_test)"
  -> [["aaa","A"]]
- "Test; UpdateKU; (1,name_test=AAA)"
  -> [["1","aaa"]]
  -> done: update
- "Test; UpdateKU; (1,code_test=Z)"
  -> [["1","A"]]
  -> done: update
- "Test; SelectKSS; (1,name,code_test)"
  -> [["AAA","Z"]]
- "Test; UpdateKUU; (1,name_test=aaa,code_test=A)"
  -> [["1","AAA","Z"]]
  -> done: update
- "Test; SelectKSS; (1,name,code_test)"
  -> [["aaa","A"]]
```

## [Sample data][sql]

### tables
- [sql/table][table]

[sql]: https://github.com/whatarule/sql/tree/master/mysql/mysql-kmgt/sql
[table]: https://github.com/whatarule/sql/tree/master/mysql/mysql-kmgt/sql/table


[info]: https://github.com/whatarule/sql/blob/master/mysql/mysql-kmgt/src/Model/InputInfo.hs


## Input string format

[format]: https://github.com/whatarule/sql/blob/master/mysql/mysql-kmgt/src/Model/Format.hs

```haskell
-- |
-- KS : "(1, name)", "(8, id_friend)"
-- KWS : "(11, class=3-B, id_student)"
-- WS : "(id_friend=8, name)"
-- WWS : "(id_teacher=14, class=3-B, name)"
-- KRS : "(8,friends,name)"
-- KRWS : "(11,students,class=3-B,name)"
-- KU : "(1, name=AAA)"
--
data Format = SelectS
  | SelectKS | SelectKSS
  | SelectWS | SelectWSS
  | SelectWWS | SelectWWSS
  | SelectKWS | SelectKWSS
  | SelectKRS | SelectKRSS
  | SelectKRWS | SelectKRWSS
  | UpdateKU | SelectForKU
  | UpdateKUU | SelectForKUU
  deriving (Show, Read)
```
[on "src/Model/Format.hs"][format]

```haskell
-- |
-- K : primary "K"ey
-- W : column and value for "W"here cause
-- S : column for "S"elect clause
-- U : column and value for "U"pdate
-- R : "R"elatioin
--
data InputFieldType = K | W | S | U | R
  deriving (Show, Eq)
```
[on "src/Model/Format.hs"][format]


## Main function
[app/Main.hs][main]

[main]: https://github.com/whatarule/sql/blob/master/mysql/mysql-kmgt/app/Main.hs

### main
```haskell
main :: IO ()
main = do
  str <- getLine
  mainIO $ str
```
[on "app/Main.hs"][main]

### mainIO
```haskell
mainIO :: String -> IO ()
-- |
-- >>> mainIO "Test; SelectS; (name)"
-- [["aaa"],["bbb"],["ccc"]]
-- >>> mainIO "Test; SelectKS; (1,name)"
-- [["aaa"]]
-- >>> mainIO "User; SelectKSS; (1,id,name)"
-- [["1","aaa"]]
-- >>> mainIO "Friend; SelectWS; (id_friend=8,name)"
-- [["friend_b"],["friend_c"]]
-- >>> mainIO "Friend; SelectWSS; (id_friend=8,id,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "Student; SelectWSS; (id_teacher=11,name,class)"
-- [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
-- >>> mainIO "Student; SelectWWS; (id_teacher=11,class=3-B,name)"
-- [["student_b"]]
-- >>> mainIO "Student; SelectWWSS; (id_teacher=11,class=3-B,id,name)"
-- [["13","student_b"]]
--
-- >>> mainIO "FriendObj; SelectKS; (8,name)"
-- [["friend_b"],["friend_c"]]
-- >>> mainIO "FriendObj; SelectKSS; (8,id_friend,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "StudentObj; SelectKSS; (11,name,class)"
-- [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
-- >>> mainIO "StudentObj; SelectKWS; (11,class=3-B,name)"
-- [["student_b"]]
-- >>> mainIO "StudentObj; SelectKWSS; (11,class=3-B,id_student,name)"
-- [["13","student_b"]]
--
-- >>> mainIO "NoSubQuery; SelectKRS; (8,friends,name)"
-- [["friend_b"],["friend_c"]]
-- >>> mainIO "NoSubQuery; SelectKRSS; (8,friends,id_friend,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "NoSubQuery; SelectKRSS; (11,students,name,class)"
-- [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
-- >>> mainIO "NoSubQuery; SelectKRWS; (11,students,class=3-B,name)"
-- [["student_b"]]
-- >>> mainIO "NoSubQuery; SelectKRWSS; (11,students,class=3-B,id_student,name)"
-- [["13","student_b"]]
--
-- >>> mainIO "Test; SelectKSS; (1,name,code_test)"
-- [["aaa","A"]]
-- >>> mainIO "Test; UpdateKU; (1,name_test=AAA)"
-- [["1","aaa"]]
-- done: update
-- >>> mainIO "Test; UpdateKU; (1,code_test=Z)"
-- [["1","A"]]
-- done: update
-- >>> mainIO "Test; SelectKSS; (1,name,code_test)"
-- [["AAA","Z"]]
-- >>> mainIO "Test; UpdateKUU; (1,name_test=aaa,code_test=A)"
-- [["1","AAA","Z"]]
-- done: update
-- >>> mainIO "Test; SelectKSS; (1,name,code_test)"
-- [["aaa","A"]]
--
```
[on "app/Main.hs"][main]


## Query

[query]: https://github.com/whatarule/sql/blob/master/mysql/mysql-kmgt/src/Lib/ToQuery.hs

```haskell
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
```
[on "src/Lib/ToQuery.hs"][query]


## Subquery

[subquery]: https://github.com/whatarule/sql/blob/master/mysql/mysql-kmgt/src/Command/FromSubQuery.hs

```haskell
-- |
-- >>> toSbqString Test
-- "( SELECT DISTINCT id_test, code_test AS code, name_test AS name FROM TestTb ) AS Test"
-- >>> toSbqString User
-- "( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb LEFT OUTER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User"
-- >>> toSbqString Friend
-- "( SELECT DISTINCT id_sbj_friend, id_obj_friend AS id_friend, name, gender, address, date_add, date_update FROM ( SELECT DISTINCT id_sbj_friend, id_obj_friend FROM FriendFriendTb UNION SELECT DISTINCT id_obj_friend AS id_sbj_friend, id_sbj_friend AS id_obj_friend FROM FriendFriendTb ) AS FriendFriend LEFT OUTER JOIN ( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb LEFT OUTER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User ON id_sbj_friend = id_user ) AS Friend"
-- >>> toSbqString FriendObj
-- "( SELECT DISTINCT id_obj_friend, id_sbj_friend AS id_friend, name, gender, address, date_add, date_update FROM ( SELECT DISTINCT id_sbj_friend, id_obj_friend FROM FriendFriendTb UNION SELECT DISTINCT id_obj_friend AS id_sbj_friend, id_sbj_friend AS id_obj_friend FROM FriendFriendTb ) AS FriendFriend LEFT OUTER JOIN ( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb LEFT OUTER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User ON id_sbj_friend = id_user ) AS FriendObj"
-- >>> toSbqString Student
-- "( SELECT DISTINCT id_student, name_class AS class, id_sbj_teacher AS id_teacher, name, gender, address, date_add, date_update FROM StudentTb LEFT OUTER JOIN ( SELECT DISTINCT code_ref_class, name_class FROM StudentClassTb WHERE active_class = \"ACTIVE\" ) AS StudentClass ON code_class = code_ref_class LEFT OUTER JOIN ( SELECT DISTINCT id_sbj_teacher, id_obj_student FROM TeacherStudentTb ) AS TeacherStudent ON id_student = id_obj_student LEFT OUTER JOIN ( SELECT DISTINCT id_user, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb LEFT OUTER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender ) AS User ON id_student = id_user ) AS Student"
--
toSbqString :: SubQuery -> String
toSbqString sbq = conLsSp [
    "(", "SELECT DISTINCT", toColumnAs sbq
  , "FROM", toTableJoin sbq
  , ")", "AS", show sbq
  ]
  where tbl = toTable $ sbq
```

```haskell
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
```
[on "src/Command/FromSubQuery.hs"][subquery]

