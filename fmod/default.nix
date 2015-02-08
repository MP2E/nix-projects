{ stdenv, fetchurl }:

assert (stdenv.system == "x86_64-linux") || (stdenv.system == "i686-linux");
let
  bits = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") "64";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc ] + ":${stdenv.cc.cc}/lib64";
  patchLib = x: "patchelf --set-rpath ${libPath} ${x}";
in
stdenv.mkDerivation rec {
  name    = "fmod-${version}";
  version = "4.24.16";

  src = fetchurl {
    url = "http://www.fmod.org/download/fmodex/api/Linux/fmodapi42416linux${bits}.tar.gz";
    sha256 = "0hkwlzchzzgd7fanqznbv5bs53z2qy8iiv9l2y77l4sg1jwmlm6y";
  };

  dontStrip = true;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/lib $out/include/fmodex

    cd api/inc && cp * $out/include/fmodex && cd ../lib
    cp * $out/lib

    ${patchLib "$out/lib/*.so"}
  '';

  meta = {
    description = "Programming library and toolkit for the creation and playback of interactive audio";
    homepage    = "http://www.fmod.org/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.MP2E ];
  };
}
