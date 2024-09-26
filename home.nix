{
  secrets,
  username,
  hostname, 
  pkgs, 
  inputs,
  ...
}: let
packages-unstable = with pkgs.unstable; [
	git
	gcc
	rustup
	jq
	fx
	fd
	uv
	fzf
];
packages-stable = with pkgs; [
	python3
	fastfetch
];
in {

  time.timeZone = "Asia/Seoul";
  networking.hostName = "${hostname}";
  security.sudo.wheelNeedsPassword = false;

	programs.fish = {
		enable = true;
    interactiveShellInit = ''
			set -U fish_prompt_pwd_dir_length 0
      set fish_greeting # Disable greeting
    '';
	};

  users.users.${username} = {
    isNormalUser = true;
		shell = pkgs.fish;
    extraGroups = [
      "wheel"
    ];
  };

  home-manager.users.${username} = {

    home.packages =
			packages-stable	
			++ packages-unstable;

		imports = [
			./home-manager.nix
		];
  };

  system.stateVersion = "24.05";

	imports = [
		./vim.nix
	];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = username;
    startMenuLaunchers = true;
  };
  
  nix = {
    settings = {
      trusted-users = [username];
      access-tokens = [
				"github.com=${secrets.token}"
			];

      accept-flake-config = true;
      auto-optimise-store = true;
		};

    registry = {
      nixpkgs = {
				flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";

  };
}
