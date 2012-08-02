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
augroup ColorColumnConfig
   au!
   if exists('+colorcolumn')
      au BufWinEnter * set colorcolumn=80
      au BufWinEnter * hi ColorColumn ctermbg=lightgrey guibg=lightgrey
   else
      au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
   endif
augroup END

" Highlight over-length characters and trailing whitespace
augroup ExtraCharacters
   au!
   au ColorScheme * highlight ExtraWhitespace ctermbg=Red guibg=Red
   au ColorScheme * highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
   au BufWinEnter * let w:whitespace_match_number =
   \ matchadd('ExtraWhitespace', '\s\+$')
   au BufWinEnter * call matchadd('OverLength',
   \ '\(^\(\s\)\{-}\(*\|//\|/\*\)\{1}\(.\)*\(\%81v\)\)\@<=\(.\)\{1,}$')
   au InsertEnter * call s:ToggleWhitespaceMatch('i')
   au InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END

" Resize splits on window resize
au VimResized * exe "normal! \<c-w>="

" Restore the cursor when we can.
au BufWinEnter * call RestoreCursor()

" Change the statusline color based on current mode
augroup StatuslineColor
   au!
   au InsertEnter * call InsertStatuslineColor(v:insertmode)
   au InsertLeave * hi statusline ctermfg=cyan ctermbg=black guifg=cyan guibg=black
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pathogen - https://github.com/tpope/vim-pathogen

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()


" Easymotion - https://github.com/Lokaltog/vim-easymotion/

" This is so much more convenient
let g:EasyMotion_leader_key=',m'


" Neocomplcache - https://github.com/Shougo/neocomplcache

" Enable at startup.
let g:neocomplcache_enable_at_startup=1
" Only display 'n' items in the list.
let g:neocomplcache_max_list=5
" Do not auto-select the first candidate.
let g:neocomplcache_enable_auto_select=1
" Do not try to match until 'n' characters have been typed
let g:neocomplcache_auto_completion_start_length=3
" Do not try to match to anything less than 'n' characters
let g:neocomplcache_min_keyword_length=6
let g:neocomplcache_min_syntax_length=6
" Only consider case if an uppercase character has been typed
let g:neocomplcache_enable_smart_case=1


" Syntastic - https://github.com/scrooloose/syntastic/
"  Commands:
"     :Errors              // pop up location list and display errors
"     :SyntasticToggleMode // toggles between active and passive mode
"     :SyntasticCheck      // forces a syntax check in passive mode

" check for syntax errors on file open
let g:syntastic_check_on_open=1
" echo errors to the command window
let g:syntastic_echo_current_error=1
" mark lines with errors and warnings
let g:syntastic_enable_signs=1
" set sign symbols
let g:syntastic_error_symbol='E>'
let g:syntastic_warning_symbol='W>'
let g:syntastic_style_error_symbol='S>'
let g:syntastic_style_warning_symbol='s>'
" open error balloons when moused over erroneous lines
let g:syntastic_enable_balloons=1
" customize Syntastic statusline
let g:syntastic_stl_format = '[%E{E: %fe #%e}%B{, }%W{W: %fw #%w}]'

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

" Toggle match of trailing whitespace
function! s:ToggleWhitespaceMatch(mode)
   let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
   if exists('w:whitespace_match_number')
     call matchdelete(w:whitespace_match_number)
     call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
   else
     " Something went wrong, try to be graceful.
     let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
   endif
endfunction

" Restore the cursor when we can
function! RestoreCursor()
    if line("'\"") <= line("$")
        normal! g`"
        normal! zz
    endif
endfunction

" Change the statusline color based on current mode
function! InsertStatuslineColor(mode)
   if a:mode == 'i'
      hi statusline ctermfg=darkmagenta ctermbg=black guifg=darkmagenta guibg=black
   elseif a:mode == 'r'
      hi statusline ctermfg=darkgreen ctermbg=black guifg=darkgreen guibg=black
   else
      hi statusline ctermfg=darkred ctermbg=black guifg=darkred guibg=black
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

set nocompatible     " No compatibility with vi.
filetype on          " Recognize syntax by file extension.
filetype indent on   " Check for indent file.
filetype plugin on   " Allow plugins to be loaded by file type.

behave xterm   " Maintain keybindings across enviornments

set autowrite                    " Write before executing the 'make' command.
set background=dark              " Background light, so foreground not bold.
set backspace=indent,eol,start   " Allow <BS> to go over indents, eol, and start of insert
set expandtab                    " Expand tabs with spaces.
set nofoldenable                 " Disable folds; toggle with zi.
set gdefault                     " Assume :s uses /g.
set hidden                       " Use hidden buffers so unsaved buffers can go to the background
set history=500                  " Set number of lines for vim to remember
set hlsearch                     " Highlight all search matches
set ignorecase                   " Ignore case in regular expressions
set incsearch                    " Immediately highlight search matches.
set laststatus=2                 " Show status line even where there is only one window
set lazyredraw                   " Redraw faster
set linespace=-1                 " Bring lines closer together vertically
set modeline                     " Check for a modeline.
set noerrorbells                 " No beeps on errors.
set nohls                        " Don't highlight all regex matches.
set nowrap                       " Don't soft wrap.
set number                       " Display line numbers.
set path=~/Code/**               " Set default path
set scrolloff=5                  " Keep min of 'n' lines above/below cursor.
set shellslash                   " Use forward slashes regardless of OS
set shiftwidth=3                 " >> and << shift 3 spaces.
set showcmd                      " Show partial commands in the status line.
set showmatch                    " Show matching () {} etc..
set showmode                     " Show current mode.
set sidescrolloff=10             " Keep min of 'n' columns right/left cursor.
set smartcase                    " Searches are case-sensitive if caps used.
set smarttab                     " Tabs and backspaces at the start of a line indent the line one level
set smartindent                  " Maintains most indentation and adds extra level when nesting
set softtabstop=3                " See spaces as tabs.
set splitright splitbelow        " Open splits below and to the right
set synmaxcol=160                " Only matches syntax on first 'n' columns of each line (faster)
set tabstop=3                    " <Tab> move three characters
set textwidth=79                 " Hard wrap at 79 characters
set title                        " Set the console title
set viminfo='20,\"500,%          " Adjust viminfo contents
set virtualedit=block            " Allow the cursor to go where it should not
set wildmenu                     " Tab completion opens a Tab- and arrow-navigable menu
set wildmode=longest,full        " Tab completion works like bash.
set wrapscan                     " Searching wraps to start of file when end is reached

" Define statusline
set statusline=%f                                     " Relative file path
set statusline+=%(\ [%M%R%H%W]%)                      " File flags (mod, RO, help, preview)
set statusline+=%(\ %<%)                              " Start truncation
set statusline+=%(\ %{fugitive#statusline()}%)        " Git branch name (if applicable)
set statusline+=%=                                    " Begin right justification
set statusline+=%#warningmsg#                         " Start warning highlighting
set statusline+=%(\ %{SyntasticStatuslineFlag()}%)    " Show Syntastic errors and warnings
set statusline+=%*                                    " End warning highlighting
set statusline+=\ [line\ %l\/%L,\ col\ %c%V,\ %p%%]   " Line and column numbers and percentage through file

" Text formatting settings
" t: Auto-wrap text using textwidth. (default)
" c: Auto-wrap comments; insert comment leader. (default)
" q: Allow formatting of comments with "gq". (default)
" r: Insert comment leader after hitting <Enter>.
" o: Insert comment leader after hitting 'o' or 'O' in command mode.
" n: Auto-format lists, wrapping to text *after* the list bullet char.
" l: Don't auto-wrap if a line is already longer than textwidth.
set formatoptions+=ronl

" Enable mouse scrolling in selected modes
" a: All
" c: Command
" i: Insert
" n: Normal
" v: Visual
set mouse=a
" Set scrolling to be single-line
"map <MouseDown> <C-Y>
"map <S-MouseDown> <C-U>
"map <MouseUp> <C-E>
"map <S-MouseUp> <C-D>

" Highlighting
syntax enable
set t_Co=16
colorscheme solarized

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert mode customization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set up dictionary completion.
set dictionary+=~/.vim/dictionary/english-freq
set complete+=k

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
