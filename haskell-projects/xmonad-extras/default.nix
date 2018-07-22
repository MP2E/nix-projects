{ mkDerivation, lib, alsa-mixer, base, bytestring, containers, hint
, libmpd, mtl, network, regex-posix, stdenv, X11, xmonad
, xmonad-contrib
}:
mkDerivation {
  pname = "xmonad-extras";
  version = "0.13.3";
  src = lib.cleanSource /home/cray/xmonad-extras;
  configureFlags = [
    "-f-with_hlist" "-fwith_parsec" "-fwith_split"
  ];
  libraryHaskellDepends = [
    alsa-mixer base bytestring containers hint libmpd mtl network
    regex-posix X11 xmonad xmonad-contrib
  ];
  homepage = "https://github.com/xmonad/xmonad-extras";
  description = "Third party extensions for xmonad with wacky dependencies";
  license = stdenv.lib.licenses.bsd3;
}
