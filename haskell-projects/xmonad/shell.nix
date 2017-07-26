{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, containers, data-default, directory
      , extensible-exceptions, filepath, mtl, process, QuickCheck
      , setlocale, stdenv, unix, utf8-string, X11
      }:
      mkDerivation {
        pname = "xmonad";
        version = "0.13";
        src = /home/cray/xmonad;
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
          mkdir -p $out/share/man/man1
          mv "$out/"**"/man/"*.1 $out/share/man/man1/
        '';
        homepage = "http://xmonad.org";
        description = "A tiling window manager";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
