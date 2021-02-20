call plug#begin('/home/ivan/.config/nvim/plugged')

" gruvbox colorscheme
Plug 'morhetz/gruvbox'

" draws vertical lines to mark indents
Plug 'Yggdroot/indentLine'

" highlight git status of lines 
Plug 'airblade/vim-gitgutter'

" info stripe below
Plug 'vim-airline/vim-airline'

" linter 
Plug 'dense-analysis/ale'

" Language server protocol 
"Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" fuzzy search for strings 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" comment shortcuts 
Plug 'preservim/nerdcommenter'

" file tree 
Plug 'scrooloose/nerdtree'

" plugin for languages
" python syntax is handled by this one
" https://github.com/vim-python/python-syntax
 "it has a lot of options I will need to explore
" do I need to disable it for all languages I'm not using?
Plug 'sheerun/vim-polyglot'

" insert matching brackets, parens or quote
"Plug 'jiangmiao/auto-pairs'
Plug 'tmsvg/pear-tree'

" git merge, rebase, diff tool (LEARN HOW TO USE, KEY BIND)
Plug 'tpope/vim-fugitive'

" surrond selection with symbols
" great for html tags 
" https://github.com/tpope/vim-surround
" how about e.g. for-loops 
Plug 'tpope/vim-surround'

" disables certain features of vim 
" when editing large files to improve speed
" https://github.com/vim-scripts/LargeFile
Plug 'vim-scripts/LargeFile'

" add common keybindings 
Plug 'liuchengxu/vim-better-default'

call plug#end()


"""""""""""""""""""""""""""""""""""""
" Language server protocol
"""""""""""""""""""""""""""""""""""""
lua << END
    local nvim_lsp = require'lspconfig'
    local api = vim.api
    
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        }
    )

    function on_attach(client, bufnr)
        require'completion'.on_attach()
        api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end

    nvim_lsp.pyls.setup{on_attach=on_attach}
END

"""""""""""""""""""""""""""""""""""""
" Treesitter
"""""""""""""""""""""""""""""""""""""
lua <<EOF
  -- require "nvim-treesitter.parsers".get_parser_configs().markdown = nil
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    ident = {
      enable = true,
    },
    highlight = {
      enable = true,
    },
  }
EOF

"""""""""""""""""""""""""""""""""""""
" Editor appearance
"""""""""""""""""""""""""""""""""""""
syntax on
" Apply colorscheme
"autocmd vimenter * 
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'soft'
" To set light gruvbox scheme, uncomment all of the below
"let g:gruvbox_contrast_light = 'soft'
"set termguicolors          " use gui 24-bit colors, gui attrs instead of cterm
"set t_Co=256
"set background=light

" Open new splits
set splitbelow
set splitright
"""""""""""""""""""""""""""""""""""""
" Editor functionality 
"""""""""""""""""""""""""""""""""""""
set encoding=utf-8 " Set right encoding and formats
set fileformat=unix
" Make search case insensitive by default (add \C to search pattern to make it sensitive)
set ignorecase 
" If search pattern contains capitals, make case sensitive search
set smartcase 
" Linter
let g:ale_linters = {
            \   'python': ['pyls', 'mypy'],
            \   'yaml': ['yamllint'],
            \   'cloudformation': ['cfn-lin']
            \}

let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['black'],
            \   'json': ['jq'],
            \}

" Autocomplete
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
set completeopt=menuone,noinsert,noselect
let g:completion_enable_auto_popup = 1

" Comments
filetype plugin on


""""""""""""""""""""""""""""""""""""
" Mapping configuration
"""""""""""""""""""""""""""""""""""""
let mapleader = " "

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Move line up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Paste multiple times with p
xnoremap p pgvy

" Delete with copying to black hole register
nnoremap dd "_dd
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

" Fugitive git conflict resolution
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" NerdTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" ALE linter
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Autocompletion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent><C-]> :call <SID>definition()<CR>
nnoremap <silent>K :call <SID>show_documentation()<CR>

function! s:definition()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'tjump '.expand('<cword>')
  else
    lua vim.lsp.buf.definition()
  endif
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction
