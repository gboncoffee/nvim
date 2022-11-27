--
-- Gabriel's Neovim config ;)
--
o = vim.opt
g = vim.g

-- Plugins {{{
require "packer".startup(function(use)
    use "wbthomason/packer.nvim"

    -- Telescope {{{
    use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" }, config = function()
        ta = require "telescope.actions"
        require "telescope".setup {
            defaults = {
                border          = false,
                layout_strategy = "center",
                layout_config   = { center = {
                        width           = 0.75,
                        height          = 0.75,
                        prompt_position = "bottom", },
                },
                mappings = { i = {
                        ["<C-k>"] = ta.move_selection_previous,
                        ["<C-j>"] = ta.move_selection_next, 
                        ["<C-d>"] = ta.close, },
                },
            },
            pickers = {
                find_files = { find_command = { "rg", "--glob", "!*.git*", "--hidden", "--files" } },
                buffers = {
                    mappings = {
                        i = { ["<C-d>"] = ta.delete_buffer, },
                        n = { ["dd"]    = ta.delete_buffer, },
                    },
                    initial_mode = "normal",
                },
            },
        }
    end,
    } -- }}}
    use { "ThePrimeagen/harpoon", config = function()
        require "harpoon".setup {
            menu = {
                borderchars = { " ", " ", " ", " ", " ", " ", " ", " ", },
            }
        }
    end,
    }
    use { "tpope/vim-fugitive", opt = true, cmd = { "G" } }
    use "tpope/vim-eunuch"
    use "tpope/vim-rsi"
    use "kchmck/vim-coffee-script"
    use "preservim/vim-markdown"
    use { "gboncoffee/lf.lua", opt = true, cmd = { "Lf", "LfChangeCwd", "LfNoChangeCwd" } }
    use "gboncoffee/run.lua"
    -- Mini.nvim {{{
    use { "echasnovski/mini.nvim", config = function()
        require "mini.align".setup()
        require "mini.comment".setup()
        require "mini.surround".setup()
    end,
    } -- }}}
    -- Colorscheme {{{
    use { "Mofiqul/dracula.nvim", config = function()
        require "dracula".setup {
            show_end_of_buffer = true,
            transparent_bg     = false,
            italic_comment     = true,
            overrides          = {
                TelescopeNormal = { bg = "#21222c" },
                NormalFloat     = { bg = "#21222c" },
                FloatBorder     = { fg = "#21222c" },
            },
        }
        vim.cmd "colorscheme dracula"
    end,
    } -- }}}
    use "nvim-tree/nvim-web-devicons"
end)
-- }}}

-- Great defaults {{{
vim.cmd "set clipboard^=unnamedplus | set path+=**"
o.conceallevel = 2

-- appearance/visual helpers
o.wrap       = false
o.signcolumn = "no"
o.scrolloff  = 5
o.splitright = true
o.splitbelow = true
o.laststatus = 1
o.guicursor  = "n-v-c-sm:block,i-ve:ver25"
o.cursorline = true
-- editor
o.foldmethod = "marker"
o.tw         = 80
o.ignorecase = true
o.tabstop    = 4
o.shiftwidth = 4
o.expandtab  = true
-- window
o.title = true
o.titlestring = "%t"
-- }}}

-- Minor sets {{{
g.Run_runwin_cmd     = "sp | wincmd J | e"
g.Run_compilewin_cmd = "e"
g.vim_markdown_folding_disabled = 1
-- }}}

-- Mappings {{{
map = vim.keymap.set
command = vim.api.nvim_create_user_command

map("n", "<Space><Space>", "/<++><CR>4xi")

command("Mit",  "read ~/.config/nvim/LICENSE", {})
command("Head", "source ~/.config/nvim/header.vim", {})

-- run.vim
map("n", "<Space>b", ":Compile<CR>")
map("n", "<Space>a", ":CompileAuto<CR>")
map("n", "<Space>r", ":CompileReset<CR>")
map("n", "<Space>t", ":CompileFocus<CR>")
-- run.vim :Run
map("n", "<Space><CR>", ":Run<CR>")
map("n", "<Space>cp",   ":Run python<CR>")
map("n", "<Space>co",   ":Run coffee<CR>")
map("n", "<Space>cl",   ":Run lua<CR>")
map("n", "<Space>cc",   ":Run julia<CR>")
map("n", "<Space>cj",   ":Run deno<CR>")
map("n", "<Space>ch",   ":Run ghci<CR>")
map("n", "<Space>cs",   ":Run btm<CR>")
map("n", "<Space>cm",   ":Run ncmpcpp<CR>")
-- harpoon/telescope
map("n", "<Space><Tab>", ":lua require 'harpoon.ui'.toggle_quick_menu()<CR>")
map("n", "<Space>w",     ":lua require 'harpoon.mark'.add_file()<CR>")
map("n", "<Tab>",        ":lua require 'harpoon.ui'.nav_next()<CR>")
map("n", "<S-Tab>",      ":lua require 'harpoon.ui'.nav_prev()<CR>")
for n = 1,9 do
    map("n", "<Space>"..n, ":lua require 'harpoon.ui'.nav_file("..n..")<CR>")
end
map("n", "<Space>.",     ":Telescope find_files<CR>")
map("n", "<Space>m",     ":Telescope man_pages<CR>")
map("n", "<Space>h",     ":Telescope help_tags<CR>")
map("n", "<Space>/",     ":Telescope live_grep<CR>")
-- others
map("n", "<Space>g",  ":G<CR>")
map("n", "<Space>f",  ":LfNoChangeCwd<CR>")
map("n", "<Space>n",  ":LfChangeCwd<CR>")
map("n", "<Space>l",  ":setlocal nu! rnu!<CR>")
-- }}}

-- Autocmds {{{
filetype_settings = vim.api.nvim_create_augroup("FiletypeSettings", {})
vim.api.nvim_create_autocmd("FileType", {
    group    = filetype_settings,
    pattern  = { "python", "shell", "sh" },
    command  = "set formatoptions-=t"
})
vim.api.nvim_create_autocmd("FileType", {
    group    = filetype_settings,
    pattern  = { "qf", "fugitive", "git", "gitcommit", "run-compiler" },
    command  = "nnoremap <buffer> q :bd<CR>"
})
-- }}}
