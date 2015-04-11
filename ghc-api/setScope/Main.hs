import Control.Applicative
import DynFlags
import GHC
import GHC.Paths
import GhcMonad ( liftIO )
import HsImpExp ( simpleImportDecl )

--(+++) = liftA2 (++)

preludeModuleName :: ModuleName
preludeModuleName = GHC.mkModuleName "Prelude"

implicitPreludeImport :: InteractiveImport
implicitPreludeImport = IIDecl (simpleImportDecl preludeModuleName)

main = defaultErrorHandler defaultFatalMessager defaultFlushOut $ do
    runGhc (Just libdir) $ do
        dflags <- getSessionDynFlags
        setSessionDynFlags $ dflags { hscTarget = HscInterpreted
                                    , ghcLink   = LinkInMemory
                                    }
        --setTargets =<< sequence [ guessTarget "test.hs" Nothing ]
        --load LoadAllTargets
        -- Bringing the module into the context
        setContext [implicitPreludeImport]

        let typesStr = ["Bool", "Integer", "String", "Char", "Double"]
        --names <- foldl1 (+++) (map GHC.parseName typesStr)
        --let names = map (\t -> (t, GHC.parseName t)) typesStr


        --names <- GHC.parseName "Bool" +++
        --         GHC.parseName "Integer" +++
        --         GHC.parseName "String" +++
        --         GHC.parseName "Char" +++
        --         GHC.parseName "Double"

        --liftIO $ mapM_ (putStrLn . nameToStr) names
        printNames typesStr
    where
      nameToStr name = moduleNameString $ moduleName $ nameModule name

      printNames [] = liftIO $ return ()
      printNames (t:ts) = do
        names' <- GHC.parseName t
        liftIO $ mapM_ (putStrLn . (++) (t ++ " -> ") . nameToStr) names'
        printNames ts

