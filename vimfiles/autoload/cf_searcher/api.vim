" 这个文件是延迟加载的
" ───────────────────────────────────────────────────────
" 🔍 Ctrl+F: vimgrep current word in current file & open cwindow
" ───────────────────────────────────────────────────────
function! cf_searcher#api#Search() abort
    if !has("gui_running")
        echohl WarningMsg | echo "⚠️  Not gui vim!" | echohl None
        return
    endif

    " 1. 获取光标下普通 word（不含标点，等价于 'iw' 内容）
    let l:word = expand('<cword>')
    if empty(l:word)
        echohl WarningMsg | echo "⚠️  No word under cursor!" | echohl None
        return
    endif

    " 2. 转义正则特殊字符（防止 /foo.bar/ 报错）
    "   只转义 vimgrep 中有含义的：\ / . * ^ $ [ ] ~
    let l:escaped = substitute(l:word, '[\/.*^$[\]~]', '\\\0', 'g')

    " 3. 执行 vimgrep（-n 显示行号，g 全局，% 当前文件）
    "    使用 \c 忽略大小写（去掉 \c 可改为区分大小写）
    execute 'vimgrep /\c' . l:escaped . '/g %'

    " 4. 打开 quickfix 窗口（若已有结果则聚焦，无结果则提示）
    copen
    " 可选：自动跳转到第一个匹配（取消下面这行的注释即可）
    " cnfile
    " 高亮当前关键词
    nohlsearch
    execute 'let @/ = "\\<' . escape(l:escaped, '\/') . '\\>"'
    set hlsearch
    redraw!
endfunction
