" Vim filetype plugin file for adding try-catch-finally 
" Language:	Java
" Maintainer:	Roman Wagner romanw@cs.tu-berlin.de
" Last Change:	Tue Sep 28 11:09:14 CEST 2004
"
" TODO:
" refactoring!!! 
" new features (more than 1 catch-block)
" look for updates


if exists("b:did_InsertTry_ftplugin")
  finish
endif
let b:did_InsertTry_ftplugin = 1
let b:java_InsertTry_Style = "Java"                 " Java | JavaShort | C
let b:java_InsertTry_Goto  = "catch"                " . | catch

fun! s:InsertTry() range
    " get lines and indent
    let s:first      = a:firstline
    let s:last       = a:lastline
    let s:indent     = matchstr(getline(s:first), "^\\s*")
    let s:shift      = matchstr("                ", "^\\s\\{" . &sw . "}")
    " let xpos   = line(".") . "normal!" . virtcol(".") . "|"
    let xpos   = virtcol(".")
    let ypos   = line(".")
    
    call BuildFormattedCode()
    call IndentBlock()
    call InsertCode()
    if b:java_InsertTry_Goto == "catch"
        call GotoCatch()
    else
        execute (ypos + s:offset1) . "normal!" . (xpos + &sw) . "|"
    endif
endf

fun! BuildFormattedCode()
    let s:tryString     = "try" 
    let s:catchString   = "}"
    let s:finallyString = "}"
    let s:offset1       = 1
    let s:offset2       = 2
    
    if b:java_InsertTry_Style == "C" 
        let s:tryString     = s:tryString . "\n" .
                            \ "{"
        let s:catchString   = s:catchString . "\n" .
                            \ "catch ( )\n".
                            \ "{"
        let s:finallyString = s:finallyString . "\n" .
                            \ "finally\n".
                            \ "{\n" .
                            \ "}"
        let s:offset1       = 2
        let s:offset2       = 3
    else
        let s:tryString = s:tryString . " {"
        if b:java_InsertTry_Style == "JavaShort"
            let s:catchString   = s:catchString . " catch ( ) {"
            let s:finallyString = s:finallyString . " finally {\n" .
                                \ "}"
            let s:offset1       = 1
            let s:offset2       = 1
        else
            let s:catchString   = s:catchString . "\n" .
                                \ "catch ( ){" 
            let s:finallyString = s:finallyString . "\n" . 
                                \ "finally {\n" .
                                \ "}"
        endif
    endif
endf


fun! IndentBlock()
    let i = s:first
    while i < s:last + 1
        call setline(i, s:shift . getline(i))
        let i = i + 1
    endwhile
endf

fun! InsertCode() 
    call MyAppend(s:last, s:finallyString )
    call MyAppend(s:last, s:catchString )
    call MyAppend(s:first - 1, s:tryString )

endfunction

fun! MyAppend(actline,text)
    let string = a:text
    let pos = a:actline

    while 1
      let len = stridx(string, "\n")

      if len == -1
        call append(pos, s:indent . string)
        break
      endif

      call append(pos, s:indent . strpart(string, 0, len))

      let pos = pos + 1
      let string = strpart(string, len + 1)
    endwhile
endf

fun! GotoCatch()
    " execute s:last + s:offset1 + (s:offset2 - 1) + 1  
    execute s:last + s:offset1 + s:offset2    
    execute "normal ^t)"
endf

if !exists("no_plugin_maps") && !exists("no_java_maps")
  if !hasmapto('<Plug>InsertTryInsertTry')
    map <unique> <buffer> ¬t <Plug>InsertTryInsertTry
  endif
  noremap <buffer> <script> 
    \ <Plug>InsertTryInsertTry 
    \ <SID>InsertTry
  noremap <buffer> 
    \ <SID>InsertTry 
    \ :call <SID>InsertTry()<CR>
endif
