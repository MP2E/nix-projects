with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, array, base, bytestring, containers, directory
             , filepath, ghc, ghc-paths, haskeline, process, stdenv, syb, time
             , transformers, unix
             }:
             mkDerivation {
               pname = "ghci-ng";
               version = "0.0.0";
               src = /home/cray/ghci-ng;
               isLibrary = false;
               isExecutable = true;
               buildDepends = [
                 array base bytestring containers directory filepath ghc ghc-paths
                 haskeline process syb time transformers unix
               ];
               homepage = "https://github.com/chrisdone/ghci-ng";
               description = "Next generation GHCi";
               license = stdenv.lib.licenses.bsd3;
             }) {};
in
  pkg.env
