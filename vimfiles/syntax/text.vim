" 语法高亮启用
if exists("b:current_syntax")
  finish
endif

syn region txtComment1 start="^//" end="$"
syn region txtComment1 start="^#"  end="$"
syn region txtComment2 start="^::" end="$"

" 颜色：黄底白字（GUI 如 gvim）
hi txtComment1 guifg=grey guibg=NONE
hi txtComment2 guifg=yellow guibg=NONE

" 颜色：终端版本（如果需要）
hi txtComment1 ctermfg=grey ctermbg=NONE
hi txtComment2 ctermfg=yellow ctermbg=NONE

let b:current_syntax = "text"
