{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, containers, contravariant, data-clist
      , deepseq, dlist, microlens, microlens-mtl, microlens-th, stdenv
      , stm, template-haskell, text, text-zipper, transformers, vector
      , vty
      }:
      mkDerivation {
        pname = "brick";
        version = "0.19";
        sha256 = "17n8qcds1pv5vijpzw0w47qijcjxcydf3glwjxj645y0k8lpdcl1";
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base containers contravariant data-clist deepseq dlist microlens
          microlens-mtl microlens-th stm template-haskell text text-zipper
          transformers vector vty
        ];
        homepage = "https://github.com/jtdaugherty/brick/";
        description = "A declarative terminal user interface library";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
