" Make sure this plugin is runnable

let g:kyle_vim_C_version = "0.1.0"

if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif


filetype plugin on

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')


" Automatic File Headers
autocmd bufnewfile *.c *.cpp *.h execute "so " . s:plugin_root_dir . "/c_header.txt"
autocmd bufnewfile *.c *.cpp *.h exe "1," . 10 . "g/File Name:.*/s//File Name: " .expand("%")
autocmd bufnewfile *.c *.cpp *.h exe "1," . 10 . "g/Date:.*/s//Date: " .strftime("%d-%m-%Y")

