{ mkDerivation, lib, base, criterion, deepseq, doctest, hspec
, MonadRandom, QuickCheck, random, stdenv
}:
mkDerivation {
  pname = "fused-effects";
  version = "0.1.2.1";
  src = lib.cleanSource /home/cray/fused-effects;
  libraryHaskellDepends = [ base deepseq MonadRandom random ];
  testHaskellDepends = [ base doctest hspec QuickCheck ];
  benchmarkHaskellDepends = [ base criterion ];
  homepage = "https://github.com/robrix/fused-effects";
  description = "A fast, flexible, fused effect system";
  license = stdenv.lib.licenses.bsd3;
}
