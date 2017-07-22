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
set background=dark                 " 背景色を指定しておくとhighlightの色などよしなにしてくれる
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
set noundofile                      " undoファイル(`.*.un~`)を作成しない
if has("nvim")
    set clipboard+=unnamedplus
else
    set clipboard=unnamed,autoselect    " システムのクリップボードと同期する
endif
set guioptions+=a                   " 上の`autoselect`のGUI VIM版
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
" Plug 'xolox/vim-misc' | Plug 'xolox/vim-notes'              " メモ取り
Plug 'Shougo/unite.vim'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'                                 " Unite - outline表示
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/syntastic'                                 " syntax checker
Plug 'elzr/vim-json'
Plug 'scrooloose/nerdtree'
Plug 'aklt/plantuml-syntax'
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'Shougo/junkfile.vim'
Plug 'glidenote/memolist.vim'
Plug 'fatih/vim-go'
if has("nvim")
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/vimproc.vim', {'do': function('BuildVimproc')}
    Plug 'Shougo/vimshell'
    Plug 'Konfekt/FastFold' | Plug 'Shougo/neocomplete.vim'     " 入力補完
endif
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
" let g:notes_suffix = '.markdown'
" let g:notes_tab_indents = 0
" let g:notes_unicode_enabled = 0
" let g:notes_list_bullets = ['-']
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
" {{{ denite
"--------------------------------------------------------------------------------
nnoremap [denite] <Nop>
nmap <Leader>u [denite]
nnoremap [denite]b :<C-u>Denite buffer<CR>
nnoremap [denite]f :<C-u>Denite file<CR>
nnoremap [denite]g :<C-u>Denite grep:.<CR>
nnoremap [denite]u :<C-u>Denite -auto-preview buffer file_mru file_rec<CR>
" Change file_rec command.
call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
" Change mappings.
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap' )
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap' )
" Change matchers.
call denite#custom#source('file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])
" Change sorters.
call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
" Add custom menus
let s:menus = {}
let s:menus.zsh = {'description': 'Edit your import zsh configuration'}
let s:menus.zsh.file_candidates = [
	\ ['zshrc', '~/.config/zsh/.zshrc'],
	\ ['zshenv', '~/.zshenv'],
	\ ]
let s:menus.my_commands = {'description': 'Example commands'}
let s:menus.my_commands.command_candidates = [
	\ ['Split the window', 'vnew'],
	\ ['Open zsh menu', 'Denite menu:zsh'],
	\ ]
call denite#custom#var('menu', 'menus', s:menus)
" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
" Define alias
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])
" Change default prompt
call denite#custom#option('default', 'prompt', '>')
" Change ignore_globs
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs', [ '.git/', '.ropeproject/', '__pycache__/', 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
" Custom action
call denite#custom#action('file', 'test', {context -> execute('let g:foo = 1')})
call denite#custom#action('file', 'test2', {context -> denite#do_action(context, 'open', context['targets'])})
" }}}
" {{{ unite-outline
"--------------------------------------------------------------------------------
nnoremap [denite]o :<C-u>Unite -vertical -no-quit -no-start-insert -winwidth=40 outline<CR>
" }}}
" {{{ unite for junkfile
"--------------------------------------------------------------------------------
nnoremap [denite]j   :<C-u>Unite junkfile<CR>
nnoremap [denite]je  :<C-u>Unite junkfile/new<CR>
" }}}
" {{{ memolist
"--------------------------------------------------------------------------------
let g:memolist_denite = 1
let g:memolist_denite_source = "file_rec"
let g:memolist_denite_option = "-auto-preview"
let g:memolist_ex_cmd = 'CtrlP'
nnoremap [denite]mn : MemoNew<CR>
nnoremap [denite]ml : MemoList<CR>
nnoremap [denite]mg : MemoGrep<CR>
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
if !has("nvim")
    let g:neocomplete#enable_at_startup = 1 " 起動時に有効化
    let g:neocomplete#enable_smart_case = 1 " 大文字小文字を区別しない
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    endfunction
    " <TAB>: completon
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
endif
" }}}
" {{{ deoplete
"--------------------------------------------------------------------------------
if has("nvim")
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
endif
" }}}
" {{{ syntastic
"--------------------------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": []
    \ }
autocmd BufWrite * SyntasticCheck
" }}}
" {{{ gnu global
"--------------------------------------------------------------------------------
" Mac OSX
"   $ mkdir -p $HOME/.vim/plugin
"   $ ln -s /usr/local/Cellar/global/6.5.2/share/gtags/gtags.vim $HOME/.vim/plugin/
nnoremap [global] <Nop>
nmap <C-g> [global]
nnoremap [global]g :<C-u>Gtags<CR>
nnoremap [global]l :<C-u>Gtags -f %<CR>
nnoremap [global]] :<C-u>GtagsCursor<CR>
nnoremap [global]n :<C-u>cn<CR>
nnoremap [global]p :<C-u>cp<CR>
" }}}
" {{{ 言語別 - Python
"--------------------------------------------------------------------------------
let g:syntastic_python_checkers = ['flake8']
autocmd FileType python autocmd BufWritePost <buffer> Errors
" }}}
" {{{ 言語別 - Ruby, YAML
"--------------------------------------------------------------------------------
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_ruby_rubocop_args = "--except LineLength"
autocmd BufNewFile,BufRead *.{rb,rake,yaml,yml} set ts=2 sw=2 sts=0
" }}}
" {{{ 言語別 - Markdown
"--------------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.{md,mkd,markdown} call SetMarkdownOptions()
function! SetMarkdownOptions()
    setfiletype markdown
    syntax match MdTaskOpen /-*\s\[\s*\]\s.\+/ display containedin=ALL
    syntax match MdTaskWip  /-*\s\[WIP\]\s.\+/ display containedin=ALL
    syntax match MdTaskDone /-*\s\[DONE\]\s.\+/ display containedin=ALL
    highlight MdTaskOpen ctermfg=darkgreen
    highlight MdTaskWip ctermfg=magenta
    " highlight MdTaskDone ctermfg=blue
endfunction
let g:vim_markdown_folding_style_pythonic = 1
" }}}
" {{{ 言語別 - HTML
"--------------------------------------------------------------------------------
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
" }}}
