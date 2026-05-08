import Distribution.Simple            (defaultMainWithHooks, simpleUserHooks, buildHook)
import Distribution.Simple.BuildPaths (autogenPackageModulesDir)
import System.Process                 (callProcess)

main :: IO ()
main = defaultMainWithHooks simpleUserHooks
  { buildHook = \ packageDescription localBuildInfo userHooks buildFlags -> do
      -- For simplicity, generate files in build/global-autogen;
      -- there they are available to all components of the package.
      callProcess "bnfc"
        [ "-o", autogenPackageModulesDir localBuildInfo
        , "-d"
        , "Lang.cf"
        ]
      -- Run the build process.
      buildHook simpleUserHooks packageDescription localBuildInfo userHooks buildFlags
  }
