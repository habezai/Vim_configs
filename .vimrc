let g:myvim_wants_pure_config = 1
if has("gui_running")
    iab xtime <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>
endif

"  < 判断是终端还是 Gvim > {{{
" -----------------------------------------------------------------------------
let g:isGUI = 0
if has("gui_running")
    "Gvim下的配置
    let g:isGUI = 1
endif
"}}}
" < Gvim 专用设置 > {{{
" -----------------------------------------------------------------------------
if(g:isGUI)
    "Gvim下的配置 
    "Gvim 安装路径下的 _vimrc文件，优先级比不上 "~/.vimrc文件，
    "但若是 C:/Users/icebg下不存在.vimrc , 那么 echo $MYVIMRC 就会打印出 D:\Program Files（x86）\Vim
    "启用GDB包,然后就能[ :Termdebug + 可执行程序名] .termdebug 是从 Vim 8.1 开始内置的调试插件，仅支持 GDB。
    packadd termdebug 
    nnoremap <F11> :call GDB()<CR>
    function! g:GDB() abort
        execute "Termdebug %:r"
    endfunction
    "Gvim行距 linespace
    set linespace=4

    if ( &filetype != 'vim' )
        colorscheme wwdc16 "motus 或者 gruvbox8_hard  或者 wwdc16
    endif

    "BufNewFile创建新的txt文件的时候， BufReadPost打开已有txt文件之后
    autocmd BufNewFile,BufReadPost *.txt setlocal linespace=10
    autocmd BufLeave *.txt setlocal linespace=4
    set guifont=Consolas:h11
else
    "终端vim下的配置
    " 判断变量 myflag 是否存在
    if !exists("g:myflag_colorscheme") && !has('nvim')
        " 在这里编写您希望只使用一次的配置
        colorscheme monokai "设置配色方案，在~/.vim/colors/目录下提前放置molokai.vim
        " 将变量 myflag_colorscheme 设置为已存在，避免重复执行
        let g:myflag_colorscheme = 1
    endif
endif
"}}}
"  < 判断操作系统是否是 Windows 还是 Linux >  {{{
" -----------------------------------------------------------------------------
let g:isWindows = 0
let g:isLinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:isWindows = 1
else
    let g:isLinux = 1
endif
"}}}
" < Linux 专用设置 >  {{{
" -----------------------------------------------------------------------------
"
"}}}
" < 编译运行：<leader>e快捷运行---Winows/Linux都行 > {{{
" -----------------------------------------------------------------------------
"}}}

"-------------------以下与gvim和vim无关----------------------------------------
" 目前我的vim个人配置文件
" 一般的映射，都写nore防止递归, 函数则写感叹号function!

" 映射 和 设置
" < Mappings映射(map) > {{{
" -----------------------------------------------------------------------------
" Backspace改为轮换缓冲区
nnoremap <Backspace> :b#<CR>
" jj映射esc
inoremap jj <esc>
" 热键Leader定为'分号'。
let mapleader = ";"
" 设置本地热键 为 "-"
let maplocalleader = "-"
" 设置;a快捷键选中所有内容
nnoremap <Leader>a ggVG
" "B"uffer "D"elete 删除当前缓冲区（而不是仅仅关闭窗口）
nnoremap <leader>bd <esc>:bd<cr>
" 关闭除此缓冲区以外的所有缓冲区
nnoremap <leader>bo :execute "%bd\|e#"<CR>
" checkbox状态切换
nnoremap <leader>cb <Plug>VimwikiToggleListItem
" "C"hange "V"imrc"的首字母,新建tab，打开.vimrc进行编辑
nnoremap <leader>cv :tabnew $MYVIMRC<cr>
" "C"opy 使用 ;c 来对选中的文字进行 赋值到系统粘贴寄存器
vnoremap <leader>c "*y
if !exists('g:myvim_wants_light_config')
    " "E"xecute 按分号e编译运行代码 (Windows生成exe)
    nnoremap <Leader>e :call CompileRunGcc()<CR>
    "<leader>m  打开临时文件 main.cpp
    nnoremap <leader>m :call OpenTempCpp()<cr>
endif
" 使用;p快捷键开启 paste。;;p关闭paste。默认关闭paste模式
set nopaste
nnoremap <Leader>p :set paste<CR>i
nnoremap <Leader><Leader>p :set nopaste<CR>
" 使用;q快捷键退出vim
nnoremap <Leader>q :q<CR>
" 使用;;q强制退出vim
nnoremap <Leader><Leader>q <esc>:q!<CR>
" 窗口切换  
" ctrl+h 切换到左边
nnoremap <c-h> <c-w>h  
" ctrl+l 切换到右边
nnoremap <c-l> <c-w>l  
nnoremap <c-j> <c-w>j  
nnoremap <c-k> <c-w>k  
"空格 一次击键选中当前word,两次击键选中WORD。小心：viwc这句话里，不要有任何多余的空格
nnoremap <space> viw
vnoremap <space> vviW
" "S"ource "V"imrc"的首字母，表示重读vimrc配置文件。
nnoremap <leader>sv <esc>:source $MYVIMRC<cr>
"分号sh 进入shell
nnoremap <Leader>sh :call IntoShell()<CR>
function! g:IntoShell() abort
    if &filetype != 'vim'
        execute "w"
    endif
    if exists('g:asyncrun_mode')
        let g:leader_e_run_prefix=":AsyncRun -mode=term -pos=right -col=50 "
        execute g:leader_e_run_prefix."powershell"
    else
        execute "terminal"
    endif
endfunction
" 使用;v快捷键粘贴 `*` 寄存器内容---也就是 Win系统粘贴板
nnoremap <Leader>v "*p 
" 使用;w快捷键保存内容
nnoremap <Leader>w :w<CR>
"H设置为行首，L设置为行尾
nnoremap H ^
nnoremap L $
"两个//搜索选中文本。可 与<space><space>搭配使用。
vnoremap // y/<c-r>"<cr>
" 分割窗口后通过前缀键 "\" 和方向键 调整窗口大小
nnoremap <Leader><Up>    :resize +5<CR>
nnoremap <Leader><Down>  :resize -5<CR>
nnoremap <Leader><Right> :vertical resize +5<CR>
nnoremap <Leader><Left>  :vertical resize -5<CR>

"指定 F2 键来打开Vista或者关闭
nnoremap <silent><F2> :Vista!!<CR>    
" 标签页导航 按键映射。silent 命令（sil[ent][!] {command}）用于安静地执行命令，既不显示正常的消息，也不会把它加进消息历史
nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt
nnoremap <Leader>5 5gt
nnoremap <Leader>6 6gt
nnoremap <Leader>7 7gt
nnoremap <Leader>8 8gt
nnoremap <Leader>9 9gt
"最后一个标签页
nnoremap <Leader>0 :tablast<CR>    
"下一个标签页
nnoremap <silent><Tab>n :tabnext<CR>    
"上一个标签页
nnoremap <silent><s-tab> :tabprevious<CR>    
" }}}
" < Basic Settings基础设置(set) >  {{{
" -----------------------------------------------------------------------------
if(g:isWindows && !has('nvim'))
    "设置python3的dll路径。可能很多插件依赖它。
    set pythonthreedll=C:/Users/yufeng.huang/AppData/Local/Programs/Python/Python37/python37.dll
    " 这是一种 set 选项为变量的方法
    execute 'set pythondll=' . &pythonthreedll
endif
"encoding=utf-8 指的是文件翻译成utf-8再呈现在gvim界面。
"encoding=utf-8 也意味着，你做的修改，gvim界面以utf-8的格式流入屏幕
"以fileencoding的格式流入文件
set encoding=utf-8
set nocompatible  "去掉讨厌的有关vi兼容模式，避免以前版本的一些bug和局限
set showcmd    "输入的命令显示出来，看的清楚些"
set showmatch "开启高亮显示匹配括号"
set showmode "显示当前处于哪种模式
set laststatus=2 "显示状态栏
set verbose=0 " 不为0时,将输出调试信息。对于调试 Vim 配置或插件非常有用
set number    "显示行号
set cursorline "突出显示当前行
set ruler      "在状态栏显示光标的当前位置(位于哪一行哪一列)
set autochdir  "自动切换当前目录为当前编辑文件所在的目录(打开多个文件时)
filetype plugin on   "允许载入文件类型插件
filetype indent on   "为特定文件类型载入对应缩进格式
filetype plugin indent on    "打开基于文件类型的插件和缩进
set smartindent  "开启新行时使用智能自动缩进 主要用于 C 语言一族
set hlsearch     "将搜索的关键字高亮处理
set ignorecase   "搜索忽略大小写(不对大小写敏感) 
set incsearch    " 随着键入即时搜索
set smartcase    " 有一个或以上大写字母时仍大小写敏感。如果同时打开了ignorecase，那么对于只有一个大写字母的搜索词，将大小写敏感；其他情况都是大小写不敏感
set confirm     " 在处理未保存或只读文件的时候，弹出确认
set t_Co=256    "设置256色
"去掉输入错误的提示声音和闪屏
set noerrorbells visualbell t_vb=    "其中 t_vb的清空对GUI的vim无效，因为会默认重置。所以开启gvim以后可能仍然闪屏，可以 :set t_vb=
"（’t_vb‘选项，默认是用来让屏幕闪起来的）Starting the GUI (which occurs after vimrc is read) resets ‘t_vb’ to its default value开启GUI是在读入vimrc以后，会把 t_vb设置成闪屏的。
autocmd GUIEnter * set visualbell t_vb=
set wrap    " 自动换行
set history=1000    " 历史记录数
set fileencodings=utf-8,gbk,cp936,gb18030,big5,euc-jp,euc-kr,latin1 "中文编码支持(gbk/cp936/gb18030)---Vim 启动时逐一按顺序使用第一个匹配到的编码方式打开文件
"set encoding=gbk    " Vim 内部 buffer (缓冲区)、菜单文本等使用的编码方式 :告诉Vim 你所用的字符的编码
"禁止生成临时文件
set nobackup    "禁止自动生成 备份文件
set noswapfile    "禁止自动生成 swap文件
set noundofile    "禁止 gvim 在自动生成 undo 文件 *.un~
set tabstop=4    "按下Tab键时,键入的tab字符显示宽度。 统一缩进为4
set shiftwidth=4    "每次>>缩进偏移4个。(自动缩进时，变化的宽度4为单位)
set softtabstop=4 "自动将键入的Tab转化为空格(宽度未达到tabstop)。或者正常输入一个tab(宽度达到tabstop)。对齐tabstop的倍数。
" 设置softtabstop有一个好处是可以用<Backspace>键来一次删除4个空格大小的tab.或者不足4个空格的几个空格。对齐tabstop的倍数。
" softtabstop的值为负数,会使用shiftwidth的值,两者保持一致,方便统一缩进.
set expandtab    "假如是noexpandtab,就是不要将后续键入的制表符tab展开成空格。expandtab 选项把插入的tab字符替换成特定数目的空格。具体空格数目跟 tabstop 选项值有关
"自动补全（字典方式）----使用ctrl+x ctrl+k 进行字典补全
set dictionary+=/usr/share/dict/english.dict
"直接CTRL+n就显示dict其中的列表
set complete-=k complete+=k
set autoread            "打开文件监视。如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示。
set timeoutlen=500      "以毫秒计的,等待键码或映射的键序列完成的时间;
set backspace=indent,eol,start "设置退格键盘能删除的隐藏符号(indent和eol是符号，start是特殊位置)。 详情参见:help options
"}}}
" < Status Line > {{{
" -----------------------------------------------------------------------------
"set statusline=%F         " 文件的路径
"set statusline+=\ --\      " 分隔符
"set statusline+=FileType: " 标签
"set statusline+=%y        " 文件的类型
"set statusline+=%=        " 切换到右边
"set statusline+=%l        " 当前行
"set statusline+=/         " 分隔符
"set statusline+=%L        " 总行数
" 设置状态行显示常用信息
" %F 完整文件路径名
" %m 当前缓冲被修改标记
" %r 当前缓冲只读标记
" %h 帮助缓冲标记
" %w 预览缓冲标记
" %Y 文件类型
" %b ASCII值
" %B 十六进制值
" %l 行数
" %v 列数
" %p 当前行数占总行数的的百分比
" %L 总行数
" %{...} 评估表达式的值，并用值代替
" %{"[fenc=".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?"+":"")."]"} 显示文件编码[中间的双引号、空格都需要转义字符。]
set statusline=%F "完整的文件路径名
set statusline+=%m "当前缓冲被修改标记 
set statusline+=%r "当前缓冲只读标记
set statusline+=%h "帮助缓冲标记
set statusline+=%w "预览缓冲标记
set statusline+=%= "切换到右边
set statusline+=\ [filetype=%y] "文件的类型
set statusline+=\ %{\"[fileenc=\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"]\"}
set statusline+=\ [ff=%{&ff}] "fileformat
set statusline+=\ [ASCII=%3.3b=0x%2.2B] "ASCII 的decimal 和 hex
set statusline+=\ [pos=%4l行,%3v列][%p%%] "position
set statusline+=\ [%L\ lines] "total num of lines
" }}}
" < abbreviate缩写替换 > {{{
" -----------------------------------------------------------------------------
"替换内容纠正笔误，如果想取消替换，那么iunabbrev main(即修正后的单词) 
inoreabbrev mian main 
inoreabbrev eixt exit 
inoreabbrev viod void 
inoreabbrev waht what
inoreabbrev tehn then
inoreabbrev tihs this
inoreabbrev cahr char
inoreabbrev pirnt print
inoreabbrev fisrt first
inoreabbrev retuen return
inoreabbrev retrun return
"个人常用信息
inoreabbrev @@ icebggg@qq.com
inoreabbrev @z //@hyf
inoreabbrev z@ //fyh@
inoreabbrev ccopy Copyright 2021 Yufeng Huang, all rights reserved.
"选中当前单词，两边添加双引号
nnoremap <leader>"        ea"<esc>bi"<esc>
nnoremap <localleader>"   Ea"<esc>Bi"<esc>

nnoremap <leader>'        ea'<esc>bi'<esc>
nnoremap <localleader>'   Ea'<esc>Bi'<esc>

nnoremap <leader>]        ea]<esc>bi[<esc>
nnoremap <localleader>]   Ea]<esc>Bi[<esc>

nnoremap <leader>)        ea)<esc>bi(<esc>
nnoremap <localleader>)   Ea)<esc>Bi(<esc>

nnoremap <leader>}        ea}<esc>bi{<esc>
nnoremap <localleader>}   Ea}<esc>Bi{<esc>

nnoremap <leader>`        ea`<esc>bi`<esc>
nnoremap <localleader>`   Ea`<esc>Bi`<esc>
" }}}

"   highlight link 配色组汇总
"{{{
" -----------------------------------------------------------------------------
"文本中的 引用高亮
func! OnColorschemeChange() abort

    "引用的内容, 灰底白字
    highlight lspReference ctermfg=red guifg=#000000 ctermbg=green guibg=Grey

    "文本中的错误高亮，不是左侧边栏(sign column)的。
    highlight LspErrorHighlight guifg=#ffffff guibg=#d44848 gui=bold,underline
    "   虚文本的。
    highlight link LspErrorVirtualText Error
    "   符号列的
    highlight link LspErrorText Error

    "文本中的警告高亮，不是左侧边栏(sign column)的
    highlight LspWarningHighlight guifg=#002fa7 guibg=#fbd26a gui=bold,underline
    "   虚文本的。
    highlight link LspWarningVirtualText Todo
    "   符号列的
    highlight link LspWarningText Todo

    "文本中的inlay提示（函数参数）
    highlight lspInlayHintsParameter guifg=#949494 guibg=#292c36 gui=italic
    "文本中的inlay提示（类型）
    highlight lspInlayHintsType guifg=#949494 guibg=#292c36 gui=italic

endfunc
"启动时，加载一次。
call OnColorschemeChange()
"之后，每改换一次颜色主题就加载一次
augroup highlightthings__
    autocmd!  
    autocmd ColorScheme * call OnColorschemeChange()
augroup END
"}}}
"
function! MySaveFunction()
    let options = {
                \ 'highlight': 'WarningMsg',
                \ 'moved':"any",
                \ 'border':[3,3,3,3],
                \ }
    if &filetype == 'dosbatch'
        silent execute ':! %'
        let popup_id = popup_create('saved and executed OK!', options)
    else
        let popup_id = popup_create('File saved OK!', options)
    endif
endfunction

augroup reload_vimrc_once
    autocmd!  
    "autocmd!这一句将会清除之前的 事件和响应动作
    "保存vimrc文件之时，先把文件拷贝覆盖一份给my-vimrc-file目录， 执行vim脚本
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    "只能这样写(source vimrc命令必须放进一个依赖保存事件触发的自动命令，不然就无穷递归了)
augroup END

" 自动命令组
" < autocmd 命令组 global设置 > {{{
" -----------------------------------------------------------------------------
augroup global__
    autocmd!
    "打开任何类型的文件时，自动缩进。(BufNewFile表示即使这个文件不存在，也创建并保存到硬盘)
    "注释不要写到自动命令后面(尤其是normal关键字后面)。 
    "autocmd BufWritePre,BufRead *.html normal! gg=G 

    "SetTitle()自动插入文件头 
    function! g:SetTitle()                          "定义函数 SetTitle，自动插入文件头
        "如果文件类型为 .sh 文件
        if &filetype == 'sh'
            call setline(1,          "\#########################################################################")
            call append(line("."),   "\# File Name: ".expand("%"))
            call append(line(".")+1, "\# Author: Yufeng Huang <icebggg@qq.com>")
            call append(line(".")+2, "\# Created Time: ".strftime("%c"))
            call append(line(".")+3, "\#########################################################################")
            call append(line(".")+4, "\#! /bin/bash")
            call append(line(".")+5, "")

        elseif &filetype == 'c'
            call setline(1,"#include<stdio.h>")
            call append(line("."), "#include<stdlib.h>")
            call append(line(".")+1, "int main()")
            call append(line(".")+2, "{")
            call append(line(".")+3, "")
            call append(line(".")+4, "    exit(0);")
            call append(line(".")+5, "}")

        elseif &filetype == 'make'
            call setline(1,"CPPFLAGS+=-Wextra -Wall -g")
            call append(line("."), "CFLAGS+=-Wextra -Wall -g")
            call append(line(".")+1, "CXX=g++")
            call append(line(".")+2, "CC=gcc")
            call append(line(".")+3, "%.o: %.c")
            call append(line(".")+4, "    $(CXX) $(CPPFLAGS) $^ -o  $@")
            call append(line(".")+5, "clean:")
            call append(line(".")+6, "    rm  main.exe *.o -rf")

        elseif &filetype == 'python'
            call setline(1,"#!/usr/bin/env python")
            call append(line("."),"# coding=utf-8")
            call append(line(".")+1, "") 

        elseif &filetype == 'java'
            call setline(1,"public class ".expand("%:r"))
            call append(line("."),"")

        elseif &filetype == 'ruby'
            call setline(1,"#!/usr/bin/env ruby")
            call append(line("."),"# encoding: utf-8")
            call append(line(".")+1, "")
        endif
        "如果文件后缀为 .cpp
        if expand("%:e") == 'cpp'
            call setline(1, "#include<iostream>")
            call append(line("."), "using namespace std;")
            call append(line(".")+1, "int main()")
            call append(line(".")+2, "{")
            call append(line(".")+3, "")
            call append(line(".")+4, "    return 0;")
            call append(line(".")+5, "}")
        endif
        "如果文件后缀为 .h 文件
        if expand("%:e") == 'h'
            call setline(1, "#ifndef ".toupper(expand("%:r"))."_H")
            call append(line("."), "#define ".toupper(expand("%:r"))."_H")
            call append(line(".")+1, "#endif")
        endif
    endfunction
    autocmd BufNewFile *.sh,*.java,*.h,*.c,*.cpp,makefile,*.py,*.rb call SetTitle()
    "normal命令中的可选参数 ! 用于指示vim在当前命令中不使用任何vim映射
    autocmd BufNewFile *.c,*.cpp normal! 5gg
    autocmd BufNewFile *.h normal! ggo

    function! s:ReadAllFileType() abort
        "这里面所有的代码，可以在文件完全读入以后生效

        " Vim 重新打开文件时，回到上次历史所编辑文件的位置
        if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif 
    endfunction
    autocmd BufReadPost * call s:ReadAllFileType()
    "call之前，函数体得存在。如果是键位map调用函数的话，倒不介意顺序(不过，需要source一下)。
    "这里是 新建文件之前做的操作
    autocmd BufNewFile * setlocal ff=unix

augroup END
" }}}
" < FileType settings 也就是autocmd命令组的文件类型具体化 > {{{
" -----------------------------------------------------------------------------
augroup c_cpp__
    autocmd!
    function! s:C_CppSettings() abort
        "设置所有的操作都是4个空格为基数对齐。依次为：一个tab的显示宽度, >> 和 == 移动的宽度，键入或者<Backspace>的tab宽度，键入的tab展开为空格。
        setlocal tabstop=4|setlocal shiftwidth=4|setlocal softtabstop=4|setlocal expandtab
        "makeprg参数设置以后，:make将执行这个语句，且可以用:cw打开错误信息、:cn跳转到下一个错误、:cp跳转到上一个
        if(g:isWindows)
            setlocal makeprg=g++\ %\ -Wextra\ -Wall\ -std=c++17\ -g\ -o\ %:r.exe\ 
        else
            setlocal makeprg=g++\ %\ -Wextra\ -Wall\ -std=c++17\ -g\ -o\ %:r\ 
        endif
        setlocal cindent
        "打开c,cpp文件时（前）全部折叠
        setlocal foldlevelstart=0
        "设定 手动折叠的标记
        setlocal foldmethod=marker | setlocal foldmarker=//<,//>
        "c,cpp注释(comment)快捷键：-c
        nnoremap <buffer> <localleader>c I//<space><esc>
        "设置c,c++文件的 帮助程序。(不然Windows默认是:help,Linux默认是man)

        "setlocal keywordprg=:MyKey
        "定义自己的 底线命令
        " command!  -nargs=* MyKey :call MyK(<f-args>)
        " function! MyK(keywd) abort
        "     if exists('g:asyncrun_mode')
        "         let l:cmd=':call HyfEchoFunc("'.a:keywd.'")'
        "         call asyncrun#run('', {}, l:cmd)
        "     endif
        " endfunction

        "弄一弄Linux下tag路径 (仅限C++和C语言)
        setlocal tags+=/usr/include/tags
        if (g:isWindows)
            "弄一弄windows下tag路径 (仅限C++和C语言)
            setlocal tags+=D:/MinGW/mingw64/lib/gcc/x86_64-w64-mingw32/8.1.0/include/tags
            setlocal tags+=D:/MinGW/mingw64/x86_64-w64-mingw32/include/tags
        endif
        "snippets
        inoreabbrev <buffer>        yfc #include<stdio.h><cr>#include<stdlib.h><cr>int main()<cr>{<cr>exit(0);<cr>}<esc>kO<esc>i   
        inoreabbrev <buffer>        yfpp #include<iostream><cr>using namespace std;<cr>int main()<cr>{<cr>return 0;<cr>}<esc>kO<esc>i   
        inoreabbrev <buffer>        ifndef #ifndef<cr>#define<cr>#endif

        inoreabbrev <buffer>        fori for(int i=0;i<m;++i)<cr>{<cr>}<esc>O
        inoreabbrev <buffer>        forj for(int j=0;j<n;++j)<cr>{<cr>}<esc>O

        inoreabbrev <buffer>        whilee while(n--)<cr>{<cr>}<esc>O
        inoreabbrev <buffer>        printt printf("",);<left><left><left>
        inoreabbrev <buffer>        structt struct<cr>{<cr>};<esc>O<esc>i   
        inoreabbrev <buffer>        classs class<cr>{<cr>public:<cr>};<esc>O<esc>i       
        inoreabbrev <buffer>        scann scanf("",);
        inoreabbrev <buffer>        switchh switch(VALUE)<cr>{<cr>case 0:<cr>break;<cr>case 1:<cr>case 2:<cr>break;<cr>default:<cr>break;<cr>}
        inoreabbrev <buffer>        iff if( )<left><left>
        inoreabbrev <buffer>        coutt cout<<<cr><cr><<endl;<esc>ki<tab>   

        inoreabbrev <buffer>        vecvec vector<vector<int>>
        inoreabbrev <buffer>        vec vector<int>
        inoreabbrev <buffer>        dfs dfs(arr,startX,startY,oneAns,ans)
        inoreabbrev <buffer>        bfs m_que.push(pRoot);<cr>while(m_que.empty()==false)<cr>{<cr>int cnt = m_que.size();<cr>for(int i=0;i<cnt;++i)<cr>{<cr>TreeNode * curNode = m_que.front();<cr>m_que.pop();<cr>if( curNode->left )<cr>m_que.push(curNode->left);<cr>if( curNode->right )<cr>m_que.push(curNode->right);<cr>}<cr>}
        inoreabbrev <buffer>        lamda [&](int a,int b)->bool {return a<b;}
        "call OpenTagList()
    endfunction
    autocmd FileType c,cpp call s:C_CppSettings()
augroup END
augroup python__
    autocmd!
    autocmd FileType python inoreabbrev <buffer> iff if:<left>
    autocmd FileType python inoreabbrev <buffer> else else:
    autocmd FileType python inoreabbrev <buffer> fori for i in range(n):
    autocmd FileType python inoreabbrev <buffer> printt print("")<left><left>
    "在编辑python类型的文件时 务必展开所有输入的tab为空格
    autocmd FileType python setlocal tabstop=4|setlocal shiftwidth=4|setlocal softtabstop=4|setlocal expandtab
    "python、shell注释(comment)快捷键：-c
    autocmd FileType python,sh nnoremap <buffer> <localleader>c I#<space><esc>
    "设定 手动折叠的标记
    autocmd FileType python setlocal foldmethod=marker | setlocal foldmarker=#<,#>
augroup END
augroup javascript__
    autocmd!
    autocmd BufReadPre *.js setlocal foldlevelstart=0
    function! s:JsSettings() abort
        inoreabbrev <buffer> iff if()<left>
        "javascript注释(comment)快捷键：-c
        nnoremap <buffer> <localleader>c I//<space><esc>
        "设定 手动折叠的标记
        setlocal foldmethod=marker | setlocal foldmarker=//<,//>
    endfunction
    autocmd FileType javascript call s:JsSettings()
augroup END
augroup html__
  autocmd!
  " autocmd BufReadPost *.html  if filereadable(expand("%:r") . ".vim") | execute 'source ' . expand("%:r") . ".vim" | elseif filereadable("must.vim") | execute "source must.vim" | endif
augroup END
augroup shell_
    autocmd!
    autocmd FileType sh inoreabbrev <buffer> yfsh #! /bin/bash<cr>
    autocmd FileType sh inoreabbrev <buffer> iff if []; then<cr><cr>fi<esc>2kf]i
augroup END
augroup asm__
    autocmd!
    "设定 手动折叠的标记
    autocmd FileType asm setlocal foldmethod=marker | setlocal foldmarker=;<,;>
augroup END
"vim的帮助文档类型
augroup help__
    autocmd!
    "让 横杠不成为分词依据(为了链接跳转可以直接使用K和ctrl+])
    autocmd FileType help setlocal iskeyword+=-
augroup END
" }}}
" < Markdown file settings > {{{
" -----------------------------------------------------------------------------
augroup markdown__
    autocmd!
    "设置折叠方式为语法 "打开文件时全部折叠
    autocmd filetype markdown call s:VimwikiSettings()
    "colorscheme motus | 
    function! s:VimwikiSettings() abort
        "vimrc 注释一行快捷键
        setlocal foldlevelstart=0 | setlocal foldmethod=syntax
        nnoremap <buffer> <localleader>c I%%<space><esc>
    endfunction
augroup END
"}}}
" < VimWiki file settings > {{{
" -----------------------------------------------------------------------------
augroup vimwiki__
    autocmd!
    "设置折叠方式为语法 "打开文件时全部折叠
    autocmd BufWritePre *.wiki execute 'VimwikiTOC'
    autocmd filetype vimwiki call s:VimwikiSettings()
    "colorscheme motus | 
    function! s:VimwikiSettings() abort
        "vimrc 注释一行快捷键
        setlocal foldlevelstart=0 | setlocal foldmethod=syntax
        nnoremap <buffer> <localleader>c I%%<space><esc>
    endfunction
augroup END
"}}}

" < Vimscript file settings > {{{
" -----------------------------------------------------------------------------
augroup vim__
    autocmd!
    "设置折叠方式为手动标记 "打开文件时全部折叠
    autocmd BufReadPost .vimrc setlocal foldlevelstart=0 | setlocal foldmethod=marker
    autocmd filetype vim call s:VimSettings()
    "colorscheme motus | 
    function! s:VimSettings() abort
        "vimrc 注释一行快捷键
        nnoremap <buffer> <localleader>c I"<space><esc>
    endfunction
augroup END
"}}}
if g:myvim_wants_pure_config == 1
    " 画面中央弹出弹窗，显示消息，移动光标就关闭弹窗
    if !has('nvim')
        let options = { 
                    \ 'highlight': 'WarningMsg',
                    \ 'moved':"any",
                    \ 'border':[3,3,3,3],
                    \ }
        let popup_id = popup_create('Vim pure config!', options)
    endif
    if !has('nvim')
        if(g:isWindows)
        call plug#begin('~/.vimfiles/plugged') "这里规定安装目录,中间各行代表获取的插件
    else
        call plug#begin('~/.vim/plugged') "这里规定安装目录,中间各行代表获取的插件
    endif
    " 只启动vim(未指定文件名)的时候 提供的一些辅助功能，比如显示最近打开文件,以及一个好看的图标。开箱即用。
    Plug 'mhinz/vim-startify'
    "auto-pairs 括号自动补全
    Plug 'jiangmiao/auto-pairs'
    "css的颜色直接渲染在文本上
    Plug 'ap/vim-css-color'
    "复制（yanked）的文本高亮一下
    Plug 'machakann/vim-highlightedyank'
    let g:highlightedyank_highlight_duration = 500 "设置为负一的话则是持续高亮"
    let g:highlightedyank_highlight_in_visual = 0 "可视模式下不搞这花里胡哨的
    "indentLine添加一些分割线 比如你写python的时候 格式对齐 就可以通过这个分割线
    Plug 'Yggdroot/indentLine'
    let g:indentLine_fileType = ["c","cpp","python","html"]
    " 大名鼎鼎的vimwiki
    Plug 'vimwiki/vimwiki'
    set runtimepath+=~\vimfiles\plugged\vimwiki\
    let g:vimwiki_list = [
                \ {'path': '~\vimwiki\my-personal-wiki\', 'css_name': 'style.css'},
                \ {'path': '~\vimwiki\my-thesis\', 'css_name': 'style.css'},
                \ ]
    autocmd FileType vimwiki setlocal shiftwidth=4 tabstop=4 noexpandtab
    call plug#end()
endif
    else
endif

" 这下面是笔记，或者是教程
" # < vim 基本知识> 
"{{{
"         系统 vimrc 文件: "$VIM\vimrc"
"         用户 vimrc 文件: "$HOME\_vimrc"
"     第二用户 vimrc 文件: "$HOME\vimfiles\vimrc"
"     第三用户 vimrc 文件: "$VIM\_vimrc"
"          用户 exrc 文件: "$HOME\_exrc"
"      第二用户 exrc 文件: "$VIM\_exrc"
"        系统 gvimrc 文件: "$VIM\gvimrc"
"        用户 gvimrc 文件: "$HOME\_gvimrc"
"    第二用户 gvimrc 文件: "$HOME\vimfiles\gvimrc"
"    第三用户 gvimrc 文件: "$VIM\_gvimrc"
"           defaults file: "$VIMRUNTIME\defaults.vim"
"            系统菜单文件: "$VIMRUNTIME\menu.vim"
"
" # <Variable prefixes >
"{{{
" -----------------------------------------------------------------------------
"举例let g:ack_options = '-s -H'    " g: global 全局有效
"举例let s:ack_program = 'ack'      " s: local (to script)  脚本中有效
"举例let l:foo = 'bar'              " l: local (to function) 函数中有效
"   Other prefixes
"       let w:foo = 'bar'    " w: window
"       let b:state = 'on'   " b: buffer
"       let t:state = 'off'  " t: tab
"       echo v:var           " v: vim special
"       let @/ = ''          " @  register (this clears last search pattern)
"       echo $PATH           " $  env环境变量加美元符号做前缀
"   Vim options
"       echo 'tabstop is ' . &tabstop
"       if &insertmode
"       echo &g:option
"       echo &l:option
"       --------------
"       Prefix Vim options with &  选项用&符号做前缀
"}}}
" # <vimdiff 快捷操作 >
"{{{
" -----------------------------------------------------------------------------
"    二、光标移动
"       跳转到下一个差异点：]c    命令前加上数字的话，可以跳过一个或数个差异点比如 2]c
"       反向跳转是：[c
"    三、文件合并
"       dp //意思是"d"iff "p"ut  这个是 从当前复制到另一个
"       do(diff "obtain") //从另一个复制到当前
"}}}
" # <vim中常用折叠命令 za zM zR ...>   https://www.cnblogs.com/litifeng/p/11675547.html
"{{{
" -----------------------------------------------------------------------------
"    za 反复打开关闭折叠：za (意思就是，当光标处折叠处于打开状态，za关闭之，当光标处折叠关闭状态，打开之）
"    :set fdm=marker  在vim中执行该命令
"    5G  将光标跳转到第5行
"    zf10G  折叠第5行到第10行的代码，vim会在折叠的开始和结束自动添加三个连续的花括号作为标记
"    zR 展开全部折叠
"    zM 收起全部折叠
"    zE 删除所有的折叠标签(有点危险，哈哈哈，注意防范弄丢所有{{{和}}}标签)
"    zo  打开open光标下的折叠。
"    zc  收起close光标下的折叠。
"    zO  打开Open光标下的折叠，以及嵌套的折叠。
"    zC  收起Close光标下的折叠，以及嵌套的折叠。
"}}}
" # <终端的vim 配色方案笔记> 
"{{{
" -----------------------------------------------------------------------------
"    lucius.vim     亮 txt
"    molokai.vim    暗
"    herald.vim     暗
"}}}
" # < vim ctags cheatsheet > 
"{{{
" -----------------------------------------------------------------------------
"利用C:\Windows\ctags.exe在当前目录下生成详细tag文件的命令：ctags -R --languages=c++ --langmap=c++:+.inl -h +.inl --c++-kinds=+p+x-d --fields=+liaS --extras=+q
"各个参数的解析，请看这个中文网站：https://www.cnblogs.com/coolworld/p/5602589.html
" 以及这里 有中文帮助: https://blog.easwy.com/archives/exuberant-ctags-chinese-manual/
"
"            Command                    Function
"-----------------------------------------------------------------------------
"            Ctrl + ]                   Go to definition 跳转到定义
"            Ctrl + t                   Jump back from the definition "           直接从定义中走出来。( Ctrl + o 只是回到上次缓冲区位置 )
"            Ctrl + W Ctrl + ]          Open the definition in a horizontal split 水平分屏打开定义
"            :ts <tag_name>             List the [t]ag[s] that match <tag_name> 罗列所有匹配这个名字的tag
"            :tn                        Jump to the  [t]ag [n]ext matching      下一个匹配
"            :tp                        Jump to the  [t]ag [p]revious matching  上一个匹配
"}}}

"}}}

" # <localleader>映射已经使用的快捷键说明
"{{{ " -----------------------------------------------------------------------------
"    + c                                                "C"omment 注释
"}}}

" # <Leader>映射已经使用的快捷键说明(a-z) 
"{{{
" -----------------------------------------------------------------------------
"    + 1 2 3 4 5 6 7 8 9 0              访问第几个tab标签页
"    + a                                "A"ll selected
"    + bd                               "B"uffer "D"elete
"    + bo                               "B"uffer "O"nly 
"    + cb                               "C"heck "B"ox
"    + cv                               "C"hange "V"imrc
"    + 
"    + e                                "E"xecute (编译执行) 函数
"    +
"    +
"    +
"    +
"    +
"    +
"    +
"    + m                                "M"ain程序，临时文件,固定在E:\Temp\main.cpp。
"    +
"    +
"    + 
"    +
"    +
"    +
"    + obj                              "Obj"Dump
"    + p                                "P"aste mode
"    + <leader>p                        no "P"aste mode
"    + q                                "Q"uit vim
"    + <leader>q                        force "Q"uit
"    + r                                "R"eplace translation
"    +
"    + sh                               "Sh"ell 函数
"    + sv                               "S"oure "V"imrc
"    + t                                "T"ranslation
"    + tag(弃)                          "Ctag" 函数
"    +
"    + v                                以 ;v 完成类似Ctrl+ "V" 的粘贴操作
"    + w                                "W"rite
"    + <up>                             竖直方向增大窗口
"    + <down>                                            
"    + <left>                                        
"    + <right>                          水平方向增大窗口
"}}}

