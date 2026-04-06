# GHS MULTI 脚本培训版 Cheatsheet

下面这份是 **面向新手培训的 GHS MULTI 脚本 cheatsheet**。  
目标是做到：

- **能直接拿去培训**
- **命令都尽量基于手册内容**
- **突出“脚本为什么比手工点 GUI 更方便”**
- **适合实际调试现场演示**

我这里引用的命令能力，主要来自 `MULTI: Debugging Command Reference` 中的这些命令：

- `usage` / `help`
- `echo` / `mprintf` / `print`
- `output`
- `define`
- `if / while / for / do`
- `wait`
- `source`
- `<`、`>`、`>>`
- `bpsave` / `bpload`
- `save` / `restore`
- `monitor`
- `window`
- `python`
- `taskwindow` / `creategroup` / `groupaction` / `setsync` 等

---

## 一、培训目标

给新手的目标不要太大，建议分成 4 个层次：

### Level 1：会“录”和“放”
让他知道：

- 命令行里输入的操作可以录下来
- 下次可以一键回放
- 重复调试动作不用每次手点

### Level 2：会“写小脚本”
让他知道：

- 用 `< script.txt` 执行脚本
- 脚本里可以放：
  - 断点
  - 打印变量
  - 运行 / 等待 / 单步
  - 输出到文件

### Level 3：会“写宏”
让他知道：

- `define` 可以封装常用动作
- 调试动作可以参数化
- 例如：
  - “打印 16 字节 buffer”
  - “一键停到某函数并打印上下文”

### Level 4：体会“自动化收益”
让他亲眼看到：

- 手工重复 20 次点击  
  vs  
- 一条脚本反复执行

这才是培训的关键。

---

## 二、新手先记住的 10 个最重要命令

这是我建议培训时第一页就给他的。

### 1) `help`
看帮助文档：

【示例命令】

help output  
help define  
help wait

### 2) `usage`
看命令语法：

【示例命令】

usage output  
usage define  
usage b

这个对新手特别重要。  
因为很多时候他不是不会调试，而是**忘了命令格式**。

---

### 3) `echo`
打印纯文本：

【示例命令】

echo start debug

适合脚本里做提示。

---

### 4) `mprintf`
格式化打印：

【示例命令】

mprintf("x=%d y=%d\n", x, y)

适合脚本里打印变量。

---

### 5) `print`
打印表达式：

【示例命令】

print x  
print/x x  
print cmacTag[0]

---

### 6) `b`
下断点：

【示例命令】

b main  
b foo#12  
b { echo hit breakpoint; }

---

### 7) `c` / `cb`
继续运行：

【示例命令】

c  
cb

`cb` 很适合脚本，因为它会**阻塞等待程序停下来**。

---

### 8) `wait`
等目标状态变化：

【示例命令】

wait  
wait -time 1000  
wait -stop

很适合脚本同步。

---

### 9) `output`
把输出导到文件：

【示例命令】

output -multi log.txt  
output -show  
output -multi -normal

这是“写入 log.txt”的关键命令。  
手册里明确写了 `output` 可以把 Debugger 输出重定向到文件。

---

### 10) `<`
执行脚本文件：

【示例命令】

< myscript.txt

这个是脚本自动化入口。

---

## 三、先讲清楚：MULTI 里的“脚本”到底是什么

培训时建议你先用这三句话解释：

### 1. 最简单的脚本
就是一个文本文件，里面一行一条 MULTI 命令。

例如 `demo.txt`：

【demo.txt 内容】

echo hello  
b main  
r

执行：

【执行命令】

< demo.txt

---

### 2. MULTI 可以录制命令
你在命令行做过的动作，可以记录成脚本文件。

开始录：

【开始录制】

> demo_record.txt

停止录：

【停止录制】

> c

回放：

【回放命令】

< demo_record.txt

---

### 3. MULTI 还有“宏”
宏比纯文本脚本更强，因为可以带参数。

例如：

【宏定义】

define px(v) { print/x v }

调用：

【调用宏】

px(x)

---

## 四、培训用最小示范 1：三分钟体验“脚本比手工快”

这是最适合开场的示范。

### 场景
每次调试你都要做这些动作：

1. 打个断点到 `main`
2. 运行
3. 程序停下来后打印几个变量
4. 看 call stack
5. 保存现场

手工每次都重复。

---

### 手工版
【手工调试命令】

b main  
r  
print/x state  
print cnt  
calls  
save quickstate.txt

---

### 脚本版：`startup_demo.txt`
【startup_demo.txt 内容】

echo === startup demo begin ===  
b main  
r  
wait  
print/x state  
print cnt  
calls  
save quickstate.txt  
echo === startup demo end ===

执行：

【执行命令】

< startup_demo.txt

---

### 培训时要强调的点
告诉新人：

- 如果你每天都要做 10 次
- 一次 20 秒
- 一天就是 200 秒以上
- 用脚本后就是 1 条命令

**这就是脚本的价值**

---

## 五、培训用最小示范 2：录制与回放

这个特别适合新手，因为**不需要先会写脚本**。

### 第一步：开始录制命令
【开始录制】

> training_record.txt

根据手册，`>` 用来录命令。  
如果不给 `t/f/c`，而是给文件名，就开始录到这个文件。

---

### 第二步：让新人手工做一遍
【手工操作】

b main  
r  
wait  
print x  
print y  
calls

---

### 第三步：停止录制
【停止录制】

> c

这里 `c` 是 close recording file。

---

### 第四步：回放
【回放命令】

< training_record.txt

---

### 培训要点
这时候新人会立刻明白：

- “原来我刚才命令行做的事情可以复用”
- “原来脚本不一定从零写”
- “我可以先手工一次，再录成模板”

这个接受度非常高。

---

## 六、培训用最小示范 3：把调试输出写到文件

这个是最容易让人觉得“脚本真有用”的点之一。

### 示例：把 command pane 输出导到文件
【输出重定向】

output -multi log.txt

如果想追加：

【追加输出】

output -multi -append log.txt

查看当前设置：

【查看设置】

output -show

恢复正常输出：

【恢复默认】

output -multi -normal

这些都能在手册 `output` 条目中找到。

---

### 培训脚本：`collect_vars.txt`
【collect_vars.txt 内容】

output -multi -append vars.log  
echo ===== collect vars begin =====  
print/x state  
print cnt  
mprintf("rx_len=%d\n", rx_len)  
calls  
echo ===== collect vars end =====  
output -multi -normal

执行：

【执行命令】

< collect_vars.txt

---

### 培训时要强调
这意味着：

- 不用手工复制 command pane
- 不用截图留证据
- 能生成可比较、可归档的文本日志

这对现场问题复现非常关键。

---

## 七、培训用最小示范 4：写一个“打印 buffer”的宏

这个非常贴近嵌入式调试实际。

假设：

【C 变量示例】

uint8_t cmacTag[16];

### 宏版本
【宏定义】

define dump_cmac() {  
    echo ==== cmacTag dump ====  
    print/x cmacTag[0]  
    print/x cmacTag[1]  
    print/x cmacTag[2]  
    print/x cmacTag[3]  
    print/x cmacTag[4]  
    print/x cmacTag[5]  
    print/x cmacTag[6]  
    print/x cmacTag[7]  
    print/x cmacTag[8]  
    print/x cmacTag[9]  
    print/x cmacTag[10]  
    print/x cmacTag[11]  
    print/x cmacTag[12]  
    print/x cmacTag[13]  
    print/x cmacTag[14]  
    print/x cmacTag[15]  
}

调用：

【调用命令】

dump_cmac()

---

### 培训时讲的核心
这不是为了炫技，而是为了让新人理解：

- **脚本最开始并不需要复杂**
- 把“常做动作”打包起来，就是效率提升

---

## 八、培训用最小示范 5：断点命中时自动打印

这是“脚本 + 断点”的第一次组合，非常适合展示 MULTI 的强大之处。

根据手册，`b` 支持 `{commands}` 命令列表。

### 示例
【断点自动打印】

b foo {  
    echo === hit foo ===  
    mprintf("cnt=%d state=%d\n", cnt, state)  
}

程序每次进入 `foo`，都会自动打印。

---

### 进一步：命中后自动继续
【断点打印并继续】

b foo {  
    mprintf("foo entered, cnt=%d\n", cnt)  
    resume  
}

适合做轻量 tracing。

---

### 培训时要强调
这和普通“只停住”断点不同。  
它能变成：

- 自动日志点
- 条件采样点
- 快速在线追踪工具

这时新人会开始明白：  
**MULTI 脚本不是只是“批处理”，而是调试逻辑自动化。**

---

## 九、培训用最小示范 6：脚本里控制执行节奏

新手很容易在脚本里踩坑：

- 程序还没停住就去 print
- 还没跑完就继续下一条命令

所以培训时必须讲 `cb` 和 `wait`。

### 推荐模式 A：用 `cb`
【示例】

b main  
rb  
print x

`rb` 会阻塞，直到程序停住。

---

### 推荐模式 B：用 `r` + `wait`
【示例】

b main  
r  
wait  
print x

---

### 推荐模式 C：单步时用 `wait`
手册里举了很典型的例子：

【示例】

b {  
    s  
    wait  
    s  
    wait  
    s  
}

意思是每一步都等完成，再做下一步。

---

### 培训重点
告诉新人：

> 脚本里的最大敌人不是语法错误，而是**时序错误**

所以：

- 跑了要等
- 单步了要等
- attach 了要等
- 目标状态变了要等

---

## 十、培训用最小示范 7：保存 / 恢复断点和会话

这个对培训非常有用，因为新人会问：

> “我下次还要重新配一遍吗？”

答案：不一定。

### 保存整个调试状态
【保存会话】

save mystate.txt

### 恢复
【恢复会话】

restore mystate.txt

---

### 只保存断点
【保存断点】

bpsave mybp.txt

### 恢复断点
【恢复断点】

bpload mybp.txt

---

### 培训要点
这表示：

- 脚本 + 断点布局 可以作为团队资产共享
- 培训老师可以发一份标准调试入口给新人
- 不用每个人重复配置一次

---

## 十一、培训用最小示范 8：source path 脚本化

很多新手第一次调试会遇到：

- source file 找不到
- 文件路径不对
- 工程挪目录后打不开源码

这时就可以用：

【示例命令】

source  
source -  
source C:\proj\src C:\proj\drv  
sourceroot remap C:\old\src D:\new\src

---

### 培训示范脚本：`env_setup.txt`
【env_setup.txt 内容】

echo === source path setup ===  
source -  
source C:\work\app\src C:\work\app\drv C:\work\app\osal

---

### 培训意义
让新人明白：

- 环境初始化也可以脚本化
- 路径修复不一定非得 GUI 点来点去

---

## 十二、培训用最小示范 9：宏参数化

这个是让新人从“会用脚本”升级到“会封装工具”的关键一步。

### 一个简单宏：打印 4 个 word
【宏定义】

define dump4(base) {  
    print/x *(unsigned int *)base  
    print/x *((unsigned int *)base + 1)  
    print/x *((unsigned int *)base + 2)  
    print/x *((unsigned int *)base + 3)  
}

调用：

【调用命令】

dump4(cmacTag)  
dump4(rxBuf)

---

### 一个简单宏：到某函数下断点并运行
【宏定义】

define run2(func) {  
    b func  
    r  
    wait  
}

调用：

【调用命令】

run2(main)  
run2(foo)

---

### 培训要点
让新人理解：

- 宏 = 调试动作函数化
- 以后团队里可以积累“调试函数库”

---

## 十三、培训用最小示范 10：条件逻辑

手册里支持：

- `if`
- `for`
- `while`
- `do`
- `break`
- `continue`

这个对新手不用讲太深，但至少要演示 1 个。

### 示例：根据变量值打印不同信息
【示例】

if (state == 0) {  
    echo state is IDLE  
} else {  
    echo state is not IDLE  
}

---

### 示例：循环打印数组
【示例】

for ($i=0; $i<8; ++$i) {  
    print/x rxBuf[$i]  
}

> 这里 `$i` 是调试器变量风格用法，培训时可以顺带提一句：  
> MULTI 脚本里也能写简单循环。

---

### 培训要点
这一节不要追求新人完全掌握。  
只要让他知道：

> “脚本不只是顺序执行，也能做判断和循环。”

就够了。

---

## 十四、推荐给新手的“培训现场演示顺序”

我建议你培训时按下面这个顺序走，效果最好：

### 演示 1：直接命令
【示例】

b main  
r  
print x

让他知道 MULTI 命令行能做什么。

---

### 演示 2：录制
【示例】

> rec.txt  
b main  
r  
wait  
print x  
> c  
< rec.txt

让他第一次体会“自动回放”。

---

### 演示 3：脚本文件
`demo.txt`

【demo.txt 内容】

echo begin  
b main  
r  
wait  
print x  
echo end

执行：

【执行命令】

< demo.txt

让他知道脚本其实就是文本文件。

---

### 演示 4：输出到文件
【示例】

output -multi run.log  
< demo.txt  
output -multi -normal

让他看到“脚本 + 文件日志”的价值。

---

### 演示 5：断点命令列表
【示例】

b foo { mprintf("foo cnt=%d\n", cnt); resume }

让他看到“自动化断点”的威力。

---

### 演示 6：宏
【示例】

define px(v) { print/x v }  
px(x)

让他知道“脚本还能封装”。

---

### 演示 7：保存状态
【示例】

bpsave bp.txt  
save sess.txt

让他知道成果可复用。

---

## 十五、适合培训发给新人的 cheatsheet 成品

下面这份你可以直接发新人。

---

### GHS MULTI 脚本 Cheatsheet

#### 1. 查看帮助
【示例】

help output  
usage output  
help define  
usage define

---

#### 2. 执行脚本
【示例】

< myscript.txt

---

#### 3. 录制命令
开始录制：

【开始录制】

> record.txt

停止录制并关闭：

【停止录制】

> c

回放：

【回放】

< record.txt

---

#### 4. 打印
纯文本：

【示例】

echo hello

格式化打印：

【示例】

mprintf("x=%d y=%d\n", x, y)

表达式：

【示例】

print x  
print/x x

---

#### 5. 断点
【示例】

b main  
b foo#12  
B  
d main#12  
tog off *  
tog on *

---

#### 6. 运行控制
【示例】

r  
R  
c  
cb  
s  
S  
si  
Si  
wait  
wait -time 1000

---

#### 7. 输出重定向到文件
【示例】

output -multi log.txt  
output -multi -append log.txt  
output -show  
output -multi -normal

---

#### 8. 保存 / 恢复
保存断点：

【示例】

bpsave bp.txt

恢复断点：

【示例】

bpload bp.txt

保存会话：

【示例】

save sess.txt

恢复会话：

【示例】

restore sess.txt

---

#### 9. 源码路径
查看：

【示例】

source

重设：

【示例】

source -  
source C:\proj\src C:\proj\drv

---

#### 10. 定义宏
【示例】

define px(v) { print/x v }  
px(x)

---

#### 11. 条件 / 循环
【示例】

if (state == 0) { echo idle } else { echo busy }

for ($i=0; $i<8; ++$i) {  
    print/x buf[$i]  
}

---

#### 12. 断点命中自动执行命令
【示例】

b foo {  
    mprintf("hit foo cnt=%d\n", cnt)  
}

自动打印后继续：

【示例】

b foo {  
    mprintf("hit foo cnt=%d\n", cnt)  
    resume  
}

---

## 十六、培训用“示范脚本模板”

下面给你几份可以直接培训演示的脚本。

---

### 模板 1：启动调试模板 `start_debug.txt`
【start_debug.txt 内容】

echo === start_debug begin ===  
b main  
r  
wait  
calls  
echo === start_debug end ===

---

### 模板 2：采集变量模板 `collect_vars.txt`
【collect_vars.txt 内容】

output -multi -append vars.log  
echo ===== collect vars begin =====  
print/x state  
print cnt  
mprintf("rx_len=%d\n", rx_len)  
calls  
echo ===== collect vars end =====  
output -multi -normal

---

### 模板 3：打印 16 字节 buffer `dump_cmac.txt`
【dump_cmac.txt 内容】

echo ==== cmacTag dump ====  
print/x cmacTag[0]  
print/x cmacTag[1]  
print/x cmacTag[2]  
print/x cmacTag[3]  
print/x cmacTag[4]  
print/x cmacTag[5]  
print/x cmacTag[6]  
print/x cmacTag[7]  
print/x cmacTag[8]  
print/x cmacTag[9]  
print/x cmacTag[10]  
print/x cmacTag[11]  
print/x cmacTag[12]  
print/x cmacTag[13]  
print/x cmacTag[14]  
print/x cmacTag[15]

---

### 模板 4：宏模板 `macros.txt`
【macros.txt 内容】

define px(v) { print/x v }

define dump4(base) {  
    print/x *(unsigned int *)base  
    print/x *((unsigned int *)base + 1)  
    print/x *((unsigned int *)base + 2)  
    print/x *((unsigned int *)base + 3)  
}

执行后可直接用：

【调用示例】

< macros.txt  
px(state)  
dump4(cmacTag)

---

### 模板 5：断点自动日志 `trace_foo.txt`
【trace_foo.txt 内容】

b foo {  
    mprintf("foo entered cnt=%d state=%d\n", cnt, state)  
    resume  
}

---

## 十七、培训时一定要提醒新人的坑

### 1. GUI only 命令
有些命令手册里明确标了 `GUI only`，比如：

- `monitor`
- `callsview`
- `debugbutton`
- `mouse`
- `taskwindow`
- `creategroup`

如果是在非 GUI 环境，可能不能用。

---

### 2. 脚本时序问题
最常见：

【错误示例】

r  
print x

有可能程序还没停。  
要改成：

【正确示例】

r  
wait  
print x

或直接：

【另一种写法】

rb  
print x

---

### 3. 录制文件和回放文件不要混用
手册明确提醒：

- 不能一边录一个文件一边又拿同一个文件回放

---

### 4. `output` 重定向的是哪类输出要分清
手册里分：

- `-multi`：command pane 输出
- `-io`：程序 I/O pane
- `-server`：target/debug server 输出

培训时一定让新人知道区别。

---

### 5. 断点命令列表要注意 `resume`
有 `resume` 的断点不会停住。

比如：

【示例】

b foo { echo hit; resume }

这更像 tracepoint，不是普通 stop breakpoint。

---

### 6. Task Group 命令前提：Task Manager 要开着
手册里明确写了：

- `creategroup`
- `changegroup`
- `destroygroup`
- `groupaction`
- `listgroup`
- `setsync`
- `showsync`

都要求 **Task Manager must be open**。

---

## 十八、如果你要把它做成“公司内部培训讲义”，建议结构

建议你整理成下面格式：

### 第 1 页：为什么要学 MULTI 脚本
- 减少重复点击
- 固化调试流程
- 方便复现与交接
- 自动生成日志

### 第 2 页：10 个最常用命令
- `<`
- `>`
- `echo`
- `print`
- `mprintf`
- `b`
- `c/cb`
- `wait`
- `output`
- `define`

### 第 3 页：3 个最小脚本例子
- 启动调试
- 导出日志
- 自动打印 buffer

### 第 4 页：宏和参数化
- `define px(v)`
- `define dump4(base)`

### 第 5 页：常见坑
- GUI only
- wait 时序
- output 类型
- resume 行为
- task group 前提

这样新手最容易吸收。

---

## 十九、给你的最终建议

如果你的目标是 **“让新手快速上手，并且体会脚本便利”**，那培训时不要一上来讲太多高级语法。  
最有效的是这三步：

### 第一步：让他看到收益
录一段命令再回放。

### 第二步：让他会改模板
改一个 `print x` 为 `print y`。

### 第三步：让他会自己写一个 5 行脚本
比如：
- 下断点
- 运行
- 等待
- 打印变量
- 记日志

做到这一步，培训就成功了。
