" Plugins (via vim-plug).
call plug#begin()
Plug 'vim-scripts/CSApprox'
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'ervandew/supertab'
" Plug 'Raimondi/delimitMate'
" Plug 'scrooloose/syntastic'
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'qpkorr/vim-bufkill'
call plug#end()

" Airline configuration.
set laststatus=2								" Make statusline always visible.
let g:airline_powerline_fonts = 1				" enable pretty arrows only works for patched fonts.
let g:airline#extensions#tabline#enabled = 1	" Enable the buffer head line.
let g:airline_theme='zenburn'					" Make the default airline theme 'zenburn'.

" NERDTree and NERDTreeTabs configuration.
" let g:nerdtree_tabs_open_on_console_startup=1	" Have the tree open on startup.
" let g:nerdtree_tabs_autofind=1					" Have the tree highlight the active file.
" let NERDTreeMouseMode = 2						" A single click to open dir and a double click to open files.
" let NERDTreeWinSize = 27						" The default window width is 27.
" let NERDTreeIgnore = ['\.pyc$']					" Have NERDTree ignore *.pyc files.
" Toggle the tree focus with \+t and toggle the tree presence with F2.
" 	map <leader>t :NERDTreeFocusToggle<CR>
" 	map <F2> :NERDTreeTabsToggle<CR>

" CtrlP configuration.
" let g:ctrlp_working_path_mode = 'w'					" Have CtrlP operate from the CWD.
" let g:ctrlp_custom_ignore = { '*.pyc' : '/.pyc$' }	" Have CtrlP ignore *.py files.
" Open the buffer list with Ctrl+i.
" 	map <C-i> :CtrlPBuffer<CR>

" BufKill configuration.
" Close the curent buffer without closing the window with Ctrl+c.
" 	map <C-c> :BD<CR>

" Base vim configuration.
set nu								" Make line numbers visible.
filetype indent plugin on			" Enable the use of the indent plugin.
set tabstop=4						" Have vim display tabs as 4 spaces.
colorscheme seoul256				" Set the default color theme to 'seoul256'.
set listchars=tab:▸\ ,eol:¬,trail:⋅	" Set the whitespace characters.
set list							" Enable the sh w whitespace feature by default.
set mouse=a							" Enable the use of the mouse.
" Scroll the viewport 3 times faster.
	nnoremap <C-e> 3<C-e>
	nnoremap <C-y> 3<C-y>

" Indentation configuration.
autocmd FileType python setlocal expandtab softtabstop=4 shiftwidth=4
