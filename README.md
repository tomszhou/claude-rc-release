# claude-rc

微信/钉钉远程控制 Claude Code。手机发指令，电脑执行，结果发回手机。

```
手机发消息 → claude-rc → Claude Code 执行 → 结果发回手机
```

支持微信和钉钉，同一套命令体系，切换渠道只需换一个参数。

## 前置条件

- macOS（Linux 未测试）
- Node.js >= 22
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 已安装并登录

## 安装

一键安装（从 GitHub Release 直接装）：

```bash
npm install -g https://github.com/tomszhou/claude-rc-release/releases/download/latest/claude-rc-latest.tgz
```

或者从 [Releases](https://github.com/tomszhou/claude-rc-release/releases) 下载 tgz 后本地安装：

```bash
npm install -g claude-rc-latest.tgz
```

## 使用

### 1. 登录/配置

**微信：**

```bash
claude-rc login
# 或
claude-rc --weixin login
```

终端显示二维码，微信扫码确认。Token 自动保存到 `~/.claude-rc.json`。

**钉钉：**

```bash
claude-rc --dingtalk login
```

交互式输入 AppKey 和 AppSecret，然后在钉钉上私聊机器人发送验证码，自动获取你的 staffId。配置保存到 `~/.claude-rc.json`。

### 2. 启动

```bash
cd ~/your-project       # 先进入要操作的项目目录

# 微信（默认）
claude-rc

# 钉钉
claude-rc --dingtalk
```

看到 Claude Code 界面后，就可以在手机上发消息了。

### 3. 启动参数

```bash
claude-rc --model opus                # 指定模型
claude-rc --permission-mode plan      # 指定权限模式
claude-rc --add-dir /tmp/data         # 额外允许访问的目录
claude-rc --allowed-tools Edit Read   # 指定允许的工具
```

参数可以组合使用：

```bash
claude-rc --dingtalk --model opus --permission-mode plan
```

| 参数 | 说明 |
|------|------|
| `--model <名>` | 模型：`sonnet` / `opus` / `haiku` 或完整 ID |
| `--permission-mode <模式>` | 权限模式：`default`（默认）/ `plan` / `auto` / `bypassPermissions` |
| `--allowed-tools <工具...>` | 允许的工具列表（空格分隔） |
| `--add-dir <目录...>` | 额外允许访问的目录（空格分隔） |

### 4. 本地配置（多实例）

默认配置在 `~/.claude-rc.json`（全局）。加 `--local` 使用当前目录的 `./claude-rc.json`，支持多实例互不干扰：

```bash
# 项目 A
cd ~/project-a
claude-rc --local login    # 扫码，保存到 ./claude-rc.json
claude-rc --local          # 用本地配置启动

# 项目 B 用钉钉
cd ~/project-b
claude-rc --dingtalk --local login
claude-rc --dingtalk --local
```

> 注意：`claude-rc.json` 含 token/密钥，使用 `--local` 时请确保已加入 `.gitignore`。

### 5. 发送任务

直接发文字，Claude Code 会执行并把结果发回来：

```
查看 git log 最近 5 条
把 src/utils.ts 里的 formatDate 函数改成用 dayjs
运行测试
```

任务执行中发新消息会自动排队（最多 5 条），不再丢弃。

### 6. 交互确认

Claude Code 遇到需要确认的操作时，会转发到手机，选项以编号列表展示：

```
🔔 Claude Code 向你提问：

关于数据库设计...

📋 选项：
1. 保留现有不动（推荐）
2. 全面迁移到分表
3. 先看完整文档再决定

回复 /1~/3 选择，或直接输入文字。
```

回复 `/1`、`/2` 等选择选项。

### 7. 控制命令

**状态与帮助**

| 命令 | 说明 |
|------|------|
| `/s` | 查看状态 + 终端画面截屏 |
| `/h` | 显示帮助 |

**选项操作**

| 命令 | 说明 |
|------|------|
| `/1` ~ `/20` | 选择第 N 个选项 |
| `/ok` | 按 Enter 确认 |
| `/esc` | 按 Esc 取消 |
| `/tab` | 按 Tab 切换标签页 |
| `/redo` | 重发选项提示 |

**系统**

| 命令 | 说明 |
|------|------|
| `/model sonnet` | 切换到 Sonnet |
| `/model opus` | 切换到 Opus |
| `/model haiku` | 切换到 Haiku |
| `/restart` | 重启 Claude Code |
| `/boot` | 重新注入工作循环（Claude 停止响应时的补救） |
| `/cc <cmd>` | 透传斜杠命令（如 `/cc compact`） |

**模式切换**

| 命令 | 说明 |
|------|------|
| `/local` | 进入本地终端模式（手机暂停控制，回到终端操作） |
| `/remote` | 恢复远程控制 |

**队列管理**

| 命令 | 说明 |
|------|------|
| `/q` | 查看消息队列 |
| `/clear` | 清空队列 |
| `/cancel` | 取消当前任务 |

**确认操作**

| 操作 | 回复 |
|------|------|
| 确认 | 确认 / 是 / ok |
| 取消 | 取消 / 否 |

**多标签页自动引导**：多标签选择界面（如逐题选择）选完当前题后自动切换下一题，最后自动提交。

### 8. 停止

终端按 `Ctrl+C`（按两次强制退出）。

## v3.0 新特性

- **钉钉支持**：`claude-rc --dingtalk`，交互式配置，验证码自动获取 userId
- **消息队列**：任务执行中新消息自动排队（最多 5 条），不再丢弃
- **命令精简**：22 个命令精简到 16 个，去除所有别名
- **智能分段**：超长回复自动按段落边界分段发送
- **循环自愈**：Claude 停止响应时自动重新注入，连续 3 次失败通知用户
- **Compact 监测**：上下文压缩时自动通知
- **`/cc clear` 自动恢复**：清空上下文后自动重新注入工作循环
- **空闲零消耗**：空闲等待不再消耗上下文 token

## 从旧版本升级

v3.0 的主要变化：
- 命令变更：`/s1`~`/s20` → `/1`~`/20`，`/submit` → `/ok`，`/cc weixin` → `/boot`
- 移除：`/v`、`/mm`、`/status`（用 `/s`）、`/help`（用 `/h`）、`/enter`、`/escape`、`/resend`、`/reboot`
- 配置文件格式不变，自动兼容

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `CLAUDE_PATH` | Claude CLI 路径 | 自动检测 |
| `CLAUDE_EXTRA_ARGS` | 额外 Claude CLI 参数（兜底透传） | 无 |
| `BOT_LANG` | 语言 `zh` / `en` | `zh` |

## 注意事项

- 同一时间处理一个任务，新消息自动排队（最多 5 条）
- 仅支持一对一私聊消息（微信/钉钉群聊消息会被忽略）
- 微信：任何能给你微信发消息的人都可以发指令，确保聊天环境安全
- 钉钉：只响应配置的 userId，其他人的消息会被拒绝
- `/model` 切换模型会重启 Claude Code（自动 `--resume` 恢复会话）

## License

MIT
