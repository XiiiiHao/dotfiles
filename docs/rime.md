# Rime 自定义配置

同步的源文件位于 `.local/local/.local/share/fcitx5/rime/`：

- `default.custom.yaml`：已有默认设置。
- `rime_ice.custom.yaml`：雾凇拼音自定义补丁及语法模型设置。
- `rime.lua`：加载 `llm_translator`。

当前机器通过软件包提供以下依赖（包名按 Arch 环境记录）：

- `rime-ice-git`：雾凇方案。
- `rime-wanxiang-gram-zh-hans`：`wanxiang-lts-zh-hans.gram`。
- `rime-llm-translator-git`：`/usr/share/rime-data/lua/llm_translator.lua`。

新机器需要先安装相应依赖，再部署自定义配置并由 Fcitx5/Rime 执行重新部署。其他发行版按实际包名或上游安装说明处理。

`~/.config/rime-llm-translator/config.lua` 可能包含接口凭据，应在本机配置或加密管理，不同步到普通 Git。LLM 翻译的网络服务取决于这份本地配置；仅恢复 dotfiles 并不等于服务可用。

`build/`、`*.userdb/`、`sync/`、`installation.yaml`、`user.yaml` 属于编译结果、学习数据或机器状态，不整体纳入 dotfiles。拼音 `user.dict` 和 `user.history` 已停止跟踪，但保留在本机并另行备份；这不清除旧 Git 历史中的副本。
