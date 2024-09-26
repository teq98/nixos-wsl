{
  secrets,
  username,
  hostname, 
  pkgs, 
  inputs,
  ...
}:
{

	programs.git = {
		enable = true;
		package = pkgs.unstable.git;
		userEmail = "yhn@yhn.fyi";
		userName = "yhn";
		extraConfig = {
			url = {
				"https://oauth1:${secrets.token}@github.com" = {
					insteadOf = "https://github.com";
				};
			};
		};
	};

	home.stateVersion = "24.05";

}
