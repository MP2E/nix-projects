{ mkDerivation, lib, base, bytestring, cassava, Chart, Chart-cairo
, containers, discord-haskell, extra, mtl, sort, stdenv, temporary
, text, time
}:
mkDerivation {
  pname = "zmi-stats";
  version = "0.5.0.0";
  src = lib.cleanSource /home/cray/zmi-stats-git;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring cassava Chart Chart-cairo containers
    discord-haskell extra mtl sort temporary text time
  ];
  homepage = "https://github.com/MP2E/zmi-stats";
  description = "Discord bot to compile ZMI Runner stats in OSRS";
  license = stdenv.lib.licenses.bsd3;
}
