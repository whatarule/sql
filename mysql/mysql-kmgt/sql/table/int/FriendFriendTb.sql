START TRANSACTION ;
SELECT "<INFO_TO_DISPLAY>" AS "" ;

USE TestDB ;

CREATE TABLE FriendFriendTb (
    id_sbj_friend TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_sbj_friend )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , id_obj_friend TINYINT UNSIGNED NOT NULL
    , FOREIGN KEY ( id_obj_friend )
      REFERENCES UserTb ( id_user )
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  , PRIMARY KEY (
      id_sbj_friend
    , id_obj_friend
    )
  ) ENGINE = InnoDB ;

DELETE FROM FriendFriendTb ;
INSERT INTO FriendFriendTb (
      id_sbj_friend
    , id_obj_friend
  ) VALUES
    ( "8"
    , "9"
    )
  , ( "8"
    , "10"
    )
  , ( "9"
    , "10"
    )
  ;

SHOW FIELDS FROM FriendFriendTb ;
SELECT * FROM FriendFriendTb ;
COMMIT ;

