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
            },
        }
    end,
    } -- }}}
    use { "ThePrimeagen/harpoon", requires = { "nvim-lua/plenary.nvim" } }
    use { "tpope/vim-fugitive", opt = true, cmd = { "G" } }
    use "tpope/vim-eunuch"
    use "tpope/vim-rsi"
    use "kchmck/vim-coffee-script"
    use "preservim/vim-markdown"
    use { "gboncoffee/lf.lua", opt = true, cmd = { "Lf", "LfChangeCwd", "LfNoChangeCwd" } }
    use "gboncoffee/run.lua"
    use "gboncoffee/yaft.lua"
    -- Mini.nvim {{{
    use { "echasnovski/mini.nvim", config = function()
        require "mini.align".setup()
        require "mini.comment".setup()
        require "mini.surround".setup()
        require "mini.pairs".setup()
    end,
    } -- }}}
    -- Colorscheme {{{
    use { "Mofiqul/dracula.nvim", config = function()
        require "dracula".setup {
            show_end_of_buffer = true,
            transparent_bg     = true,
            italic_comment     = true,
            overrides = {
                StatusLine   = { bg = "#21222c" },
                StatusLineNC = { bg = "#21222c", fg = "#6272a4" },
                VertSplit    = { fg = "#abb2bf" },
            }
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

g.vim_markdown_folding_disabled = 1

-- appearance/visual helpers
o.wrap       = false
o.signcolumn = "no"
o.scrolloff  = 10
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

-- Mappings {{{
map = vim.keymap.set
command = vim.api.nvim_create_user_command

map("n", "<Space><Space>", "/<++><CR>4xi")

command("Mit",  "read ~/.config/nvim/LICENSE", {})
command("Head", "source ~/.config/nvim/header.vim", {})

-- run.vim
map("n", "<Space>b", ":wall | Compile<CR>")
map("n", "<Space>a", ":wall | CompileAuto<CR>")
map("n", "<Space>r", ":wall | CompileReset<CR>")
map("n", "<Space>t",        ":CompileFocus<CR>")
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
map("n", "<Space>.", ":Telescope find_files<CR>")
map("n", "<Space>m", ":lua require'telescope.builtin'.man_pages({sections={'ALL'}})<CR>")
map("n", "<Space>h", ":Telescope help_tags<CR>")
map("n", "<Space>/", ":lua require'telescope.builtin'.live_grep({glob_pattern='!*.git*',additional_args={'--hidden'}})<CR>")
-- others
map("n", "<Space>g", ":G<CR>")
map("n", "<Space>n", ":YaftToggle<CR>")
map("n", "<Space>f", ":LfNoChangeCwd<CR>")
-- keep things in the middle
map("n", "<C-d>",    "<C-d>zz")
map("n", "<C-u>",    "<C-u>zz")
map("n", "n",        "nzzzv")
map("n", "N",        "Nzzzv")
-- utils
map("v", "J",        ":m '>+1<CR>gv=gv")
map("v", "K",        ":m '<-2<CR>gv=gv")
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
    pattern  = { "qf", "fugitive", "git", "gitcommit", "help" },
    command  = "nnoremap <buffer> q :bd<CR>"
})
vim.api.nvim_create_autocmd({ "BufEnter", "TermEnter" }, {
    group    = filetype_settings,
    pattern  = "*",
    callback = function()
        local buftype  = vim.api.nvim_buf_get_option(0, "buftype")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if (buftype == "") and (filetype ~= "gitcommit") then
            vim.cmd "setlocal nu rnu"
        else
            vim.cmd "setlocal nonu nornu"
        end
    end
})
-- }}}
