
module Command.FromFormat (module Command.FromFormat
  ) where

import Model.ModelBase
import Model.Format
import Command.FromFormat.ToFormatInfo

toDmlType :: Format -> DmlType
toDmlType = toDmlType' . toFormatInfo

toInputFieldTypeLs :: Format -> InputFieldTypeList
toInputFieldTypeLs = toInputFieldTypeLs' . toFormatInfo

toFormatSelectFor :: Format -> Format
toFormatSelectFor fmt = case fmt of
  UpdateKU -> SelectForKU
  UpdateKUU -> SelectForKUU
  _ -> fmt

-- |
-- >>> toInputValueLs [K] SelectKS ["1","name"]
-- ["1"]
-- >>> toInputValueLs [S] SelectKS ["1","name"]
-- ["name"]
-- >>> toInputValueLs [W] SelectKS ["1","name"]
-- []
--
-- >>> toInputValueLs [U] UpdateKU ["1","name_test=AAA"]
-- ["name_test=AAA"]
-- >>> toInputValueLs [K,U] UpdateKU ["1","name_test=AAA"]
-- ["1","name_test=AAA"]
--
toInputValueLs :: InputFieldTypeList -> Format -> StringList -> StringList
toInputValueLs ls1 fmt = fmap snd . filter (flip elem ls1 . fst) . zip ls2
  where ls2 = toInputFieldTypeLs $ fmt

