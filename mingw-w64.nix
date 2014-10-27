{
  windows32 = import <nixpkgs> {
    system = "x86_64-linux";
    crossSystem = {
      config = "i686-w64-mingw32";
      arch = "x86";
      libc = "msvcrt";
      platform = {};
      openssl.system = "mingw";
    };
  };

  windows64 = import <nixpkgs> {
    system = "x86_64-linux";
    crossSystem = {
      config = "x86_64-w64-mingw32";
      arch = "x86_64";
      libc = "msvcrt";
      platform = {};
      openssl.system = "mingw64";
    };
  };
}