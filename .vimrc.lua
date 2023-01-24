local set = vim.opt

set.compatible = false
set.number = true

set.linebreak = true
set.showbreak = '⮨'
set.textwidth = 120

set.visualbell = true
set.vb.t_vb='[?5h$<100>[?5l'

set.hlsearch = true
set.smartcase = true
set.ignorecase = true
set.incsearch = true

set.autoindent = true
set.expandtab = true
set.shiftwidth = 2
set.smartindent = true
set.smarttab = true
set.softtabstop = 2

set.path:append('**')
set.wildmenu = true
set.showcmd = true
set.mouse = 'a'
set.splitbelow = true
set.splitright = true
set.showmatch = true
set.ruler = true
set.shell = 'zsh -i'
set.history = 200
set.undolevels = 1000
set.backspace = {'indent','eol','start'}
set.updatetime = 100
set.signcolumn = 'yes:1'
set.hidden = true
set.backup = false
set.writebackup = false
-- don't give |ins-completion-menu| messages.
set.shortmess:append('c')
-- todo: which is best setting?
set.cmdheight = 1
set.completeopt = {'menu','menuone','noselect'}
set.laststatus = 2
set.ttimeoutlen = 50
set.showmode = false

vim.keymap.set('n', '<Space>', '<Leader>', {
  remap = true, desc = 'Space is Leader'
})
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], {
  desc = 'Esc in terminal'
})

vim.g.fzf_layout = {
  window = {
    border = 'sharp',
    xoffset = 1,
    yoffset = 1,
    width = 1,
    height = 0.3,
  },
}

vim.g.lexima_enable_basic_rules = 1
vim.g.lexima_enable_newline_rules = 1
vim.g.lexima_enable_endwise_rules = 1

vim.g.ranger_replace_netrw = 1
vim.keymap.set('n', '-', ':<C-u>RangerEdit<CR>', {
  silent = true, remap = true, desc = 'Open ranger'
})

vim.g['sneak#label'] = 1

vim.g.gitgutter_map_keys = 1
vim.g.gitgutter_set_sign_backgrounds = 1
vim.g.gitgutter_highlight_linenrs = 1

require('onedark').setup {
    style = 'warmer'
}
require('onedark').load()

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
    -- set to `false` to disable one of the mappings
      init_selection = "gnn",
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
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    -- No actual key bindings are created
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  operators = { gc = "Comments" },
  key_labels = {
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  popup_mappings = {
    scroll_down = '<c-d>',
    scroll_up = '<c-u>',
  },
  window = {
    border = "shadow", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    -- [top, right, bottom, left]
    margin = { 1, 0, 0, 0 },
    padding = { 0, 0, 0, 0 },
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 10 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  ignore_missing = false,
  hidden = { "<silent>", "<cmd>", "<Cmd>",
    "<CR>", "call", "lua", "^:", "^ "
  },
  show_help = false,
  show_keys = false,
  triggers = "auto",
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
}

which_key.register({
  ["/"] = {"<cmd>Rg<cr>", "rg"},
  ["-"] = {
    name = "+ranger",
    ["-"] = {"<cmd>RangerEdit<cr>"        , "ranger-edit" },
    t     = {"<cmd>RangerTab<cr>"         , "ranger-tab" },
    f     = {"<cmd>FloatermNew ranger<cr>", "ranger-float" },
    s     = {"<cmd>RangerSplit<cr>"       , "ranger-split-h"},
    v     = {"<cmd>RangerVSplit<cr>"      , "ranger-split-v"},
  },

  q = {
    name = "+quickfix",
    o = {"<cmd>copen<cr>"    , "open-quickfix"},
    d = {"<cmd>cclose<cr>"   , "close-quickfix"},
    n = {"<cmd>cnext<cr>"    , "next-quickfix"},
    p = {"<cmd>cprevious<cr>", "previous-quickfix"},
    c = {"<cmd>cc<cr>"       , "current-quickfix"},
    l = {"<cmd>lopen<cr>"    , "open-locationlist"},
    f = "fix-current",
  },

  w = {
    name = "+windows" ,
    w     = {"<C-W>w"            , "other-window"},
    d     = {"<C-W>c"            , "delete-window"},
    o     = {"<C-W>o"            , "keep-current-window"},
    s     = {"<C-W>s"            , "split-window-below"},
    v     = {"<C-W>v"            , "split-window-right"},
    h     = {"<C-W>h"            , "window-left"},
    j     = {"<C-W>j"            , "window-down"},
    l     = {"<C-W>l"            , "window-right"},
    k     = {"<C-W>k"            , "window-up"},
    H     = {"<C-W>5<"           , "expand-window-left"},
    J     = {"<cmd>resize +5<cr>", "expand-window-down"},
    L     = {"<C-W>5>"           , "expand-window-right"},
    K     = {"<cmd>resize -5<cr>", "expand-window-up"},
    r     = {"<C-W>R"            , "rotate-window-order"},
    t     = {"<C-W>T"            , "window-to-new-tab"},
    ["="] = {"<C-W>="            , "balance-window"},
    ["/"] = {"<cmd>Windows<cr>"  , "fzf-window"},
  },

--Buffers
--b +buffers
  b = {
    name = "+buffers" ,
    ["1"] = {"<cmd>b1<cr>"        , "buffer 1"},
    ["2"] = {"<cmd>b2<cr>"        , "buffer 2"},
    e     = {"<cmd>e<cr>"         , "refresh (:e)"},
    d     = {"<cmd>bd<cr>"        , "delete-buffer"},
    f     = {"<cmd>bfirst<cr>"    , "first-buffer"},
    l     = {"<cmd>blast<cr>"     , "last-buffer"},
    n     = {"<cmd>bnext<cr>"     , "next-buffer"},
    p     = {"<cmd>bprevious<cr>" , "previous-buffer"},
    ["/"] = {"Buffers"            , "fzf-buffer"},
  },

  h = {
    name = "+hunk" ,
    p = "preview-git-hunk",
    s = "stage-git-hunk",
    u = "undo-git-hunk",
  },

  g = {
    name = "+git" ,
    g = {
      name = "+gutter",
      s = {"<cmd>GitGutterSignsToggle<cr>"         , "signs-toggle"},
      l = {"<cmd>GitGutterLineHighlightsToggle<cr>", "line-highlight-toggle"},
    },
    f     = {"<cmd>GitGutterFold<cr>", "git-fold"},
    d     = {"<cmd>Gdiffsplit<cr>"   , "diff-split"},
    v     = {"<cmd>Gvdiff<cr>"       , "diff-split-vertical"},
    -- todo need :?
    h     = {"<cmd>:diffget //2<cr>" , "get-left-diff"},
    l     = {"<cmd>:diffget //3<cr>" , "get-right-diff"},
    [" "] = {"<cmd>G<cr>"            , "git-fugitive-menu"},
    ["/"] = {"<cmd>Commits<cr>"      , "fzf-commits"},
    ["?"] = {"<cmd>BCommits<cr>"     , "fzf-buffer-commits"},
  },

  v = {
      name = "+view" ,
      c = {"<cmd>TSContextToggle<cr>", "toggle-context"}  ,
  },

-- use rg when searching files (follows .gitignore)
-- let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
  f = {
    name = "+file" ,
    s = {"<cmd>w<cr>" , "save"},
    -- todo need :?
    ["/"] = {"<cmd>:GFiles --cached --others --exclude-standard<cr>", "fzf-gfiles"},
    ["?"] = {"<cmd>Files<cr>", "fzf-files"},
  },

-- Major (SuperCollider)
-- m +majormode
  m = {
      name = '+SuperCollider',
      S = {"<cmd>SCNvimStatusLine<cr>"    , "SC-statusline"},
      s = {"<cmd>SCNvimStart<cr>"         , "start-SuperCollider"},
      x = {"<cmd>SCNvimStop<cr>"          , "stop-SuperCollider"},
      r = {"<cmd>SCNvimRecompile<cr>"     , "recompile-SCClassLibrary"},
      t = {"<cmd>SCNvimGenerateAssets<cr>", "generate-assets"},
      -- todo need :?
      h = {"<cmd>:SCNvimHelp <cr>"        , "help"},
      c = "clear-postwindow",
      k = "show-signature",
      m = "mute-(hard-stop)",
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
  --[[ todo fzf-sc: after fixing plugin build; re-enable
  extensions = {
    ['fzf-sc'] = {
      search_plugin = 'fzf-vim',
    },
  }
  --]]
}

--[[ todo fzf-sc: after fixing plugin build; re-enable
scnvim.load_extension('fzf-sc')
--]]

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

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local custom_capabilities = vim.tbl_extend(
  'keep',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
);
-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
--[[
require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  capabilities = capabilities
}
--]]
require'lspconfig'.clangd.setup {
  capabilities = custom_capabilities,
}

require'lspconfig'.sumneko_lua.setup {
    settings = {
    }
}

require('lspconfig').nil_ls.setup {
  autostart = true,
  capabilities = custom_capabilities,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
}

require'lspconfig'.vimls.setup{}

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
  virtual_text = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    -- todo: add scnvim status line info
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
