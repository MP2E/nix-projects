{ mkDerivation, base, containers, data-default, directory
, extensible-exceptions, filepath, mtl, process, QuickCheck
, setlocale, stdenv, unix, utf8-string, X11
}:
mkDerivation {
  pname = "xmonad";
  version = "0.12";
  src = /home/cray/xmonad;
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base containers data-default directory extensible-exceptions
    filepath mtl process setlocale unix utf8-string X11
  ];
  testDepends = [
    base containers extensible-exceptions QuickCheck X11
  ];
  patches = [
    ./xmonad_ghc_var_0.11.patch
  ];
  doCheck = false;
  postInstall = ''
    shopt -s globstar
    mkdir -p $out/share/man/man1
    mv "$out/"**"/man/"*.1 $out/share/man/man1/
  '';
  homepage = "http://xmonad.org";
  description = "A tiling window manager";
  license = stdenv.lib.licenses.bsd3;
}
