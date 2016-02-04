" {{{ Memo
" :h[elp] options       => vimの各オプション
" :helpg[rep] {pattern} => ヘルプファイルを対象にキーワード検索
" :copen                => quickfixを開く
" :cclose               => quickfixを閉じる
" :map                  => 設定されているmappingを表示する
" }}}

let mapleader = "\<Space>"
let s:dotfiles_dir = $HOME.'/dotfiles/'
execute 'source' s:dotfiles_dir.'.vimrc.local'

" {{{ Encoding
"--------------------------------------------------------------------------------
scriptencoding utf-8            " vimscriptのエンコーディング
set encoding=utf-8              " vim内部のエンコーディング
set fileencodings=utf-8,euc_jp  " ファイルエンコーディング(先頭から試行)
" }}}
" {{{ 表示
"--------------------------------------------------------------------------------
syntax on                           " シンタックスハイライト
set number                          " 行番号表示
set laststatus=2                    " statuslineを常に表示
" set statusline+=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" set cursorline                    "カーソルがある画面上の行をCursorLineで強調
" カレントウィンドウのみcursorlineを有効にする
" augroup cch
"     autocmd! cch
"     autocmd WinLeave * set nocursorline
"     autocmd WinEnter,BufRead * set cursorline
" augroup END
set visualbell t_vb=                " ビープ音もフラッシュもしない
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif    " ファイルを開いた時に、前回終了時の行で起動する
" }}}
" {{{ 検索
"--------------------------------------------------------------------------------
set ignorecase      " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase       " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan        " 検索時に最後まで行ったら最初に戻る
set incsearch       " 検索文字列入力時に順次対象文字にヒットさせる
set hlsearch        " 検索結果文字列のハイライト表示
" }}}
" {{{ 編集
"--------------------------------------------------------------------------------
set backspace=start,eol,indent  " {insert位置以前,EOL,autoindent space}を削除可能
set autoindent
set smartindent
" }}}
" {{{ バッファ
"--------------------------------------------------------------------------------
set nobackup                        " バックアップファイル(`*~`)を作成しない
set clipboard=unnamed,autoselect    " システムのクリップボードと同期する
set guioptions+=a                   " 上の`autoselect`のGUI VIM版
set wildignorecase                  " ファイル名やディレクトリを補完するときに大文字と小文字が無視される
set wildmode=list:full              " 複数のマッチがあるときは、全てのマッチを羅列し、最初のマッチを補完
" au BufEnter * execute ":lcd" .expand("%:p:h") " カレントバッファのパスに移動するする
" }}}
" {{{ Folding
"--------------------------------------------------------------------------------
set foldmethod=marker   " marker使ってfoldする
" }}}
" {{{ 入力
"--------------------------------------------------------------------------------
set expandtab           " タブの代わりに空白文字挿入
set ts=4 sw=4 sts=0     " タブは半角4文字分のスペース
inoremap <S-Tab> <C-d>
" }}}
" {{{ Plugins - Build Functions
"--------------------------------------------------------------------------------
function! BuildVimproc(info)
    if has('win32') || has('win64')
        ! 'tools\\update-dll-mingw'
    else
        ! 'make'
    endif
endfunction
" }}}
" {{{ Plugins
"--------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'                                " statusline
Plug 'Shougo/vimproc.vim', {'do': function('BuildVimproc')}
Plug 'Shougo/vimshell'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-notes'              " メモ取り
Plug 'Shougo/neocomplete.vim'                               " 入力補完
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'                                 " Unite - outline表示
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()
" }}}
" {{{ lightline
"--------------------------------------------------------------------------------
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
" }}}
" {{{ vim-notes
"--------------------------------------------------------------------------------
let g:notes_suffix = '.markdown'
let g:notes_unicode_enabled = 0
" }}}
" {{{ unite
"--------------------------------------------------------------------------------
" MEMO:
" - :Unite [source,...]
" - soureに対して<TAB>するとactionが色々出る (:h unite-actions)
nnoremap [unite] <Nop>
nmap <Leader>u [unite]
call unite#custom#profile('default', 'context', {
\   'start_insert': 1,
\   'winheight': 10,
\   'direction': 'botright',
\   'ignorecase': 1,
\   'smartcase': 1
\ })
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" Using ag as recursive command.
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '-i --vimgrep --hidden'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
endif
nnoremap [unite]b :<C-u>Unite buffer<CR>
nnoremap [unite]f :<C-u>Unite file<CR>
nnoremap [unite]g :<C-u>Unite grep:.<CR>
nnoremap [unite]u :<C-u>Unite -auto-preview buffer file_mru file_rec/async:!:fnameescape(expand('%:p:h'))<CR>
" nnoremap [unite]c :<C-u>UniteWithCurrentDir -buffer-name=files buffer bookmark file<CR>
" }}}
" {{{ unite-outline
"--------------------------------------------------------------------------------
nnoremap [unite]o :<C-u>Unite -vertical -no-quit -winwidth=40 outline<CR>
" }}}
" {{{ ctrlp
"--------------------------------------------------------------------------------
let g:ctrlp_cmd = 'CtrlPMRUFiles'
if executable('ag')
    let g:ctrlp_user_command = 'ag %s'
endif
let g:ctrlp_prompt_mappings = {
\   'PrtSelectMove("j")':   ['<c-n>', '<down>'],
\   'PrtSelectMove("k")':   ['<c-p>', '<up>'],
\   'PrtHistory(-1)':       ['<c-j>'],
\   'PrtHistory(1)':        ['<c-k>'],
\   }
" }}}
" {{{ neocomplete
"--------------------------------------------------------------------------------
let g:neocomplete#enable_at_startup = 1 " 起動時に有効化
let g:neocomplete#enable_smart_case = 1 " 大文字小文字を区別しない
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
" <TAB>: completon
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}
" {{{ 言語別 - Ruby
"--------------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.rb set ts=2 sw=2 sts=0
" }}}
" {{{ 言語別 - Markdown
"--------------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.{md,mkd,markdown} setfiletype markdown
" }}}
" {{{ 言語別 - HTML
"--------------------------------------------------------------------------------
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
" }}}

" ================================================================================
" ================================================================================
" ================================================================================
" ================================================================================
" ================================================================================
" " {{{ NeoBundle
" "--------------------------------------------------------------------------------
" if has('vim_starting')
"     set runtimepath+=~/.vim/bundle/neobundle.vim/
" endif
" 
" " Required:
" call neobundle#begin(expand('~/.vim/bundle/'))
" 
" " Let NeoBundle manage NeoBundle
" NeoBundleFetch 'Shougo/neobundle.vim'
" 
" " My Bundles here:
" "
" " Note: You don't set neobundle setting in .gvimrc!
" " Original repos on github
" NeoBundle 'plasticboy/vim-markdown' " markdownシンタックス
" NeoBundle 'kannokanno/previm'       " markdownプレビュー
" NeoBundle 'tyru/open-browser.vim'   " ブラウザでファイルを開く
" NeoBundle 'scrooloose/syntastic'    " syntax checker
" NeoBundle 'scrooloose/nerdtree'
" NeoBundle 'majutsushi/tagbar'
" NeoBundle 'szw/vim-tags'
" NeoBundle 'vim-scripts/Source-Explorer-srcexpl.vim'
" NeoBundle 'vim-scripts/SrcExpl'
" NeoBundle 'wesleyche/Trinity'
" NeoBundle 'The-NERD-tree'
" NeoBundle 'taglist.vim'
" NeoBundle 'aklt/plantuml-syntax'
" NeoBundle 'kchmck/vim-coffee-script'
" NeoBundle 'elzr/vim-json'
" " NeoBundle 'derekwyatt/vim-scala'
" " NeoBundle 'cespare/vim-toml'
" 
" " Required:
" call neobundle#end()
" " 
" " filetype plugin indent on     " Required!
" " " Brief help
" " " :NeoBundleList          - list configured bundles
" " " :NeoBundleInstall(!)    - install(update) bundles
" " " :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles
" " 
" " " Installation check.
" " NeoBundleCheck
" " " }}}
" " " {{{ previm
" " "--------------------------------------------------------------------------------
" " "g:previm_open_cmd   " open-browser使用時は不要
" " autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} setfiletype mkd
" " " }}}
" " 
" " " {{{ syntastic
" " "--------------------------------------------------------------------------------
" " "let g:syntastic_check_on_open=1
" " "let g:syntastic_always_populate_loc_list=1
" " let g:syntastic_python_checkers = ['flake8']
" " autocmd FileType python autocmd BufWritePost <buffer> Errors
" " " }}}
" " 
" " " {{{ nerdtree
" " "--------------------------------------------------------------------------------
" " map <Space>n :NERDTreeToggle<CR>
" " autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" " " }}}
" " 
" " " {{{ Tagbar
" " "--------------------------------------------------------------------------------
" " nmap <Leader>t :TagbarToggle<CR>
" " " }}}
" " 
" " " {{{ MISC
" " "--------------------------------------------------------------------------------
" " " previm
" " let g:previm_open_cmd = 'open -a Firefox'
" " " }}}
" " 
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " " vim-tags
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " let g:vim_tags_project_tags_command = '/usr/local/bin/ctags -R {OPTIONS} {DIRECTORY} 2> /dev/null'
" " let g:vim_tags_gems_tags_command = '/usr/local/bin/ctags -R {OPTIONS} `bundle show --paths` 2> /dev/null'
" " 
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " " taglist
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " let Tlist_Ctags_Cmd = '"/usr/local/bin/ctags"'
" " 
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " " Syntastic
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " let g:syntastic_check_on_open=1
" " let g:syntastic_always_populate_loc_list=1
" " let g:syntastic_python_checkers = ['flake8']
" " "let g:syntastic_python_flake8_args = '--ignore="E221,E303,E501"'
" " autocmd FileType python autocmd BufWritePost <buffer> Errors
