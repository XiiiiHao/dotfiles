# 可移植的应用偏好

DMS、Mark Shot 和 Cursor 会自动回写配置，且同一个 JSON 包含用户偏好与本机状态。本目录保存经过挑选的偏好快照，不直接软链接到应用配置路径。

## 更新仓库快照

应用设置修改完成并保存后，在仓库根目录执行：

```sh
python3 scripts/app-settings.py export dms
python3 scripts/app-settings.py export mark-shot
python3 scripts/app-settings.py export cursor
git diff -- presets/
```

导出只选择现有快照中的字段。新的设置字段或新的 DMS 状态栏需要人工审查后加入快照。导出不会修改本机配置。提交前仍需检查 diff；这个工具不能代替完整的秘密扫描。

## 恢复偏好

先关闭对应应用，避免应用回写与合并操作竞争。然后执行：

```sh
python3 scripts/app-settings.py check dms
python3 scripts/app-settings.py apply dms
python3 scripts/app-settings.py check mark-shot
python3 scripts/app-settings.py apply mark-shot
python3 scripts/app-settings.py check cursor
python3 scripts/app-settings.py apply cursor
```

`check` 只报告是否有待应用差异。`apply` 递归合并选中的偏好，备份存入 `${XDG_STATE_HOME:-~/.local/state}/dotfiles-backups/`。首次运行时可创建配置。重新打开应用后生效。

DMS 的状态栏按 `id` 合并，保留本机 `screenPreferences` 和快照之外的状态栏。新机器可以在 DMS 中选择显示器。第三方插件、天气位置、`clsettings.json` 和运行状态未整体同步。

Mark Shot 保留本机上传/翻译/OCR 配置、环境变量、截图选区历史等未纳入快照的字段。本仓库只同步标注、外观、快捷键、保存路径模板、部分截图与窗口检测偏好。`annotation-state.json` 和截图历史图片不纳入仓库。

Cursor 只同步选定的编辑器、窗口、终端、主题和扩展更新偏好。代理、SSH 主机、背景文件路径和终端自动批准规则留在本机。快捷键另以 `.config/cursor` 包逐文件链接；背景资源与扩展安装需要独立恢复。当前设置是标准 JSON；如果以后加入 JSONC 注释或尾逗号，此工具会拒绝解析，应先人工处理格式，避免丢失注释。

用户配置默认位于 `~/.config`，也支持 `XDG_CONFIG_HOME`。合并部署要求应用 JSON 及其父目录不通过软链接指向其他位置；工具拒绝覆盖这种链接目标。若另有任务将整个应用目录链接进仓库，`check`/`export` 仍可读取，但 `apply` 有差异时会拒绝写入，应先明确选择整目录管理还是偏好合并。
