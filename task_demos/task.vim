" 这是一个完整的 Vim 脚本，支持函数、多行操作
" 将此脚本静默执行作用于myfile.txt示例： vim -es -S task.vim myfile.txt 
func! ProcessFile()
    " 替换文本
    %s/xxxxx/yyyyy/g
    " 删除空行
    g/^$/d
    " 在末尾添加一行
    $put ='末尾自动添加的内容'
    " 统计行数
    echo "处理完成，总行数：" . line('$')
endfunc

" 调用函数
call ProcessFile()

" 保存退出
wq
