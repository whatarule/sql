
module Lib.ToQuery.ToString (
    module Lib.ToQuery.ToString
  ) where

import Model.ModelBase
import Model.SubQuery
import Model.Format
import Command.CommandBase
import Command.FromSubQuery


toPrKey :: SubQuery -> String -> String
toPrKey sbq str = case str of
  _ | str `elem` ["id", "code"] -> (!! 0) . toPrKeyLs $ sbq
  _ | str `elem` ["id_obj"] -> (!! 1) . toPrKeyLs $ sbq
  _ -> str

-- |
-- >>> toColumnEq " name_test=AAA"
-- "name_test = \"AAA\""
--
toColumnEq :: String -> String
toColumnEq str = toEqual (toColumnLs str , toValueLs str) where
  toEqual (x, y) = conLsSp [x, "=", show y]
  toColumnLs = (!! 0) . fmap unpack . splitOn (pack "=") . pack . filter ( /= ' ')
  toValueLs = (!! 1) . fmap unpack . splitOn (pack "=") . pack . filter ( /= ' ')


-- |
-- >>> conLsAnd ["id_teacher=1","class=3-B"]
-- "id_teacher=1 AND class=3-B"
-- >>> conLsAnd ["class=3-B"]
-- "class=3-B"
-- >>> conLsAnd []
-- "/**/"
--
conLsAnd :: StringList -> String
conLsAnd ls = case ls of
  [] -> "/**/"
  _ -> conLsSeparated " AND " [x | x <- ls, x /= "/**/"]



