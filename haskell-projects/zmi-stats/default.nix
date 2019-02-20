{ mkDerivation, lib, base, bytestring, cassava, containers
, discord-haskell, extra, mtl, sort, stdenv, text, time
}:
mkDerivation {
  pname = "zmi-stats";
  version = "0.2.0.0";
  src = lib.cleanSource /home/cray/zmi-stats-git;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring cassava containers discord-haskell extra mtl sort
    text time
  ];
  homepage = "https://github.com/MP2E/zmi-stats";
  description = "Discord bot to compile ZMI Runner stats in OSRS";
  license = stdenv.lib.licenses.bsd3;
}
