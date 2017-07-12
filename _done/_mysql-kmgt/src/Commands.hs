
{-# LANGUAGE OverloadedStrings #-}

module Commands
--(
--)
  where

import Models

--import Data.Text
--  ( Text(..)
--  , unpack
--  , pack
----, splitOn
--  )
--import Control.Monad
--  ( forM_
--  , forM
--  )
--import Control.Exception
--  ( catch
--  , SomeException(..)
--  , evaluate
--  , try
--  )
----import qualified Control.Monad.Except as E
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

--import Data.Time.Clock
--import Data.Time.LocalTime
--import Data.Time.Calendar
--
--import Prelude hiding
--  ( id )
--
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


modifyInput :: Input -> [ String ]
-- |
-- >>> let strIn = "(1,name)"
-- >>> modifyInput strIn
-- ["1","name"]
--
-- >>> let strIn = "( 1, name )"
-- >>> modifyInput strIn
-- ["1","name"]
--
-- >>> let strIn = "1,name"
-- >>> modifyInput strIn
-- ["1","name"]
--
-- >>> let strIn = "1"
-- >>> modifyInput strIn
-- ["",""]
--
-- >>> let strIn = "name"
-- >>> modifyInput strIn
-- ["",""]
--
-- >>> let strIn = ""
-- >>> modifyInput strIn
-- ["",""]
--
modifyInput strIn =
--[ "1", "name" ]
  ( `evalState` strIn ) $ do
  --modify $ filter $ not . isSpace
    modify $ filter ( \x -> x /= ' ' )
    modify $ filter ( \x -> x /= '(' )
    modify $ filter ( \x -> x /= ')' )
    str <- get
    let ls = splitOn "," str
    case length ls of
      2 ->
        return $ ls
      _ ->
        return $ [ "", "" ]
-- |


readInt :: String -> Either String Int
-- |
-- >>> readInt "1"
-- Right 1
-- >>> readInt "111"
-- Right 111
-- >>> readInt "0.1"
-- Left "0.1"
-- >>> readInt "a"
-- Left "a"
-- >>> readInt "1a"
-- Left "1a"
-- >>> readInt "a1"
-- Left "a1"
--
readInt str = case str of
  _ | cnd ->
    Right $ ( read str :: Int )
  _ ->
    Left $ str
  where
    cnd = all isDigit str
-- |

readIntEi :: String -> Either ErrMsg Int
-- |
-- >>> readIntEi "1"
-- Right 1
-- >>> readIntEi "a"
-- Left ["Invalid input: id = \"a\"","\"a\" is not a number"]
--
readIntEi str = case readInt str of
  Right int ->
    Right int
  Left str ->
    Left $ [
        "Invalid input: id = " ++ show str
      , show str ++ " is not a number"
      ]



