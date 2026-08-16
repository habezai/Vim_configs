" 这个文件是延迟加载的
function! k_runner#api#Init()
    let g:k_runner_turn_on = 1
    echo "KRunner: " . (g:k_runner_turn_on ? "已启用" : "已禁用")
endfunction

function! k_runner#api#Deinit()
    let g:k_runner_turn_on = 0
    echo "KRunner: " . (g:k_runner_turn_on ? "已启用" : "已禁用")
endfunction

function! k_runner#api#RunBatCmd()
    if !(has("win32") || has("win64") || has("win95") || has("win16"))
        echo "非Windows系统"
        return
    endif
    let s:cfg = expand("$VIM") ."\\". "k_runner.init"
    if filereadable(s:cfg) 
        echom "KRunner已通过".s:cfg."启用."
        let g:k_runner_turn_on = 1
    endif

    if(g:k_runner_turn_on)
        " 获取当前行完整内容
        let current_line = getline('.')

        " 1. 先处理空行和注释行的原有逻辑
        if current_line =~ '^\s*$' || current_line =~ '^\(rem\|::\)'
            echo "Skipping comment or empty line"
            return
        endif

        " 2. 扩展匹配规则：支持任意数量前置点号+cmd:
        " 正则说明：
        " ^\s*          行首可以有任意空白字符
        " \.*           匹配0个或多个前置点号（支持.cmd:、..cmd:、...cmd:）
        " cmd:          匹配cmd:关键字
        " \s*           cmd:后面可以有任意空白字符
        " .*            后面跟实际命令内容
        if current_line !~# '^\s*\.*cmd:\s*.*'
            echoerr "本行消息并不是以cmd:起始，当前行原始内容为：[" . current_line . "]"
            return
        endif

        " 3. 提取最终要执行的命令：自动忽略所有前置点号、空白和cmd:前缀
        let cmd = substitute(current_line, '^\s*\.*cmd:\s*\(.*\)\s*$', '\1', '')

        " 4. 保留原有执行逻辑
        echo "Executing: " . cmd
        " Windows后台执行
        silent execute '!start cmd /c "' . cmd .'"'

        " 返回Vim
        redraw!
    else
        echo "put a file `k_runner.init` or use `:KInit` to activate this function, then try again"
    endif

endfunction
