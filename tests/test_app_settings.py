import importlib.util
from pathlib import Path
import unittest

SPEC = importlib.util.spec_from_file_location(
    "app_settings", Path(__file__).resolve().parents[1] / "scripts/app-settings.py"
)
settings = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(settings)


class AppSettingsTests(unittest.TestCase):
    def test_merge_preserves_local_history_credentials_and_extra_bars(self):
        current = {
            "translation": {"apiKey": "local-only"},
            "capture": {"selectionHistory": [{"x": 12}], "includeCursor": True},
            "barConfigs": [
                {"id": "default", "position": 1, "screenPreferences": [{"name": "DP-9"}]},
                {"id": "local-extra", "enabled": True},
            ],
        }
        preset = {
            "capture": {"includeCursor": False},
            "barConfigs": [{"id": "default", "position": 0}],
        }
        result = settings.merge(current, preset)
        self.assertEqual(result["translation"], current["translation"])
        self.assertEqual(result["capture"]["selectionHistory"], [{"x": 12}])
        self.assertFalse(result["capture"]["includeCursor"])
        self.assertEqual(result["barConfigs"][0]["screenPreferences"], [{"name": "DP-9"}])
        self.assertEqual(result["barConfigs"][1], current["barConfigs"][1])
        self.assertEqual(current["barConfigs"][0]["position"], 1)
        self.assertEqual(settings.merge(result, preset), result)

    def test_export_uses_approved_shape_and_matches_bar_ids(self):
        current = {
            "translation": {"apiKey": "local-only"},
            "capture": {"selectionHistory": ["private"], "includeCursor": True},
            "barConfigs": [
                {"id": "extra", "position": 2},
                {"id": "default", "position": 3, "screenPreferences": ["local"]},
            ],
        }
        template = {"capture": {"includeCursor": False},
                    "barConfigs": [{"id": "default", "position": 0}]}
        exported = settings.project(current, template)
        self.assertEqual(exported, {"capture": {"includeCursor": True},
                                    "barConfigs": [{"id": "default", "position": 3}]})
        settings.validate(exported)

    def test_sensitive_keys_in_new_widget_objects_are_rejected(self):
        for key in ["apiKey", "env", "command", "screenPreferences", "selectionHistory"]:
            with self.subTest(key=key), self.assertRaises(ValueError):
                settings.validate({"widgets": [{key: "local-only"}]})

    def test_presets_can_bootstrap_new_machine(self):
        preset = {"barConfigs": [{"id": "default", "position": 0}], "fontScale": 1.15}
        self.assertEqual(settings.merge({}, preset), preset)


if __name__ == "__main__":
    unittest.main()
