
{-# LANGUAGE ScopedTypeVariables #-}

import Sql.Query

import Control.Exception.Safe
  ( MonadCatch,catch
  , MonadThrow,throw
  )
import Database.MySQL.Simple
  ( connect, ConnectInfo(..), defaultConnectInfo
  , withTransaction, close
  , query, query_
  , execute, execute_, commit
  )


-- |
--

main :: IO ()
main = do

{-
  info <- eitherIO . toInputInfoEi . inputTest Select Test "(id,field)" $ "(1,name)"
  info <- eitherIO . toInputInfoEi . inputTest Select Test "(id,relation)" $ "(8,friends)"
  info <- eitherIO . toInputInfoEi . inputTest Select Test "(id,relation,class)" $ "(11,students,3-B)"
  info <- eitherIO . toInputInfoEi . inputTest Update Test "(id_test,field,value)" $ "(1,name_test,AAA)"
  info <- eitherIO . toInputInfoEi . inputTest Update Test "(id_test,field,value)" $ "(1,name_test,aaa)"
-}
  info <- eitherIO . toInputInfoEi . inputTest Select Test "(id,field)" $ "(1,name)"

  let connectInfo = defaultConnectInfo {
        connectDatabase = toDB info
      , connectHost = "localhost"
      , connectUser = "root"
      , connectPassword = ""
      }
  conn <- connect connectInfo

  let dml = toSqlDmlType info
  case dml of
    Select -> printQr toValueLs' $ info where
      toValueLs' x = toValueLs (x::QrMaybe1)
      printQr f = (print =<<) . (conLsSeparated "; " . fmap (toResultString . f) <$>)
        . query_ conn . toSql Select
    Update ->
      withTransaction conn $ do
        (fromOnlyLs <$>) . query_ conn . toSql SelectKeyForUpdate $ info
        (fromOnlyLs <$>) . query_ conn . toSql SelectValueForUpdate $ info
        execute_ conn . toSql Update $ info
        commit conn
      *> putStrLn "done: update"

  close conn
  pure ()

  where

  toInputInfoLs :: Path -> IO [InputInfo]
  toInputInfoLs = undefined
  -- txt <- readFile path
  -- let inStrLs = lines txt


eitherIO :: Either ErrMsg InputInfo -> IO (InputInfo)
eitherIO ei = case ei of
  Right x     -> pure x
  Left errMsg -> mapM_ putStrLn errMsg
    *> (eitherIO . toInputInfoEi . Input "" $ "")

-- |
-- >>> headEi $ ["aaa"]
-- Right "aaa"
--

-- |
-- >>> info <- eitherIO . toInputInfoEi . inputTest Select Test "(id,field)" $ "(1,name)"
-- >>> con <- connect defaultConnectInfo {connectDatabase = toDB info}
-- >>> (fromOnlyLs <$>) . query_ con . toSql Select $ info
-- [ValueString "aaa"]
-- >>> (conLsSeparated ", " . fmap toString . fromOnlyLs <$>) . query_ con . toSql Select $ info
-- "aaa"
--


