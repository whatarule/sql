
--module Main where

import Test.DocTest

main :: IO ()
main = doctest [
          "-isrc"
        , "src/Lib.hs"
        , "src/Models.hs"
        , "src/Commands.hs"
        , "src/Tests/Tests.hs"
        , "src/Tests/TestData.hs"
        , "src/IO.hs"
        ]


