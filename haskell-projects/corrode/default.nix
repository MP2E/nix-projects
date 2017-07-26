{ mkDerivation, array, base, bytestring, containers, filepath
, language-c, markdown-unlit, pretty, stdenv, tasty
, tasty-quickcheck, transformers
}:
mkDerivation {
  pname = "corrode";
  version = "0.1.0.0";
  src = /home/cray/corrode-src;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base containers language-c markdown-unlit pretty transformers
  ];
  executableHaskellDepends = [
    base bytestring filepath language-c markdown-unlit pretty
    transformers
  ];
  testHaskellDepends = [
    base containers pretty tasty tasty-quickcheck transformers
  ];
  license = stdenv.lib.licenses.gpl2;
}
