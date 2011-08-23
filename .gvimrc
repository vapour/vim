" janlay's personal config for gVim

if v:version < 700
    echoerr 'This vimrc requires Vim 7 or later.'
    quit
endif

" IME settings
" set noimdisable
" set imsearch=0
" set imactivatekey=C-space
" inoremap <ESC> <ESC>:set iminsert=0<CR>

" gui
set guifont=Consolas:h11,Monaco,mono,Courier
if has("win32")
	" maximum the initial window
	au GUIEnter * simalt ~x
	" source $VIMRUNTIME/mswin.vim
	set guioptions-=a
	set mousemodel=popup
	set guifontwide=YaHei_Consolas_Hybrid:h10:cGB2312
elseif has("mac") || has("gui_macvim") || has("macunix")
	" au GUIEnter * winpos 0 0
	" set lines=60
	" set columns=150
	set transparency=6
	set guifont=Monaco:h13
	set imactivatekey=D-space
elseif has("unix")
	au GUIEnter * winpos 0 0
	set lines=40
	set columns=125
endif

set guioptions-=T
set guioptions-=a

" Taglist feature
let g:Tlist_Show_Menu = 1

runtime after/plugin/snipMate.vim

" vim: set ts=4:
