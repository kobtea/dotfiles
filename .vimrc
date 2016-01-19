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
" {{{ 言語別 - Ruby
"--------------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.rb set ts=2 sw=2 sts=0
" }}}
" {{{ 言語別 - Markdown
"--------------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.{md,mkd,markdown} setfiletype markdown
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
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'Shougo/neomru.vim'
" NeoBundle 'Shougo/neocomplcache.vim'
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
" NeoBundle 'xolox/vim-misc'
" NeoBundle 'xolox/vim-notes'
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
" " 
" " " {{{ unite
" " "--------------------------------------------------------------------------------
" " nnoremap [unite] <Nop>
" " nmap <Space>u [unite]
" " nnoremap [unite]c :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
" " nnoremap [unite]b :<C-u>Unite buffer<CR>
" " " }}}
" " 
" " " {{{ neocomplcache
" " "--------------------------------------------------------------------------------
" " "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" " " Disable AutoComplPop.
" " let g:acp_enableAtStartup = 0
" " " Use neocomplcache.
" " let g:neocomplcache_enable_at_startup = 1
" " " Use smartcase.
" " let g:neocomplcache_enable_smart_case = 1
" " " Set minimum syntax keyword length.
" " let g:neocomplcache_min_syntax_length = 3
" " let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" " 
" " " Enable heavy features.
" " " Use camel case completion.
" " "let g:neocomplcache_enable_camel_case_completion = 1
" " " Use underbar completion.
" " "let g:neocomplcache_enable_underbar_completion = 1
" " 
" " " Define dictionary.
" " let g:neocomplcache_dictionary_filetype_lists = {
" "     \ 'default' : '',
" "     \ 'vimshell' : $HOME.'/.vimshell_hist',
" "     \ 'scheme' : $HOME.'/.gosh_completions'
" "         \ }
" " 
" " " Define keyword.
" " if !exists('g:neocomplcache_keyword_patterns')
" "     let g:neocomplcache_keyword_patterns = {}
" " endif
" " let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" " 
" " " Plugin key-mappings.
" " inoremap <expr><C-g>     neocomplcache#undo_completion()
" " inoremap <expr><C-l>     neocomplcache#complete_common_string()
" " 
" " " Recommended key-mappings.
" " " <CR>: close popup and save indent.
" " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" " function! s:my_cr_function()
" "   return neocomplcache#smart_close_popup() . "\<CR>"
" "   " For no inserting <CR> key.
" "   "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
" " endfunction
" " " <TAB>: completion.
" " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" " " <C-h>, <BS>: close popup and delete backword char.
" " inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
" " inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" " inoremap <expr><C-y>  neocomplcache#close_popup()
" " inoremap <expr><C-e>  neocomplcache#cancel_popup()
" " " Close popup by <Space>.
" " "inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"
" " 
" " " my mapping # begin
" " imap <C-k> <Plug>(neocomplcache_snippets_expand)
" " smap <C-k> <Plug>(neocomplcache_snippets_expand)
" " inoremap <expr><C-g> neocomplcache#undo_completion()
" " inoremap <expr><C-l> neocomplcache#complete_common_string()
" " inoremap <expr><CR> neocomplcache#smart_close_popup(). "\<CR>"
" " inoremap <expr><TAB> pumvisible() ?"\<C-n>" : "\<TAB>"
" " inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
" " inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" " inoremap <expr><C-y> neocomplcache#close_popup()
" " inoremap <expr><C-e> neocomplcache#cancel_popup()
" " " my mapping # end
" " 
" " " For cursor moving in insert mode(Not recommended)
" " "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
" " "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
" " "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
" " "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" " " Or set this.
" " "let g:neocomplcache_enable_cursor_hold_i = 1
" " " Or set this.
" " "let g:neocomplcache_enable_insert_char_pre = 1
" " 
" " " AutoComplPop like behavior.
" " "let g:neocomplcache_enable_auto_select = 1
" " 
" " " Shell like behavior(not recommended).
" " "set completeopt+=longest
" " "let g:neocomplcache_enable_auto_select = 1
" " "let g:neocomplcache_disable_auto_complete = 1
" " "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
" " 
" " " Enable omni completion.
" " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" " 
" " " Enable heavy omni completion.
" " if !exists('g:neocomplcache_omni_patterns')
" "   let g:neocomplcache_omni_patterns = {}
" " endif
" " let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" " let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
" " let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" " 
" " " For perlomni.vim setting.
" " " https://github.com/c9s/perlomni.vim
" " let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" " " }}}
" " 
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
" " 
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " " plantuml-syntax
" " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " let g:plantuml_executable_script = '/usr/local/bin/plantuml'
" " 
