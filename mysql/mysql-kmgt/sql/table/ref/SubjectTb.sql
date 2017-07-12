START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE SubjectTb (
    code_ref_subject char(3) NOT NULL
      PRIMARY KEY
  , name_subject VARCHAR(16) NOT NULL
  ) ;

DELETE FROM SubjectTb ;
INSERT INTO SubjectTb (
    code_ref_subject
  , name_subject
  ) VALUES
    ( "NNN"
    , "unknown"
  )
  , ( "JPN"
    , "Japanese"
    )
  , ( "MTH"
    , "Mathematics"
    )
  , ( "ENG"
    , "English"
    )
  ;

SHOW FIELDS FROM SubjectTb ;
SELECT * FROM SubjectTb ;
COMMIT ;

