
module Command.FromInputString (module Command.FromInputString
  ) where

import Model.ModelBase
import Model.InputInfo
import Command.Parse

-- |
-- >>> parseInputStringEi "(1,name)"
-- Right ["1","name"]
-- >>> parseInputStringEi "(1,name_test)"
-- Right ["1","name_test"]
-- >>> parseInputStringEi "(1,name!)"
-- Left ["(line 1, column 8):\nunexpected \"!\"\nexpecting \",\" or \")\""]
--
parseInputStringEi :: InputString -> Either ErrMsg StringList
parseInputStringEi = fromEitherParseError
  . parse (parens . commaSep $ many (alphaNum <|> oneOf "_-=")) ""

