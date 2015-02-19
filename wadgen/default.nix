{ stdenv, cmake, zlib, libpng, pkgconfig }:

stdenv.mkDerivation {
  name = "wadgen-2.6";
  src = /home/cray/wadgen;

  buildInputs = [ cmake zlib libpng pkgconfig ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp src/wadgen $out/bin
  '';

  meta = {
    homepage = http://doom64ex.wordpress.com/;
    description = "MP2E's branch of wadgen for Doom64 EX";
  };
}

