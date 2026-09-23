#!/usr/bin/env python3
"""Generate what Apple's Terminal.app needs: a .terminal profile and a
256-color variant of the prompt theme.

Usage: python3 terminal-app/make_terminal.py

Writes terminal-app/headroom.terminal, the profile to import.

Terminal.app gained 24-bit color and Powerline font rendering in macOS 26
(Tahoe), which is what makes themes/headroom.zsh and the p10k glyphs work
there at all. On macOS 15 and older the hex colors degrade; regenerate a
256-color theme from this palette if such a machine ever turns up.
"""
import plistlib
import sys
from pathlib import Path

here = Path(__file__).resolve().parent
sys.path.insert(0, str(here.parent))
from palettes import PALETTES, rgb  # noqa: E402

PALETTE = PALETTES["headroom-dark"]
FONT = "JetBrainsMonoNFM-Regular"
FONT_SIZE = 12.0

# ── NSKeyedArchiver blobs ────────────────────────────────────────────────────
# Terminal.app stores colors and the font as archived Cocoa objects inside the
# profile plist. Same structure Terminal writes when you export a profile.

def archived_color(hexval):
    r, g, b = rgb(hexval)
    # NSColorSpace 2 = device RGB. Terminal renders through the display
    # profile, so wide-gamut screens shift these a hair; close enough that the
    # palette reads as intended.
    return plistlib.dumps({
        "$version": 100000,
        "$archiver": "NSKeyedArchiver",
        "$top": {"root": plistlib.UID(1)},
        "$objects": [
            "$null",
            {"$class": plistlib.UID(2), "NSColorSpace": 2,
             "NSRGB": f"{r:.10f} {g:.10f} {b:.10f}".encode() + b"\x00"},
            {"$classes": ["NSColor", "NSObject"], "$classname": "NSColor"},
        ],
    }, fmt=plistlib.FMT_BINARY)


def archived_font(name, size):
    return plistlib.dumps({
        "$version": 100000,
        "$archiver": "NSKeyedArchiver",
        "$top": {"root": plistlib.UID(1)},
        "$objects": [
            "$null",
            {"$class": plistlib.UID(3), "NSName": plistlib.UID(2),
             "NSSize": size, "NSfFlags": 16},
            name,
            {"$classes": ["NSFont", "NSObject"], "$classname": "NSFont"},
        ],
    }, fmt=plistlib.FMT_BINARY)


ANSI_KEYS = [
    "ANSIBlackColor", "ANSIRedColor", "ANSIGreenColor", "ANSIYellowColor",
    "ANSIBlueColor", "ANSIMagentaColor", "ANSICyanColor", "ANSIWhiteColor",
    "ANSIBrightBlackColor", "ANSIBrightRedColor", "ANSIBrightGreenColor",
    "ANSIBrightYellowColor", "ANSIBrightBlueColor", "ANSIBrightMagentaColor",
    "ANSIBrightCyanColor", "ANSIBrightWhiteColor",
]

profile = {
    "name": "Headroom",
    "type": "Window Settings",
    "ProfileCurrentVersion": 2.07,
    "Font": archived_font(FONT, FONT_SIZE),
    "FontAntialias": True,
    "BackgroundColor": archived_color(PALETTE["Background"]),
    "TextColor": archived_color(PALETTE["Foreground"]),
    "TextBoldColor": archived_color(PALETTE["Bold"]),
    "CursorColor": archived_color(PALETTE["Cursor"]),
    "SelectionColor": archived_color(PALETTE["Selection"]),
    "columnCount": 120,
    "rowCount": 34,
    "CursorBlink": False,
    "ShouldLimitScrollback": 0,
    # Option stays a normal modifier, so Option+a still types ą. The word
    # motions come from the CSI sequences Terminal sends natively, which
    # zsh/keybindings.zsh binds.
    "useOptionAsMetaKey": False,
}
for i, key in enumerate(ANSI_KEYS):
    profile[key] = archived_color(PALETTE[f"Ansi {i}"])

out = here / "headroom.terminal"
out.write_bytes(plistlib.dumps(profile, fmt=plistlib.FMT_XML))
print(f"wrote {out.relative_to(here.parent)}")

