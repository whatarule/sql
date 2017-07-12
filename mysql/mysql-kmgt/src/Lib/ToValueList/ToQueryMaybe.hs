
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}

module Lib.ToValueList.ToQueryMaybe (
    module Lib.ToValueList.ToQueryMaybe
  , Only(..)
  ) where

import Model.Value
import Database.MySQL.Simple (Only(..))

class QueryResultMaybe a qrMb where
  toQrMaybe :: a -> qrMb
-- |
-- >>> toQrMaybe (1::Int) :: Maybe Value
-- Just (ValueInt 1)
-- >>> toQrMaybe ("aaa"::String) :: Maybe Value
-- Just (ValueString "aaa")
--
instance QueryResultMaybe Int (Maybe Value) where
  toQrMaybe x = Just . ValueInt $ x
instance QueryResultMaybe String (Maybe Value) where
  toQrMaybe x = Just . ValueString $ x
-- |
-- >>> toQrMaybe . ValueInt $ 1 :: QrMaybe1
-- Only {fromOnly = Just (ValueInt 1)}
-- >>> toQrMaybe . ValueString $ "aaa" :: QrMaybe1
-- Only {fromOnly = Just (ValueString "aaa")}
--
instance QueryResultMaybe Value (Maybe Value) where
  toQrMaybe x = Just x
-- |
-- >>> toQrMaybe (1::Int) :: QrMaybe1
-- Only {fromOnly = Just (ValueInt 1)}
-- >>> toQrMaybe "aaa" :: QrMaybe1
-- Only {fromOnly = Just (ValueString "aaa")}
--
instance (QueryResultMaybe a aMb) => QueryResultMaybe a (Only aMb) where
  toQrMaybe a = Only . toQrMaybe $ a
-- |
-- >>> toQrMaybe (1::Int,"aaa") :: QrMaybe2
-- (Just (ValueInt 1),Just (ValueString "aaa"))
-- >>> toQrMaybe ("aaa","bbb") :: QrMaybe2
-- (Just (ValueString "aaa"),Just (ValueString "bbb"))
-- >>> toQrMaybe (1::Int,2::Int) :: QrMaybe2
-- (Just (ValueInt 1),Just (ValueInt 2))
--
instance (QueryResultMaybe a aM, QueryResultMaybe b bM)
  => QueryResultMaybe (a, b) (aM, bM) where
  toQrMaybe (a, b) = (toQrMaybe a, toQrMaybe b)
-- |
-- >>> toQrMaybe (1::Int,"aaa","bbb") :: QrMaybe3
-- (Just (ValueInt 1),Just (ValueString "aaa"),Just (ValueString "bbb"))
--
instance (QueryResultMaybe a aM, QueryResultMaybe b bM, QueryResultMaybe c cM)
  => QueryResultMaybe (a, b, c) (aM, bM, cM) where
  toQrMaybe (a, b, c) = (toQrMaybe a, toQrMaybe b, toQrMaybe c)

