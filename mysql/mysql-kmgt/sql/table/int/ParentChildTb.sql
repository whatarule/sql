START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE ParentChildTb (
    id_sbj_parent TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_sbj_parent )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , id_obj_child TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_obj_child )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , PRIMARY KEY (
      id_sbj_parent
    , id_obj_child
    )
  ) ENGINE = InnoDB ;

DELETE FROM ParentChildTb ;
INSERT INTO ParentChildTb (
      id_sbj_parent
    , id_obj_child
  ) VALUES
    ( "4"
    , "6"
    )
  , ( "4"
    , "7"
    )
  , ( "5"
    , "6"
    )
  , ( "5"
    , "7"
    )
  ;

SHOW FIELDS FROM ParentChildTb ;
SELECT * FROM ParentChildTb ;
COMMIT ;

