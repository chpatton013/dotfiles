"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Reread configuration of Vim if .vimrc is saved
augroup VimConfig
  au!
  au BufWritePost ~/.vimrc       so ~/.vimrc
  au BufWritePost _vimrc         so ~/_vimrc
  au BufWritePost vimrc          so ~/.vimrc
augroup END

" Set colorcolumn to 80 chars, or (if not supported) highlight lines > 80 chars
if exists('+colorcolumn')
   au BufEnter * set colorcolumn=80
   au BufEnter * hi ColorColumn ctermbg=lightgrey guibg=lightgrey
else
   au BufEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Resize splits on window resize
au VimResized * exe "normal! \<c-w>="

" Restore the cursor when we can.
au BufWinEnter * call RestoreCursor()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pathogen - https://github.com/tpope/vim-pathogen
call pathogen#infect()

" Syntastic - https://github.com/scrooloose/syntastic/
let g:syntastic_check_on_open=1

" vim-powerline - https://github.com/Lokaltog/vim-powerline
let g:Powerline_theme="solarized"
let g:Powerline_symbols="compatible"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fucntions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
   let _s=@/
   let l = line(".")
   let c = col(".")
   %s/\s\+$//e
   let @/=_s
   call cursor(l, c)
endfunction

" Insert <Tab> or complete identifier if the cursor is after a keyword character
function TabOrComplete()
    let col = col('.')-1
    if !col || getline('.')[col-1] !~ '\k'
        return "\<tab>"
    else
        return "\<C-N>"
     endif
endfunction

" Restore the cursor when we can
function! RestoreCursor()
    if line("'\"") <= line("$")
        normal! g`"
        normal! zz
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration customization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" gui configuration (do not move from top of configurations)
set guioptions=am
set guifont=Consolas:h9
set encoding=utf-8
set fileencoding=utf-8

set nocompatible              " No compatibility with vi.
filetype on                   " Recognize syntax by file extension.
filetype indent on            " Check for indent file.
filetype plugin on            " Allow plugins to be loaded by file type.

behave xterm                  " Maintain keybindings across enviornments

set autowrite                 " Write before executing the 'make' command.
set background=dark           " Background light, so foreground not bold.
set backspace=2               " Allow <BS> to go past last insert.
set expandtab                 " Expand tabs with spaces.
set nofoldenable              " Disable folds; toggle with zi.
set gdefault                  " Assume :s uses /g.
set ignorecase                " Ignore case in regular expressions
set incsearch                 " Immediately highlight search matches.
set history=500               " Set number of lines for vim to remember
set hlsearch                  " Highlight all search matches
set laststatus=2              " show status line even where there is only one window
set linespace=-1              " Bring lines closer together vertically
set modeline                  " Check for a modeline.
set noerrorbells              " No beeps on errors.
set nohls                     " Don't highlight all regex matches.
set nowrap                    " Don't soft wrap.
set number                    " Display line numbers.
set path=~/Code/**            " Set default path
set ruler                     " Display row, column and % of document.
set rulerformat=%l,%c%V%=%P   " Cleaner ruler format
set scrolloff=6               " Keep min of 6 lines above/below cursor.
set shiftwidth=3              " >> and << shift 3 spaces.
set showcmd                   " Show partial commands in the status line.
set showmatch                 " Show matching () {} etc..
set showmode                  " Show current mode.
set smartcase                 " Searches are case-sensitive if caps used.
set smartindent               " Maintains most indentation and adds extra level when nesting
set softtabstop=3             " See spaces as tabs.
set splitright splitbelow     " Open splits below and to the right
set tabstop=3                 " <Tab> move three characters.
set textwidth=79              " Hard wrap at 79 characters.
set title                     " Set the console title
set viminfo='20,\"500,%       " Adjust viminfo contents
set virtualedit=block         " Allow the cursor to go where there's no char.
set wildmenu                  " Tab completion opens a Tab- and arrow-navigable menu
set wildmode=longest,full     " Tab completion works like bash.

" Formatting settings
" t: Auto-wrap text using textwidth. (default)
" c: Auto-wrap comments; insert comment leader. (default)
" q: Allow formatting of comments with "gq". (default)
" r: Insert comment leader after hitting <Enter>.
" o: Insert comment leader after hitting 'o' or 'O' in command mode.
" n: Auto-format lists, wrapping to text *after* the list bullet char.
" l: Don't auto-wrap if a line is already longer than textwidth.
set formatoptions+=ronl

" Enable mouse scrolling in all modes (same as 'a')
"set mouse=nvic
" Set scrolling to be single-line
"map <MouseDown> <C-Y>
"map <S-MouseDown> <C-U>
"map <MouseUp> <C-E>
"map <S-MouseUp> <C-D>

" Highlighting
syntax enable
set t_Co=16
colorscheme solarized

" Highlight trailing whitespace
highlight WhitespaceEOL ctermbg=Red guibg=Red
   match WhitespaceEOL /\s\+$/

" Configuration variables
let loaded_matchparen=0   " do automatic bracket highlighting.
let mapleader=","         " Use , instead of \ for the map leader.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command mode customization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make y behave like all other capitals
map Y y$

" Make Q reformat text.
noremap Q gq

" Toggle paste mode.
noremap <Leader>p :set paste!<CR>

" Open the file under the cursor in a new tab.
noremap <Leader>ot <C-W>gf

" Toggle highlighting of the last search.
noremap <Leader>h :set hlsearch! hlsearch?<CR>

" Open a scratch buffer.
noremap <Leader>s :Scratch<CR>

" Improve movement on wrapped lines
nnoremap j gj
nnoremap k gk

" Keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

" Use C-hjkl in to change windows
nnoremap <C-h> <C-w><Left>
nnoremap <C-j> <C-w><Down>
nnoremap <C-k> <C-w><Up>
nnoremap <C-l> <C-w><Right>

" Strip trailing whitespace
nnoremap <silent> <leader>W :call <SID>StripTrailingWhitespaces()<CR>

" Allow easy toggling of spaces / tabs mode
nnoremap <C-t><C-t> :set invexpandtab<CR>

" Create simple toggles for line numbers, paste mode, and word wrap.
nnoremap <C-N><C-N> :set invnumber<CR>
nnoremap <C-p><C-p> :set invpaste<CR>
nnoremap <C-w><C-w> :set invwrap<CR>

" Folding stuff
nnoremap <C-o> zo
nnoremap <C-c> zc
nnoremap <C-O> zO
nnoremap <C-O><C-O> zR
set foldmethod=indent

" Open file for class name under cursor
nnoremap <C-i> yiw:find <C-R>".php<CR>

" word wrapping
map \b i[<Esc>ea]<Esc>
map \B a]<Esc>bi[<Esc>
map \c i{<Esc>ea}<Esc>
map \C a}<Esc>bi{<Esc>
map \p i(<Esc>ea)<Esc>
map \P a)<Esc>bi(<Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert mode customization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set up dictionary completion.
set dictionary+=~/.vim/dictionary/english-freq
set complete+=k

" Insert <Tab> or complete identifier if the cursor is after a keyword character
inoremap <Tab> <C-R>=TabOrComplete()<CR>

" Smash Esc
inoremap jk <Esc>
inoremap kj <Esc>

" Use hjkl in insert mode
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

" Make C-s write the buffer and return to insert mode when applicable
inoremap <C-s> <C-O>:w<CR>
nnoremap <C-s> :w<CR>

" auto-insert second braces and parynthesis
inoremap {<CR> {<CR>}<Esc>O
inoremap ({<CR> ({<CR>});<Esc>O
inoremap <<<<CR> <<<EOT<CR>EOT;<Esc>O<C-TAB><C-TAB><C-TAB>
set cpoptions+=$ "show dollar sign at end of text to be changed

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode customization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" reselect visual block after indent/outdent
xnoremap < <gv
xnoremap > >gvo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
