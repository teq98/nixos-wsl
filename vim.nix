{
  secrets,
  username,
  hostname, 
  pkgs, 
  inputs,
  ...
}:
{
programs.nixvim = {
	enable = true;
	opts = {
		number = true;
		shiftwidth = 2;
		tabstop = 2;
		ignorecase = true;
		smartcase = true;

		hlsearch = true;
		incsearch = true;

	};

	plugins = {
		comment.enable = true;
		telescope.enable = true;
		floaterm.enable = true;
		floaterm.autoclose = 2; # Auto-closes without Proceed exited 101
	};

	globals.mapleader = " ";
	keymaps = [
		{
			mode = "n";
			key = "<leader>f";
			action = "<cmd>Telescope find_files<cr>";
		}
		{
			key = "<leader>term";
			action = "<cmd>FloatermNew --position=top-left<cr>";
			options.nowait = true;
		}
	];
};
}
