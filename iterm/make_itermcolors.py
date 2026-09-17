#!/usr/bin/env python3
"""Generate .itermcolors presets and the dynamic profile from palettes.py.

Usage: python3 make_itermcolors.py  (writes <name>.itermcolors next to itself)
"""
import json
import sys
from pathlib import Path

here = Path(__file__).resolve().parent
sys.path.insert(0, str(here.parent))
from palettes import PALETTES, rgb  # noqa: E402

ENTRY = """\t<key>{name} Color</key>
\t<dict>
\t\t<key>Color Space</key>
\t\t<string>sRGB</string>
\t\t<key>Red Component</key>
\t\t<real>{r:.10f}</real>
\t\t<key>Green Component</key>
\t\t<real>{g:.10f}</real>
\t\t<key>Blue Component</key>
\t\t<real>{b:.10f}</real>
\t\t<key>Alpha Component</key>
\t\t<real>1</real>
\t</dict>
"""

HEADER = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
"""

for name, colors in PALETTES.items():
    out = HEADER
    for key in sorted(colors):
        r, g, b = rgb(colors[key])
        out += ENTRY.format(name=key, r=r, g=g, b=b)
    out += "</dict>\n</plist>\n"
    (here / f"{name}.itermcolors").write_text(out)
    print(f"wrote {name}.itermcolors")


# ── iTerm2 dynamic profile ────────────────────────────────────────────────────
# Bundles the headroom palette with the key mappings + font extracted from the
# original profile (keyboard-map.json). install.sh drops the output into
# ~/Library/Application Support/iTerm2/DynamicProfiles; iTerm2 picks it up
# live. Everything not specified inherits from the "Default" profile.

def color_component(hexval):
    r, g, b = rgb(hexval)
    return {
        "Color Space": "sRGB",
        "Red Component": r, "Green Component": g, "Blue Component": b,
        "Alpha Component": 1,
    }

keymap = json.loads((here / "keyboard-map.json").read_text())
profile = {
    "Name": "Headroom",
    "Guid": "headroom-terminal-profile",
    "Dynamic Profile Parent Name": "Default",
    "Normal Font": keymap["Normal Font"],
    "Keyboard Map": keymap["Keyboard Map"],
    "Minimum Contrast": 0,
}
for key, hexval in PALETTES["headroom-dark"].items():
    profile[f"{key} Color"] = color_component(hexval)

(here / "headroom.profile.json").write_text(
    json.dumps({"Profiles": [profile]}, indent=2, sort_keys=True) + "\n")
print("wrote headroom.profile.json")
