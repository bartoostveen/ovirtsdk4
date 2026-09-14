{
  lib,
  python3Packages,
  nix-update-script,
  libxml2,
}:

let
  src = lib.cleanSourceWith {
    src = ./.;
    name = "source";
    filter =
      path: type: builtins.match ".*\\.(c|h|py|toml)" path != null;
  };
in
python3Packages.buildPythonPackage (finalAttrs: {
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

  buildInputs = [
    libxml2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for oVirt Engine API";
    homepage = "https://git.bartoostveen.nl/bart/ovirtsdk4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bartoostveen ];
    platforms = lib.platforms.all;
  };
})
