"Display extra whitespaces in green
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=green guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"Theme
colorscheme molokai-delroth

"Display
set scrolloff=5 "lines offset before starting scrolling
set number
set relativenumber
set laststatus=2 "always display the status line
set wildmenu
set wildmode=longest,list
set colorcolumn=+1
set t_Co=256

set list
set listchars=tab:→\ ,nbsp:¤
highlight SpecialKey ctermfg=59

"Edit
set expandtab "spaces instead of tabs
set smarttab "insert shiftwidth in the beginning of line or sts.
set tabstop=6
set softtabstop=4 "length of a fake tab in expandtab mode
set shiftwidth=4 "length of indentation
set autoindent "duh
set textwidth=79
set wrap

"Search
set nohlsearch "remove the persistant highlight after searches
set incsearch "search incrementally

"Backup/swap/undo
set backup
set undofile

"Other
set noerrorbells "remove terminal bells on error

"Keys & mappings
let mapleader=" "
set pastetoggle=<F2>

"Abbreviations
cabbr <expr> %% expand('%:h')
