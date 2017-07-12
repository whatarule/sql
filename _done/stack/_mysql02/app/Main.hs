{-# LANGUAGE OverloadedStrings #-}

module Main where

import Database.MySQL.Base
import qualified System.IO.Streams as Streams

main :: IO ()
main = do
  conn <- connect defaultConnectInfo
  (defs, is) <- query_ conn "SELECT 2 + 2"
  print =<< Streams.toList is


--module Main where
--
--import Lib
--
--main :: IO ()
--main = someFunc
