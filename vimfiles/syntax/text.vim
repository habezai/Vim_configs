" 语法高亮启用，避免重复加载
if exists("b:current_syntax")
  finish
endif

---
" ==============================================
" 第一优先级：匹配 . 开头的整行 暗粉色
" ==============================================
" 严格匹配行首只有一个.的情况，避免和..、...混淆
syn region txtDotFull start="^\.\s*\%$$" end="$$" keepend
syn region txtDotFull start="^\.$$" end="$$" keepend
" 兼容行首.后面跟内容的情况
syn region txtDotStart start="^\." end="$" keepend

" ==============================================
" 第二优先级：匹配 .. 开头的整行 粉色
" ==============================================
syn region txtDot2Full start="^\.\.\s*\%$$" end="$$" keepend
syn region txtDot2Start start="^\.\." end="$" keepend

" ==============================================
" 第三优先级：匹配 ... 开头的整行 暗绿色
" ==============================================
syn region txtDot3Full start="^\.\.\.\s*\%$$" end="$$" keepend
syn region txtDot3Start start="^\.\.\." end="$" keepend

" ==============================================
" 第四优先级：匹配 : 开头的整行 暗黄色
" ==============================================
" 严格匹配单个:开头，避免和::、:::混淆
syn region txtColonFull start="^:\s*\%$$" end="$$" keepend
syn region txtColonStart start="^:" end="$" keepend

" ==============================================
" 第五优先级：匹配 :: 开头的整行 黄色
" ==============================================
syn region txtColon2Full start="^::\s*\%$$" end="$$" keepend
syn region txtColon2Start start="^::" end="$" keepend

" ==============================================
" 第六优先级：匹配 ::: 开头的整行 普通绿色
" ==============================================
syn region txtColon3Full start="^:::\s*\%$$" end="$$" keepend
syn region txtColon3Start start="^:::" end="$" keepend

" ==============================================
" 配置行开头的//注释高亮，调整为暗灰色
" ==============================================
syn region txtSlashHash start="^//" end="$"

" ==============================================
" 匹配标题开头的 # + [空格]注释高亮
" ==============================================
syntax match txtHeading /^\s*#\{1,10}\%(\s\|$$\).*$$/ keepend

" ------------------------------
" 配色定义：GUI版本
" ------------------------------
"  .开头整行 → 暗粉色
hi txtDotFull      guifg=#d16a9a guibg=NONE ctermfg=162
hi txtDotStart    guifg=#d16a9a guibg=NONE ctermfg=162
" ..开头整行 → 粉色
hi txtDot2Full    guifg=#ff87b6 guibg=NONE ctermfg=205
hi txtDot2Start   guifg=#ff87b6 guibg=NONE ctermfg=205
" ...开头整行 → 暗绿色
hi txtDot3Full    guifg=#00AA00 guibg=NONE ctermfg=22
hi txtDot3Start   guifg=#00AA00 guibg=NONE ctermfg=22

" :开头整行 → 暗黄色
hi txtColonFull   guifg=#b8860b guibg=NONE ctermfg=136
hi txtColonStart  guifg=#b8860b guibg=NONE ctermfg=136
" ::开头整行 → 黄色
hi txtColon2Full  guifg=#ffd700 guibg=NONE ctermfg=220
hi txtColon2Start guifg=#ffd700 guibg=NONE ctermfg=220
" :::开头整行 → 普通标准绿色
hi txtColon3Full  guifg=#00ff00 guibg=NONE ctermfg=46
hi txtColon3Start guifg=#00ff00 guibg=NONE ctermfg=46

" //注释 → 暗灰色
hi txtSlashHash   guifg=#696969 guibg=NONE ctermfg=241

" # 标题
hi txtHeading guifg=#87afff guibg=NONE ctermfg=111

" 标记当前语法加载完成
let b:current_syntax = "customtext"

" ==============================================
" # 标题折叠
" #       一级
" ##      二级
" ###     三级
" ...
" ########## 十级
" ==============================================

function! CustomTxtFoldExpr(lnum) abort
  let l:line = getline(a:lnum)

  " 去掉行首空白
  let l:line = substitute(l:line, '^\s*', '', '')

  " 空行不继承上一行的折叠层级
  if empty(l:line)
    return 0
  endif

  " 匹配 1~10 个 #，并且 # 后面必须是空白或行尾
  if l:line =~# '^#\{1,10}\%(\s\|$\)'
    " 统计 # 的数量
    return strlen(matchstr(l:line, '^#\{1,10}'))
  endif

  " 普通内容继承上一行的折叠层级
  if a:lnum == 1
    return 0
  endif

  return '='
endfunction

" 启用表达式折叠
setlocal foldmethod=expr
setlocal foldexpr=CustomTxtFoldExpr(v:lnum)

" 打开文件时默认全部展开
setlocal foldlevel=1

" 开启折叠
setlocal foldenable
