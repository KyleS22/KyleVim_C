" Auto comment headers
" Insert an auto populated docstring at lineNum
function! InsertCHeader(lineNum)
    python3 sys.argv = [vim.eval('a:lineNum')]
    python3 auto_func.insert_header_comment(sys.argv[0])

endfunction

command! -nargs=1 InsertCHeader call InsertCHeader(<f-args>)


