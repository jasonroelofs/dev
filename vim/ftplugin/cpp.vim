:setlocal ai
:setlocal cindent

:iabbr _ae ensure_equals("xxx", actual, expected);
:iabbr _at ensure("xxx", cond);
:iabbr _af fail("xxx");

" Set tags
:set tags=$PROJ_HOME/tags
" Regenerate tags
:cabbr ptags !ctags -f $PROJ_HOME/tags `find $PROJ_HOME -name "*.php"`

:iabbr _ps "<< <<"<Left><Left><Left><Left>

:iabbr fori for (int i=0; i < _something_; i++) {}<Left><Up>	

:iabbr _bm _bogifyMethod<ESC>:.!~/.vim/tools/cpp/cpp_bogify_method.pl<CR>,i
:iabbr _test _test<ESC>:.!~/.vim/tools/cpp/cpp_test_expand.pl<CR>,i
:iabbr _ntc _newTestClass<ESC>:.!~/.vim/tools/cpp/cpp_new_test_class.pl<CR>,i
:iabbr _get _getSet<ESC>:.!~/.vim/tools/cpp/cpp_get_expand.pl<CR>,i
:iabbr _try _tryCatch<ESC>:.!~/.vim/tools/cpp/cpp_try_catch.pl<CR>,i
:iabbr _nm _newMethod<ESC>:.!~/.vim/tools/cpp/cpp_new_method.pl<CR>,i
:iabbr _gpl _insertGPL<ESC>:.!~/.vim/tools/cpp/cpp_gpl.pl<CR>,i
