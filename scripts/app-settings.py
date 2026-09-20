#!/usr/bin/env python3
"""同步经过挑选的应用偏好，保留本机凭据、历史和显示器设置。"""
import argparse
import copy
import json
import os
from pathlib import Path
import shutil
import tempfile

REPO = Path(__file__).resolve().parent.parent
APPS = {"dms": "DankMaterialShell/settings.json", "mark-shot": "mark-shot/config.json",
        "cursor": "Cursor/User/settings.json"}
BLOCKED = {"apikey", "api_key", "token", "password", "secret", "env", "command",
           "selectionhistory", "screenpreferences", "latitude", "longitude"}


def validate(value):
    if isinstance(value, dict):
        for key, child in value.items():
            if key.lower() in BLOCKED:
                raise ValueError(f"本地字段不能进入偏好快照: {key}")
            validate(child)
    elif isinstance(value, list):
        for child in value:
            validate(child)


def project(current, template, key=""):
    """只导出快照中已有的字段；新字段和新状态栏需要人工审查后加入。"""
    if isinstance(template, dict):
        if not isinstance(current, dict):
            raise ValueError(f"字段类型不匹配: {key}")
        return {k: project(current[k], v, k) if k in current else copy.deepcopy(v)
                for k, v in template.items()}
    if key == "barConfigs":
        if not isinstance(current, list):
            raise ValueError("barConfigs 必须为数组")
        by_id = {bar["id"]: bar for bar in current}
        return [project(by_id[bar["id"]], bar) for bar in template if bar["id"] in by_id]
    if isinstance(template, list) and not isinstance(current, list):
        raise ValueError(f"字段类型不匹配: {key}")
    return copy.deepcopy(current)


def merge(current, preset, key=""):
    if isinstance(preset, dict):
        result = copy.deepcopy(current) if isinstance(current, dict) else {}
        for k, v in preset.items():
            result[k] = merge(result.get(k), v, k)
        return result
    if key == "barConfigs":
        result = copy.deepcopy(current) if isinstance(current, list) else []
        for bar in preset:
            index = next((i for i, old in enumerate(result) if old.get("id") == bar["id"]), None)
            if index is None:
                result.append(copy.deepcopy(bar))
            else:
                result[index] = merge(result[index], bar)
        return result
    return copy.deepcopy(preset)


def load(path):
    value = json.loads(path.read_text())
    if not isinstance(value, dict):
        raise ValueError(f"配置必须为 JSON 对象: {path}")
    return value


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as f:
        temp = Path(f.name)
        json.dump(value, f, ensure_ascii=False, indent=2)
        f.write("\n")
    try:
        temp.chmod(0o600)
        os.replace(temp, path)
    finally:
        temp.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["check", "export", "apply"])
    parser.add_argument("app", choices=APPS)
    args = parser.parse_args()
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config")))
    local = config_home / APPS[args.app]
    preset_path = REPO / "presets" / args.app / "settings.json"
    preset = load(preset_path)
    validate(preset)
    current = load(local) if local.exists() else {}
    if args.action == "export":
        if not local.exists():
            raise ValueError(f"找不到本机配置: {local}")
        selected = project(current, preset)
        validate(selected)
        write_json(preset_path, selected)
        print(f"已导出已审查字段，请查看 Git diff: {preset_path}")
        return
    merged = merge(current, preset)
    if args.action == "check":
        print("已同步" if current == merged else "存在待应用的偏好差异")
        return
    if current == merged:
        print("已同步，无需写入")
        return
    if local.is_symlink():
        raise ValueError("应用偏好使用合并部署；请先检查配置软链接，避免写入未知目标")
    before = local.read_bytes() if local.exists() else None
    if before is not None:
        state_home = Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state")))
        backup_root = state_home / "dotfiles-backups"
        backup_root.mkdir(parents=True, exist_ok=True)
        backup_dir = Path(tempfile.mkdtemp(prefix=f"{args.app}-settings-", dir=backup_root))
        backup = backup_dir / local.name
        shutil.copy2(local, backup)
        backup.chmod(0o600)
        # 检测读取后发生的修改，避免用旧数据覆盖应用的新设置。
        if load(local) != current or local.read_bytes() != before:
            raise ValueError("应用配置在操作期间变化，请关闭应用后重试")
        print(f"原配置已备份: {backup}")
    elif local.exists():
        raise ValueError("配置在操作期间出现，请重试")
    write_json(local, merged)
    print(f"偏好已合并，未修改其他本机字段: {local}")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError) as exc:
        raise SystemExit(str(exc))
