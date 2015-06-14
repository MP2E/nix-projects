{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7101" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bound, hashable, hashable-extras
      , lexer-applicative, logict, mainland-pretty, optparse-applicative
      , parsec, prelude-extras, regex-applicative, srcloc, stdenv
      , transformers, tuples-homogenous-h98, unordered-containers
      }:
      mkDerivation {
        pname = "prover";
        version = "0.1";
        src = /home/cray/prover-src;
        isLibrary = false;
        isExecutable = true;
        buildDepends = [
          base bound hashable hashable-extras lexer-applicative logict
          mainland-pretty optparse-applicative parsec prelude-extras
          regex-applicative srcloc transformers tuples-homogenous-h98
          unordered-containers
        ];
        homepage = "https://github.com/feuerbach/prover";
        description = "Lambda equality prover";
        license = stdenv.lib.licenses.mit;
      };

  drv = pkgs.haskell.packages.${compiler}.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
