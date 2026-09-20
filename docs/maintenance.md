# 配置整理记录

## 失效入口

以下本机软链接已在仓库外备份后移除，因为目标不存在：

- `~/.custom`
- `~/.config/{code,electron,kiro,qq,typora,windsurf}-flags.conf`
- `~/.config/systemd/user/qs-notifications.service`
- `~/.config/systemd/user/xdg-desktop-autostart.target.wants/sunshine.service`

Code 的旧备份包含 `--disable-gpu`，没有恢复这组过期参数。其他目标没有可确认的源文件。应用继续使用默认参数；以后确实需要自定义时，再创建对应配置并建立正确链接。

有效的 Spotify flags 链接保留。移除 Sunshine 的失效启用链接不等于卸载应用；将来安装并启用对应服务时，由 systemd 重新建立链接。

这些修复发生在仓库外，不会仅凭一次 Git clone 自动应用到已有机器。迁移到已有环境前，应检查软链接目标，不要盲目复用旧机器的链接。

## 已知独立问题

本机 Vim 为 `-clipboard` 构建，现有 `"+y` / `"+p` 映射需要支持系统剪贴板的 Vim 才能使用。本轮按现有操作习惯同步配置，未更换 Vim 软件包。
