
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where


--import Database.MySQL.Simple
--
--hello :: IO Int
--hello = do
--  conn <- connect defaultConnectInfo
--  [Only i] <- query_ conn "select 2 + 2"
--  return i

someFunc :: IO ()
someFunc = putStrLn "someFunc"
--someFunc = hello


