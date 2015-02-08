with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, alsa-core, alsa-mixer, base, bytestring
             , containers, dbus, directory, filepath, hinotify, HTTP, libmpd
             , libXpm, libXrandr, mtl, parsec, process, regex-compat, stdenv
             , stm, time, time-locale-compat, timezone-olson, timezone-series
             , transformers, unix, utf8-string, wirelesstools, X11, X11-xft
             , Xrender
             }:
             mkDerivation {
               pname = "xmobar";
               version = "0.23";
               src = /home/cray/xmobar;
               isLibrary = false;
               isExecutable = true;
               buildDepends = [
                 alsa-core alsa-mixer base bytestring containers dbus directory
                 filepath hinotify HTTP libmpd mtl parsec process regex-compat stm
                 time time-locale-compat timezone-olson timezone-series transformers
                 unix utf8-string X11 X11-xft
               ];
               extraLibraries = [ libXpm libXrandr wirelesstools Xrender ];
               configureFlags = [ "-fall_extensions" ];
               homepage = "http://xmobar.org";
               description = "A Minimalistic Text Based Status Bar";
               license = stdenv.lib.licenses.bsd3;
             }) {};
in
  pkg.env
