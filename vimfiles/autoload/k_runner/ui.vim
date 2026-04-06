" 这个文件是延迟加载的
function! k_runner#ui#Hello()
    let options = { 
                \ 'highlight': 'WarningMsg',
                \ 'moved':"any",
                \ 'border':[3,3,3,3],
                \ }

    if (has("win32") || has("win64") || has("win95") || has("win16"))
        let popup_id = popup_create('k_runner/ui: Hello (windows)', options)
    else
        let popup_id = popup_create('k_runner/ui: Hello (other)', options)
    endif
    
endfunction
