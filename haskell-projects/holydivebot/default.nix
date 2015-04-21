{ mkDerivation, aeson, base, bytestring, containers, directory
, exceptions, filepath, lens, mtl, network, pipes, stdenv, text
, text-format, text-show, time, vector
}:
mkDerivation {
  pname = "divebot";
  version = "0.2.0.0";
  src = /home/cray/divebot;
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson base bytestring containers directory exceptions filepath lens
    mtl network pipes text text-format text-show time vector
  ];
  description = "A toy IRC Bot with various utilities";
  license = stdenv.lib.licenses.mit;
}
