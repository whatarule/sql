
use TestDB

/*
 */

/*
 */
SELECT DISTINCT
  id, name, gender
FROM (
SELECT DISTINCT
    id_user AS id
  , name_user AS name
  , name_gender AS gender
FROM UserTb
  LEFT OUTER JOIN GenderTb
    ON code_gender = code_ref_gender
) AS User
ORDER BY id ASC
;
/*
 */

/*
 */
SELECT DISTINCT
  id, name, class, id_teacher
FROM (
SELECT DISTINCT
    id
  , name
  , name_class AS class
  , id_sbj_teacher AS id_teacher
FROM StudentTb
  LEFT OUTER JOIN StudentClassTb
    ON code_class = code_ref_class
  LEFT OUTER JOIN TeacherStudentTb
    ON id_student = id_obj_student
  LEFT OUTER JOIN (
    SELECT DISTINCT
        id_user AS id
      , name_user AS name
      , name_gender AS gender
    FROM UserTb
      LEFT OUTER JOIN GenderTb
        ON code_gender = code_ref_gender
    ) AS User
    ON id_student = id
) AS Student
ORDER BY id, name ASC
;
/*
where id = 12
where id_teacher = 11
where id_teacher > 10
 */

/*
SELECT DISTINCT
  id, name, class, id_teacher
FROM (
SELECT DISTINCT
    id_user AS id
  , name_user AS name
  , name_class AS class
  , id_sbj_teacher AS id_teacher
FROM UserTb
  RIGHT OUTER JOIN StudentTb
    ON id_user = id_student
    LEFT OUTER JOIN StudentClassTb
      ON code_class = code_ref_class
  LEFT OUTER JOIN TeacherStudentTb
    ON id_user = id_obj_student
) AS Student
ORDER BY id ASC
;
 */
/*
 */
/*
where id = 12
where id_teacher = 11
 */

/*
 */
SELECT DISTINCT
  id, name, gender, id_friend
FROM (
SELECT DISTINCT
    id
  , name
  , gender
  , id_obj_friend AS id_friend
FROM
( SELECT DISTINCT
    id_sbj_friend
  , id_obj_friend
  FROM FriendFriendTb
  UNION
  SELECT DISTINCT
    id_obj_friend AS id_sbj_friend
  , id_sbj_friend AS id_obj_friend
  FROM FriendFriendTb
) AS FriendFriend
  LEFT OUTER JOIN (
    SELECT DISTINCT
        id_user AS id
      , name_user AS name
      , name_gender AS gender
    FROM UserTb
      LEFT OUTER JOIN GenderTb
        ON code_gender = code_ref_gender
    ) AS User
    ON id_sbj_friend = id
) AS Friend
ORDER BY id ASC
;
/*
WHERE id_friend = 8
LEFT OUTER JOIN FriendFriendTb
  ON id_user = id_sbj_friend
WHERE id = 8 OR id_friend = 8
 */


/*
  id, name
  id, name, gender, address
  id, name, gender, address, date_add, date_update
SELECT DISTINCT
FROM
 */
SELECT DISTINCT id_test, name_test FROM TestTb WHERE id_test = 1 FOR UPDATE
;
UPDATE TestTb SET name_test = "aaa"  WHERE id_test = "1"
;
SELECT DISTINCT id_test, name_test FROM TestTb WHERE id_test = 1
;
/*
( SELECT DISTINCT id, name, gender, address, date_add, date_update, name_class AS class, id_sbj_teacher
AS id_teacher FROM StudentTb LEFT OUTER JOIN StudentClassTb ON code_class = code_ref_class LEFT OUTER JOIN
TeacherStudentTb ON id_student = id_obj_student LEFT OUTER JOIN ( SELECT DISTINCT id_user AS id, name_user AS
name, name_gender AS gender, address AS address, date_add AS date_add, date_update AS date_update FROM UserTb
LEFT OUTER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS Gender ON code_gender = code_ref_gender
) AS User ON id_student = id ) AS Student
ORDER BY id ASC
( SELECT DISTINCT id, name, gender, address, date_add, date_update, id_friend FROM ( SELECT DISTINCT
id_sbj_friend, id_obj_friend AS id_friend FROM FriendFriendTb UNION SELECT DISTINCT id_obj_friend AS id_sbj_friend,
id_sbj_friend AS id_obj_friend FROM FriendFriendTb ) AS FriendFriend LEFT OUTER JOIN ( SELECT DISTINCT
id_user AS id, name_user AS name, name_gender AS gender, address AS address, date_add AS date_add, date_update
AS date_update FROM UserTb LEFT OUTER JOIN ( SELECT DISTINCT code_ref_gender, name_gender FROM GenderTb ) AS
Gender ON code_gender = code_ref_gender ) AS User ON id_sbj_friend = id ) AS Friend
 */

/*
 */

