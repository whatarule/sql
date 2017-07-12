{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import Database.MySQL.Base
import qualified System.IO.Streams as Streams

--someFunc :: IO ()
--someFunc = putStrLn "someFunc"

someFunc :: IO ()
someFunc = do
--conn <- connect defaultConnectInfo
--(defs, is) <- query_ conn "SELECT 2 + 2"
  db <- connect defaultConnectInfo {ciDatabase = "test"}
  (dwfs, is) <- query_ db "SELECT * FROM test"
--print $ "aaa"
  print =<< Streams.toList is


