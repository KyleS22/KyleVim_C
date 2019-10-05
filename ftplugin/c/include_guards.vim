" Auto insert include guards
function! InsertIncludeGuard()
	let lines = getbufline(bufnr("%"), 1, "$")
	let i = 0
	
	let include_name = toupper(expand("%:r")) . "_INCLUDE"
	

	for line in lines
		if line =~ "//"
			let i = i + 1
		else
			call append(i, "#ifndef " . include_name)
			call append(i + 1, "#define " . include_name)	
			break
		endif
	endfor	
	call append("$", "#endif // " . include_name)
endfunction

"
