START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE GenderTb (
    code_ref_gender CHAR(1) NOT NULL
      PRIMARY KEY
  , name_gender VARCHAR(32) NOT NULL
  ) ;

DELETE FROM GenderTb ;
INSERT INTO GenderTb (
    code_ref_gender
  , name_gender
  ) VALUES
    ( "M"
    , "Masculine"
    )
  , ( "F"
    , "Feminine"
    )
  , ( "O"
    , "Others"
    )
  , ( "U"
    , "Unknown"
    )
  ;

SHOW FIELDS FROM GenderTb ;
SELECT * FROM GenderTb ;
COMMIT ;

