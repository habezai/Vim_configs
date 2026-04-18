" 这个文件是延迟加载的
" ───────────────────────────────────────────────────────
" 🔍 Ctrl+F: vimgrep current word in current file & open cwindow
" ───────────────────────────────────────────────────────
function! cf_searcher#api#SearchByInternalTool() abort
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

function! cf_searcher#api#SearchByThirdPartyTool() abort
    " 1. 获取光标下普通 word（不含标点，等价于 'iw' 内容）
    let l:pattern = expand('<cword>')
    if !has("gui_running")
        echohl WarningMsg | echo "⚠️  Not gui vim!" | echohl None
        return
    endif

    if !exists('g:grep_tools_backend')
        let g:grep_tools_backend = executable('rg') ? 'rg' : 'grep'
    endif

    if empty(l:pattern)
        echohl ErrorMsg
        echom 'Search pattern is empty'
        echohl None
        return
    endif

    if g:grep_tools_backend ==# 'rg'
        let cmd = 'rg --vimgrep ' . shellescape(l:pattern)
    else
        let cmd = 'grep -Rn ' . shellescape(l:pattern) . ' .'
    endif

    let output = systemlist(cmd)

    if v:shell_error != 0 && empty(output)
        echohl WarningMsg
        echom 'No results'
        echohl None
        return
    endif

    let qf = []

    if g:grep_tools_backend ==# 'rg'
        " rg --vimgrep 格式: file:line:col:text
        for line in output
            let parts = matchlist(line, '\v^(.+):(\d+):(\d+):(.*)$')
            if !empty(parts)
                call add(qf, {
                            \ 'filename': parts[1],
                            \ 'lnum': str2nr(parts[2]),
                            \ 'col': str2nr(parts[3]),
                            \ 'text': parts[4]
                            \ })
            endif
        endfor
    else
        " grep -Rn 格式: file:line:text
        for line in output
            let parts = matchlist(line, '\v^(.+):(\d+):(.*)$')
            if !empty(parts)
                call add(qf, {
                            \ 'filename': parts[1],
                            \ 'lnum': str2nr(parts[2]),
                            \ 'col': 1,
                            \ 'text': parts[3]
                            \ })
            endif
        endfor
    endif

    silent call setqflist(qf, 'r')
    copen
    nohlsearch
    execute 'let @/ = "\\<' . escape(l:pattern, '\/') . '\\>"'
    set hlsearch
    redraw!
    echom printf('Loaded %d results into quickfix', len(qf))
endfunction

function! cf_searcher#api#Search() abort
    if g:cf_searcher_mode ==# 'file'
        call cf_searcher#api#SearchByInternalTool()
    elseif g:cf_searcher_mode ==# 'dir'
        call cf_searcher#api#SearchByThirdPartyTool()
    else
        echo "模式不支持"
    endif
endfunction

function! cf_searcher#api#SearchModeToggle() abort
    if g:cf_searcher_mode ==# 'file'
        let g:cf_searcher_mode = 'dir'
    elseif g:cf_searcher_mode ==# 'dir'
        let g:cf_searcher_mode = 'file'
    else
        echo "模式不支持"
    endif
endfunction
