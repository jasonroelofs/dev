" Run the current file with F5
:noremap <F5> :only<CR>:w<CR>:!go run '%' 2>&1 \| tee ~/tmp/.go-lang.out<CR>:sp ~/tmp/.go-lang.out<CR><CR>
