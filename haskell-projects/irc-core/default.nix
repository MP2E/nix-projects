{ mkDerivation, attoparsec, base, base64-bytestring, bytestring
, hashable, HUnit, primitive, stdenv, text, time, vector
}:
mkDerivation {
  pname = "irc-core";
  version = "2.4.0";
  sha256 = "1e3480ec72b050b1708b7b603e44851ed4eb6a6f8f686ad094a77860d75ca3d1";
  libraryHaskellDepends = [
    attoparsec base base64-bytestring bytestring hashable primitive
    text time vector
  ];
  testHaskellDepends = [ base hashable HUnit text ];
  homepage = "https://github.com/glguy/irc-core";
  description = "IRC core library for glirc";
  license = stdenv.lib.licenses.isc;
}
