
module Command.CommandBase (module Command.CommandBase
  , fromString,fromMaybe
  , readMaybe
  , Text,pack,unpack,split,splitOn
  , (<=<),join,ap,liftM,liftM2,liftM3,liftM4,liftM5
  , uncurry,mapFst,mapSnd
  ) where

import Model.ModelBase

import Data.String (fromString)
import Data.Maybe (fromMaybe)

import Text.Read (readMaybe)
import Data.Text (Text,pack,unpack,split,splitOn)
import Control.Monad ((<=<),join,ap,liftM,liftM2,liftM3,liftM4,liftM5)

--
import Data.Tuple (uncurry)
import Data.Graph.Inductive.Query.Monad (mapFst, mapSnd)
--


-- | conLs
type Separator = String

-- |
-- >>> conLsSeparated " " ["a","b","c"]
-- "a b c"
-- >>> conLsSeparated "," ["a","b","c"]
-- "a,b,c"
conLsSeparated :: Separator -> StringList -> String
conLsSeparated spr [] = ""
conLsSeparated spr [x] = x
conLsSeparated spr (x:xs) = foldl f x xs
  where f = (++) . (++ spr)

conLsSpr = conLsSeparated
conLsSp = conLsSeparated " "
conLsC = conLsSeparated ","
conLsCsp = conLsSeparated ", "
conLsS = conLsSeparated ";"
conLsSsp = conLsSeparated "; "

conLsSpaced :: StringList -> String
conLsSpaced xs = conLsSeparated " " xs
conLsSemi :: StringList -> String
conLsSemi xs = conLsSeparated ";" xs


headStringList :: StringList -> String
headStringList [] = ""
headStringList [x] = x
headStringList (x:xs) = x


-- |
-- >>> inParens "aaa"
-- "(aaa)"
inParens :: String -> String
inParens = (++) "(" . flip (++) ")"


-- | readAs

-- |
-- >>> readAsIntEi "1"
-- Right 1
readAsIntEi :: String -> Either ErrMsg Int
readAsIntEi str = case intMb of
  Just int -> Right int
  Nothing  -> Left []
  where intMb = readMaybe str :: Maybe Int

readAsIntStrEi :: String -> Either ErrMsg String
readAsIntStrEi valIn = show <$> readAsIntEi valIn


-- | ei
lookupEi :: (Eq a) => a -> [(a,b)] -> Either ErrMsg b
lookupEi key xs = case lookup key xs of
  Just x  -> Right x
  Nothing -> Left []

-- |
-- >>> elemEi "name" ["name"]
-- Right "name"
elemEi :: (Eq a) => a -> [a] -> Either ErrMsg a
elemEi x ys = case x of
  _ | x `elem` ys -> Right x
  _               -> Left []

-- |
-- >>> headEi []
-- Left []
-- >>> headEi [0]
-- Right 0
-- >>> headEi [0,1]
-- Right 0
headEi :: [a] -> Either ErrMsg a
headEi []     = Left []
headEi (x:xs) = Right x

-- |
-- >>> lengthEi 2 [0,1]
-- Right [0,1]
-- >>> lengthEi 2 [0]
-- Left ["list length"]
lengthEi :: Int -> [a] -> Either ErrMsg [a]
lengthEi int ls = case ls of
  _ | length ls == int -> pure $ ls
  _ -> Left ["list length"]

-- | lift

liftA4 :: (Applicative f) => (a -> b -> c -> d -> e)
  -> f a -> f b -> f c -> f d -> f e
liftA4 f a b c d = f <$> a <*> b <*> c <*> d
--(<****>) f a b c d = f <$> a <*> b <*> c <*> d
--(<$$$$>) f a b c d = (<****>) f <$> a <*> b <*> c <*> d

liftA6 :: (Applicative f) => (a1 -> a2 -> a3 -> a4 -> a5 -> a6 -> r)
  -> f a1 -> f a2 -> f a3 -> f a4 -> f a5 -> f a6 -> f r
liftA6 f a1 a2 a3 a4 a5 a6 = f <$> a1 <*> a2 <*> a3 <*> a4 <*> a5 <*> a6

liftA7 :: (Applicative f) => (a1 -> a2 -> a3 -> a4 -> a5 -> a6 -> a7 -> r)
  -> f a1 -> f a2 -> f a3 -> f a4 -> f a5 -> f a6 -> f a7 -> f r
liftA7 f a1 a2 a3 a4 a5 a6 a7 = f <$> a1 <*> a2 <*> a3 <*> a4 <*> a5 <*> a6 <*> a7

liftM7 :: (Monad m) => (a1 -> a2 -> a3 -> a4 -> a5 -> a6 -> a7 -> r)
  -> m a1 -> m a2 -> m a3 -> m a4 -> m a5 -> m a6 -> m a7 -> m r
liftM7 f m1 m2 m3 m4 m5 m6 m7 = do {
  x1 <- m1; x2 <- m2; x3 <- m3; x4 <- m4; x5 <- m5; x6 <- m6; x7 <- m7;
  return (f x1 x2 x3 x4 x5 x6 x7) }


-- | tuple

-- |
-- >>> sequenceAtp (Right 1, Right "name")
-- Right (1,"name")
-- >>> sequenceAtp (Right 1, Left "error")
-- Left "error"
sequenceAtp :: (Applicative f) => (f a,f b) -> f (a,b)
sequenceAtp (x,y) = (,) <$> x <*> y

-- |
-- >>> toTuple2Ei [0,1]
-- Right (0,1)
-- >>> toTuple2Ei [0]
-- Left ["1"]
-- >>> toTuple2Ei [0,1,2,3]
-- Left ["4"]
toTuple2Ei :: [a] -> Either ErrMsg (a,a)
toTuple2Ei []     = Left [show 0]
toTuple2Ei [x,y]  = Right (x,y)
toTuple2Ei (x:xs) = Left [show . length $ (x:xs)]


