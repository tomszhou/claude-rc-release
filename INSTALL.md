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

## 安装 claude-rc

### 方法一：从 GitHub Release 下载

1. 前往 [Releases](https://github.com/tomszhou/claude-rc-release/releases) 页面
2. 下载最新的 `claude-rc-x.x.x.tgz` 文件
3. 执行安装：

```bash
npm install -g claude-rc-2.0.0.tgz
```

### 方法二：直接用 URL 安装

```bash
npm install -g https://github.com/tomszhou/claude-rc-release/releases/download/v2.0.0/claude-rc-2.0.0.tgz
```

## 验证安装

```bash
claude-rc
# 应输出：请先登录: claude-rc login
```

## 首次配置

```bash
# 1. 扫码登录微信
claude-rc login

# 2. 进入项目目录，启动
cd ~/your-project
claude-rc start
```

## 卸载

```bash
npm uninstall -g claude-rc
rm ~/.weixin-mcp.json          # 删除微信 token
```

## 常见问题

### claude-rc: command not found

确认 npm 全局 bin 目录在 PATH 中：

```bash
npm config get prefix
# 确保 <prefix>/bin 在你的 PATH 中
```

### node-pty 编译失败

需要 Xcode Command Line Tools：

```bash
xcode-select --install
```

然后重新安装：

```bash
npm install -g claude-rc-2.0.0.tgz
```
