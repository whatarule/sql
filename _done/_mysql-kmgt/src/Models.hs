
module Models
--(
--)
  where

import Data.Text
  ( Text(..)
  , unpack
  , pack
--, splitOn
  )
import Data.List.Split
  ( splitOn
  )

import Data.Time.Clock
import Data.Time.LocalTime
import Data.Time.Calendar

import Prelude hiding
  ( id )


type DB = String
type Table = String
type Field = String

type Input = String

type Id         = Int
type Name       = Text
type Gender     = Text
type Address    = Text
type DateAdd    = Day
type DateUpdate = Day

data User = User {
    id         :: Id
  , name       :: Name
  , gender     :: Gender
  , address    :: Address
  , dateAdd    :: DateAdd
  , dateUpdate :: DateUpdate
  }

data UserStr = UserStr {
    idStr         :: String
  , nameStr       :: String
  , genderStr     :: String
  , addressStr    :: String
  , dateAddStr    :: String
  , dateUpdateStr :: String
  }

type QueryUser = (
    Id
  , Name
  , Gender
  , Address
  , DateAdd
  , DateUpdate
  )

type QueryUserM = (
    Maybe Id
  , Maybe Name
  , Maybe Gender
  , Maybe Address
  , Maybe DateAdd
  , Maybe DateUpdate
  )

type QueryFld = (
    Maybe Text, Maybe Text, Maybe Text
  , Maybe Text, Maybe Text, Maybe Text
  )

type ErrMsg = [ String ]


userFromUserStr :: UserStr -> User
userFromUserStr userStr =
  User { id         = read $ idStr userStr :: Int
       , name       = pack $ nameStr userStr
       , gender     = pack $ genderStr userStr
       , address    = pack $ addressStr userStr
       , dateAdd    = dayFromStr $ dateAddStr userStr
       , dateUpdate = dayFromStr $ dateUpdateStr userStr
       }

dayFromStr :: String -> Day
dayFromStr str =
  let lsDay = splitOn "-" str
      year  = read $ lsDay !! 0 :: Integer
      month = read $ lsDay !! 1 :: Int
      day   = read $ lsDay !! 2 :: Int
  in fromGregorian year month day

queryFromUser :: User -> QueryUser
queryFromUser user =
  ( id         user
  , name       user
  , gender     user
  , address    user
  , dateAdd    user
  , dateUpdate user
  )

userFromQuery :: QueryUser -> User
userFromQuery q =
  let ( id, name, gender, address, dateAdd, dateUpdate ) = q
  in User {
      id         = id
    , name       = name
    , gender     = gender
    , address    = address
    , dateAdd    = dateAdd
    , dateUpdate = dateUpdate
    }

strFromQueryM :: QueryUserM -> UserStr
strFromQueryM qM =
  let ( idM, nameM, genderM, addressM, dateAddM, dateUpdateM ) = qM
      id = case idM of
        Just a -> show a
        Nothing -> ""
      name = case nameM of
        Just a -> unpack a
        Nothing -> ""
      gender = case genderM of
        Just a -> unpack a
        Nothing -> ""
      address = case addressM of
        Just a -> unpack a
        Nothing -> ""
      dateAdd = case dateAddM of
        Just a ->  showGregorian a
        Nothing -> ""
      dateUpdate = case dateUpdateM of
        Just a ->  showGregorian a
        Nothing -> ""
  in UserStr id name gender address dateAdd dateUpdate


