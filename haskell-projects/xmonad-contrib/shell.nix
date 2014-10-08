let pkgs = import <nixpkgs> {};
    myHaskellPackages = pkgs.myHaskellPackages;
    haskellPackages = myHaskellPackages.override {
      extension = self: super: {
        xmonadContrib = myHaskellPackages.callPackage ./. {};
      };
    };
in haskellPackages.xmonadContrib
