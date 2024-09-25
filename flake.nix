{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    default_templates.url = "github:NixOS/templates";
  };
  outputs = { self, nixpkgs, utils, default_templates }:
    let
      subdirs = nixpkgs.lib.attrsets.filterAttrs
        (n: v: v == "directory" && builtins.substring 0 1 n != ".")
        (builtins.readDir ./.);
      mkTemplate = tdir: _: { "${tdir}" = {path = ./. + "/${tdir}"; description = "Auto-generated template"; }; };
      templates = nixpkgs.lib.attrsets.concatMapAttrs mkTemplate subdirs;
    in
      (utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          {
            devShell = pkgs.mkShell {
              buildInputs = with pkgs; [
                nixd
              ];
            };
          }
      )) // { templates = default_templates.templates // templates; };
}
