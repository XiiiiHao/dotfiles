#!/bin/sh
# 安装 PipeWire/WirePlumber 后恢复用户服务的启用状态；不启动或重启服务。
set -eu
for unit in pipewire.service pipewire.socket pipewire-pulse.service pipewire-pulse.socket wireplumber.service; do
    if [ ! -f "/usr/lib/systemd/user/$unit" ]; then
        printf 'Missing system unit: %s\n' "$unit" >&2
        exit 1
    fi
done
systemctl --user enable pipewire.service pipewire.socket pipewire-pulse.service pipewire-pulse.socket wireplumber.service
