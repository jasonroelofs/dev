:noremap z :s/^/\/\/<CR>
:noremap Z :s/^\s*\(\/\/\)//<CR>

:iabbr test /** * See that */function test(){fail("implement me");}

:iabbr _a assertTrue(
:iabbr _af assertFalse(
:iabbr _an assertNull(
:iabbr _ann assertNotNull(
:iabbr _au assertUndefined(
:iabbr _anu assertNotUndefined(
:iabbr _ae assertEquals(
:iabbr _ane assertNotEqual(
:iabbr _im fail("implement me");
