noremap \gs :!ruby ~/.vim/tools/ruby/gen_server_template.rb<CR>
noremap \sup :!ruby ~/.vim/tools/ruby/supervisor_template.rb<CR>
noremap \app :!ruby ~/.vim/tools/ruby/application_template.rb<CR>

" Comment-in and -out lines of erlang code
:noremap z :s/^/%<CR><Down>
:noremap Z :s/^\s*\(%\)//<CR><Down>
