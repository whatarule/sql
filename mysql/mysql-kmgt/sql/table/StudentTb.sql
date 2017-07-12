START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE StudentTb (
    id_student TINYINT UNSIGNED NOT NULL
      PRIMARY KEY
    , FOREIGN KEY ( id_student )
        REFERENCES UserTb ( id_user )
        ON UPDATE CASCADE
        ON DELETE RESTRICT
  , code_class CHAR(3) NOT NULL
    , FOREIGN KEY ( code_class )
        REFERENCES StudentClassTb ( code_ref_class )
        ON UPDATE CASCADE
        ON DELETE RESTRICT
  ) ENGINE = InnoDB ;

DELETE FROM StudentTb ;
INSERT INTO StudentTb (
    id_student
  , code_class
  ) VALUES
    ( 0
    , "NNN"
    )
  , ( 12
    , "3-A"
    )
  , ( 13
    , "3-B"
    )
  , ( 14
    , "3-C"
    )
  , ( 15
    , "3-D"
    )
  ;

SHOW FIELDS FROM StudentTb ;
SELECT * FROM StudentTb ;
COMMIT ;

