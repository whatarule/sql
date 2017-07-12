START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE StudentClassTb (
    code_ref_class CHAR(3) NOT NULL
      PRIMARY KEY
  , name_class VARCHAR(8) NOT NULL
  , active_class ENUM (
      "ACTIVE"
    , "INACTIVE"
    ) NOT NULL
    DEFAULT "ACTIVE"
  ) ;

DELETE FROM StudentClassTb ;
INSERT INTO StudentClassTb (
    code_ref_class
  , name_class
  , active_class
  ) VALUES
    ( "NNN"
    , "unknown"
    , "ACTIVE"
    )
  , ( "3-A"
    , "3-A"
    , "ACTIVE"
    )
  , ( "3-B"
    , "3-B"
    , "ACTIVE"
    )
  , ( "3-C"
    , "3-C"
    , "ACTIVE"
    )
  , ( "3-D"
    , "3-D"
    , "INACTIVE"
    )
  ;

SHOW FIELDS FROM StudentClassTb ;
SELECT * FROM StudentClassTb ;
COMMIT ;

