{ pkgs }:

with import ../../nixpkgs/pkgs/development/haskell-modules/lib.nix { inherit pkgs; };
with pkgs;
let
  # Directories where I'll store extra packages.
  normalProjectDir = "/home/cray/nix-projects/";
  haskellProjectDir = normalProjectDir + "haskell-projects/";

  # Wrap callPackage with the default Haskell directories.
  haskellPackage = s: p: s.callPackage (haskellProjectDir + p) {};
  haskellPackageS = s: p: s.callPackage (haskellProjectDir + p);
  haskellPackageC = s: p: v: s.callPackage (haskellProjectDir + p) v;

  # Wrap callPackage with the default non-Haskell directories.
  normalPackage = p: callPackage (normalProjectDir + p) {};
  normalPackage32 = p: callPackage_i686 (normalProjectDir + p) {};
  normalPackageS = s: p: s.callPackage (normalProjectDir + p) {};
  normalPackageO = p: v: callPackage (normalProjectDir + p) v;
  normalPackageC = s: p: v: s.callPackage (normalProjectDir + p) v;

  # Custom dev package function
  devPackage = p: callPackage (normalProjectDir + p + "/master.nix") {};
  devPackageC = s: p: v: s.callPackage (normalProjectDir + p + "/master.nix") v;

in
{ allowUnfree = true;
  packageOverrides = self: rec {
    # Haskell packages I want to use that reside out of nixpkgs or don't
    # have the settings I want.
    ownHaskellPackages = ver : recurseIntoAttrs (ver.override {
      overrides = se : super : rec {
        divebot          = haskellPackage se "divebot";
        # needed for xmonad master
        xmonad           = haskellPackage se "xmonad";
        xmonad-contrib   = haskellPackage se "xmonad-contrib";
        total            = doJailbreak super.total;
        corrode          = haskellPackage se "corrode";
        brick            = super.brick_0_19;
        cabal2nix        = haskellPackage se "cabal2nix";

        libmpd = se.callPackage ../haskell-projects/libmpd {};

        # overrides below copied from:
        # https://gist.github.com/nh2/a6de5e5409c8893d67ef444a7664ed98

        # GHC 8.2 fixes

        # fix upper bounds with doJailbreak
        dynamic-mvector = pkgs.haskell.lib.doJailbreak super.dynamic-mvector;
        threads = pkgs.haskell.lib.doJailbreak super.threads;
        pqueue = pkgs.haskell.lib.doJailbreak super.pqueue;
        quickcheck-instances = pkgs.haskell.lib.doJailbreak super.quickcheck-instances;
        repa = pkgs.haskell.lib.doJailbreak super.repa;
        safecopy = pkgs.haskell.lib.doJailbreak super.safecopy;
        aeson = pkgs.haskell.lib.doJailbreak super.aeson;
        opaleye = pkgs.haskell.lib.doJailbreak super.opaleye;
        servant = pkgs.haskell.lib.doJailbreak super.servant;
        servant-server = pkgs.haskell.lib.doJailbreak super.servant-server;
        servant-client = pkgs.haskell.lib.doJailbreak super.servant-client;
        # fix tests pulling in `rebase` package that's broken with 8.2
        vector-builder = pkgs.haskell.lib.dontCheck super.vector-builder; # https://github.com/nikita-volkov/rebase/issues/9

        # https://github.com/albertoruiz/hmatrix/pull/231
        hmatrix = pkgs.haskell.lib.overrideCabal super.hmatrix (old: {
          src = fetchgit {
            url = "https://github.com/nh2/hmatrix.git";
            rev = "8e79121454171b145e5d102e5713299b43604d88";
            sha256 = "0ksjzvmsdijmvf66dn7pmjy3l2fg4zsbpglvc0bvjvylnhxy521r";
          };
          prePatch = ''
            cd packages/base
          '';
        });

        # If this doesn't work, disable tests for `yaml`, because then
        # `aeson-qq` doesn't get pulled in, and then `haskell-src-meta` doesn't.
        haskell-src-meta = pkgs.haskell.lib.doJailbreak (pkgs.haskell.lib.overrideCabal super.haskell-src-meta (old: {
          version = "0.8.0.1";
          editedCabalFile = null;
          revision = null;
          sha256 = "1i5f21mx061k50nl3pvvffjqsbvvldl50y8d4b9b31g63l0jg5q9";
          doCheck = false; # Setup: Encountered missing dependencies: HUnit -any, test-framework -any, test-framework-hunit -any
        }));

        # 0.5.1 gives:
        #   test/Windows.hs:60:15: error:
        #       • Exception when trying to run compile-time code:
        #           InvalidAbsDir "C:\\chris\\"
        path = pkgs.haskell.lib.overrideCabal super.path (old: {
          version = "0.6.1";
          sha256 = "0nayla4k1gb821k8y5b9miflv1bi8f0czf9rqr044nrr2dddi2sb";
          doCheck = false; # Setup: Encountered missing dependencies: genvalidity ==0.3.*, genvalidity-property ==0.0.*, validity >=0.3.1.1 && <0.4
        });
        path-io = pkgs.haskell.lib.overrideCabal super.path-io (old: {
          version = "1.3.2";
          sha256 = "031y6dypf6wnwx7fnjyvn2sb5y1lxfibx0jnwc19h93harm3lfyp";
          editedCabalFile = null;
          revision = null;
          doCheck = false; # fails with CCP error "error: missing binary operator before token" (somehow MIN_VERSION_directory isn't defined)
        });

        # https://github.com/fpco/store/pull/110
        store = pkgs.haskell.lib.overrideCabal super.store (old: {
          src = fetchgit {
            url = "https://github.com/fpco/store.git";
            rev = "63e56ec4b8eb137bcca217eb0dcd56db129c898a";
            sha256 = "0mgiwxq749kwcm9m58jh7j6p5vzal3lxs0yga5dfz8cri240jbk4";
          };
          doCheck = false; # https://github.com/fpco/store/issues/111
        });
      };
    });

    # Derive package sets for the versions of GHC I'm interested in.
    myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc821;

    haskellEnv = myHaskellPackages.ghcWithPackages (p: with p; [
      attoparsec parsec aeson mtl transformers lens lens-aeson
      text random vector stm comonad free total network HTTP
      QuickCheck deepseq deepseq-generics hspec optparse-applicative
      bytestring pipes turtle foldl cereal OpenGL GLUT
      hlint cabal-install hoogle yesod yesod-bin djinn alex happy
      intero stack
      xmonad xmonad-contrib xmobar
      corrode
    ]);

#   jsEnv = haskell.packages.ghcjs.ghcWithPackages (p: with p; [
#     reflex reflex-dom ghcjs-dom
#   ]);

    # Packages that aren't Haskell packages.
    sixpair      = normalPackage "sixpair";
    doom64ex     = normalPackage "doom64ex";
    wadgen       = normalPackage "wadgen";
    slade        = normalPackageO "slade" { wxGTK30 = pkgs.wxGTK30.override { withWebKit = true; }; };
    zdbsp        = normalPackage "zdbsp";
    strife       = normalPackage "strife-ve";

    # Development versions of packages
    odamexMaster        = devPackage "odamex";
    eternityMaster      = devPackage "eternity-engine";
    chocolateDoomMaster = devPackage "chocolate-doom";
    nestopiaMaster      = devPackage "nestopia";
    mgbaMaster          = devPackageC libsForQt5 "mgba" {};

    wineStaging = self.winePackages.full.override {
      wineRelease = "staging";
      wineBuild = "wineWow";
      gstreamerSupport = false;
    };

    winetricks = self.winetricks.override {
      wine = wineStaging;
    };

    # Package overrides
    ffmpeg     = self.ffmpeg-full.override {
#                                             enableLto        = true;
                                              nonfreeLicensing = true;
                                              alsaLib          = pkgs.alsaLib;
                                              fdkaacExtlib     = true;
                                              fdk_aac          = pkgs.fdk_aac;
                                              lame             = pkgs.lame;
                                              libogg           = pkgs.libogg;
                                              libopus          = pkgs.libopus;
                                              libass           = pkgs.libass;
                                              libvpx           = pkgs.libvpx;
                                              libva            = pkgs.libva;
                                              libvdpau         = pkgs.libvdpau;
                                              libvorbis        = pkgs.libvorbis;
                                              libpulseaudio    = pkgs.libpulseaudio;
                                              lzma             = pkgs.xz;
                                              nvenc            = true;
                                              nvidia-video-sdk = pkgs.nvidia-video-sdk;
                                              x264             = pkgs.x264;
                                              x265             = pkgs.x265;
                                              zlib             = pkgs.zlib;
                                              SDL2             = pkgs.SDL2;
                                           };
    SDL_mixer  = self.SDL_mixer.override   { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
    SDL2_mixer = self.SDL2_mixer.override  { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
    obs-studio = self.obs-studio.override  { pulseaudioSupport = true; };
  };
}
