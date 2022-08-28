" setting
"文字コードをUFT-8に設定
set encoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
" バックアップファイルを作らない
set nobackup
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
"set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を止める
set visualbell t_vb=
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライトの有効化
syntax enable

" カラースキーム
colorscheme desert

" Tab系
" 不可視文字を可視化
set listchars=tab:»-,trail:-,nbsp:%,eol:↲
" 文字色
hi NonText    ctermbg=NONE ctermfg=239 guibg=NONE guifg=NONE
hi SpecialKey ctermbg=NONE ctermfg=239 guibg=NONE guifg=NONE
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" <Tab> を押した時, 何個分のスペースを挿入するか
set softtabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" .un~ファイルの出力を行い、出力ディレクトリを1箇所にまとめる
set undofile
set undodir=~/.vim/undo

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.sh,*.bash setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
  autocmd BufNewFile,BufRead *.java      setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.go        setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.gitconfig        setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.py        setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.rb        setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" カーソル位置を記憶する ---------------------------------------
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END
" カーソル位置を記憶する ---------------------------------------

" カーソルラインの位置を保存する -------------------------------
augroup cursorlineRestore
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END
" カーソルラインの位置を保存する -------------------------------

" lightline ----------------------------------------------------
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'MyGitBranch',
  \ },
  \ 'component': {
  \   'charvaluehex': '0x%B'
  \ },
  \ }

function! MyGitBranch()
  let branch = gina#component#repo#branch()
  return branch !=# '' ? "\ue0a0 ".branch : ''
endfunction
" lightline ----------------------------------------------------

" vim-lsp ------------------------------------------------------
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" vim-lsp ------------------------------------------------------

" asyncomplete -------------------------------------------------
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
" asyncomplete -------------------------------------------------

" vim-plub -----------------------------------------------------
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/fern.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
call plug#end()
" vim-plub -----------------------------------------------------

""dein Scripts-----------------------------
"if &compatible
"  set nocompatible               " Be iMproved
"endif
"
"let s:dein_dir = expand('~/.cache/dein')
"let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
"
"" Required:
"execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
"
"" Required:
"if dein#load_state(s:dein_dir)
"  call dein#begin(s:dein_dir)
"
"  " Let dein manage dein
"  " Required:
"  call dein#add(s:dein_repo_dir)
"
"  " Add or remove your plugins here like this:
"  "call dein#add('Shougo/neosnippet.vim')
"  "call dein#add('Shougo/neosnippet-snippets')
"  call dein#add('itchyny/lightline.vim')
"  call dein#add('lambdalisue/gina.vim')
"  call dein#add('lambdalisue/fern.vim')
"  call dein#add('prabirshrestha/vim-lsp')
"  call dein#add('mattn/vim-lsp-settings')
"
"  " Required:
"  call dein#end()
"  call dein#save_state()
"endif
"
"" Required:
"filetype plugin indent on
"syntax enable
"
"" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif
"
""End dein Scripts-------------------------
