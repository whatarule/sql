
{-# LANGUAGE ScopedTypeVariables #-}

import Command.CommandBase
import Command.FromInputInfo
import Command.FromFormat
import Command.FromInputString
import Sql.Query
import Sql.SubQuery
import Command.FromQueryResult

import Control.Exception.Safe
  ( MonadCatch,catch
  , MonadThrow,throw
  )
import Database.MySQL.Simple
  ( Connection, Only, fromOnly
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
  str <- getLine
--let str = "Test; SelectKS; (1,name)"
--let str = "Test; UpdateKU; (1,name_test=AAA)"
--let str = "Test; SelectKS; (1,name)"
  let str = "Test; UpdateKU; (1,name_test=aaa)"
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



main_proto :: IO ()
main_proto = do
  let str = undefined :: String
      info = toInputInfo str
  conn <- connect . toConnectInfo $ info
  mapM_ (print =<<)
    . fmap ((fmap toShow' <$>) . toQueryResults1 conn)
    . toQueryLs $ info
  close conn
  pure ()

  where
  toQueryResults1 conn qr = undefined :: IO ([Only (Maybe Value)])
  toShow' qr = undefined :: String

toInputInfo :: String -> InputInfo
toInputInfo = undefined

toShow :: (QueryResult qr, Show a) => qr -> a
toShow = undefined

toQueryLs :: InputInfo -> [Query]
toQueryLs (InputInfo tbl fmt str) = undefined
  where
  keyLs = toPrKeyLs $ tbl
  dml = toDmlType $ fmt


----join . (toIoQrResults conn <$> eitherIO 0 (lengthKW <$> sbqEi <*> fmtEi <*> lsEi) <*>)
----  . eitherIO ([fromString ""]) . (toQueryList <$> sbqEi <*> fmtEi <*>) $ lsEi
----(mapM_ (print =<<) =<<)
----  . (fmap ((fmap toValueLs <$>) . (toQueryResults1 conn)) <$>)
----  . eitherIO ([fromString ""]) . (toQueryList <$> sbqEi <*> fmtEi <*>) $ lsEi
--
----  1 -> mapM_ (print =<<) . fmap ((fmap (fmap toString . toValueLs) <$>) . (toQueryResults conn)) $ ls
----    where toQueryResults conn qr = query_ conn qr :: IO (QrMbList1)
----  2 -> mapM_ (print =<<) . fmap ((fmap toValueLs <$>) . (toQueryResults conn)) $ ls
----    where toQueryResults conn qr = query_ conn qr :: IO (QrMbList2)
----  --toQueryResults conn qr = case int of
----  --  1 -> query_ conn qr :: IO (QrMbList1)
----  --  2 -> query_ conn qr :: IO (QrMbList2)
--
---- >>> eitherIO 0 . (lengthKW <$> sbqEi <*> fmtEi <*> lsEi))
--
---- >>> let str = "Test; SelectKS; (1,name)"
---- >>> let infoEi = toInputInfoEi str
---- >>> let sbqEi = Right Test
---- >>> let fmtEi = Right SelectKS
---- >>> let lsEi = Right ["1","name"]
---- >>> conn <- (connect =<<) . eitherIO (defaultConnectInfo) . (toConnectInfo <$>) $ infoEi
---- >>> let toQueryResults1 conn qr = undefined :: IO (QrMaybe1)
---- >>> :t (fmap (toQueryResults1 conn) <$>) . eitherIO ([fromString ""]) . (toQueryList <$> sbqEi <*> fmtEi <*>) $ lsEi

-- >>> mainIO "Test; SelectS; (name)"
-- [["1","aaa"],["2","bbb"],["3","ccc"]]
-- >>> mainIO "Test; SelectKS; (1,name)"
-- [["1","aaa"]]
-- >>> mainIO "Test; SelectKSS; (1,name,code)"
-- [["1","aaa","A"]]
-- >>> mainIO "Friend; SelectKS; (8,id_friend)"
-- [["8","9"],["8","10"]]
-- >>> mainIO "Friend; SelectWS; (id_friend=8,name)"
-- [["9","friend_b"],["10","friend_c"]]
-- >>> mainIO "Student; SelectWSS; (id_teacher=11,name,class)"
-- [["12","student_a","3-A"],["13","student_b","3-B"],["14","student_c","3-C"]]
-- >>> mainIO "Student; SelectWWSS; (id_teacher=11,class=3-B,name,class)"
-- [["13","student_b","3-B"]]
--
-- >>> mainIO "NoSubQuery; SelectKRS; (8,friends,name)"
-- [["8","friend_b"],["8","friend_c"]]
-- >>> mainIO "NoSubQuery; SelectKRSS; (11,students,name,class)"
-- [["11","student_a","3-A"],["11","student_b","3-B"],["11","student_c","3-C"]]
-- >>> mainIO "NoSubQuery; SelectKRWS; (11,students,class=3-B,name)"
-- [["11","student_b"]]
-- >>> mainIO "NoSubQuery; SelectKRWSS; (11,students,class=3-B,name,class)"
-- [["11","student_b","3-B"]]
-- >>> mainIO "NoSubQuery; SelectKRSS; (8,friends,id_friend,name)"
-- [["8","9","friend_b"],["8","10","friend_c"]]

--toIoQrResults :: Connection -> Int -> QueryList -> IO ()
--toIoQrResults conn int ls = case int of
--  1 -> toIoQrResults' f
--    where f conn qr = query_ conn qr :: IO (QrMbList1)
--  2 -> toIoQrResults' f
--    where f conn qr = query_ conn qr :: IO (QrMbList2)
--  _ -> mapM_ print ["quantity of select columns"]
--  where
--  toIoQrResults' f = mapM_ (print =<<)
--    . fmap ((fmap (fmap toString . toValueLs) <$>) . (f conn)) $ ls


