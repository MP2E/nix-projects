{ mkDerivation, async, attoparsec, base, base64-bytestring
, bytestring, Cabal, config-schema, config-value, containers
, directory, filepath, free, gitrev, hashable, hookup, HsOpenSSL
, HUnit, irc-core, kan-extensions, lens, network, process
, regex-tdfa, semigroupoids, split, stdenv, stm, template-haskell
, text, time, transformers, unix, unordered-containers, vector, vty
}:
mkDerivation {
  pname = "glirc";
  version = "2.27";
  sha256 = "fcc9145d9edf94341e95ec5c96b0f2e6d2271c6eaf2dd1c8004f5b20c080f058";
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  setupHaskellDepends = [ base Cabal filepath ];
  libraryHaskellDepends = [
    async attoparsec base base64-bytestring bytestring config-schema
    config-value containers directory filepath free gitrev hashable
    hookup HsOpenSSL irc-core kan-extensions lens network process
    regex-tdfa semigroupoids split stm template-haskell text time
    transformers unix unordered-containers vector vty
  ];
  executableHaskellDepends = [ base lens text vty ];
  testHaskellDepends = [ base HUnit ];
  homepage = "https://github.com/glguy/irc-core";
  description = "Console IRC client";
  license = stdenv.lib.licenses.isc;
}
