:setlocal ai
:setlocal cindent

:iabbr utest /**<BS> * See that*/function test_some_thing(){$this->fail("<b style='color: red;'>implement me</b>");}<ESC>5<Up>A

:iabbr _ae $this->assertEquals($expect, $got, "xxx");<esc>21<Left>
:iabbr _ar $this->assertRegexp("/^$/", $str, "xxx");<esc>18<Left>
:iabbr _at $this->assertTrue($bool, "xxx");<esc>13<Left>
:iabbr _af $this->assertTrue(!$bool, "xxx");<esc>13<Left>
:iabbr _aem $this->assertEqualsMultilineStrings($expect, $got, "xxx");<esc>21<Left>
:iabbr _fail throw new PHPUnit2_Framework_IncompleteTestError("Implement Me");<esc>15<LEFT>

:iabbr _atype $this->assertEquals("array", gettype($list), "wrong type");<esc>38<Left>
:iabbr _aempty $this->assertEquals(0, count($list), "list not empty");<esc>25<Left>
" Set tags
:set tags=$PROJ_HOME/tags
" Regenerate tags
:cabbr ptags !ctags -f $PROJ_HOME/tags `find $PROJ_HOME -name "*.php"`

:iabbr _ps ". ."<Left><Left><Left>

:iabbr fori for ($i=0; $i < _something_; $i++) {}<Left><Up>	


:iabbr loaddebug require_once "debug.php";debugOn();

:iabbr _bm _bogifyMethod<ESC>:.!~/.vim/tools/php/php_bogify_method.pl<CR>,i
:iabbr _bc _bogifyClass<ESC>:.!~/.vim/tools/php/php_bogify_class.pl<CR>,i
:iabbr _test _test<ESC>:.!~/.vim/tools/php/php_test_expand.pl<CR>
:iabbr _ntc _newTestClass<ESC>:.!~/.vim/tools/php/php_new_test_class.pl<CR>
:iabbr _get _getSet<ESC>:.!~/.vim/tools/php/php_get_expand.pl<CR>
:iabbr _try _tryCatch<ESC>:.!~/.vim/tools/php/php_try_catch.pl<CR>
:iabbr _nm _newMethod<ESC>:.!~/.vim/tools/php/php_new_method.pl<CR>
:iabbr _pa _printArray<ESC>:.!~/.vim/tools/php/php_print_array.pl<CR>


" Easy open php tags
iabbr _php <?php ?><LEFT><LEFT><LEFT>
iabbr _pv <?= ?><LEFT><LEFT><LEFT>
