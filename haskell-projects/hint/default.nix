{ mkDerivation, lib, base, directory, exceptions, extensible-exceptions
, filepath, ghc, ghc-boot, ghc-paths, HUnit, mtl, random, stdenv
, unix, temporary
}:
mkDerivation {
  pname = "hint";
  version = "0.8.0";
  src = lib.cleanSource /home/cray/hint;
  libraryHaskellDepends = [
    base directory exceptions filepath ghc ghc-boot ghc-paths mtl
    random unix temporary
  ];
  testHaskellDepends = [
    base directory exceptions extensible-exceptions filepath HUnit unix
    temporary
  ];
  homepage = "https://github.com/mvdan/hint";
  description = "Runtime Haskell interpreter (GHC API wrapper)";
  license = stdenv.lib.licenses.bsd3;
}
