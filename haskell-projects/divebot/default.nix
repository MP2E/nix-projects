{ mkDerivation, base, bytestring, cereal, cereal-text, containers
, exceptions, lens, mtl, network, random, stdenv, text, text-format
, text-show, time
}:
mkDerivation {
  pname = "divebot";
  version = "0.1.0.0";
  src = /home/cray/divebot;
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    base bytestring cereal cereal-text containers exceptions lens mtl
    network random text text-format text-show time
  ];
  homepage = "http://github.com/MP2E/divebot";
  description = "a simple IRC markov bot";
  license = stdenv.lib.licenses.mit;
}
