--
-- Gabriel's Neovim config ;)
--
o = vim.opt
g = vim.g

-- Plugins {{{
require "paq" {
    "savq/paq-nvim",

    "nvim-lua/plenary.nvim",

    "matbme/JABS.nvim",
    "nvim-telescope/telescope.nvim",
    "tpope/vim-fugitive",
    "kchmck/vim-coffee-script",
    "preservim/vim-markdown",
    "tpope/vim-eunuch",
    "gboncoffee/lf.vim",
    "gboncoffee/run.vim",
    "echasnovski/mini.nvim",

    "folke/tokyonight.nvim",
    "nvim-tree/nvim-web-devicons",
}
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
-- editor
o.foldmethod = "marker"
o.tw         = 80
o.ignorecase = true
o.tabstop    = 4
o.shiftwidth = 4
o.expandtab  = true
-- }}}

-- Minor sets {{{
g.Run_runwin_cmd     = "sp | wincmd J | e"
g.Run_compilewin_cmd = "e"
g.vim_markdown_folding_disabled = 1
require "mini.align".setup()
require "mini.comment".setup()
require "mini.surround".setup()
-- }}}

-- Mappings {{{
map = vim.keymap.set
command = vim.api.nvim_create_user_command

map("n", "<Space><Space>", "/<++><CR>4xi")
map("n", "<Tab>", "<C-^>")

command("Mit",  "read ~/.config/nvim/LICENSE", {})
command("Head", "source ~/.config/nvim/header.vim", {})

-- run.vim
map("n", "<Space>b", ":Compile<CR>")
map("n", "<Space>a", ":CompileAuto<CR>")
map("n", "<Space>r", ":CompileReset<CR>")
-- run.vim :Run)
map("n", "<Space><CR>", ":Run<CR>")
map("n", "<Space>cp",   ":Run python<CR>")
map("n", "<Space>co",   ":Run coffee<CR>")
map("n", "<Space>cl",   ":Run lua<CR>")
map("n", "<Space>cc",   ":Run julia<CR>")
map("n", "<Space>cj",   ":Run node<CR>")
map("n", "<Space>ch",   ":Run ghci<CR>")
map("n", "<Space>cs",   ":Run btm<CR>")
map("n", "<Space>cm",   ":Run ncmpcpp<CR>")
-- buffers/files/sorters
tb = require "telescope.builtin"
map("n", "<Space><Tab>", ":JABSOpen<CR>")
map("n", "<Space>.",     tb.find_files)
map("n", "<Space>m",     tb.man_pages)
map("n", "<Space>h",     tb.help_tags)
map("n", "<Space>/",     tb.live_grep)
-- others
map("n", "<Space>g",  ":G<CR>")
map("n", "<Space>f",  ":LfNoChangeCwd<CR>")
map("n", "<Space>n",  ":LfChangeCwd<CR>")
map("n", "<Space>s",  ":s//g<Left><Left>")
map("n", "<Space>%s", ":%s//g<Left><Left>")
map("n", "<Space>l",  ":setlocal nu! rnu!<CR>")
map("n", "<C-n>",     ":nohl<CR>")
-- }}}

-- Telescope {{{
ta = require "telescope.actions"
require "telescope".setup {
    defaults = {
        border          = false,
        layout_strategy = "center",
        layout_config   = {
            center = {
                width           = 0.75,
                height          = 0.75,
                prompt_position = "bottom",
            },
        },
        mappings = {
            i = {
                ["<C-k>"] = ta.move_selection_previous,
                ["<C-j>"] = ta.move_selection_next,
            },
        },
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--glob", "!.git/*", "--hidden", "--files" }
        },
    },
}
-- }}}

-- JABS {{{
require "jabs".setup {
    position = "center",
    border   = "none",
    use_devicons = true,
    keymap = {
        close   = "dd",
        jump    = "<CR>",
        preview = "p",
    }
}
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

-- choose between dark and light themes
term_colors = io.popen("readlink " .. os.getenv("HOME") .. "/.config/alacritty/colors.yml"):read()
if term_colors == os.getenv("HOME") .. "/.config/alacritty/colors/Tokyo-Night-Night.yml" then
    vim.cmd "colorscheme tokyonight-night"
else
    vim.cmd "colorscheme tokyonight-day"
end

vim.cmd "hi! link EndOfBuffer Identifier"