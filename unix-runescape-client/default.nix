{ stdenv, lib, makeWrapper, fetchFromGitHub, jre, wget, xdg_utils, pulseaudio, p7zip, perl, ListMoreUtils, ConfigIniFiles, ArchiveExtract, Wx }:

stdenv.mkDerivation rec {
  name = "unix-runescape-client-${version}";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "rsu-client";
    repo = "rsu-client";
    rev = "a298a37eb54b3554d56a6bec52dbe02628e1af91";
    sha256 = "0nj8bvr14srpsvzm874j2nflx9an21xb3q2kzcbas9ap76b9yyb1";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ListMoreUtils ConfigIniFiles ArchiveExtract Wx ];

  runtimeDependencies = [ wget xdg_utils p7zip jre pulseaudio ];

  installPhase = ''
    mkdir -p $out/{bin,share,runescape}

    cd runescape

    rm -rf rsu/3rdParty

    for i in templates/packaging/usr/games/* templates/packaging/usr/share/applications/*; do
      substituteInPlace $i --replace /opt/ "$out/"
    done

    cp -t "$out/runescape" *.txt runescape updater rsu-settings AUTHORS
    cp -Rt "$out/runescape" share rsu
    cp -Rt "$out/bin" templates/packaging/usr/games/*
    cp -Rt "$out/share" templates/packaging/usr/share/*

    for i in $out/bin/*; do
      wrapProgram $i --prefix PERL5LIB : $PERL5LIB
    done
  '';

  patches = [ ./fix-paths.patch ];

  meta = with stdenv.lib; {
    description = "A Unix old-school RuneScape client";
    homepage = https://github.com/rsu-client/rsu-client;
    maintainers = [ maintainers.MP2E ];
    platforms = platforms.all;
  };
}
