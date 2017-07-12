
module Model.InputInfo (module Model.InputInfo
  ) where

import Model.SubQuery
import Model.Format

data InputInfo = InputInfo {
    toSubQuery :: SubQuery
  , toFormat :: Format
  , toInputString :: InputString
  } deriving (Show)
type InputString = String
type InputStringList = [String]


data InfoFormat = InputInfoFormat
  deriving (Show, Read)

data InfoFormatField = SubQuery | Format | InputString
  deriving (Show, Read, Eq)
type InfoFormatFieldList = [InfoFormatField]


