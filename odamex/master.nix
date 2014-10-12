{ stdenv, cmake, fetchsvn, pkgconfig, SDL, SDL_mixer, SDL_net }:

stdenv.mkDerivation rec {
  name = "odamex-20141012";
  src = fetchsvn {
    url = http://odamex.net/svn/root/trunk;
    rev = "5135";
    sha256 = "0idk54cfbiqx46sri9a9gi4zdnwqlai0nzks9bkim5jq1fvy4z2k";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ stdenv cmake pkgconfig SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://odamex.net/;
    description = "A port with a focus on setting the standard in online Doom";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
