{ mkDerivation, lib, base, hpack, mmorph, mtl, stdenv, transformers }:
mkDerivation {
  pname = "too-fast-too-free";
  version = "0.1.0.0";
  src = lib.cleanSource /home/cray/haskell-stuff/too-fast-too-free;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base mmorph mtl transformers ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base mmorph mtl transformers ];
  testHaskellDepends = [ base mmorph mtl transformers ];
  preConfigure = "hpack";
  homepage = "https://github.com/isovector/too-fast-too-free#readme";
  license = stdenv.lib.licenses.bsd3;
}
