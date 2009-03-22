"hookup all the tabbing and indentation
setlocal et
setlocal ts=4
setlocal sw=4
setlocal ai
runtime! indent.vim

"the dreaded output
:iabbr _do DBMS_OUTPUT.PUT_LINE();

"new procedure
:iabbr _p _newProcedure<ESC>:.!ruby 'C:\Program Files\Vim\vimfiles\tools\plsql\plsql_new_procedure.rb'<CR>
"
"new function
:iabbr _f _newFunction<ESC>:.!ruby 'C:\Program Files\Vim\vimfiles\tools\plsql\plsql_new_function.rb'<CR>

"new package
:iabbr _pb _newPackageBody<ESC>:.!ruby 'C:\Program Files\Vim\vimfiles\tools\plsql\plsql_new_package_body.rb'<CR>

"sqlplus hooks for compiling packages
if has("unix")
	"FIXME"noremap <F8> :only<CR>:w<CR>:!cp '%' ~/tmp/.plsql.tmp<CR>:!ruby  '%' > ~/tmp/.plsql.out 2>&1<CR>:sp ~/tmp/.plsql.out<CR>G
else
	noremap <F5> :only<CR>:w<CR>:!copy "%" "<C-R>=expand($HOME)<CR>/tmp/.plsql.tmp"<CR>:!ruby 'C:\Program Files\Vim\vimfiles\tools\plsql\compile_plsql.rb' "<C-R>=expand($HOME)<CR>/tmp/.plsql.tmp"<CR>:!sqlplus -S <C-R>=b:db_login<CR> "@<C-R>=expand($HOME)<CR>/tmp/.plsql.tmp" > "<C-R>=expand($HOME)<CR>/tmp/.plsql.out"<CR>:sp ~/tmp/.plsql.out<CR><CR>G
endif
	"noremap <F8> :only<CR>:w<CR>:!copy "%" "<C-R>=expand($HOME)<CR>/tmp/.plsql.tmp"<CR>:!ruby 'C:\Program Files\Vim\vimfiles\tools\plsql\compile_plsql.rb' "<C-R>=expand($HOME)<CR>/tmp/.plsql.tmp"<CR>:!sqlplus -S eg_owner/egow15scrt@WHSEDEV "@<C-R>=expand($HOME)<CR>/tmp/.plsql.tmp" > "<C-R>=expand($HOME)<CR>/tmp/.plsql.out"<CR>:sp ~/tmp/.plsql.out<CR><CR>G
