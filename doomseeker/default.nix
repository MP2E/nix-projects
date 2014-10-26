{ stdenv, cmake, fetchhg, pkgconfig, qt4, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "doomseeker-20140921";
  src = fetchhg {
    url = https://bitbucket.org/Blzut3/doomseeker;
    rev = "79a8e5820f73";
    sha256 = "0k3pb2na38xm366lda0chlg1vs57lvp9vq1zpdbaiz2nsqqawgid";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ cmake pkgconfig qt4 zlib bzip2 ];

  enableParallelBuilding = true;

  patchPhase = ''
    sed -e 's#/usr/share/applications#$out/share/applications#' -i src/core/CMakeLists.txt
  '';

  meta = {
    homepage = http://doomseeker.drdteam.org/;
    description = "Doomseeker is a multiplayer server browser for many Doom source ports";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
