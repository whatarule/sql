START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE SiblingElderYoungerTb (
    id_sbj_elder TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_sbj_elder )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , id_obj_younger TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_obj_younger )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , PRIMARY KEY (
      id_sbj_elder
    , id_obj_younger
    )
  ) ENGINE = InnoDB ;

DELETE FROM SiblingElderYoungerTb ;
INSERT INTO SiblingElderYoungerTb (
      id_sbj_elder
    , id_obj_younger
  ) VALUES
    ( "15"
    , "16"
    )
  , ( "17"
    , "18"
    )
  ;

SHOW FIELDS FROM SiblingElderYoungerTb ;
SELECT * FROM SiblingElderYoungerTb ;
COMMIT ;

