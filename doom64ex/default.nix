{ stdenv, cmake, SDL2, SDL2_net, fluidsynth, zlib, libpng, mesa, pkgconfig }:

stdenv.mkDerivation {
  name = "doom64ex-2.6";
  src = /home/cray/kexplus;

  buildInputs = [ cmake SDL2 SDL2_net fluidsynth zlib libpng mesa pkgconfig ];

  cmakeFlags = [ "-DUSE_SDL2=True" ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp src/doom64ex $out/bin
  '';

  meta = {
    homepage = http://doom64ex.wordpress.com/;
    description = "MP2E's branch of Doom64 EX";
  };
}

