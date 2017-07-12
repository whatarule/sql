
module Command.FromInfoFormat (module Command.FromInfoFormat
  ) where

import Model.InputInfo

toInfoFormatFieldList :: InfoFormat -> InfoFormatFieldList
toInfoFormatFieldList fmt = case fmt of
  InputInfoFormat -> [SubQuery, Format, InputString]


