
module Model.Value (module Model.Value
  ) where


import Database.MySQL.Simple (Only(..), fromOnly)
import Database.MySQL.Base.Types (Type(String, VarString, Tiny, Short, Int24, Long))
import qualified Database.MySQL.Base.Types as SQL (Field(..))
import qualified Database.MySQL.Simple.Result as SQL (Result, convert)

data Value = ValueInt Int | ValueString String
  deriving (Show)
instance SQL.Result Value where
  convert f bs = case typ of
    _ | typ `elem` ls -> ValueInt . SQL.convert f $ bs
      where ls = [Tiny, Short, Int24, Long]
    _ | typ `elem` ls -> ValueString . SQL.convert f $ bs
      where ls = [String, VarString]
    _ -> ValueString "invalid SQL type"
    where typ = SQL.fieldType f
type ValueList = [Value]


type QrMaybe1 = Only (Maybe Value)
type QrMbList1 = [QrMaybe1]
type QrMaybe2 = (Maybe Value, Maybe Value)
type QrMbList2 = [QrMaybe2]
type QrMaybe3 = (Maybe Value, Maybe Value, Maybe Value)
type QrMbList3 = [QrMaybe3]


