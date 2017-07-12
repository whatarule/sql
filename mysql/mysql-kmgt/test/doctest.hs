
import Test.DocTest

main :: IO ()
main = doctest [
    "-isrc"

  , "src/Command.hs"
  , "src/Command/CommandBase.hs"
  , "src/Command/Parse.hs"
  , "src/Command/FromInfoFormat.hs"
  , "src/Command/FromSubQuery.hs"
  , "src/Command/FromFormat.hs"
  , "src/Command/FromFormat/ToFormatInfo.hs"
  , "src/Command/FromInputString.hs"
  , "src/Command/FromValue.hs"

  , "src/Lib.hs"
  , "src/Lib/ToQuery.hs"
  , "src/Lib/ToQuery/ToDmlClause.hs"
  , "src/Lib/ToQuery/ToWhereClause.hs"
  , "src/Lib/ToQuery/ToString.hs"
  , "src/Lib/ToValueList.hs"
  , "src/Lib/ToValueList/ToQueryMaybe.hs"

  ]


