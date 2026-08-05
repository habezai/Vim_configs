" 语法高亮启用，避免重复加载
if exists("b:current_syntax")
  finish
endif

" ==============================================
" 第一优先级：匹配 . 开头的整行 暗粉色
" ==============================================
" 严格匹配行首只有一个.的情况，避免和..、...混淆
syn region txtDotFull start="^\.\s*\%$" end="$" keepend
syn region txtDotFull start="^\.$" end="$" keepend
" 兼容行首.后面跟内容的情况
syn region txtDotStart start="^\." end="$" keepend

" ==============================================
" 第二优先级：匹配 .. 开头的整行 粉色
" ==============================================
syn region txtDot2Full start="^\.\.\s*\%$" end="$" keepend
syn region txtDot2Start start="^\.\." end="$" keepend

" ==============================================
" 第三优先级：匹配 ... 开头的整行 暗绿色
" ==============================================
syn region txtDot3Full start="^\.\.\.\s*\%$" end="$" keepend
syn region txtDot3Start start="^\.\.\." end="$" keepend

" ==============================================
" 第四优先级：匹配 : 开头的整行 暗黄色
" ==============================================
" 严格匹配单个:开头，避免和::、:::混淆
syn region txtColonFull start="^:\s*\%$" end="$" keepend
syn region txtColonStart start="^:" end="$" keepend

" ==============================================
" 第五优先级：匹配 :: 开头的整行 黄色
" ==============================================
syn region txtColon2Full start="^::\s*\%$" end="$" keepend
syn region txtColon2Start start="^::" end="$" keepend

" ==============================================
" 第六优先级：匹配 ::: 开头的整行 普通绿色
" ==============================================
syn region txtColon3Full start="^:::\s*\%$" end="$" keepend
syn region txtColon3Start start="^:::" end="$" keepend

" ==============================================
" 原配置保留的//和#注释高亮，调整为暗灰色避免和自定义规则冲突
" ==============================================
syn region txtSlashHash start="^//" end="$"
syn region txtSlashHash start="^#"  end="$"

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

" 原//和#注释 → 暗灰色
hi txtSlashHash   guifg=#696969 guibg=NONE ctermfg=241

" 标记当前语法加载完成
let b:current_syntax = "customtext"
