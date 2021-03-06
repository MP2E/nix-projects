{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { lib, mkDerivation, base, containers, data-default, directory
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
          install -D man/xmonad.1 $doc/share/man/man1/xmonad.1
          install -D man/xmonad.hs $doc/share/doc/$name/sample-xmonad.hs
        '';
        homepage = "http://xmonad.org";
        description = "A tiling window manager";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.myHaskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
