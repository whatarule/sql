
{-# LANGUAGE OverloadedStrings #-}

module IO
  (
  )
  where

import Models
import Commands
  ( modifyInput
  )

import Tests.TestData

import Data.Text
  ( Text(..)
  , unpack
  , pack
  )
import Control.Monad
  ( forM_
  , forM
  )
import Control.Exception
  ( catch
  , SomeException(..)
  , evaluate
  , try
  )

import Database.MySQL.Simple
  ( connect
  , defaultConnectInfo
  , connectDatabase
  , query
  , query_
  , Only(..)
  , execute
  , execute_
  )


getData :: DB -> Input -> IO ()
-- |
getData db strIn = do
--putStrLn $ "Please input an id:"
--showFields db
  putStrLn $ ""
--strIn <- getLine

  inLs <- return $ modifyInput strIn
  let [ idInStr, fldInStr ] = inLs
  fldls <- getFldLs db

  idInE <- try $ evaluate $
              ( read idInStr :: Int )
  fldInE <- do
    fldLs <- getFldLs db
    return $ case fldInStr of
      _ | elem fldInStr fldLs ->
            Right fldInStr
      _ ->
            Left ""
  _ <- return ( idInE :: Either SomeException Int )
  _ <- return ( fldInE :: Either Field Field )

  getIdIn idInE fldInE

  putStrLn $ "---"
  putStrLn $ ""
  return ()
--`catch` \(SomeException e) ->
--    print e
  `catch` errMysql

  where
    getIdIn idInE fldInE = case idInE of
      Right idIn -> do
        getFldIn idIn fldInE
      Left err -> do
        errInput db "id"
        putStrLn $ "(Detail)"
        print err
      --strIn <- getLine
      --getData db strIn

    getFldIn idIn fldInE = case fldInE of
      Right fldIn -> do
        getQuery db idIn fldIn
      Left _ -> do
        errInput db "field"
      --strIn <- getLine
      --getData db strIn
-- |
-- >>> let db = "test"
-- >>> let strIn = "(1,name)"
-- >>> getData db strIn
-- <BLANKLINE>
-- name:
-- aaa
-- ---
-- <BLANKLINE>


getQuery :: DB -> Id -> Field -> IO ()
-- |
getQuery db idIn fldIn = do
  conn <- connect defaultConnectInfo { connectDatabase = db }
  xs <- query conn "select * from test where id = ?"
        [ idIn :: Int ]
  _ <- return ( xs :: [ QueryUserM ] )
--print xs
  case xs of
    [] ->
      putStrLn $ "No data: " ++ "id = " ++ show idIn
    _ ->
      forM_ xs $ \ qUsrM -> do
        let usrStr = strFromQueryM qUsrM
            val = case fldIn of
              "id"         -> idStr usrStr
              "name"       -> nameStr usrStr
              "gender"     -> genderStr usrStr
              "address"    -> addressStr usrStr
              "dateAdd"    -> dateAddStr usrStr
              "dateUpdate" -> dateUpdateStr usrStr
              _            -> ""
        printVal fldIn idIn val
  return ()
--`catch` errMysql
-- |
-- >>> let db = "test"
-- >>> initTestData db dataTest
--
-- >>> let id = 1
-- >>> let fld = "name"
-- >>> getQuery db id fld
-- name:
-- aaa
--
-- >>> let id = 3
-- >>> let fld = "name"
-- >>> getQuery db id fld
-- No name: id = 3
--
-- >>> let id = 4
-- >>> let fld = "name"
-- >>> getQuery db id fld
-- No data: id = 4
--

-- >>> let id = 1
-- >>> let fld = "<invalid field name>"
-- >>> getQuery db id fld
--



printVal :: Field -> Id -> String -> IO ()
-- |
-- >>> let fld = "<field name>"
-- >>> let id = 0
--
-- >>> let val = "<field value>"
-- >>> printVal fld id val
-- <field name>:
-- <field value>
--
-- >>> let val = ""
-- >>> printVal fld id val
-- No <field name>: id = 0
--
printVal fld id val = case val of
  "" -> do
    putStrLn $ "No " ++ fld ++ ": id = " ++ show id
  _ -> do
    putStrLn $ fld ++ ": "
    putStrLn $ val
-- |


getFldLs :: DB -> IO [ Field ]
-- |
-- >>> let db = "test"
-- >>> getFldLs db
-- ["id","name","gender","address","dateAdd","dateUpdate"]
getFldLs db = do
  conn <- connect defaultConnectInfo { connectDatabase = db }
  xs <- query_ conn "show fields from test"
  _ <- return ( xs :: [ QueryFld ] )
  let fldLs = ( `map` xs ) $
                \ ( fld, _, _
                    , _, _, _ ) -> fld
--print fldLs
  forM xs $
    \ ( fld, _, _
        , _, _, _ ) -> do
      case fld of
        Just a ->
          return $ unpack a
        Nothing ->
          return ""
-- |

showFields :: DB -> IO ()
-- |
showFields db = do
--print =<< getFileds db
  xs <- getFldLs db
  forM_ xs $ \x ->
    putStrLn x
  return ()
--`catch` errMysql
-- |


errInput :: DB -> String -> IO ()
-- |
errInput db str = do
  putStrLn $ "Error: Invalid input"
  case str of
    "id" -> do
      putStrLn $ "An id should be a number"
    "field" -> do
      putStrLn $ "Choose one from the list below for the field name"
      showFields db
    _ -> do
      return ()
-- |

errMysql :: SomeException -> IO ()
-- |
errMysql e = do
  putStrLn $ "Error: Invalid data request"
  putStrLn $ "The requested data is not available."
  putStrLn $ "(Detail)"
  print e
  putStrLn $ "---"
  putStrLn $ ""
-- |

-- // old

--getQuery :: DB -> Id -> Field -> IO ()
--getQuery db idIn fldIn = do
--  conn <- connect defaultConnectInfo { connectDatabase = db }
----xs <- query conn "select id,name from test where id = ?"
----      [ idIn :: Int ]
----xs <- query conn "select id,names from test where id = ?"
----      [ idIn :: Int ]
--  xs <- query conn "select * from test where id = ?"
--        [ idIn :: Int ]
--  _ <- return ( xs :: [ QueryUserM ] )
--  case xs of
--    [] ->
--      putStrLn $ "No data: " ++ "id = " ++ show idIn
--    _ ->
--    --forM_ xs $
--    --  \ ( idM
--    --    , nameM
--    --    ) -> do
--    --      _ <- return ( idM         :: Maybe Id         )
--    --      _ <- return ( nameM       :: Maybe Text       )
--    --      let ( id , name ) = toStrResult2
--    --            ( idM
--    --            , nameM
--    --            )
--    --          val = case fldIn of
--    --            "id" -> show ( id :: Int )
--    --            "name" -> unpack ( name :: Name )
--    --            _ -> ""
--    --      printFld fldIn id val
--      forM_ xs $ \ qUsrM -> do
--        let usrStr = strFromQueryM qUsrM
--            val = case fldIn of
--              "id"         -> idStr usrStr
--              "name"       -> nameStr usrStr
--              "gender"     -> genderStr usrStr
--              "address"    -> addressStr usrStr
--              "dateAdd"    -> dateAddStr usrStr
--              "dateUpdate" -> dateUpdateStr usrStr
--              _            -> ""
--        printFld fldIn idIn val
--  return ()
----`catch` errMysql
--where
----toStrResult2 :: ( Show a ) =>
----  ( Maybe a, Maybe Text ) -> ( String, String )
--  toStrResult2 ( x1M, x2M ) =
--    let x1 = case x1M of
--          Just a -> a
--          Nothing -> ""
--        x2 = case x2M of
--          Just a -> a
--          Nothing -> ""
--    in ( x1, x2 )

--getData :: DB -> Input -> IO ()
----getData :: DB -> Table -> IO ()
--getData db strIn = do
----putStrLn $ "Please input an id:"
----showFields db
--  putStrLn $ ""
----strIn <- getLine
--
----print $ ( read str :: ( Int, String ) )
--  tplIn <- return $
--  --( `execState` strIn ) $ do
--    ( `evalState` strIn ) $ do
--      modify $ filter $ not . isSpace
--      modify $ filter ( \x -> x /= '(' )
--      modify $ filter ( \x -> x /= ')' )
--      str <- get
--    --let ls = splitOn "," $ pack str
--      let ls = splitOn "," str
--      return $ ( ls !! 0, ls !! 1 )
--  print tplIn
--  putStrLn $ ""
--
----idInE <- try $ evaluate $ ( read strIn :: Int )
----idInE <- try $ evaluate $ ( read strIn :: ( Int, String ) )
----print (idInE :: Either SomeException ( Int, String ) )
--  let ( idInStr, fldInStr ) = tplIn
--  idInE <- try $ evaluate $
--              ( read idInStr :: Int )
--  fldInE <- do
--    fldLs <- getFileds db
--    return $ case fldInStr of
--      _ | elem fldInStr fldLs ->
--            Right fldInStr
--      _ ->
--            Left ""
--  _ <- return ( idInE :: Either SomeException Int )
--  _ <- return ( fldInE :: Either String String )
--
--  getIdIn idInE fldInE
--
--  putStrLn $ "---"
--  putStrLn $ ""
--  return ()
----`catch` \(SomeException e) ->
----    print e
--  `catch` errMysql
--
--  where
--    getIdIn idInE fldInE = case idInE of
--      Right idIn -> do
--        getFldIn idIn fldInE
--      Left err -> do
--        errInput db "id"
--        putStrLn $ "(Detail)"
--        print err
--      --strIn <- getLine
--      --getData db strIn
--
--    getFldIn idIn fldInE = case fldInE of
--      Right fldIn -> do
--      --getQuery idInE fldIn
--        getQuery db idIn fldIn
--      Left _ -> do
--        errInput db "field"
--      --strIn <- getLine
--      --getData db strIn
--
--
