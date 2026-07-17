#!/usr/bin/env python3
"""Generate .itermcolors presets from palette definitions.

Usage: python3 make_itermcolors.py  (writes <name>.itermcolors next to itself)
"""
from pathlib import Path

PALETTES = {
    "gruvbox-dark": {
        # Official gruvbox dark palette, https://github.com/morhetz/gruvbox
        "Ansi 0": "282828", "Ansi 1": "cc241d", "Ansi 2": "98971a",
        "Ansi 3": "d79921", "Ansi 4": "458588", "Ansi 5": "b16286",
        "Ansi 6": "689d6a", "Ansi 7": "a89984",
        "Ansi 8": "928374", "Ansi 9": "fb4934", "Ansi 10": "b8bb26",
        "Ansi 11": "fabd2f", "Ansi 12": "83a598", "Ansi 13": "d3869b",
        "Ansi 14": "8ec07c", "Ansi 15": "ebdbb2",
        "Background": "282828", "Foreground": "ebdbb2",
        "Bold": "ebdbb2", "Cursor": "ebdbb2", "Cursor Text": "282828",
        "Selection": "504945", "Selected Text": "ebdbb2",
        "Link": "83a598",
    },
}

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

here = Path(__file__).parent
for name, colors in PALETTES.items():
    out = HEADER
    for key in sorted(colors):
        hexval = colors[key]
        r, g, b = (int(hexval[i:i + 2], 16) / 255 for i in (0, 2, 4))
        out += ENTRY.format(name=key, r=r, g=g, b=b)
    out += "</dict>\n</plist>\n"
    (here / f"{name}.itermcolors").write_text(out)
    print(f"wrote {name}.itermcolors")
