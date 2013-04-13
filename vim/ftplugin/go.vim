" Run the current file with F5
:noremap <F5> :only<CR>:w<CR>:!go run '%' 2>&1 \| tee ~/tmp/.go-lang.out<CR>:sp ~/tmp/.go-lang.out<CR><CR>

" Go back to using real tabs, it's the Go Way
set noexpandtab

" Alias for :Fmt, the inline gofmt call
:noremap <leader>f :Fmt<CR>
