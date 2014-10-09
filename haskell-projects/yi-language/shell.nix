let pkgs = import <nixpkgs> {};
    myHaskellPackages = pkgs.myHaskellPackages;
    haskellPackages = myHaskellPackages.override {
      extension = self: super: {
        yi = myHaskellPackages.callPackage ./. {};
      };
    };
in haskellPackages.yiLanguage
