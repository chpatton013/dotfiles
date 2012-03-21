" resize splits on window resize
au VimResized * exe "normal! \<c-w>="

autocmd VimEnter * set vb t_vb=

behave xterm

function! <SID>StripTrailingWhitespaces()
   let _s=@/
   let l = line(".")
   let c = col(".")
   %s/\s\+$//e
   let @/=_s
   call cursor(l, c)
endfunction

highlight WhitespaceEOL ctermbg=Red guibg=Red
   match WhitespaceEOL /\s\+$/

if exists('+colorcolumn')
   set cc=80
   hi ColorColumn ctermbg=lightgrey guibg=lightgey
else
   au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

inoremap jk <Esc>
inoremap kj <Esc>

let mapleader=','

map Y y$
" word wrapping
map \b i[<Esc>ea]<Esc>
map \B a]<Esc>bi[<Esc>
map \c i{<Esc>ea}<Esc>
map \C a}<Esc>bi{<Esc>
map \p i(<Esc>ea)<Esc>
map \P a)<Esc>bi(<Esc>
" detab
map <F2> y:g/<C-R>"/d<CR>

" improve movement on wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
" strip trailing whitespace
nnoremap <silent> <leader>W :call <SID>StripTrailingWhitespaces()<CR>

set backspace=1
set cindent
set cinoptions=:0,p0,t0
set cinwords=if,unless,else,while,until,do,for,switch,case
set expandtab
set formatoptions=tcqr
set history=500
set hlsearch
set incsearch
set linespace=-1
set nocompatible
set noerrorbells
set novisualbell
set nowrap
set number
set path=~/Code/**
set ruler
set rulerformat=%l,%c%V%=%P
set shiftwidth=3
set showcmd
set showmatch
set showmode
set splitright splitbelow
set tabstop=3
set title
set viminfo='20,\"500,%
set wildmenu

syntax on

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gvo
