START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE TeacherStudentTb (
    id_sbj_teacher TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_sbj_teacher )
      REFERENCES TeacherTb ( id_teacher )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , id_obj_student TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_obj_student )
      REFERENCES StudentTb ( id_student )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , PRIMARY KEY (
      id_sbj_teacher
    , id_obj_student
    )
  ) ENGINE = InnoDB ;

DELETE FROM TeacherStudentTb ;
INSERT INTO TeacherStudentTb (
      id_sbj_teacher
    , id_obj_student
  ) VALUES
    ( "11"
    , "12"
    )
  , ( "11"
    , "13"
    )
  , ( "11"
    , "14"
    )
  , ( "11"
    , "15"
    )
  ;

SHOW FIELDS FROM TeacherStudentTb ;
SELECT * FROM TeacherStudentTb ;
COMMIT ;

