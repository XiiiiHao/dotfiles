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

## DankMaterialShell

配置继续使用本仓库既有的 `.config/<包>/.config/<名称>` 结构：

- `~/.config/DankMaterialShell` 链接到 `.config/DankMaterialShell/.config/DankMaterialShell`。设置和插件保留；生成的 CSS、版本标记及下载的插件由 `.gitignore` 排除。
- Niri 主配置直接 include `dms.kdl`，由该文件管理 DMS 登录启动、专属快捷键和生成配置引用。
- DMS 通过 `dms run -d` 启动；Niri 的 `spawn-at-startup` 仅在登录时执行，重载配置不会重新启动 DMS。
- DMS 的 Mod+B 切换状态栏，Mod+Shift+W 打开壁纸界面，Mod+Shift+V 打开剪贴板。独立 Matugen 脚本仍读取 DMS 壁纸状态。
- 系统的 `quickshell` 软件包是 `dms-shell` 的运行依赖，需要保留。

迁移机器时，应为 `DankMaterialShell` 建立同样的目录链接。已有目录应先核对内容再迁移，不要直接覆盖。

## 已知独立问题

本机 Vim 为 `-clipboard` 构建，现有 `"+y` / `"+p` 映射需要支持系统剪贴板的 Vim 才能使用。本轮按现有操作习惯同步配置，未更换 Vim 软件包。
