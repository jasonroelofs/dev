" Vim syntax file
" Language:	rhtml (Ruby Server Pages)
" Maintainer:	Rafael Garcia-Suarez <rgarciasuarez@free.fr>
" URL:		http://rgarciasuarez.free.fr/vim/syntax/rhtml.vim
" Last change:	2004 Feb 02
" Credits : Patch by Darren Greaves (recognizes <rhtml:...> tags)
"	    Patch by Thomas Kimpton (recognizes rhtmlExpr inside HTML tags)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'rhtml'
endif

" Source HTML syntax
if version < 600
  source <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
endif
unlet b:current_syntax

" Next syntax items are case-sensitive
syn case match

" Include Ruby syntax
syn include @rhtmlRuby <sfile>:p:h/ruby.vim

syn region rhtmlScriptlet matchgroup=rhtmlTag start=/<%/  keepend end=/%>/ contains=@rhtmlRuby
syn region rhtmlComment			  start=/<%--/	      end=/--%>/
syn region rhtmlDecl	matchgroup=rhtmlTag start=/<%!/ keepend end=/%>/ contains=@rhtmlRuby
syn region rhtmlExpr	matchgroup=rhtmlTag start=/<%=/ keepend end=/%>/ contains=@rhtmlRuby
syn region rhtmlDirective			  start=/<%@/	      end=/%>/ contains=htmlString,rhtmlDirName,rhtmlDirArg

syn keyword rhtmlDirName contained include page taglib
syn keyword rhtmlDirArg contained file uri prefix language extends import session buffer autoFlush
syn keyword rhtmlDirArg contained isThreadSafe info errorPage contentType isErrorPage
syn region rhtmlCommand			  start=/<rhtml:/ start=/<\/rhtml:/ keepend end=/>/ end=/\/>/ contains=htmlString,rhtmlCommandName,rhtmlCommandArg
syn keyword rhtmlCommandName contained include forward getProperty plugin setProperty useBean param params fallback
syn keyword rhtmlCommandArg contained id scope class type beanName page flush name value property
syn keyword rhtmlCommandArg contained code codebase name archive align height
syn keyword rhtmlCommandArg contained width hspace vspace jreversion nspluginurl iepluginurl

" Redefine htmlTag so that it can contain rhtmlExpr
syn region htmlTag start=+<[^/%]+ end=+>+ contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster,rhtmlExpr

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_rhtml_syn_inits")
  if version < 508
    let did_rhtml_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " ruby.vim has redefined htmlComment highlighting
  HiLink htmlComment	 Comment
  HiLink htmlCommentPart Comment
  " Be consistent with html highlight settings
  HiLink rhtmlComment	 htmlComment
  HiLink rhtmlTag		 htmlTag
  HiLink rhtmlDirective	 rhtmlTag
  HiLink rhtmlDirName	 htmlTagName
  HiLink rhtmlDirArg	 htmlArg
  HiLink rhtmlCommand	 rhtmlTag
  HiLink rhtmlCommandName  htmlTagName
  HiLink rhtmlCommandArg	 htmlArg
  delcommand HiLink
endif

if main_syntax == 'rhtml'
  unlet main_syntax
endif

let b:current_syntax = "rhtml"

" vim: ts=8
