# 安装指南

## 系统要求

- macOS（Linux 未测试）
- Node.js >= 22（`node --version` 检查）
- Claude Code CLI 已安装并登录

### 安装 Claude Code（如未安装）

```bash
npm install -g @anthropic-ai/claude-code
claude auth login
```

---

## 全新安装

### 方法一：从 GitHub Release 直接安装

```bash
npm install -g https://github.com/tomszhou/claude-rc-release/releases/download/latest/claude-rc-latest.tgz
```

### 方法二：下载 tgz 后本地安装

1. 前往 [Releases](https://github.com/tomszhou/claude-rc-release/releases) 页面
2. 下载最新的 `claude-rc-x.x.x.tgz`
3. 执行：

```bash
npm install -g claude-rc-latest.tgz
```

### 验证安装

```bash
claude-rc --version
# 应输出：claude-rc v3.0.0 (2026-04-08 ...)
```

---

## 从旧版本升级

```bash
# 1. 停止正在运行的 claude-rc（终端按 Ctrl+C）

# 2. 卸载旧版本
npm uninstall -g claude-rc

# 3. 安装新版本
npm install -g claude-rc-latest.tgz

# 4. 确认版本
claude-rc --version

# 5. 重新启动
cd ~/your-project
claude-rc
```

> Token 不需要重新登录，`~/.claude-rc.json` 会保留。

### v3.0 命令变更

| 旧命令 | 新命令 | 说明 |
|--------|--------|------|
| `/s1`~`/s20` | `/1`~`/20` | 选择选项 |
| `/submit` / `/enter` | `/ok` | 确认 |
| `/cc weixin` | `/boot` | 重新注入工作循环 |
| `/mm` | `/model <名>` | 切换模型 |
| `/v` | `/h` | 版本信息合并到帮助 |
| `/status` | `/s` | 查看状态 |

新增命令：`/q`（查看队列）、`/clear`（清空队列）、`/cancel`（取消当前任务）、`/boot`（重新注入）

---

## 首次配置

### 微信

```bash
# 1. 扫码登录微信
claude-rc login

# 2. 进入项目目录，启动
cd ~/your-project
claude-rc
```

### 钉钉

```bash
# 1. 配置钉钉（交互式输入 AppKey/AppSecret + 验证码获取 userId）
claude-rc --dingtalk login

# 2. 进入项目目录，启动
cd ~/your-project
claude-rc --dingtalk
```

#### 钉钉配置前提

1. 在[钉钉开放平台](https://open-dev.dingtalk.com/)创建企业内部应用
2. 开启"机器人"能力，配置消息接收模式为 **Stream 模式**
3. 准备好 AppKey 和 AppSecret

---

## 卸载

```bash
npm uninstall -g claude-rc
rm ~/.claude-rc.json          # 删除配置（可选）
```

---

## 常见问题

### claude-rc: command not found

npm 全局 bin 目录不在 PATH 中：

```bash
# 查看 npm 全局 bin 路径
npm config get prefix
# 确保 <prefix>/bin 在你的 PATH 中，例如：
export PATH="$(npm config get prefix)/bin:$PATH"
```

### claude-rc --version 显示旧版本

全局缓存了旧版本。彻底重装：

```bash
npm uninstall -g claude-rc
npm cache clean --force
npm install -g claude-rc-latest.tgz
```

如果是开发环境用了 `npm link`，先解除：

```bash
cd /path/to/claude-rc
npm unlink
npm install -g claude-rc-latest.tgz
```

### node-pty 编译失败

需要 Xcode Command Line Tools：

```bash
xcode-select --install
```

然后重新安装：

```bash
npm install -g claude-rc-latest.tgz
```

### posix_spawnp failed

node-pty 与 Node.js 版本不兼容。确保 Node.js >= 22：

```bash
node --version
```

### 终端二维码显示不出来

`claude-rc login` 时如果二维码无法显示，复制终端输出的链接在浏览器中打开，用微信扫码。

### Ctrl+C 无法退出

按两次 Ctrl+C 强制退出。如果仍然无法退出：

```bash
# 查找进程
ps aux | grep claude-rc
# 手动 kill
kill -9 <PID>
```

### 微信收不到消息

1. 确认 token 没过期：收到「登录已过期」提示时重新 `claude-rc login`
2. 确认 `~/.claude-rc.json` 存在且有 token
3. 确认微信 ClawBot 插件已启用（iOS 微信 8.0.70+，设置 → 插件）

### 钉钉收不到消息

1. 确认 `~/.claude-rc.json` 中有 `dingtalk` 配置
2. 确认钉钉应用的"机器人"能力已开启，消息模式为 Stream
3. 确认是通过**私聊**发的消息（群聊消息会被忽略）
4. 发 `/s` 检查状态

### 选项操作没反应

- 用 `/1`、`/2` 等命令选择（注意是斜杠加数字）
- 发 `/redo` 重新获取选项列表
- 发 `/esc` 取消当前操作
- 发 `/boot` 重新注入工作循环
- 发 `/restart` 重启 Claude Code

### IPC 连接不上

MCP Server 由 Claude Code 延迟启动。PTY Runner 会自动重试连接，通常 5-10 秒内建立。

如果持续失败，检查是否有冲突的全局 MCP 配置：

```bash
cat ~/.claude.json | grep -A5 '"weixin"\|"dingtalk"'
```

如果有，删掉它（claude-rc 通过 `--mcp-config` 自动注入）。
