START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

DROP TABLE IF EXISTS TeacherStudentTb ;
DROP TABLE IF EXISTS SiblingElderYoungerTb ;
DROP TABLE IF EXISTS ParentChildTb ;
DROP TABLE IF EXISTS FriendFriendTb ;

DROP TABLE IF EXISTS StudentTb ;
DROP TABLE IF EXISTS TeacherTb ;
DROP TABLE IF EXISTS UserTb ;

DROP TABLE IF EXISTS StudentClassTb ;
DROP TABLE IF EXISTS SubjectTb ;
DROP TABLE IF EXISTS GenderTb ;

DROP TABLE IF EXISTS TestTb ;
DROP DATABASE IF EXISTS TestDB ;

SOURCE sql/db/TestDB.sql ;
SOURCE sql/table/TestTb.sql ;

SOURCE sql/table/ref/GenderTb.sql ;
SOURCE sql/table/ref/SubjectTb.sql ;
SOURCE sql/table/ref/StudentClassTb.sql ;

SOURCE sql/table/UserTb.sql ;
SOURCE sql/table/StudentTb.sql ;
SOURCE sql/table/TeacherTb.sql ;

SOURCE sql/table/int/FriendFriendTb.sql ;
SOURCE sql/table/int/ParentChildTb.sql ;
SOURCE sql/table/int/SiblingElderYoungerTb.sql ;
SOURCE sql/table/int/TeacherStudentTb.sql ;

COMMIT ;

SOURCE sql/show.sql ;

