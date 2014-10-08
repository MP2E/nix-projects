let pkgs = import <nixpkgs> {};
    myHaskellPackages = pkgs.myHaskellPackages;
    haskellPackages = myHaskellPackages.override {
      extension = self: super: {
        yiContrib = myHaskellPackages.callPackage ./. {};
      };
    };
in haskellPackages.yiContrib
