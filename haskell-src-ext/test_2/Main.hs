module Main (
    main
  ) where

import Language.Haskell.Exts
import Language.Haskell.Exts.Syntax

import System.Environment ( getArgs )

main = do
  args <- getArgs
  let filePath = args !! 0
  parseResult <- parseFile filePath
  let md = fromParseResult parseResult

  print md


  where
    parseResultFailed (ParseOk _) = False
    parseResultFailed (ParseFailed _ _) = True
