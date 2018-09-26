{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, lib, base, bytestring, containers, directory
      , extensible-exceptions, filepath, mtl, old-locale, old-time
      , process, random, semigroups, stdenv, unix, utf8-string, X11
      , X11-xft, xmonad
      }:
      mkDerivation {
        pname = "xmonad-contrib";
        version = "0.14";
        src = lib.cleanSource /home/cray/XMonadContrib;
        libraryHaskellDepends = [
          base bytestring containers directory extensible-exceptions filepath
          mtl old-locale old-time process random semigroups unix utf8-string
          X11 X11-xft xmonad
        ];
        homepage = "http://xmonad.org/";
        description = "Third party extensions for xmonad";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.myHaskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
