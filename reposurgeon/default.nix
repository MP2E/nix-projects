{ stdenv, fetchurl, python27, asciidoc, xmlto, pkgconfig }:

stdenv.mkDerivation rec {
  name = "reposurgeon-3.18";

  src = fetchurl {
    url = "http://www.catb.org/~esr/reposurgeon/${name}.tar.gz";
    sha256 = "0ajiwx24vll11yigx9nm5jpzj5qkn5v0zsg7x03s74p8s2whldg1";
  };

  buildInputs = [ python27 asciidoc xmlto pkgconfig ];

  patchPhase = ''
    sed -i 's,#!/usr/bin/env python,#!${python27}/bin/python,g' repodiffer repopuller reposurgeon
  '';

  installPhase = ''
    make prefix=$out install

    install -dm755 "$out/share/emacs/site-lisp"
    install -Dm644 reposurgeon-mode.el "$out/share/emacs/site-lisp"

    install -Dm644 conversion.mk "$out/share/doc/reposurgeon"
  '';

  meta = with stdenv.lib; {
    description = "A tool for editing version-control repository history";
    homepage = http://www.catb.org/esr/reposurgeon/;
    license = licenses.bsd;
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.all;
  };
}

