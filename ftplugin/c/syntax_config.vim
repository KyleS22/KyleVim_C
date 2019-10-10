function! AddSyntaxConfig(command)
    python3 import sys
    python3 sys.argv = [vim.eval("expand('%')"), vim.eval('a:command')]
    python3 import syntax_config
    python3 syntax_config.set_command_for_file(sys.argv[0], sys.argv[1])
endfunction

function! GetSyntaxConfig(filename)
    python3 import sys
    python3 sys.argv = [vim.eval('a:filename')]
    python3 import syntax_config
    python3 syntax_config.get_command_for_file(sys.argv[0])
endfunction
