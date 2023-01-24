set nocompatible        " Turn off vi compatibility
set number	        " Show line numbers

set linebreak	        " Break lines at word
set showbreak=⮨
set textwidth=120	" Line wrap (number of cols)

set visualbell	        " Use visual bell (no beeping)
set vb t_vb=[?5h$<100>[?5l " Short visual bell

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
set splitbelow
set splitright
set showmatch	        " Highlight matching brace
set ruler
set shell=zsh\ -i
set history=200
set undolevels=1000
set backspace=indent,eol,start
set updatetime=100
set signcolumn=yes:1
set hidden
set nobackup
set nowritebackup
" don't give |ins-completion-menu| messages.
set shortmess+=c
" todo: which is best setting?
set cmdheight=0
set completeopt=menu,menuone,noselect

" todo: figure out best way to do fold
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" set nofoldenable                     " Disable folding at startup.

filetype plugin indent on
filetype plugin on
runtime macros/matchit.vim

" Set cursor to | _ []
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"


" Keybinding
map <Space> <Leader>
" Map esc to terminal normal mode
tnoremap <Esc> <C-\><C-n>

" let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

" lexima autoclose ()
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_endwise_rules = 1


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

let g:ranger_replace_netrw = 1 " open ranger when vim open a directory
nmap <silent> - :<C-u>RangerEdit<CR>

" Fix autofix problem of current line
" todo code action: update to lsp code action
nmap <leader>qf <esc>

let g:sneak#label = 1

" gitgutter
let g:gitgutter_map_keys = 1
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
