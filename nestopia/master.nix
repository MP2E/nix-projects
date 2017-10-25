{ stdenv, lib, cmake, pkgconfig, SDL2, alsaLib, gtk3, mesa_glu, glew, makeWrapper
, mesa, libarchive, libao, unzip, xdg_utils, gsettings_desktop_schemas, epoxy }:

stdenv.mkDerivation rec {
  name = "nestopia-20171025";
  src = lib.cleanSource /home/cray/nestopia-src;

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];
  buildInputs = [ SDL2 alsaLib gtk3 mesa_glu glew mesa
                  libarchive libao unzip xdg_utils gsettings_desktop_schemas epoxy ];

  installPhase = ''
    mkdir -p $out/{bin,share/nestopia}
    make install PREFIX=$out
  '';

  preFixup = ''
     for f in $out/bin/*; do
       wrapProgram $f \
         --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
     done
  '';

  meta = {
    homepage = http://0ldsk00l.ca/nestopia/;
    description = "NES emulator with a focus on accuracy";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

