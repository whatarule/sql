
{-# LANGUAGE OverloadedStrings #-}

module Tests.TestData
--(
--)
  where

import Models

import Control.Monad
  ( forM_
  , forM
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

type TestUser = User

userEmpty :: TestUser
userEmpty = userFromUserStr $
    UserStr { idStr         = "0"
            , nameStr       = ""
            , genderStr     = ""
            , addressStr    = ""
            , dateAddStr    = "1000-01-01"
            , dateUpdateStr = "1000-01-01"
            }

userTest :: TestUser
userTest = userFromUserStr $
    UserStr { idStr         = "1"
            , nameStr       = "aaa"
            , genderStr     = "female"
            , addressStr    = "1-9-12 Ryoke Izumi-ku"
            , dateAddStr    = "1000-01-01"
            , dateUpdateStr = "2000-01-01"
            }

dataTest :: [ TestUser ]
dataTest = map userFromUserStr [
    UserStr { idStr         = "1"
            , nameStr       = "aaa"
            , genderStr     = "female"
            , addressStr    = "1-9-12 Ryoke Izumi-ku"
            , dateAddStr    = "1000-01-01"
            , dateUpdateStr = "2000-01-01"
            }
  , UserStr { idStr         = "2"
            , nameStr       = "bbb"
            , genderStr     = "male"
            , addressStr    = "221B Baker Street"
            , dateAddStr    = "1859-05-22"
            , dateUpdateStr = "1930-07-07"
            }
  , UserStr { idStr         = "3"
            , nameStr       = ""
            , genderStr     = "unknown"
            , addressStr    = ""
            , dateAddStr    = "1000-03-01"
            , dateUpdateStr = "2000-03-01"
            }
  ]


initTestData :: DB -> [ TestUser ] -> IO ()
-- |
-- >>> let db = "test"
-- >>> initTestData db dataTest
initTestData db users = do
  deleteData db
  setData db users
  return ()
-- |

deleteData :: DB -> IO ()
-- |
-- >>> let db = "test"
-- >>> deleteData db
deleteData db = do
  conn <- connect defaultConnectInfo { connectDatabase = db }
  execute_ conn "delete from test"
  return ()
-- |

setData :: DB -> [ TestUser ] -> IO ()
-- |
-- >>> let db = "test"
-- >>> setData db dataTest
setData db usrs = do
  forM_ usrs $ setUser db
  return ()
-- |

setUser :: DB -> TestUser -> IO ()
-- |
-- >>> let db = "test"
-- >>> setUser db userTest
setUser db usr = do
  let qUsr = queryFromUser usr
  conn <- connect defaultConnectInfo { connectDatabase = db }
  execute conn "insert into test values (?,?,?,?,?,?)" qUsr
  return ()
-- |


