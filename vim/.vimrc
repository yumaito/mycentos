let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
    set nocompatible
endif

if !isdirectory(s:dein_repo_dir)
    execute '!git clone git@github.com:Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let g:rc_dir    = expand('~/.vim/rc')
    let s:toml      = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

" neocomplete.vimの設定 -----------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define directory
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }
" Define keyword
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Recommended key-mappings
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
        " For no inserting <CR> key.
    return pumvisible() ? "\<C-y>" : "\<CR>"
        endfunction
    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-r>" : "<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#start_close_popup(). "\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup(). "\<C-h>"
    " Close popup by <Space>
    " inoremap <expr><Space> pumvisibe() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior
" let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended)
" set completeopt+=longest
" let g:neocomplete#enablee_auto_select = 1
" let g:neocomplate#disable_auto_complete = 1
" inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion
if !exists('g:neocomplete#source#omni#input_patterns')
    let g:neocomplete#source#omni#input_patterns = {}
    endif
    " let g:neocomplete#source#omni#input_patterns.php = '[^.
    " \t]->\h\w*|\h\w*::'
    " let g:neocomplete#source#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\. \|->\)'
    " let g:neocomplete#source#input_patterns.cpp = '[^.[:digit:] *\t]\%(\. \|->\)|\h\w*::'

" For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#source#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    " let g:neocomplete#sources#omni#input_patterns.go = '\h\w\.\w*'

" vim-easymotion の設定
" デフォルトのキーマッピング無効
let g:EasyMotion_do_mapping = 0
" f + 2文字で画面全体を検索してジャンプ
nmap f <plug>(easymotion-overwin-f2)
" 検索時、大文字小文字を区別しない
let g:EasyMotion_smartcase = 1

" lightline.vim の設定 ----------------------------------------------
let g:lightline = {
    \ 'colorscheme': 'powerline',
    \ 'mode_map': {'c': 'NORMAL'},
    \ 'active' : {
    \    'left' : [ ['mode', 'paste'],
    \               ['fugitive', 'readonly', 'filename', 'modified'],
    \               ['ctrlpmark'] ],
    \    'right': [ [ 'syntastic', 'lineinfo' ], ['percent'],
    \               ['fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'component_function': {
    \    'readonly': 'LightlineReadonly',
    \    'modified': 'LightlineModified',
    \    'fugitive': 'LightlineFugitive',
    \    'filename': 'LightlineFilename',
    \    'fileformt': 'LightlineFileformat',
    \    'filetype': 'LightlineFiletype',
    \    'fileencoding': 'LightlineFileencoding',
    \    'mode': 'LightlineMode',
    \    'ctrlpmark': 'CtrlPMark',
    \ },
    \ 'separator': {'left': "⮀", 'right': "⮂"},
    \ 'subseparator': {'left': "⮁", 'right': "⮃"},
    \ 'tabline': {
    \       'right': [ [ 'rows'], ['cd'], ['tabopts'], ['fugitive']]
    \ },
    \ 'tab': {'active': ['prefix', 'filename']},
    \ }
let g:lightline.tab.inactive = g:lightline.tab.active

function! LightlineReadonly()
    if &readonly
        return "⭤"
    else
        return ""
endfunction

function! LightlineModified()
    if &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
endfunction

function! LightlineFugitive()
    return exists('*fugitive#head') ? '⭠ '. fugitive#head() : ''
endfunction

function! LightlineFilename()
let fname = expand('%')
return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
    \ fname =~ 'NERD_tree' ? '' :
    \ &fp == 'unite' ? unite#get_status_string() :
    \ ('' != fname ? fname : '[No Name]')
endfunction

function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
    let fname = expand('%:t')
    return fname == 'ControlP' ? 'CtrlP' :
        \ fname =~ 'NERD_tree' ? 'NERD_tree' :
        \ &ft == 'unite' ? 'Unite' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
    if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
        call lightline#link('iR'[g:lightline.ctrlp_regex])
        return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
        \ , g:lightline.ctrlp_next], 0)
    else
        return ''
    endif
endfunction

let g:ctrlp_status_func = {
    \ 'main': 'CtrlPStatusFunc_1',
    \ 'prog': 'CtrlPStatusFunc_2',
    \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev  = a:prev
    let g:lightline.ctrlp_item  = a:item
    let g:lightline.ctrlp_next  = a:next
    return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
endfunction

" NERDTree の設定 ----------------------------------------------------------------------------------------
" ディレクトリ表示の設定
    let g:NERDTreeDirArrows = 1
    let g:NERDTreeDirArrowExpandable = '▶'
    let g:NERDTreeDirArrowCollapsible = '▼'
    let g:NERDTreeShowHidden = 1
" ctrl-nでNERDTreeを起動
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" CtrlP の設定---------------------------------------------------------------------------------------------
" キャッシュディレクトリ
" F5 でキャッシュ更新
" let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" キャッシュを終了時に削除しない
" let g:ctrlp_clear_cache_on_exit = 0
if executable('ag')
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command='ag --hidden %s -i --nocolor --nogroup -g ""'
endif
" 遅延再描画
let g:ctrlp_lazy_update = 1
" 無視するディレクトリ/ファイル
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]\.?(extlib|git|hg|svn)',
    \}
" Unite の設定
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--hidden --nocolor --nogroup'
let g:unite_source_grep_max_candidates = 200
let g:unite_source_grep_recursive_opt = ''
" unite-grepのキーマッピング
vnoremap /g y:Unite grep::-iRn:<C-R>=escape(@",'\\.*$^[]')<CR><CR>

" 基本設定 ------------------------------------------------------------------------------------------------

set background=dark
colorscheme hybrid
syntax on
set t_Co=256
" カラースキームの調整
    hi Normal ctermbg=none
    hi default link fortranTab none

set number                " 行番号表示
set ruler                 " 現在の行とカラム位置表示
set cursorline            " カーソルラインの表示
set laststatus=2          "ステータス行を常に表示
set showcmd               " 入力中のコマンドを表示
set cmdheight=2           " コマンドラインを2行表示
set showmatch             " 対応する括弧を強調表示
set noshowmode            " vim モード非表示
set matchtime=1           " 括弧にカーソルが飛ぶ時間の設定
set list                  " 不可視文字を表示する
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:% " タブを>---- 半角スペースを.で表示
let fortran_free_source=1 " 固定形式を自由形式に変える
let fortran_fold=1

" カーソル移動
set backspace=start,indent,eol " Backspaceキーの影響範囲に制限なし
set scrolloff=8                " 上下スクロール時の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは1文字ずつ行う

" 文字入力
set autoindent                              " インデント
set shiftwidth=4                            " 自動インデントの幅
set tabstop=4                               " タブ幅
set expandtab                               " タブを空白で置換
autocmd FileType * setlocal formatoptions=q " 自動改行しない
set pastetoggle=<F2>                        " F2でペーストモードへ切り替え
set viminfo='20,\"1000                      " ヤンクを1000行まで保存する
set clipboard=unnamed,autoselect

au BufNewFile,BufRead *.go set noexpandtab tabstop=4 shiftwidth=4
" インデントの可視化
highlight WhitespaceEOL cterm=underline ctermfg=62 guibg=#F00F00
au BufWinEnter * let w:m1 = matchadd("WhitespaceEOL", '    ')
au WinEnter * let w:m1 = matchadd("WhitespaceEOL", '    ')
" indentLine
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#F00F00'
let g:indentLine_char = '¦' "use ¦, ┆ or │

" CSVのハイライト
function! CSVH(x)
    execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
    execute 'normal ^'.a:x.'f,'
endfunction
command! -nargs=1 Csv :call CSVH(<args>)

command! CS :call CSVH(strlen(substitute(getline('.')[0:col('.')-1], "[^,]", "", "g")))

command! Csvn execute 'match none'

" vim-goの設定
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

set rtp+=$GOROOT/misc/vim
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
" ファイル処理
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことができる
set autoread   " 外部でファイルに変更がされた場合は読み直す
set nobackup   " ファイル保存時にバックアップを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない
set hidden     " buffer機能on

" フォント系
scriptencoding utf-8
set encoding=utf-8
set guifont=Ricty\ for\ Powerline
let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown']
autocmd BufEnter * EnableStripWhitespaceOnSave
let g:better_whitespace_verbosity=1

" 検索/置換
set hlsearch   " 検索文字列をハイライトする
set incsearch  " インクリメンタルサーチ
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan   " 最後尾まで検索を終えたら次の検索で先頭に移る

" マウスの有効化
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" キーマッピング
    " ESC + ESC でハイライトを消す
    nnoremap <silent><ESC><ESC> :nohlsearch<CR>
    " g + h でカーソルの位置の文字を置換
    nnoremap gh *<CR>
    " Y で行末までヤンクする
    nnoremap Y y$
    " + と - 数字のインクリメント、デクリメントを行う
    nnoremap + <C-a>
    nnoremap - <C-x>
    " gis で git statusの呼び出し
    "  -  : add,  reset
    "  cc : git commit
    nnoremap <silent>gis :Gstatus<CR>
    " gid で git diff
    nnoremap <silent>gid :Gvdiff<CR>
    " gic で git checkout HEAD
    nnoremap <silent>gic :Gread<CR>
    " ctrl + jで半画面進む
    nnoremap <C-j> <C-d>
    nnoremap <C-k> <C-u>
    " Uでredo
    nnoremap U <C-r>
    " window関係
    nnoremap s <Nop>
    nnoremap sj <C-w>j " 下ウインドウへ
    nnoremap sk <C-w>k " 上ウインドウへ
    nnoremap sl <C-w>l " 右ウインドウへ
    nnoremap sh <C-w>h " 左ウインドウへ
    nnoremap sJ <C-w>J " 現在のウインドウを下へ
    nnoremap sK <C-w>K " 現在のウインドウを上へ
    nnoremap sL <C-w>L " 現在のウインドウを右へ
    nnoremap sH <C-w>H " 現在のウインドウを左へ
    nnoremap <silent>bp :bprevious<CR> " 前のバッファ
    nnoremap <silent>bn :bnext<CR> " 次のバッファ
    nnoremap <silent>bb :b#<CR> " 直前開いたバッファ
    nnoremap <silent>bf :bf<CR> " 最初のバッファ
    nnoremap <silent>bl :bl<CR> " 最後のバッファ
    nnoremap <silent>bm :bm<CR>
    nnoremap <silent>bd :bdelete<CR>
    nnoremap <C-r> :bufdo e<CR>
    nnoremap ss :<C-u>sp<CR>
    nnoremap sv :<C-u>vs<CR>
    nnoremap ]q :cprevious<CR>   " 前のvimgrep
    nnoremap [q :cnext<CR>       " 次のvimgrep
    nnoremap [Q :<C-u>cfirst<CR> " 最初のvimgrep
    nnoremap ]Q :<C-u>clast<CR>  " 最後のvimgrep

    command -nargs=1 Grep vimgrep <args> `git ls-files` | cw

    filetype on
    filetype plugin on
    filetype indent on

