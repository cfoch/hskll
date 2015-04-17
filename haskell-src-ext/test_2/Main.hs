module Main (
    main,
    getTypeParents
  ) where

import GHC
import GHC.Paths --libdir
import Language.Haskell.Exts
import Language.Haskell.Exts.Syntax

import System.Environment ( getArgs )

getTypeParents :: GhcMonad m => String -> [String] -> m String
getTypeParents aType tsTypes = do
  names <- GHC.parseName aType
  return "HOLA"

main = do
  args <- getArgs
  let filePath = args !! 0
  parseResult <- parseFile filePath
  let md = fromParseResult parseResult

  print md


  where
    parseResultFailed (ParseOk _) = False
    parseResultFailed (ParseFailed _ _) = True
