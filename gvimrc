"""""""""""""""""""""""""""
""" Gvim Global Configs """
"""""""""""""""""""""""""""

command -nargs=0 Zoom :macaction performZoom:

" Setup the font (Bitstream on Linux, Lucida on Windows)
:set guifont=Monaco:h16.00,Bitstream\ Vera\ Sans\ Mono\ 11,\ Lucida_Sans_Typewriter:h8:cANSI

" Set all gui options
"   Options can be set or unset with
"   :set guioptions+=(options)
"   :set guioptions-=(options)
"   Options
"     r - right scrollbar
"     l - left scrollbar
"     b - bottom scrollbar
"     m - menu bar
"     t - tools bar
"     e - Macvim native tabs

"Disable all options, scrollbars give funky business in full screen
:set guioptions=e

:cabbr toff set guioptions-=T
:cabbr ton set guioptions+=T
:cabbr moff set guioptions-=m
:cabbr mon set guioptions+=m

" Maximize both dimensions when going fullscreen
:set fuopt=maxhorz,maxvert

:highlight Normal guifg=white guibg=black

"""""""""""""""""""""""""""""
""" Plugin Initialization """
"""""""""""""""""""""""""""""

""" CtrlP """

" I want Command+p!
if has("gui_macvim")
  macmenu &File.Print key=<nop>
  nmap <D-p> :CtrlP<CR>
  nmap <D-P> :CtrlPBuffer<CR>
endif

""" SweeterVest """

" Ensure dispatch is always turned on if we're in MacVim
let g:use_dispatch=1
