
module Model.Format (module Model.Format
  ) where


--
-- KS : "(1, name)", "(8, id_friend)"
-- KWS : "(11, class=3-B, id_student)"
-- WS : "(id_friend=8, name)"
-- WWS : "(id_teacher=14, class=3-B, name)"
-- KRS : "(8,friends,name)"
-- KRWS : "(11,students,class=3-B,name)"
-- KU : "(1, name=AAA)"
--
data Format = SelectS
  | SelectKS | SelectKSS
  | SelectWS | SelectWSS
  | SelectWWS | SelectWWSS
  | SelectKWS | SelectKWSS
  | SelectKRS | SelectKRSS
  | SelectKRWS | SelectKRWSS
  | UpdateKU | SelectForKU
  | UpdateKUU | SelectForKUU
  deriving (Show, Read)


data FormatInfo = ToFormatInfo {
    toDmlType' :: DmlType
  , toInputFieldTypeLs' :: InputFieldTypeList
  }
  deriving (Show)

data DmlType = NoDmlType
  | Select
  | Update | SelectForUpdate
  deriving (Show, Read)

-- |
-- K : primary "K"ey
-- W : column and value for "W"here cause
-- S : column for "S"elect clause
-- U : column and value for "U"pdate
-- R : "R"elatioin
--
data InputFieldType = K | W | S | U
  | R
  deriving (Show, Eq)
type InputFieldTypeList = [InputFieldType]


