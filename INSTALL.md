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
npm install -g https://github.com/tomszhou/claude-rc-release/releases/download/v2.2.0/claude-rc-2.2.0.tgz
```

### 方法二：下载 tgz 后本地安装

1. 前往 [Releases](https://github.com/tomszhou/claude-rc-release/releases) 页面
2. 下载最新的 `claude-rc-x.x.x.tgz`
3. 执行：

```bash
npm install -g claude-rc-2.2.0.tgz
```

### 验证安装

```bash
claude-rc --version
# 应输出：claude-rc v2.2.0 (2026-03-30 ...)
```

---

## 从旧版本升级

```bash
# 1. 停止正在运行的 claude-rc（终端按 Ctrl+C）

# 2. 卸载旧版本
npm uninstall -g claude-rc

# 3. 安装新版本
npm install -g claude-rc-2.2.0.tgz

# 4. 确认版本
claude-rc --version

# 5. 重新启动
cd ~/your-project
claude-rc start
```

> Token 不需要重新登录，`~/.weixin-mcp.json` 会保留。

---

## 首次配置

```bash
# 1. 扫码登录微信
claude-rc login

# 2. 进入项目目录，启动
cd ~/your-project
claude-rc start
```

---

## 卸载

```bash
npm uninstall -g claude-rc
rm ~/.weixin-mcp.json          # 删除微信 token（可选）
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

### claude-rc --version 显示旧版本或 "未知命令"

全局缓存了旧版本。彻底重装：

```bash
npm uninstall -g claude-rc
npm cache clean --force
npm install -g claude-rc-2.2.0.tgz
```

如果是开发环境用了 `npm link`，先解除：

```bash
cd /path/to/claude-rc
npm unlink
npm install -g claude-rc-2.2.0.tgz
```

### node-pty 编译失败

需要 Xcode Command Line Tools：

```bash
xcode-select --install
```

然后重新安装：

```bash
npm install -g claude-rc-2.2.0.tgz
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
2. 确认 `~/.weixin-mcp.json` 存在且有 token
3. 确认微信 ClawBot 插件已启用（iOS 微信 8.0.70+，设置 → 插件）

### 微信回复数字后没反应

使用 `/s1`、`/s2` 等前缀命令代替直接发数字，更可靠。如果卡住了：

- 发 `/redo` 重新获取选项列表
- 发 `/esc` 取消当前操作
- 发 `/restart` 重启 Claude Code

### 交互提示选项内容不全

发 `/redo` 可以重新获取完整的选项列表。

### IPC 连接不上

MCP Server 由 Claude Code 延迟启动。PTY Runner 会自动重试连接，通常 5-10 秒内建立。

如果持续失败，检查是否有冲突的全局 MCP 配置：

```bash
grep -A5 '"weixin"' ~/.claude.json
```

如果有，删掉它（claude-rc 通过 `--mcp-config` 自动注入）。
