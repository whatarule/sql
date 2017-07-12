
{-# LANGUAGE ScopedTypeVariables #-}

import Lib

import Database.MySQL.Simple
  ( Connection, fromOnly
  , connect, ConnectInfo(..), defaultConnectInfo
  , withTransaction, close
  , query, query_
  , execute, execute_, commit
  )
import GHC.Int (Int64)

-- |
--

main :: IO ()
main = do
--str <- getLine

  let str = "Test; SelectKS; (1,name)"
--let str = "Test; UpdateKU; (1,name_test=AAA)"
--let str = "Test; SelectKS; (1,name)"
--let str = "Test; UpdateKU; (1,name_test=aaa)"
--let str = "Test; SelectKS; (1,name)"

  mainIO $ str
  pure ()


-- |
-- >>> mainIO "Test; UpdateKUU; (1,name_test=aaa,code_test=A)"
-- [["1","aaa","A"]]
-- fail: update
--

-- |
-- >>> mainIO "Test; SelectS; (name)"
-- [["aaa"],["bbb"],["ccc"]]
-- >>> mainIO "Test; SelectKS; (1,name)"
-- [["aaa"]]
-- >>> mainIO "User; SelectKSS; (1,id,name)"
-- [["1","aaa"]]
-- >>> mainIO "Friend; SelectWS; (id_friend=8,name)"
-- [["friend_b"],["friend_c"]]
-- >>> mainIO "Friend; SelectWSS; (id_friend=8,id,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "Student; SelectWSS; (id_teacher=11,name,class)"
-- [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
-- >>> mainIO "Student; SelectWWS; (id_teacher=11,class=3-B,name)"
-- [["student_b"]]
-- >>> mainIO "Student; SelectWWSS; (id_teacher=11,class=3-B,id,name)"
-- [["13","student_b"]]
--
-- >>> mainIO "FriendObj; SelectKS; (8,name)"
-- [["friend_b"],["friend_c"]]
-- >>> mainIO "FriendObj; SelectKSS; (8,id_friend,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "StudentObj; SelectKSS; (11,name,class)"
-- [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
-- >>> mainIO "StudentObj; SelectKWS; (11,class=3-B,name)"
-- [["student_b"]]
-- >>> mainIO "StudentObj; SelectKWSS; (11,class=3-B,id_student,name)"
-- [["13","student_b"]]
--
-- >>> mainIO "NoSubQuery; SelectKRS; (8,friends,name)"
-- [["friend_b"],["friend_c"]]
-- >>> mainIO "NoSubQuery; SelectKRSS; (8,friends,id_friend,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "NoSubQuery; SelectKRSS; (11,students,name,class)"
-- [["student_a","3-A"],["student_b","3-B"],["student_c","3-C"]]
-- >>> mainIO "NoSubQuery; SelectKRWS; (11,students,class=3-B,name)"
-- [["student_b"]]
-- >>> mainIO "NoSubQuery; SelectKRWSS; (11,students,class=3-B,id_student,name)"
-- [["13","student_b"]]
--
-- >>> mainIO "Test; SelectKSS; (1,name,code_test)"
-- [["aaa","A"]]
-- >>> mainIO "Test; UpdateKU; (1,name_test=AAA)"
-- [["1","aaa"]]
-- done: update
-- >>> mainIO "Test; UpdateKU; (1,code_test=Z)"
-- [["1","A"]]
-- done: update
-- >>> mainIO "Test; SelectKSS; (1,name,code_test)"
-- [["AAA","Z"]]
-- >>> mainIO "Test; UpdateKUU; (1,name_test=aaa,code_test=A)"
-- [["1","AAA","Z"]]
-- done: update
-- >>> mainIO "Test; SelectKSS; (1,name,code_test)"
-- [["aaa","A"]]
--
mainIO :: String -> IO ()
mainIO str = do
  let
      infoEi = toInputInfoEi str
      sbqEi' = toSubQuery <$> infoEi
      fmtEi = toFormat <$> infoEi
      strInEi = toInputString <$> infoEi
      lsEi = join . (toValidInputValueLsEi <$> fmtEi <*>) $ strInEi
      sbqEi = toSubQueryR <$> sbqEi' <*> fmtEi <*> lsEi
  lsDQ <- eitherIO ([(NoDmlType, fromString "/**/")]) . (toDmlQuerySetList <$> sbqEi <*> fmtEi <*>) $ lsEi
  int <- eitherIO 0 . (toQuantSelect <$> sbqEi <*> fmtEi <*>) $ lsEi
  conn <- (connect =<<) . eitherIO (defaultConnectInfo) . (toConnectInfo <$>) $ infoEi
  withTransaction conn $ do
    mapM_ (toIoQrResults conn int) $ lsDQ
    commit conn
  close conn
  pure ()

  where

  toIoQrResults :: Connection -> Int -> DmlQuerySet -> IO ()
  toIoQrResults conn int (dml, qr) = case dml of
    Update -> putStrLn . toResult =<< f conn qr where
      f conn qr = execute_ conn qr :: IO (Int64)
      toResult int = case int of
        1 -> "done: update"
        0 -> "fail: update"
    _ -> case int of
      1 -> toIoQrResults' f qr where
        f conn qr = query_ conn qr :: IO (QrMbList1)
      2 -> toIoQrResults' f qr where
        f conn qr = query_ conn qr :: IO (QrMbList2)
      3 -> toIoQrResults' f qr where
        f conn qr = query_ conn qr :: IO (QrMbList3)
      _ -> mapM_ print ["quantity of select columns"]
    where
    toIoQrResults' f = (print =<<)
      . (fmap (fmap toString . toValueLs) <$>) . f conn

  eitherIO :: a -> Either ErrMsg a -> IO (a)
  eitherIO left ei = case ei of
    Right x     -> pure x
    Left errMsg -> mapM_ putStrLn errMsg *> pure left

-- |
--

toConnectInfo :: InputInfo -> ConnectInfo
toConnectInfo info = defaultConnectInfo {
    connectDatabase = show db
  , connectHost = "localhost"
  , connectUser = "root"
  , connectPassword = ""
  } where db = toDB . toSubQuery $ info



