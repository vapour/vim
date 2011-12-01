" janlay's personal config for Vim
" aaa

if v:version < 700
    echoerr 'This vimrc requires Vim 7 or later.'
    quit
endif

" find a file in RUNTIMEPATH
function! GetFilePath(file)
	let files = globpath(&rtp, a:file)
	if !strlen(files)
		throw 'File not found:'. a:file
	endif
	return split(files, '\n')[0]
endfunction

" diff
if has("diff")
	function! MyDiff()
		let opt = '-a --binary '
		if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		let arg1 = v:fname_in
		if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		let arg2 = v:fname_new
		if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		let arg3 = v:fname_out
		if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		let eq = ''
		if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
				let cmd = '""' . $VIMRUNTIME . '\diff"'
				let eq = '"'
			else
				let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		else
			let cmd = $VIMRUNTIME . '\diff'
		endif
		silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
	set diffexpr=MyDiff()
endif

" global
set encoding=utf-8
" set termencoding=&encoding
set nocompatible
set history=128
set autoread
set helplang=cn,en
set t_Co=256

" if has("netbeans_intg") || has("sun_workshop")
	set autochdir
" endif
let mapleader = ","

" lines
set wrap
set number
set cursorline

" search
set hlsearch
set incsearch
set ignorecase

" indent & tab
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set switchbuf=useopen

" syntax & folding
if has("syntax")
	syntax enable
	colorscheme slate2
	let html_number_lines = 0
endif
if has("folding")
	set foldenable
	set foldmethod=syntax
	set foldcolumn=1
	set foldminlines=5
	set foldlevel=2
	set foldnestmax=3
endif
filetype plugin on

function! ToggleColor()
	let colors = ['slate2', 'ir_black', 'simplewhite']
	let current = (index(colors, g:colors_name) + 1) % len(colors)
	execute 'colorscheme ' . colors[current]
endfunction

function! ToggleWrapping()
	if &wrap == 1
		set nowrap
	else
		set wrap
	endif
endfunction

function! ToggleMRU()
	if bufname('%') ==# '__MRU_Files__'
		exec 'close'
	else
		exec 'MRU'
	endif
endfunction

" keys & mouse
set backspace=indent,eol,start
set mouse=a
map <Space> :e#<CR>
map Q :exit<CR>
map <Tab> <C-w><C-w>
" map <C-t> :tabnew<CR>
map <C-S-Tab> :tabprevious<CR> 
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <C-Tab> :tabnext<CR> 
map <C-F4> :tabclose<CR>
map <F4> :split<CR>
map <S-F4> :vsplit<CR>
map <F6> :call ToggleMRU()<CR>
map <C-F6> :BufExplorer<CR>
map <F7> :TlistToggle<CR>
map <F8> :ToggleNERDTree<CR>
map <C-F8> :NERDTreeFind<CR>
map <F9> :!svn update<CR>
map <C-F9> :!svn 
map <F10> :!svn commit --message=''<LEFT>
map <C-F10> :new<cr>:read !svn diff<cr>:set syntax=diff buftype=nofile<cr>:silent! %s/<C-V><C-M>//g<cr>ggdd
map <F11> :call ToggleWrapping()<CR>
map <F12> :CommandT<CR>
map <A-F12> :call ToggleColor()<CR>
" ROT13
map <C-A-S-F12> ggVGg?
map ,f :write<CR>:!start %:p<CR>
map ,i :write<CR>:!start <cWORD><CR>
map <C-S-o> :edit!<CR>

" use Alt-n to switch tab
for i in range(1, min([&tabpagemax, 9]))
    execute 'nmap <A-'.i.'> '.i.'gt'
endfor

" html
left g:html_use_css = 1
let g:use_xhtml = 1

" auto complete
set complete=.,k,t,i
set completeopt=longest,menu
" local vimrc
let g:local_vimrc = "local.vimrc"
" snipMate's Trigger Completion
let g:acp_behaviorSnipmateLength = 1
" preview in acp
let g:acp_completeoptPreview = 0
" Taglist feature
let g:Tlist_Show_One_File = 1
let g:Tlist_Sort_Type = "name"
" NERDTree feature
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeChDirMode = 2

" interface
set ruler
set rulerformat=%15(%c%V\ %p%%%)
set showcmd
set showmode

if has("statusline")
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

	set laststatus=2
set statusline=%n\ %F%m%r%h%y[%{&fileformat},\ %{&fileencoding}%{((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\")}]\ %w%{SyntaxItem()}%=(%b,0x%B)\ (%l,%c)\ %P\ %{&wrap?'WR':'NW'}\ %{&ic?'IC':'CS'}\ 
endif

if has("mksession")
	set sessionoptions=buffers,curdir,tabpages
endif

if has("signs")
	""" showmarks setting
	" Enable ShowMarks
	let showmarks_enable = 1
	" Show which marks
	let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	" Ignore help, quickfix, non-modifiable buffers
	let showmarks_ignore_type = "hqm"
	" Hilight lower & upper marks
	let showmarks_hlline_lower = 1
	let showmarks_hlline_upper = 1 
endif

" prepare directory
let s:files_dir=$HOME . "/.vimfiles/"
if !isdirectory(s:files_dir)
	call mkdir(s:files_dir)
endif

" set file path
set viminfo+=n$HOME/.vimfiles/viminfo
let $FAVOURITES=$HOME . "/.vimfiles/vimfavourites"
let g:NERDTreeBookmarksFile=$HOME . "/.vimfiles/NERDTreeBookmarks"
let g:MRU_File=$HOME . "/.vimfiles/mru_files"
let g:netrw_home=$HOME . "/.vimfiles"

if has("persistent_undo")
	let s:files_dir=$HOME . "/.vimfiles/undo"
	if !isdirectory(s:files_dir)
		call mkdir(s:files_dir)
	endif
	set undofile
	set undodir=$HOME/.vimfiles/undo
endif

" taglist & ctags
let Tlist_Use_Right_Window = 1
let tlist_xml_settings = 'xml;i:id'
let tlist_xhtml_settings = tlist_xml_settings
let tlist_html_settings = tlist_xml_settings
let tlist_htmldjango_settings = tlist_xml_settings
let tlist_markdown_settings = 'markdown;h:Headings'
let tlist_css_settings = 'css;s:Selectors'
let g:tlist_javascript_settings = 'javascript;s:string;a:array;o:object;f:function'

" autocmd
if has("autocmd")
	" helper function
	function! SetDict()
		execute 'setlocal dict+='. GetFilePath('dict/'. &filetype . '.dict')
	endfunction

	" TextBrowser settings
	let tlist_txt_settings = 'txt;c:content;f:figures;t:tables'
	autocmd BufRead,BufNewFile *.txt setlocal filetype=txt
	autocmd BufRead,BufNewFile *.log setlocal filetype=apachelogs

	" template
	autocmd BufNewFile *.html,*.htm execute '0r '. GetFilePath('template/default.html')
	autocmd BufNewFile,BufRead *.vm set fileencoding=gbk

	" refresh config immediately
	autocmd! bufwritepost .vimrc source %

	" set options for specified filetype
	autocmd FileType text setlocal textwidth=80
	autocmd FileType c,cpp map <buffer> <leader><space> :write<cr>:make<cr> | setlocal foldmethod=syntax | setlocal foldenable
    autocmd FileType javascript,css,php call SetDict()

	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html,htm set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType c set omnifunc=ccomplete#Complete

	autocmd FileType velocity set filetype=velocity.html
	

	if exists("+omnifunc")
		autocmd Filetype *
		    \	if &omnifunc == "" |
		    \		setlocal omnifunc=syntaxcomplete#Complete |
		    \	endif
    endif
	" map keys for quickfix
	nmap <leader>cn :cnext<cr>
	nmap <leader>cp :cprevious<cr>
	nmap <leader>cw :cwindow 10<cr> 
	nmap <leader>d yyp
	nmap <leader>p :let @" = expand("%:p")<cr>
	nmap <leader>ht :TOhtml<cr>
endif

" multi byte
if has("multi_byte")
	language messages en_US.utf-8

	setglobal fileencoding=utf-8
	set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5
	set formatoptions+=mm

	if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
		set ambiwidth=double
	endif
endif


if has("unix") 
	cmap w!! %!sudo tee > /dev/null %
endif

behave xterm
if !has("mac")
	" ==========Ctrl+C/V/X from mswin.vim
	" backspace in Visual mode deletes selectiobackspacen
	vnoremap <BS> d

	" CTRL-X and SHIFT-Del are Cut
	vnoremap <C-X> "+x
	vnoremap <S-Del> "+x

	" CTRL-C and CTRL-Insert are Copy
	vnoremap <C-C> "+y
	vnoremap <C-Insert> "+y

	" CTRL-V and SHIFT-Insert are Paste
	map <C-V>		"+gP
	map <S-Insert>		"+gP
	cmap <C-V>		<C-R>+
	cmap <S-Insert>		<C-R>+

	" Use CTRL-S for saving, also in Insert mode
	noremap <C-S>		:update<CR>
	vnoremap <C-S>		<C-C>:update<CR>
	inoremap <C-S>		<C-O>:update<CR>

	" CTRL-A is Select all
	noremap <C-A> gggH<C-O>G

	" Pasting blockwise and linewise selections is not possible in Insert and
	" Visual mode without the +virtualedit feature.  They are pasted as if they
	" were characterwise instead.
	" Uses the paste.vim autoload script.

	exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
	exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
endif

" vim: set ts=4:
