{ mkDerivation, base, bytestring, Cabal, data-default, directory
, filepath, ghc-prim, mtl, process, stdenv, template-haskell
, temporary, transformers
}:
mkDerivation {
  pname = "cabal-helper";
  version = "0.3.3.0";
  sha256 = "0bvd7qf206slg4ckjc7bjjfrgdxsq3kmb9rp8qp7lfc81ccnr09j";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base bytestring Cabal data-default directory filepath ghc-prim mtl
    process template-haskell temporary transformers
  ];
  description = "Simple interface to Cabal's configuration state used by ghc-mod";
  license = stdenv.lib.licenses.agpl3;
}
