let pkgs = import <nixpkgs> {};
    myHaskellPackages = pkgs.myHaskellPackages;
    haskellPackages = myHaskellPackages.override {
      extension = self: super: {
        xmobar = myHaskellPackages.callPackage ./. {};
      };
    };
in haskellPackages.xmobar
