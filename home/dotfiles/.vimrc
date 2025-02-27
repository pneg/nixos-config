" Gotta be first
set nocompatible

filetype off

" ---- Plugins -------------------------------------------
call plug#begin()
" ---- General Plugins -----------------------------------
"Plug 'morhetz/gruvbox'
Plug 'lifepillar/gruvbox8'
Plug 'itchyny/lightline.vim'
"Plug 'lambdalisue/vim-fern'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'justinmk/vim-sneak'
"Plug 'Houl/repmo-vim'
"Plug 'vds2212/vim-remotions'

" ---- Vim as a programmer's text editor -----------------
Plug 'yegappan/lsp'
Plug 'girishji/vimcomplete'
Plug 'girishji/scope.vim'
Plug 'girishji/devdocs.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'puremourning/vimspector'
Plug 'tpope/vim-surround'
"Plug 'Raimondi/delimitMate'
Plug 'yms9654/HTML-AutoCloseTag', { 'commit': '9e5acea749bde5818ba5782270ed7fda79dd03c3', 'for': ['html', 'javascript']}
Plug 'kovisoft/slimv', { 'for': [ 'scheme', 'cl', 'lisp', 'clojure' ] }
"Plug 'jpalardy/vim-slime'

" ---- Git -------------------------------
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" ---- Plaintext -------------------------
Plug 'preservim/vim-pencil', { 'for': ['text', 'markdown', 'org'] }
Plug 'junegunn/goyo.vim', { 'for': ['text', 'markdown', 'org'] }
Plug 'junegunn/limelight.vim', { 'for': ['text', 'markdown', 'org'] }

" ---- Extras ----------------------------
Plug 'christoomey/vim-tmux-navigator'
Plug 'jasonccox/vim-wayland-clipboard'
Plug 'ntpeters/vim-better-whitespace'
Plug 'dbakker/vim-paragraph-motion'
"Plug 'thirtythreeforty/LessSpace.vim'
"Plug 'antoinemadec/FixCursorHold.nvim'

call plug#end()

filetype plugin indent on

" see man pages in new buffer
runtime! ftplugin/man.vim


" ---- General settings --------------------------------
set backspace=indent,eol,start
set ruler
set relativenumber
set number
set showcmd
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrap
set textwidth=0
set scrolloff=4
set wildmenu
set wildmode=longest:list,full
syntax on
set mouse=a
let mapleader = " "

" We need this for plugins like lsp and vim-gitgutter
" which put symbols in the signcolumn
hi clear SignColumn
set signcolumn=yes

" allow Ctrl-[ without timeout
set ttimeoutlen=0

" bar cursor in insert mode
let &t_SI = "\e[6 q"
" else steady block
let &t_EI = "\e[2 q"

" Try and make things faster
set lazyredraw

" Spellcheck
hi clear SpellBad
hi SpellBad cterm=underline

" ---- GUI settings
hi SpellBad gui=undercurl

if has("gui_running")
  set guifont=Terminus\ 8
endif

set guioptions-=T

if !has("gui_running")
    :source $VIMRUNTIME/menu.vim
    :set cpoptions-=<
    :set wildcharm=<C-Z>
    :map <Leader>m :emenu <C-Z>
endif

" ---- Indentation/Folding Settings ---------------------
set autoindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" see tabs
set listchars=tab:▷▷⋮
set invlist

" folding settings
set foldmethod=manual
set foldnestmax=2
set foldopen-=block


" ---- File Management ---------------------------------
" Use undofiles instead of swapfile
if !isdirectory($HOME."/.cache/vim")
    call mkdir($HOME."/.cache/vim", "", 0770)
endif
if !isdirectory($HOME."/.cache/vim/undo-dir")
    call mkdir($HOME."/.cache/vim/undo-dir", "", 0700)
endif
set undodir=~/.cache/vim/undo-dir
set undofile
set noswapfile

" netrw nerdtree-like setup (not anymore)
let g:netrw_banner = 0
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_winsize = 10
nmap <Leader>f :Vexplore<CR>


" ---- Keybindings -------------------------------------
" bind nohl
nnoremap <Leader>n :nohl<return>

" Make Ctrl-Backspace work
"imap <C-"BS> <C-W>
" Rebind shift-tab for insert mode
"inoremap <S-Tab> <C-d>

" Move between tabs quickly
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
nnoremap <A-0> :tablast<CR>

" append/insert any text object
" https://gist.github.com/wellle/9289224
nnoremap <silent> <Leader>a :set opfunc=Append<CR>g@
nnoremap <silent> <Leader>i :set opfunc=Insert<CR>g@
function! Append(type, ...)
    call feedkeys("`]a", 'n')
endfunction

function! Insert(type, ...)
    call feedkeys("`[i", 'n')
endfunction

" Asynchronous make cs project
autocmd Filetype cs nmap <Leader>r :call job_start('dotnet run')<CR>

" Asynchronous make love2d project
autocmd Filetype lua nmap <Leader>r :w \| call job_start('love .')<CR>

" ---- AutoCMDs -----------------------------------------
" save folds and cursor position
set viewoptions-=options
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Open folds on opening files
au BufRead * normal zM

" Stop highlighting when entering insert mode
autocmd InsertEnter * call feedkeys("\<Cmd>noh\<cr>", 'n')

" Disable comments automatically inserting on new line
autocmd FileType * set formatoptions-=cro

" Bug where man pages are one column too large when signcolumn is on
autocmd Filetype man setlocal signcolumn=no

" make cs project
autocmd Filetype cs set makeprg=dotnet\ run


" ---- Commands -----------------------------------------
" Write to file with sudo
command WriteSudo w !sudo tee %

command EnableSpellCheck set spell spelllang=en_us
command DisableSpellCheck set nospell


" ---- Theming ------------------------------------------
set background=dark

" italics (must be before colorscheme)
let g:gruvbox_italics=0
let g:gruvbox_italicize_strings=0

" Highlight groups for various languages
let g:gruvbox_filetype_hi_groups=1

" Set the colorscheme
colorscheme gruvbox8


" ---- Plugin-Specific Settings -------------------------

" ---- morhetz/gruvbox & lifepiller/gruvbox8 settings ----
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" ---- itchyny/lightline.vim settings ----
"  Always show statusbar
set laststatus=2
" get rid of echoing mode
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'gruvbox8',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" ---- yegappan/lsp settings ----
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
      \	  name: 'clang',
      \	  filetype: ['c', 'cpp'],
      \	  path: $HOME.'/.nix-profile/bin/clangd',
      \	  args: ['--background-index']
      \ }, #{
      \	  name: 'jdtls',
      \	  filetype: 'java',
      \	  path: $HOME.'/.nix-profile/bin/jdtls',
      \	  args: []
      \ }, #{
      \	  name: 'OmniSharp',
      \	  filetype: 'cs',
      \	  path: $HOME.'/.nix-profile/bin/OmniSharp',
      \	  args: ['-z', '--languageserver', '--encoding', 'utf-8']
      \ }, #{
      \	  name: 'nil',
      \	  filetype: 'nix',
      \	  path: $HOME.'/.nix-profile/bin/nil'
      \ }, #{
      \	  name: 'luals',
      \	  filetype: 'lua',
      \	  path: $HOME.'/.nix-profile/bin/lua-language-server',
      \	  workspaceConfig: #{
      \	    Lua: #{
      \	      hint: #{
      \		enable: v:true,
      \	      },
      \	      workspace: #{
      \		checkThirdParty: v:false,
      \		library: [ "${3rd}/love2d/library" ]
      \	      }
      \	    }
      \	  }
      \	}]
autocmd User LspSetup call LspAddServer(lspServers)

nmap <Leader>l :LspDiagShow<CR>
nmap gd :LspGotoDefinition<CR>
nmap <Leader>gd :LspGotoDeclaration<CR>

" Signature help
nmap K :LspHover<CR>
" Man pages
set keywordprg=:Man
nnoremap <Leader>k <Leader>K

" ---- girishji/vimcomplete settings ----
let g:vimcomplete_tab_enable = 1

let vimcompleteOptions = #{
      \  lsp: #{ priority: 20 }
      \}

autocmd VimEnter * call g:VimCompleteOptionsSet(vimcompleteOptions)
"autocmd VimEnter * VimCompleteEnable c cpp cs python java javascript nix vim lua

" disable echoing matches
set shortmess+=c

" ---- girishji/scope.vim settings ----
nnoremap <Leader>p :call g:scope#fuzzy#File()<cr>

" ---- girishji/devdocs.vim settings ----
nnoremap <Leader>d :DevdocsFind<CR>

" ---- puremourning/vimspector settings ----
let g:vimspector_enable_mappings = 'HUMAN'

" ---- airblade/vim-gitgutter settings ----
" Makes signpost same color as line numbers because for some reason its reset halfway through the file
hi clear SignColumn

" ---- Raimondi/delimitMate settings ----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ---- kovisoft/slimv settings ----
let g:lisp_rainbow=1
let g:slimv_leader=","

" ---- jpalardy/vim-slime settings ----
let g:slime_target = "vimterminal"

" ---- justinmk/vim-sneak settings ----
let g:sneak#label = 1
"map f <Plug>Sneak_s
"map F <Plug>Sneak_S

" ---- vim-scripts/vim-pencil settings ----
let g:pencil#wrapModeDefault = 'soft'
augroup pencil
  autocmd!
  autocmd FileType markdown call pencil#init()
  "autocmd FileType textile call pencil#init()
  "autocmd FileType text call pencil#init({'wrap': 'hard'})
augroup END

" ---- junegunn/goyo.vim settings ----
"autocmd! User GoyoEnter EnableSpellCheck
"autocmd! User GoyoLeave DisableSpellCheck
autocmd! User GoyoEnter Limelight " | EnableSpellCheck
autocmd! User GoyoLeave Limelight! " | DisableSpellCheck

" ---- antoinemadec/FixCursorHold.nvim settings ----
" Time between CursorHolds
"let g:cursorhold_updatetime=100
