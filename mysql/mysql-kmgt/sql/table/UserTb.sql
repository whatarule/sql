START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE UserTb (
    id_user TINYINT UNSIGNED NOT NULL
      PRIMARY KEY
  , name_user VARCHAR(32) NOT NULL
  , code_gender CHAR(1) NOT NULL
    , FOREIGN KEY (code_gender)
      REFERENCES GenderTb ( code_ref_gender )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , address VARCHAR(256)
  , date_add DATETIME NOT NULL
      DEFAULT CURRENT_TIMESTAMP
  , date_update DATETIME NOT NULL
      DEFAULT CURRENT_TIMESTAMP
      ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB ;
/*
    , FOREIGN KEY (  )
  ) ENGINE = InnoDB ;
 */

DELETE FROM UserTb ;
INSERT INTO UserTb (
    id_user
  , name_user
  , code_gender
  , address
  ) VALUES
    ( 0
    , "<name_user>"
    , "U"
    , "<address>"
    )
  , ( 1
    , "aaa"
    , "M"
    , "221B Baker Street"
    )
  , ( 2
    , "bbb"
    , "F"
    , ""
    )
  , ( 3
    , "ccc"
    , "U"
    , ""
    )

  , ( 4
    , "father"
    , "M"
    , ""
    )
  , ( 5
    , "mother"
    , "F"
    , ""
    )
  , ( 6
    , "son"
    , "M"
    , ""
    )
  , ( 7
    , "daughter"
    , "F"
    , ""
    )

  , ( 8
    , "friend_a"
    , "F"
    , ""
    )
  , ( 9
    , "friend_b"
    , "F"
    , ""
    )
  , ( 10
    , "friend_c"
    , "F"
    , ""
    )

  , ( 11
    , "teacher_a"
    , "F"
    , ""
    )
  , ( 12
    , "student_a"
    , "F"
    , ""
    )
  , ( 13
    , "student_b"
    , "F"
    , ""
    )
  , ( 14
    , "student_c"
    , "F"
    , ""
    )

  , ( 15
    , "brother_elder"
    , "M"
    , ""
    )
  , ( 16
    , "brother_younger"
    , "F"
    , ""
    )
  , ( 17
    , "sister_elder"
    , "F"
    , ""
    )
  , ( 18
    , "sister_younger"
    , "F"
    , ""
    )
  ;

SHOW FIELDS FROM UserTb ;
SELECT * FROM UserTb ;
COMMIT ;

