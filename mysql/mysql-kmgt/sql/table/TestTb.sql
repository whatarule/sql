START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE TestTb (
    id_test TINYINT UNSIGNED NOT NULL
      PRIMARY KEY
  , code_test char(1) NOT NULL
  , name_test VARCHAR(32) NOT NULL
  ) ;

DELETE FROM TestTb ;
INSERT INTO TestTb (
    id_test
  , code_test
  , name_test
  ) VALUES
    ( 1
    , "A"
    , "aaa"
    )
  , ( 2
    , "B"
    , "bbb"
    )
  , ( 3
    , "C"
    , "ccc"
    )
  ;

SHOW FIELDS FROM TestTb ;
SELECT * FROM TestTb ;
COMMIT ;

