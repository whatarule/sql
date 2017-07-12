
{-# LANGUAGE FlexibleInstances #-}

module Lib.ToValueList (module Lib.ToValueList
  ) where

import Model.Value
import Lib.ToValueList.ToQueryMaybe

class QueryResult qr where
  toValueLs :: qr -> ValueList
instance QueryResult (Maybe Value) where
  toValueLs (Just x) = [x]
  toValueLs Nothing = [ValueString ""]
-- |
-- >>> toValueLs (toQrMaybe (1::Int) :: QrMaybe1)
-- [ValueInt 1]
-- >>> toValueLs (toQrMaybe "aaa" :: QrMaybe1)
-- [ValueString "aaa"]
-- >>> let noValue = Nothing :: Maybe Value
-- >>> toValueLs . Only $ noValue
-- [ValueString ""]
--
instance (QueryResult a) => QueryResult (Only a) where
  toValueLs (Only a) = toValueLs a
-- |
-- >>> toValueLs (toQrMaybe (1::Int, "aaa") :: QrMaybe2)
-- [ValueInt 1,ValueString "aaa"]
-- >>> let noValue = Nothing :: Maybe Value
-- >>> toValueLs (Just . ValueInt $ (1::Int), noValue)
-- [ValueInt 1,ValueString ""]
-- >>> toValueLs (noValue, Just . ValueString $ "aaa")
-- [ValueString "",ValueString "aaa"]
--
-- >>> toValueLs (toQrMaybe (1::Int, 2::Int) :: QrMaybe2)
-- [ValueInt 1,ValueInt 2]
-- >>> toValueLs (toQrMaybe ("aaa", "bbb") :: QrMaybe2)
-- [ValueString "aaa",ValueString "bbb"]
-- >>> toValueLs (noValue, noValue)
-- [ValueString "",ValueString ""]
--
instance (QueryResult a, QueryResult b)
  => QueryResult (a, b) where
  toValueLs (a, b) = toValueLs a ++ toValueLs b
-- |
-- >>> toValueLs (toQrMaybe (1::Int, "aaa") :: QrMaybe2)
-- [ValueInt 1,ValueString "aaa"]
--
instance (QueryResult a, QueryResult b, QueryResult c)
  => QueryResult (a, b, c) where
  toValueLs (a, b, c) = toValueLs a ++ toValueLs b ++ toValueLs c

