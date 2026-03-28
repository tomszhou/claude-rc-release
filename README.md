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

从 [Releases](https://github.com/tomszhou/claude-rc-release/releases) 下载最新的 `claude-rc-2.0.0.tgz`，然后：

```bash
npm install -g claude-rc-2.0.0.tgz
```

## 使用

### 1. 登录微信

```bash
claude-rc login
```

终端会显示二维码链接，浏览器打开后微信扫码确认。Token 自动保存到 `~/.weixin-mcp.json`。

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
```

```
把 src/utils.ts 里的 formatDate 函数改成用 dayjs
```

```
运行测试
```

### 4. 交互确认

Claude Code 遇到需要确认的操作时，会转发到微信：

```
🔔 Claude Code 需要你的输入:

  1. Yes
  2. Yes, and always allow
  3. No

请直接回复选项编号或内容。
```

**回复数字**即可选择。

### 5. 高危操作

`rm -rf`、`git push --force` 等危险操作会被拦截，需要你在微信回复「确认」或「取消」：

```
⚠️ 需要你确认

操作：删除 dist 目录
风险：不可逆删除

请回复【确认】或【取消】
```

### 6. 查看状态

微信发 `/s` 或 `/status` 查看 Claude Code 当前状态：

- 空闲中 / 执行任务中 / 可能卡住 / 等待回复 / 已离线

### 7. 停止

终端按 `Ctrl+C`。

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `CLAUDE_PERMISSION_MODE` | 权限模式：`plan`（默认，最安全）/ `auto` / `default` | `plan` |
| `CLAUDE_PATH` | Claude CLI 路径 | 自动检测 |
| `BOT_LANG` | 语言 `zh` / `en` | `zh` |

示例：
```bash
# 自动模式（操作更流畅，安全性较低）
CLAUDE_PERMISSION_MODE=auto claude-rc start
```

## Token 过期

微信会提示「登录已过期」，重新执行：

```bash
claude-rc login
claude-rc start
```

## 注意事项

- 同一时间只处理一个任务，任务执行中发新消息会提示等待
- 仅支持一对一私聊文字消息
- 任何能给你微信发消息的人都可以向 Claude Code 发指令，确保聊天环境安全

## License

MIT
