" --------------------
" Basic Vim Configuration
" --------------------
syntax on                 " Turn on syntax highlighting
set number                " Display absolute line numbers
set relativenumber        " Use relative line numbers to help with quick navigation
set ruler                 " Show the cursor position in the status bar
set cursorline            " Highlight the current line
filetype plugin indent on " Enable file-specific indenting and plugins
set expandtab             " Convert tabs to spaces
set tabstop=4             " A tab is worth 4 spaces
set shiftwidth=4          " Indent/outdent by 4 spaces
set showmatch             " Highlight matching bracket or parenthesis
set hlsearch              " Highlight search results
set incsearch             " Highlight matches as you type in search
set ignorecase            " Ignore case when searching...
set smartcase             " ...unless the search contains an uppercase letter
set wildmenu              " Enhanced command line completion
set nobackup              " Don't keep a backup file
set nowritebackup         " Don't keep a backup file when overwriting
set scrolloff=3           " Keep 3 lines visible around the cursor during scroll
set nowrap                " Don't wrap long lines; scroll horizontally instead
colorscheme abstract    " Set colorscheme
