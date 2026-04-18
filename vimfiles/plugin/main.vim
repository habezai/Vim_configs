" K-runner.vim - 单行BAT命令执行插件(快捷键K)
"" ~/.vim/plugin/k-runner.vim
" 避免重复加载
if exists('g:loaded_main')
  finish
endif

let g:loaded_main = 1
"
" 在各类型文件中启用K快捷键
autocmd FileType text,dosbatch,markdown nnoremap <buffer> K :<C-U>call k_runner#api#RunBatCmd()<CR>

nnoremap <silent> <C-F> :<C-U>call cf_searcher#api#Search()<CR>

" 定义命令
command! KRunInit call k_runner#api#Init()
command! KRunDeinit call k_runner#api#Deinit()
command! KRun call k_runner#api#RunBatCmd()
command! CFSearch call cf_searcher#api#Search()
command! CFSearchModeToggle call cf_searcher#api#SearchModeToggle()

" 定义变量
let g:k_runner_turn_on = 0
set shortmess+=F
let g:cf_searcher_mode = 'dir'

" 创建 GUI 菜单（仅 gVim）
if has("gui_running")
  " 创建主菜单
  menu HyfPlugin.Edit-Plugin-Source :edit $VIM\vimfiles\plugin\main.vim <CR>
  menu HyfPlugin.Edit-All-Navigation :edit $VIM\vimfiles\all-navigation.txt<CR>

  menu HyfPlugin.KRunner.Init :KRunInit<CR>
  menu HyfPlugin.KRunner.Deinit :KRunDeinit<CR>
  menu HyfPlugin.KRunner.Run\ This\ Line :KRun<CR>
  menu HyfPlugin.KRunner.ShowStatus :echo "KRunner: " . (g:k_runner_turn_on ? "已启用" : "已禁用")<CR>
  menu HyfPlugin.KRunner.-Sep- :
  menu HyfPlugin.KRunner.Help :echo "the short-cut key is `K` "<CR>

  menu HyfPlugin.CFSearcher.SetFileMode :let g:cf_searcher_mode = 'file'  <CR>
  menu HyfPlugin.CFSearcher.SetDirMode  :let g:cf_searcher_mode = 'dir'  <CR>
  menu HyfPlugin.CFSearcher.Find\ This\ Word :CFSearch<CR>
  menu HyfPlugin.CFSearcher.-Sep- :
  menu HyfPlugin.CFSearcher.ShowStatus : echo "CFSearcher mode : " . g:cf_searcher_mode <CR>
  menu HyfPlugin.CFSearcher.Help :echo "the short-cut key is `Ctrl-F` "<CR>

  " 或者添加到右键上下文菜单
  menu PopUp.KRunner.Init :KRunInit<CR>
  menu PopUp.KRunner.Deinit :KRunDeinit<CR>
  menu PopUp.KRunner.Run\ This\ Line :call k_runner#api#RunBatCmd()<CR>
  menu PopUp.CFSearcher.SetFileMode :let g:cf_searcher_mode = 'file'  <CR>
  menu PopUp.CFSearcher.SetDirMode  :let g:cf_searcher_mode = 'dir'  <CR>
  menu PopUp.CFSearcher.Find\ This\ Word :CFSearch<CR>
endif
