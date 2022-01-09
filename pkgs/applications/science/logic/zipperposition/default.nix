{ lib
, fetchFromGitHub
, stdenv
, ocamlPackages
}:

stdenv.mkDerivation rec {
  pname = "zipperposition";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "sneeuwballen";
    repo = pname;
    rev = version;
    sha256 = "sha256-FHNl4kXQ1JMNQ78LUTOvwiYZIOjPZKrh6C4VJwlSJOs=";
  };

  nativeBuildInputs = with ocamlPackages; [ ocaml dune_2 findlib ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';
  checkPhase = ''
    runHook preCheck
    dune runtest -p ${pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${pname}
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/sneeuwballen/zipperposition";
    description = ''
      An automatic theorem prover in OCaml for typed higher-order logic with
      equality and datatypes, based on superposition+rewriting; and Logtk, a
      supporting library for manipulating terms, formulas, clauses, etc.
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ _1000teslas ];
  };
}
