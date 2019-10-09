if exists("*OpenHeaderFile")
	finish
endif

" Open new file in vertical split by default
if !exists("g:KyleVimC_HeaderExe")
	let g:KyleVimC_HeaderExe = "vsplit"
endif

" Open the header or c file that has the same name as the current file
" Assumes that both files exist as children of the current directory
function! OpenHeaderFile()
	" See if this file is a .c or .h file and replace the extension
	if match(expand("%"), '\.c') > 0 || match(expand("%"), "\.cpp") > 0
    		let l:file_to_open = substitute(".*\\\/" . expand("%:t"), '\.c\(.*\)', '.h[a-z]*', "")
  	elseif match(expand("%"), "\\.h") > 0
    		let l:file_to_open = substitute(".*\\\/" . expand("%:t"), '\.h\(.*\)', '.c[a-z]*', "")
	endif
	
	" Get the directory
	let l:dir = fnamemodify(expand("%:p"), ":h")
    	
	" Find the file that needs to be opened	
	let l:cmd="find " . l:dir . " . -type f -iregex \""  . l:file_to_open . "\" -print -quit"
    	let l:result = substitute(system(l:cmd), '\n', '', '')

    	if filereadable(l:result)
      		exe g:KyleVimC_HeaderExe l:result
    	endif

endfunction
