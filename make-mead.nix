{
  nixpkgs,
  cellBlock ? "nixosConfigurations",
  evalConfigArgs,
}: let
  l = nixpkgs.lib // builtins;
  inherit (import ./pasteurize.nix {inherit nixpkgs cellBlock evalConfigArgs;}) pasteurize stir beeOptions;
in
  self: let
    comb = pasteurize self;
    evalNode = extra: name: config: let
      inherit (stir config) evalConfig system;
    in
      evalConfig (l.recursiveUpdate config.evalConfigArgs {
        inherit system;
        modules = [extra beeOptions config];
      });
  in
    l.mapAttrs (evalNode {}) comb
