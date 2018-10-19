{ mkDerivation, lib, base, containers, data-default, directory
, extensible-exceptions, filepath, mtl, process, QuickCheck
, setlocale, stdenv, unix, utf8-string, X11
}:
mkDerivation {
  pname = "xmonad";
  version = "0.15";
  src = lib.cleanSource /home/cray/xmonad;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers data-default directory extensible-exceptions
    filepath mtl process setlocale unix utf8-string X11
  ];
  executableHaskellDepends = [ base mtl unix X11 ];
  testHaskellDepends = [
    base containers extensible-exceptions QuickCheck X11
  ];
  postInstall = ''
    shopt -s globstar
    mkdir -p $doc/share/man/man1
    mv "$data/"**"/man/"*[0-9] $doc/share/man/man1/
    rm "$data/"**"/man/"*
  '';
  homepage = "http://xmonad.org";
  description = "A tiling window manager";
  license = stdenv.lib.licenses.bsd3;
}
