{ stdenv, fetchurl, cmake, SDL, nasm, zlib, flac, fmod_4_24_16, libjpeg, fetchhg, openssl, mesa, pkgconfig }:

stdenv.mkDerivation {
  name = "zandronum-1.3";
  src = /home/cray/zandronum;
# src = fetchhg {
#   url = https://bitbucket.org/Torr_Samaho/zandronum;
#   rev = "03d4c3286dce2148475bc0ff7cfde7e792d53999";
#   sha256 = "16vmysiyz8ar1sswyiyvn4yk2z3jf3wkyq2qn1gflp2936xj9707";
# };

  buildInputs = [ cmake nasm SDL zlib flac fmod_4_24_16 libjpeg openssl mesa pkgconfig ];

  cmakeFlags = [ "-DSDL_INCLUDE_DIR=${SDL}/include/SDL -DFMOD_LIBRARY=${fmod_4_24_16}/lib/libfmodex64-4.24.16.so -DFMOD_INCLUDE_DIR=${fmod_4_24_16}/include/fmodex" ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp zandronum $out/bin
    cp zandronum.pk3 $out/bin
    cp skulltag_actors.pk3 $out/bin
  '';

  meta = {
    homepage = http://zandronum.com/;
    description = "Enhanced online multiplayer Doom port";
  };
}

