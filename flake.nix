{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs-unstable"; # stable branch doesn't work because of astro-language-server
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";

    };
  };

outputs = inputs:
	with inputs; let
		secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

		configurationDefaults = args: {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
			home-manager.backupFileExtension = "hm-backup";
			home-manager.extraSpecialArgs = args;
		};

		nixpkgsWithOverlays = system: ( import nixpkgs rec {
			inherit system;
			config = {
				allowUnfree = true;
			};

			overlays = [
				(_final: prev: {
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit config;
            };
				})
			];
		});

		nixosConf = {
			system ? "x86_64-linux",
			hostname,
			username,
			args ? {},
			modules,
		}: let
			specialArgs = { inherit hostname username inputs secrets; } // args;
		in
		nixpkgs.lib.nixosSystem {
			inherit system specialArgs;
			pkgs  = nixpkgsWithOverlays system;
			modules = [
				( configurationDefaults specialArgs )
				home-manager.nixosModules.home-manager
			]
			++ modules;

		};
			in {
				nixosConfigurations.nixos = nixosConf {
		hostname = "nixos";
		username = "yhn";
		modules = [
			nixvim.nixosModules.nixvim
			nixos-wsl.nixosModules.wsl
			./home.nix
		];
	};
 };
}
