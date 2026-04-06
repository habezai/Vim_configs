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
        " 获取当前行内容
        let cmd = getline('.')

        " 跳过注释和空行
        if cmd =~ '^\s*$' || cmd =~ '^\(rem\|::\)'
            echo "Skipping comment or empty line"
            return
        endif

        " 清理命令
        let cmd = substitute(cmd, '^\s*\(.\{-}\)\s*$', '\1', '')

        echo "Executing: " . cmd

        " Windows后台执行
        silent execute '!start cmd /c "' . cmd 

        " 返回Vim
        redraw!
    else
        echo "put a file `k_runner.init` or use `:KInit` to activate this function, then try again"
    endif

endfunction
