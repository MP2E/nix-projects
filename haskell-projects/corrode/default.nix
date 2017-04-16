{ mkDerivation, array, base, bytestring, containers, filepath
, language-c_0_6_1, markdown-unlit, pretty, stdenv, tasty
, tasty-quickcheck, transformers, happy, alex
}:
mkDerivation {
  pname = "corrode";
  version = "0.1.0.0";
  src = /home/cray/corrode-src;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base containers language-c_0_6_1 markdown-unlit pretty transformers
  ];
  executableHaskellDepends = [
    base bytestring filepath language-c_0_6_1 markdown-unlit pretty
    transformers happy alex
  ];
  testHaskellDepends = [
    base containers pretty tasty tasty-quickcheck transformers
  ];
  license = stdenv.lib.licenses.gpl2;
}
