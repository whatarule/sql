
module Command.Parse (
    module Command.Parse
  , Parsec, ParseError
  , parse, many, sepBy, (<|>)
  , char, oneOf, noneOf, alphaNum
  ) where

import Model.ModelBase
import Command.CommandBase
import Text.Parsec (
    Parsec, ParseError
  , parse, many, sepBy, (<|>)
  )
import Text.Parsec.Char (
    char, oneOf, noneOf, alphaNum
  )
import Text.Parsec.Language (haskellDef)
import qualified Text.Parsec.Token as T
-- |
lexer = T.makeTokenParser haskellDef

commaSep = T.commaSep lexer
semiSep = T.semiSep lexer
parens = T.parens lexer
identifier = T.identifier lexer
symbol = T.symbol lexer
-- |

-- |
-- fromEitherParseError . parse (noneOf "a") "" $ "a"
fromEitherParseError :: Either ParseError a -> Either ErrMsg a
fromEitherParseError ei = case ei of
  Right x         -> Right x
  Left parseError -> Left [show parseError]

