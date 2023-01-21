" General
set nocompatible        " Turn off vi compatibility
set number	        " Show line numbers
" set number relativenumber " Hybrid line numbers
set linebreak	        " Break lines at word (requires Wrap lines)
set showbreak=+++	" Wrap-broken line prefix
set textwidth=120	" Line wrap (number of cols)
set showmatch	        " Highlight matching brace
set visualbell	        " Use visual bell (no beeping)
set vb t_vb=[?5h$<100>[?5l " Short visual bell; set to nothing to stop

set hlsearch	        " Highlight all search results
set smartcase	        " Enable smart-case search
set ignorecase	        " Always case-insensitive
set incsearch	        " Searches for strings incrementally

set autoindent	        " Auto-indent new lines
set expandtab	        " Use spaces instead of tabs
set shiftwidth=2	" Number of auto-indent spaces
set smartindent	        " Enable smart-indent
set smarttab	        " Enable smart-tabs
set softtabstop=2	" Number of spaces per Tab

set path+=**            " Recursively search path (fuzzy find)
set wildmenu

set showcmd

set mouse=a

" Set cursor to | _ []
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" :highlight ExtraWhitespace ctermbg=red guibg=red
" :match ExtraWhitespace /\s\+$/

" Language Specific Indentation
filetype plugin indent on

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable                     " Disable folding at startup.

set ruler	        " Show row and column ruler information
set shell=zsh\ -i

set history=200
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour
set updatetime=100   " Set for lsp update time
set signcolumn=yes:1

" File Manager
let g:netrw_dirhistmax=0
let g:netrw_liststyle=3 " tree view

let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night_Blue',
      \ }

" Colors
" syntax on
" colorscheme desert 
" colorscheme tir_black 

" hi MatchParen cterm=none ctermbg=darkblue ctermfg=black
" hi Visual cterm=reverse ctermbg=black 
" hi Search cterm=none ctermbg=5 ctermfg=black
" hi IncSearch ctermfg=11 ctermbg=5

" use with tir_black
" hi Pmenu ctermbg=16 guibg=black
" hi Pmenu ctermfg=7 guibg=white
"
"

" hi Sneak guifg=black guibg=red ctermfg=black ctermbg=red
" hi SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow
"
"
"

" use with desert
" hi Pmenu ctermbg=black guibg=black
" hi Pmenu ctermfg=white guibg=white

" Keybinding
map <Space> <Leader>
" Map esc to terminal normal mode
tnoremap <Esc> <C-\><C-n>

" let g:mapleader = "\<Space>"
let g:maplocalleader = '\'


" Plugins
filetype plugin on
runtime macros/matchit.vim

" Lightline - Status Bar
"
set laststatus=2        " For lightline - make it visible
set ttimeoutlen=50      " For lightline - switch to normal
set noshowmode          " For lightline - don't show below

let g:lightline = {}

let g:lightline.component_function = {
      \ 'gitbranch' : 'fugitive#head',
      \ 'server_status' : 'scnvim#statusline#server_status',
      \ }

let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ],
    \           [ 'readonly', 'filename', 'modified' ],
    \           [ 'gitbranch' ],
    \         ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'server_status' ],
    \          ] }

" gitgutter
" set updatetime=100
let g:gitgutter_map_keys = 1

" lexima autoclose ()
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_endwise_rules = 1


" context
let g:context_nvim_no_redraw = 0
let g:context_border_char = '-'
let g:context_enabled = 0

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" TODO: Do I need this?
" nvim 0.8 has 0 as autohide
set cmdheight=0

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call scnvim#scnvim-show-signature()
"   endif
" endfunction

nmap <C-i> <Plug>(scnvim-show-signature)


" AutoComplete and Snippets
"
" Ctrl + j/k - Move up and down autocomplete list
" Ctrl + l   - Select item (will expand snippets)
" Ctrl + l   - Jump to next snippet empty location


" Ctrl + j/k goes up and down autocomplete (or triggers if not shown)
" TODO: fix this
" inoremap <silent><expr> <C-j>
"       \ pumvisible() ? "\<C-n>" :
"       \ deoplete#manual_complete()
" inoremap <silent><expr> <C-k>
"       \ pumvisible() ? "\<C-p>" :
"       \ deoplete#manual_complete()

" Ctrl + l selects autocomplete. Or expands snippet if no dropdown
" imap <expr> <C-l> pumvisible() ? "\<C-y>" : ":call UltiSnips#ExpandSnippetOrJump()"


" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_layout = { 'window': { 
      \ 'border': 'sharp',
      \ 'xoffset': 1,
      \ 'yoffset': 1,
      \ 'width': 1,
      \ 'height': 0.3,
      \ } }

let g:floaterm_keymap_new    = '<localleader>n'
let g:floaterm_keymap_prev   = '<localleader>h'
let g:floaterm_keymap_next   = '<localleader>l'
let g:floaterm_keymap_toggle = '<localleader>`'

" Ranger in vim!
let g:ranger_replace_netrw = 1 " open ranger when vim open a directory
nmap <silent> - :<C-u>RangerEdit<CR>

set splitbelow
set splitright

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

let g:sneak#label = 1
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_highlight_linenrs = 1

highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
hi clear SignColumn

" set markdown comments to html comments
autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->

" wrap postwindow output
autocmd FileType scnvim setlocal wrap

" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
" imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" " -1 for jumping backwards.
" inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

" snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
" snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

set completeopt=menu,menuone,noselect

""" LUA

lua << EOF


require('onedark').setup {
    style = 'warmer'
}

require('onedark').load()
-- require('vimrc.lua')

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}

vim.o.timeout = true
vim.o.timeoutlen = 500
local which_key = require("which-key");
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil
which_key.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by deafult for Telescope
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
}

which_key.register({
  ["/"] = { "<cmd>Rg<cr>", "rg" },
  ["-"] = {
    name = "+ranger",
    ["-"] = { "<cmd>RangerEdit<cr>", "ranger-edit" },
    t = { "<cmd>RangerTab<cr>", "ranger-tab" },
    f = { "<cmd>FloatermNew ranger<cr>", "ranger-float" },
    s = { "<cmd>RangerSplit<cr>", "ranger-split-below" },
    v = { "<cmd>RangerVSplit<cr>", "ranger-split-right" },
  },

  q = {
    name = "+quickfix",
    o = {"<cmd>copen<cr>", "open-quickfix"     } ,
    d = {"<cmd>cclose<cr>", "close-quickfix"     } ,
    n = {"<cmd>cnext<cr>", "next-quickfix"     } ,
    p = {"<cmd>cprevious<cr>", "previous-quickfix"     } ,
    c = {"<cmd>cc<cr>", "current-quickfix"     } ,
    l = {"<cmd>lopen<cr>", "open-locationlist" } ,
    f = "fix-current",
  },

  w = {
    name = "+windows" ,
    w = {"<C-W>w"     , "other-window"}          ,
    d = {"<C-W>c"     , "delete-window"}         ,
    o = {"<C-W>o"     , "keep-current-window"}   ,
    s = {"<C-W>s"     , "split-window-below"}    ,
    v = {"<C-W>v"     , "split-window-right"}    ,
    h = {"<C-W>h"     , "window-left"}           ,
    j = {"<C-W>j"     , "window-down"}           ,
    l = {"<C-W>l"     , "window-right"}          ,
    k = {"<C-W>k"     , "window-up"}             ,
    H = {"<C-W>5<"    , "expand-window-left"}    ,
    J = {"<cmd>resize +5<cr>"  , "expand-window-down"}    ,
    L = {"<C-W>5>"    , "expand-window-right"}   ,
    K = {"<cmd>resize -5<cr>"  , "expand-window-up"}      ,
    r = {"<C-W>R"     , "rotate-window-order"}   ,
    t = {"<C-W>T"     , "window-to-new-tab"}     ,
    ["="] = {"<C-W>="     , "balance-window"}        ,
    ["/"] = {"<cmd>Windows<cr>"    , "fzf-window"}            ,
  },

--Buffers
--b +buffers
  b = {
    name = "+buffers" ,
    ["1"] = {"<cmd>b1<cr>"        , "buffer 1"}        ,
    ["2"] = {"<cmd>b2<cr>"        , "buffer 2"}        ,
    e = {"<cmd>e<cr>"         , "refresh (:e)"}  ,
    d = {"<cmd>bd<cr>"        , "delete-buffer"}   ,
    f = {"<cmd>bfirst<cr>"    , "first-buffer"}    ,
    l = {"<cmd>blast<cr>"     , "last-buffer"}     ,
    n = {"<cmd>bnext<cr>"     , "next-buffer"}     ,
    p = {"<cmd>bprevious<cr>" , "previous-buffer"} ,
    ["/"] = {"Buffers"   , "fzf-buffer"}      ,
  },

  h = {
    name = "+hunk" ,
    p = "preview-git-hunk",
    s = "stage-git-hunk"  ,
    u = "undo-git-hunk"  ,
  },

  g = {
    name = "+git" ,
    f = {"<cmd>GitGutterFold<cr>", "git-fold"},
    g = {
      name = "+gutter",
      s = {"<cmd>GitGutterSignsToggle<cr>"     , "signs-toggle"}      ,
      l = {"<cmd>GitGutterLineHighlightsToggle<cr>" , "line-highlight-toggle"} ,
      } ,
    d = {"<cmd>Gdiffsplit<cr>", "diff-split"},
    v = {"<cmd>Gvdiff<cr>", "diff-split-vertical"},
    -- todo need :?
    h = {"<cmd>:diffget //2<cr>", "get-left-diff"},
    l = {"<cmd>:diffget //3<cr>", "get-right-diff"},
    [" "]  = {"<cmd>G<cr>" , "git-fugitive-menu"}  ,
    ["/"] = {"<cmd>Commits<cr>"    , "fzf-commits"}            ,
    ["?"] = {"<cmd>BCommits<cr>"    , "fzf-buffer-commits"}            ,
  },

  v = {
      name = "+view" ,
      -- todo need :?
      c = {"<cmd>:call context#toggle(1)<cr>" , "toggle-context"}  ,
  },

-- use rg when searching files (follows .gitignore)
-- let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
  f = {
    name = "+file" ,
    s = {"<cmd>w<cr>" , "save"}  ,
    -- todo need :?
    ["/"] = {"<cmd>:GFiles --cached --others --exclude-standard<cr>"    , "fzf-gfiles"}            ,
    ["?"] = {"<cmd>Files<cr>"    , "fzf-files"}            ,
  },


-- Major (SuperCollider)
-- m +majormode
  m = {
      name = '+SuperCollider',
      --[
      S = { "<cmd>SCNvimStatusLine<cr>" , "SC-statusline" } ,
      s = { "<cmd>SCNvimStart<cr>"      , "start-SuperCollider" } ,
      x = { "<cmd>SCNvimStop<cr>"       , "stop-SuperCollider" } ,
      r = { "<cmd>SCNvimRecompile<cr>"  , "recompile-SCClassLibrary" } ,
      t = { "<cmd>SCNvimGenerateAssets<cr>", "generate-assets" } ,
      --]]
      -- todo need :?
      h = { "<cmd>:SCNvimHelp <cr>"     , "help" } ,
      c = "clear-postwindow" ,
      k = "show-signature" ,
      m = "mute-(hard-stop)" ,
  },

  ["<space>"] = "send to sclang", 
  ["<cr>"] = "sclang postwin toggle", 
  l = "send line to sclang",

}, { prefix = "<leader>" })

local scnvim = require 'scnvim'
local map = scnvim.map
local map_expr = scnvim.map_expr
scnvim.setup {
  keymaps = {
    ['<leader>mc'] = map('postwin.clear', {'n'}),
    ['<leader>mm'] = map('sclang.hard_stop', {'n'}),
    ['<leader>mk'] = map('signature.show', {'n'}),
    ['<leader><space>'] = {
      map('editor.send_block', {'n'}),
      map('editor.send_selection', 'x'),
    },
    ['<leader>l'] = map('editor.send_line', {'n'}),
    ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
    ['<CR>'] = map('postwin.toggle'),
    ['<leader><CR>'] = map('postwin.toggle', {'n'}),
    ['<C-e>'] = {
      map('editor.send_block', {'i', 'n'}),
      map('editor.send_selection', 'x'),
    },
    ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
    ['<C-k>'] = map('signature.show', {'n', 'i'}),
    ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
    ['<F1>'] = map_expr('s.boot'),
    ['<F2>'] = map_expr('s.meter'),
  },
  documentation = {
    cmd = '/home/parker/.nix-profile/bin/pandoc',
  },
  editor = {
    highlight = {
      color = 'IncSearch',
    },
  },
  snippet = {
    engine = {
      name = 'luasnip',
    },
  },
  postwin = {
    float = {
      enabled = true,
    },
  },
}


--[[
-- snippets
-- Append table2 to table1
local function append_to_table(table1, table2)
	for key, value in ipairs(table2) do
		table.insert(table1, value)
	end

	return table1
end

-- This table contains all of your custom SuperCollider snippets
local my_custom_sc_snipz = {

	-- Ndef
	s("ndef",{
		t("Ndef("),
		t("\\"), i(1, "name"), t(",{|"), i(2, "freq=100, amp=0.5"), t({"|", ""}),
		t("\t"), i(2, "SinOsc.ar(freq) * amp;"), t({"", ""}),
		t({"", "})"}),
		i(3, ".play"),
	}),

	-- SynthDef
	s("synthdef",{
		t("SynthDef("),
		t("\\"), i(1, "name"), t(",{|"), i(2, "out=0, amp=0.5"), t({"|", ""}),
		t("\t"), i(3, "var sig = SinOsc.ar;"), t({"", ""}),
		t("\t"), i(4, "Out.ar(out, sig)"),
		t({"", "})"}),
		i(5, ".add"),
	}),

	-- Value pattern shorthands
	s("pwh", { t("Pwhite("), c(1, {t("0.0"), rnd()}), t(", "), c(1, {t("1.0"), rnd()}), t(")")}),
	s("pbr", { t("Pbrown("), i(1, "0.0"), t(", "), i(2, "1.0"), t(", "), i(3, "0.125"), t(")")}),
	s("ps", { t("Pseq(["), i(1, "1.0"), t("], "), i(2, "inf"), t(")")}),
	s("pr", { t("Prand(["), i(1, "1.0"), t("], "), i(2, "inf"), t(")")}),
	s("pxr", { t("Prand(["), i(1, "1.0"), t("], "), i(2, "inf"), t(")")}),
	s("pw", { t("Pwrand(["), i(1, "0.5, 0.5"), t("], ["), i(2, "50.0, 100.0"), t("], "), i(3, "inf"), t(")")}),
	s("pseg", { t("Pseg("), t("["),i(1, "1.0,0.0"), t("],"), i(2, "16"), t(","), i(3, "\\lin"), t(","), i(4,"inf"), t(")")}),
	s("pstep", { t("Pstep("), t("["),i(1, "1.0,0.0"), t("],"), i(2, "16"), t(","), i(3,"inf"), t(")")}),

	-- Misc Pattern
	s("pf", { t("Pfunc({|ev| "), i(1, ""), t(" })")}),
	s("pp", { t("Ppar(["), i(1, "p,o"), t("], "), i(2, "inf"), t(")")}),
	s("ptp", { t("Ptpar(["), i(1, "0.0, p, 2.0, o"), t("], "), i(2, "inf"), t(")")}),
}

-- Now append custom snippets to table of scnvim snippets
require'luasnip'.snippets.supercollider = append_to_table(
	require'scnvim/utils'.get_snippets(),
	my_custom_sc_snipz
)
--]]

-- Add SCNvim snippets to LuaSnip
-- Note: This replaces any supercollider snippets already present in LuaSnip
require('luasnip').add_snippets('supercollider', require'scnvim.utils'.get_snippets())

local cmp = require'cmp'
local luasnip = require'luasnip'

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {
    autocomplete = false,
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },

  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },


  mapping = cmp.mapping.preset.insert({

    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),


    ['<C-l>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        cmp.mapping.confirm()
      end
    end, { "i", "s" }),
    ['<C-h>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp' },
    -- { name = 'tags' },
    { name = 'luasnip' },
    { name = 'treesitter' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--[[
require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  capabilities = capabilities
}
--]]
require'lspconfig'.clangd.setup {
  capabilities = capabilities,
}

require'lspconfig'.sumneko_lua.setup {
    settings = {
        -- Settings go here!
    }
}

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

EOF
