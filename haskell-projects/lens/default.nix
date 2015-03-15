{ mkDerivation, array, base, bifunctors, bytestring, comonad
, containers, contravariant, deepseq, directory, distributive
, doctest, exceptions, filepath, free, generic-deriving, ghc-prim
, hashable, hlint, HUnit, kan-extensions, mtl, nats, parallel
, primitive, profunctors, QuickCheck, reflection, semigroupoids
, semigroups, simple-reflect, stdenv, tagged, template-haskell
, test-framework, test-framework-hunit, test-framework-quickcheck2
, test-framework-th, text, transformers, transformers-compat
, unordered-containers, vector, void
}:
mkDerivation {
  pname = "lens";
  version = "4.8";
  sha256 = "1h39cbw25aynz7kzx55i3rcz4p2mi0907ri6g78xbk2r3wf0qbnr";
  editedCabalFile = "50c7ea763fd0273f84d02acdf9cdc2b497deb83d595a231ce3c663f877bd8d33";
  buildDepends = [
    array base bifunctors bytestring comonad containers contravariant
    distributive exceptions filepath free ghc-prim hashable
    kan-extensions mtl parallel primitive profunctors reflection
    semigroupoids semigroups tagged template-haskell text transformers
    transformers-compat unordered-containers vector void
  ];
  testDepends = [
    base bytestring containers deepseq directory doctest filepath
    generic-deriving hlint HUnit mtl nats parallel QuickCheck
    semigroups simple-reflect test-framework test-framework-hunit
    test-framework-quickcheck2 test-framework-th text transformers
    unordered-containers vector
  ];
  homepage = "http://github.com/ekmett/lens/";
  description = "Lenses, Folds and Traversals";
  license = stdenv.lib.licenses.bsd3;
}
