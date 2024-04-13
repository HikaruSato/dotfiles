

" 挿入モードでバックスペースで削除できるようにする
set backspace=indent,eol,start

" wildmenuオプションを有効(vimバーからファイルを選択できる)
set wildmenu

"----------------------------------------
" 検索
"----------------------------------------
" 検索するときに大文字小文字を区別しない
set ignorecase
" 検索結果をハイライト表示
set hlsearch


" タイトルを表示
set title
" シンタックスハイライト
syntax on
" 行番号の表示
set number

" マウス利用モード有効
set mouse=a

" clipboard 連携(unnamedplus)
"set clipboard=unnamedplus

" vimの yank 壊れたのがこれで治った
set clipboard^=unnamed,unnamedplus
