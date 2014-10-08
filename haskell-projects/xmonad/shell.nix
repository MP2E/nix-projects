let pkgs = import <nixpkgs> {};
    myHaskellPackages = pkgs.myHaskellPackages;
    haskellPackages = myHaskellPackages.override {
      extension = self: super: {
        xmonad = myHaskellPackages.callPackage ./. {};
      };
    };
in haskellPackages.xmonad
