# claude-rc

微信远程控制 Claude Code。手机发指令，电脑执行，结果发回微信。

```
微信发消息 → claude-rc → Claude Code 执行 → 结果发回微信
```

## 前置条件

- macOS（Linux 未测试）
- Node.js >= 22
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 已安装并登录

## 安装

一键安装（从 GitHub Release 直接装）：

```bash
npm install -g https://github.com/tomszhou/claude-rc-release/releases/download/v2.2.0/claude-rc-2.2.0.tgz
```

或者从 [Releases](https://github.com/tomszhou/claude-rc-release/releases) 下载 tgz 后本地安装：

```bash
npm install -g claude-rc-2.2.0.tgz
```

## 使用

### 1. 登录微信

```bash
claude-rc login
```

终端会显示二维码，微信扫码确认。Token 自动保存到 `~/.weixin-mcp.json`。

### 2. 启动

```bash
cd ~/your-project       # 先进入要操作的项目目录
claude-rc start
```

看到 Claude Code 界面后，就可以在微信上发消息了。

### 3. 发送任务

微信直接发文字，Claude Code 会执行并把结果发回来：

```
查看 git log 最近 5 条
把 src/utils.ts 里的 formatDate 函数改成用 dayjs
运行测试
```

### 4. 交互确认

Claude Code 遇到需要确认的操作时，会转发到微信，选项以编号列表展示：

```
🔔 Claude Code 向你提问：

关于数据库设计...

📋 选项：
1. 保留现有不动（推荐）
2. 全面迁移到分
3. 先看完整文档再决定

回复 /s1~/s3 选择，或直接输入文字。
```

回复 `/s1`、`/s2` 等选择选项。

### 5. 高危操作

`rm -rf`、`git push --force` 等危险操作会被拦截：

```
⚠️ 需要你确认
操作：删除 dist 目录
风险：不可逆删除
请回复【确认】或【取消】
```

### 6. 微信控制命令

| 命令 | 说明 |
|------|------|
| `/h` | 显示帮助 |
| `/s` | 查看状态 + 终端画面截屏 |
| `/v` | 显示版本 |
| `/s1` ~ `/s20` | 选择第 N 个选项 |
| `/submit` | 按 Enter 确认 |
| `/tab` | 按 Tab 切换标签页 |
| `/esc` | 按 Esc 取消 |
| `/redo` | 重发选项提示 |
| `/mm` | 交互式选择模型 |
| `/model sonnet` | 直接切换到 Sonnet |
| `/model opus` | 直接切换到 Opus |
| `/model haiku` | 直接切换到 Haiku |
| `/restart` | 重启 Claude Code |

**多标签页自动引导**：多标签选择界面（如逐题选择）选完当前题后自动切换下一题，最后自动提交。

### 7. 停止

终端按 `Ctrl+C`（按两次强制退出）。

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `CLAUDE_PERMISSION_MODE` | 权限模式：`plan`（默认）/ `auto` / `default` | `plan` |
| `CLAUDE_PATH` | Claude CLI 路径 | 自动检测 |
| `CLAUDE_EXTRA_ARGS` | 额外 Claude CLI 参数 | 无 |
| `BOT_LANG` | 语言 `zh` / `en` | `zh` |

## 注意事项

- 同一时间只处理一个任务，任务执行中发新消息会提示等待
- 仅支持一对一私聊文字消息
- 任何能给你微信发消息的人都可以向 Claude Code 发指令，确保聊天环境安全
- `/model` 切换模型会重启 Claude Code（自动 `--resume` 恢复会话）

## License

MIT
