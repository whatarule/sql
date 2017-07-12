
module Command.FromValue (module Command.FromValue
  ) where

import Model.Value

-- |
-- >>> toString . ValueString $ "aaa"
-- "aaa"
-- >>> toString . ValueInt $ 1
-- "1"
--
toString :: Value -> String
toString val = case val of
  ValueInt x -> show x
  ValueString x -> x

