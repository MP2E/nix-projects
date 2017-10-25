{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, containers, directory
      , extensible-exceptions, filepath, mtl, old-locale, old-time
      , process, random, stdenv, unix, utf8-string, X11, X11-xft, xmonad
      }:
      mkDerivation {
        pname = "xmonad-contrib";
        version = "0.13";
        src = lib.cleanSource /home/cray/XMonadContrib;
        libraryHaskellDepends = [
          base bytestring containers directory extensible-exceptions filepath
          mtl old-locale old-time process random unix utf8-string X11 X11-xft
          xmonad
        ];
        homepage = "http://xmonad.org/";
        description = "Third party extensions for xmonad";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
