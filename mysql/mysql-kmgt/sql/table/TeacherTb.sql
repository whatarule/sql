START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE TeacherTb (
    id_teacher TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_teacher )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , code_subject CHAR(3) NOT NULL
    , FOREIGN KEY ( code_subject )
      REFERENCES SubjectTb ( code_ref_subject )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , PRIMARY KEY (
      id_teacher
    , code_subject
    )
  ) ENGINE = InnoDB ;

DELETE FROM TeacherTb ;
INSERT INTO TeacherTb (
    id_teacher
  , code_subject
  ) VALUES
    ( 0
    , "NNN"
    )
  , ( 11
    , "MTH"
    )
  ;

SHOW FIELDS FROM TeacherTb ;
SELECT * FROM TeacherTb ;
COMMIT ;

