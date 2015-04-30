with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, async, base, bytestring, cabal-helper, cereal
             , containers, data-default, deepseq, directory, djinn-ghc, doctest
             , emacs, filepath, ghc, ghc-paths, ghc-syb-utils, haskell-src-exts
             , hlint, hspec, makeWrapper, monad-control, monad-journal, mtl
             , old-time, pretty, process, split, stdenv, syb, temporary, text
             , time, transformers, transformers-base
             }:
             mkDerivation {
               pname = "ghc-mod";
               version = "0";
               src = /home/cray/ghc-mod;
               isLibrary = true;
               isExecutable = true;
               buildDepends = [
                 async base bytestring cabal-helper cereal containers data-default
                 deepseq directory djinn-ghc filepath ghc ghc-paths ghc-syb-utils
                 haskell-src-exts hlint monad-control monad-journal mtl old-time
                 pretty process split syb temporary text time transformers
                 transformers-base
               ];
               testDepends = [ base doctest hspec ];
               buildTools = [ emacs makeWrapper ];
               configureFlags = "--datasubdir=ghc-mod-0";
               postInstall = ''
                 cd $out/share/ghc-mod-0
                 make
                 rm Makefile
                 cd ..
                 ensureDir "$out/share/emacs"
                 mv ghc-mod-0 emacs/site-lisp
               '';
               homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
               description = "Happy Haskell Programming";
               license = stdenv.lib.licenses.agpl3;
             }) {};
in
  pkg.env
