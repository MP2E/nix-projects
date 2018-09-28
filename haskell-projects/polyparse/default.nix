{ mkDerivation, base, bytestring, stdenv, text }:
mkDerivation {
  pname = "polyparse";
  version = "1.12";
  sha256 = "f54c63584ace968381de4a06bd7328b6adc3e1a74fd336e18449e0dd7650be15";
  revision = "1";
  editedCabalFile = "18daiyj3009wx0bhr87fbgy7xfh68ss9qzn6k3lgmh1z9dfsryrd";
  jailbreak = true;
  patches = [ ./polyparse-ghc-8.6-fix.patch ];
  libraryHaskellDepends = [ base bytestring text ];
  homepage = "http://code.haskell.org/~malcolm/polyparse/";
  description = "A variety of alternative parser combinator libraries";
  license = "LGPL";
}
