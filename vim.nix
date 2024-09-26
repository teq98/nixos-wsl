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
		signcolumn = "number";
		smartcase = true;

		hlsearch = true;
		incsearch = true;

	};

	plugins = {
		comment.enable = true;
		rustaceanvim.enable = true;
		telescope.enable = true;
		floaterm.enable = true;
		floaterm.autoclose = 2; # Auto-closes without Proceed exited 101
		cmp = {
			enable = true;
			autoEnableSources = true;
			settings.performance.max_view_entries = 5;
			settings.view.docs.auto_open = false;
			settings.sources = [
				{ name = "nvim_lsp"; }
				{ name = "path"; }
				{ name = "buffer"; }
			];
		};
		lsp.enable = true;
		harpoon	=	{
			enable = true;
			enableTelescope = true;
			keymaps	=	{
				toggleQuickMenu	=	"<leader>q";
				addFile	=	"<leader>a";
				navFile	=	{	
					"1"="<C-j>";
					"2"="<C-k>";
					"3"="<C-l>";
					"4"="<C-m>";
				};
			};
		};
	};

	globals.mapleader = " ";
	keymaps = [
		{
			mode = "n";
			key = "<leader>f";
			action = "<cmd>Telescope find_files<cr>";
		}
		{
			key = "<leader>t";
			action = "<cmd>FloatermNew <cr>";
			options.nowait = true;
		}
	];
};
}
