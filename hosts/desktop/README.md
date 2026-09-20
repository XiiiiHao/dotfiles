# 当前桌面主机的可选配置

本目录只在需要同一套用户目录和 EDIFIER W820NB 耳机优先级的机器上部署，不随通用配置自动应用。

```sh
# 在仓库根目录运行；先备份已有文件，使用 --no-folding 避免接管整个目录。
stow --no-folding --dir=hosts --target="$HOME" desktop
```

- `.config/user-dirs.dirs`：保留当前目录设置，含 `XDG_PROJECTS_DIR`。该附加变量不保证被所有遵循 XDG 的程序识别。
- `.config/wireplumber/wireplumber.conf.d/51-usb-headset.conf`：只对匹配的 EDIFIER USB 耳机提高优先级。

当前机器已经逐文件建立链接。本轮没有重启 WirePlumber，也没有改变目录位置或设备优先级值。新机器如果目录布局/设备不同，应保留自身配置。
