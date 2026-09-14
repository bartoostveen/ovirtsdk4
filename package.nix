{
  lib,
  python314Packages,
  nix-update-script,
  pkg-config,
  libxml2,
}:

let
  src = lib.sourceFilesBySuffices ./. [
    ".c"
    ".h"
    ".py"
    ".toml"
    ".crt"
    ".key"
  ];

  python3Packages = python314Packages;
in
python3Packages.buildPythonPackage {
  pname = "ovirtsdk4";
  version = ("${src}/pyproject.toml" |> builtins.readFile |> fromTOML).project.version;
  pyproject = true;
  __structuredAttrs = true;

  inherit src;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.pycurl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for oVirt Engine API";
    homepage = "https://git.bartoostveen.nl/bart/ovirtsdk4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bartoostveen ];
    platforms = lib.platforms.all;
  };
}
