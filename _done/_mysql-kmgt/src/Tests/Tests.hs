
{-# LANGUAGE OverloadedStrings #-}

module Tests.Tests where
--  (
--  ) where

import Models

import Data.Text
  ( Text(..)
  , unpack
  , pack
--, splitOn
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
--import qualified Control.Monad.Except as E
import Control.Monad.State
  ( State(..)
  , execState
  , evalState
  , modify
  , get
  )
import Data.List.Split
  ( splitOn
  )
import Data.List
  ( all
  )
import Data.Char
  ( isDigit
  , isSpace
  )

import Data.Time.Clock
import Data.Time.LocalTime
import Data.Time.Calendar

import Prelude hiding
  ( id )

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


test str = all isDigit str
-- |
-- >>> test "1"
-- True


testInt :: Int -> Int
-- |
-- >>> testInt 0
-- 1
-- >>> testInt 1
-- 1
testInt int = 1

testIO :: Int -> IO ()
-- |
-- >>> testIO 1
-- 1
testIO int = do
  print int
  return int
  return ()

testIOint :: Int -> IO Int
-- |
-- >>> testIOint 1
-- 1
testIOint int = do
  return ()
  return int

testDate :: IO ()
testDate = do
--print =<< getCurrentTime
--print =<< getZonedTime
  now <- getZonedTime
  print $ localDay $ zonedTimeToLocalTime now

  print $ fromGregorian 2017 1 1
  return ()

--data ErrMsg = ErrMsg {
--    name :: String
--  , msg :: String
--  }
--
--getErrMsg :: [ ErrMsg ] -> String -> String
--getErrMsg msgs str =
--  let msgPicked = head $ filter pick msgs
--      pick x =
--        ( name x ) == str
--  in msg msgPicked
--
--errInput :: DB -> SomeException -> String -> IO ()
--errInput db e str = do
--  putStrLn $ "Error: Invalid input"
--  msgs <- return [
--      ErrMsg {
--        name = "id"
--      , msg = "An id should be a number"
--      }
--    , ErrMsg  {
--        name = "field"
--      , msg = "Choose a name of field in the table"
--      }
--    ]
--  putStrLn $ getErrMsg msgs str
--  putStrLn $ "(Detail)"
--  print e
--  putStrLn $ ""

errId :: SomeException -> IO ()
errId e = do
  putStrLn $ "Error: Invalid input"
  putStrLn $ "An id should be a number"
  putStrLn $ "(Detail)"
  print e
  putStrLn $ ""


getName :: IO ()
getName = do
  putStrLn $ "Please input an id:"
  strIn <- getLine
  idInE <- try $ evaluate $ ( read strIn :: Int )
  putStrLn $ ""
  case ( idInE :: Either SomeException Int ) of
    Right idIn -> do
      conn <- connect defaultConnectInfo { connectDatabase = "test" }
      xs <- query conn "select id,name from test where id = ?"
            [ idIn :: Int ]
      case xs of
        [] ->
          putStrLn $ "No data: " ++"id = " ++ show idIn
        _ ->
          forM_ xs $ \( idM, nameM ) -> do
            let ( id, name ) = toStrResult2
                  ( idM :: Maybe Int
                  , nameM :: Maybe Text
                  )
            case name of
              "" ->
                putStrLn $ "No name: " ++"id = " ++ id
              _ ->
                putStrLn $ "name: " ++ name
      putStrLn $ ""
      return ()
      `catch` \(SomeException e) ->
        print e
    Left e -> do
      errId e
      getName
      return ()

  where
  --toStrResult2 :: ( Show a ) =>
  --  ( Maybe a, Maybe Text ) -> ( String, String )
    toStrResult2 ( x1M, x2M ) =
      let x1 = case x1M of
            Just a -> show a
            Nothing -> ""
          x2 = case x2M of
            Just a -> unpack a
            Nothing -> ""
      in ( x1, x2 )

--toStrResult2 :: ( Show a ) =>
--  [( Maybe a, Maybe Text )] -> [( String, String )]
--toStrResult2 xs = case xs of
--  [] -> [("","")]
--  _ -> map f xs
--    where
--      f = \( x1M, x2M ) ->
--        let x1 = case x1M of
--              Just a -> show a
--              Nothing -> ""
--            x2 = case x2M of
--              Just a -> unpack a
--              Nothing -> ""
--        in ( x1, x2 )

hello :: IO Int
hello = do
  conn <- connect defaultConnectInfo
--[Only i] <- query_ conn "select 2 + 2"
  [Only i] <- query conn "select ? + ?" ( 2 :: Int, 3 :: Int )
  return i

testMysql :: IO ()
testMysql = do
  conn <- connect defaultConnectInfo

--xs <- query_ conn "select 2 + 2"
--print ( xs :: [Only Int] )

--xs <- query_ conn "select id,name from test"
--xs <- query_ conn "select id,name from test where name = 'test_a'"
--xs <- query_ conn "select id,name from test where id = '01' and name = 'test_a'"
--xs <- query conn "select id,name from test where id = ? and name = ?"
--        ( "01" :: String, "test_a" :: String )
--xs <- query conn "select id,name from test where name = ?"
--      [ "test_a" :: String ]
--xs <- query conn "select id,name from test where id = ?"
--      [ "01" :: String ]
--  _ <- return ( idM :: Maybe Int )
--  _ <- return ( nameM :: Maybe Text )
--forM_ xs $ \( id, name ) ->
--  putStrLn $ unpack id ++ ": " ++ unpack name
--forM_ xs $ \( idM, nameM ) ->
--  let
--    id = case idM of
--      Just a -> a
--      Nothing -> ""
--    name = case nameM of
--      Just a -> a
--      Nothing -> ""
--  in putStrLn
--    $ unpack id ++ ": " ++ unpack name

  ys <- query conn "select name from test where id = ?"
--ys <- query conn "select id from test where id = ?"
        [ 4 :: Int ]
--print $ forM_ ( ys :: [ Only Text ] )
--        $ \ ( Only text ) -> unpack text
--print $ ( ys :: [ Only Text ] )
--print $ ( ys :: [ Only ( Maybe Text ) ] )
  forM_ ( ys :: [ Only ( Maybe Text ) ] ) $ \ nameM -> do
    let name = case ( nameM :: Only ( Maybe Text ) ) of
          Only ( Just a ) -> unpack a
          Only ( Nothing ) -> ""
    putStrLn name

--xs <- query conn "select name from test where id = ?"
--      [ 1 :: Int ]
--forM_ xs $ \ nameM ->
--  let
--    name = case nameM of
--      Just a -> a
--      Nothing -> ""
--  in putStrLn
--    $ unpack name
  return ()


