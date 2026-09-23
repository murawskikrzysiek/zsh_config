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


# ── Key map ──────────────────────────────────────────────────────────────────
# The same bytes ghostty/config and iterm/keyboard-map.json send, so
# zsh/keybindings.zsh reacts identically under all three terminals.
#
# Syntax, taken from Terminal's own files rather than guessed: the app's
# bundled Resources/keyMappings.plist (its default key map) and the format
# string "%@%@%@%@%04X" in its binary. A key is up to four modifier marks
# followed by the key's Unicode scalar as four uppercase hex digits:
#   ~ Option   ^ Control   $ Shift   # keypad
#   007F Backspace   F728 fn+Delete   F702 / F703 Left / Right   F704.. F1..
# Option comes before Control when both are held ("~^F728" in Apple's map).
# The value is the byte sequence to send, stored as literal control
# characters in the XML (Apple's default map has raw 0x1B in it, and its
# parser takes them). plistlib refuses to write those, so they travel through
# the dump as private-use stand-ins and are swapped back below.
#
# A profile's key map REPLACES the default map, it does not overlay it.
# Measured on macOS 26: with only the four entries below in the profile, F5
# sent nothing and Ctrl+Left / Shift+Left sent a plain arrow. So Apple's
# defaults are carried here verbatim and ours are laid on top.

# Terminal.app's Resources/keyMappings.plist, macOS 26, unchanged.
DEFAULT_MAP = [
    ("F704", b"\x1bOP"), ("F705", b"\x1bOQ"),          # F1 .. F4
    ("F706", b"\x1bOR"), ("F707", b"\x1bOS"),
    ("F708", b"\x1b[15~"), ("F709", b"\x1b[17~"),      # F5 .. F12
    ("F70A", b"\x1b[18~"), ("F70B", b"\x1b[19~"),
    ("F70C", b"\x1b[20~"), ("F70D", b"\x1b[21~"),
    ("F70E", b"\x1b[23~"), ("F70F", b"\x1b[24~"),
    ("F710", b"\x1b[25~"), ("F711", b"\x1b[26~"),      # F13 .. F20
    ("F712", b"\x1b[28~"), ("F713", b"\x1b[29~"),
    ("F714", b"\x1b[31~"), ("F715", b"\x1b[32~"),
    ("F716", b"\x1b[33~"), ("F717", b"\x1b[34~"),
    ("F728", b"\x1b[3~"),                              # fn+Delete
    ("$F702", b"\x1b[1;2D"), ("$F703", b"\x1b[1;2C"),  # Shift+arrows
    ("$F708", b"\x1b[25~"), ("$F709", b"\x1b[26~"),    # Shift+F5 ..
    ("$F70A", b"\x1b[28~"), ("$F70B", b"\x1b[29~"),
    ("$F70C", b"\x1b[31~"), ("$F70D", b"\x1b[32~"),
    ("$F70E", b"\x1b[33~"), ("$F70F", b"\x1b[34~"),
    ("$F728", b"\x1b[3;2~"),
    ("^F702", b"\x1b[1;5D"), ("^F703", b"\x1b[1;5C"),  # Ctrl+arrows
    ("^F728", b"\x1b[3;5~"),
    ("~F702", b"\x1bb"), ("~F703", b"\x1bf"),          # Option+arrows
    ("~F704", b"\x1b[17~"), ("~F705", b"\x1b[18~"),    # Option+F1 ..
    ("~F706", b"\x1b[19~"), ("~F707", b"\x1b[20~"),
    ("~F708", b"\x1b[21~"), ("~F709", b"\x1b[23~"),
    ("~F70A", b"\x1b[24~"), ("~F70B", b"\x1b[25~"),
    ("~F70C", b"\x1b[26~"), ("~F70D", b"\x1b[28~"),
    ("~F70E", b"\x1b[29~"), ("~F70F", b"\x1b[31~"),
    ("~F710", b"\x1b[32~"), ("~F711", b"\x1b[33~"),
    ("~F712", b"\x1b[34~"),
    ("~^F728", b"\x1b\x1b[3;5~"),
    ("#F704", b"\x1bOP"), ("#F705", b"\x1bOQ"),        # keypad
    ("#F706", b"\x1bOR"), ("#F707", b"\x1bOS"),
    ("#F739", b"toggleNumLock:"),
]

# Ours, on top. Option+arrows are already ESC b / ESC f in the defaults.
KEY_MAP = [
    ("~007F", b"\x1b\x7f"),  # Option+Backspace: delete the previous word
    ("^007F", b"\x08"),      # Ctrl+Backspace: delete the whole line (^H)
    ("F728", b"\x04"),       # fn+Delete: delete the character ahead (^D)
    ("~F728", b"\x1bd"),     # Option+fn+Delete: delete the next word
]

# Control bytes -> private-use code points that survive plistlib's XML writer.
PLACEHOLDERS = {b: chr(0xE000 + b) for b in list(range(0x20)) + [0x7F]}


def _placeholders(seq):
    return "".join(PLACEHOLDERS.get(b, chr(b)) for b in seq)


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
    # Option stays a normal modifier, so Option+a still types ą. The keys
    # that need Meta-style sequences are mapped one by one below instead.
    "useOptionAsMetaKey": False,
    "keyMapBoundKeys": {key: _placeholders(seq)
                        for key, seq in DEFAULT_MAP + KEY_MAP},
}
for i, key in enumerate(ANSI_KEYS):
    profile[key] = archived_color(PALETTE[f"Ansi {i}"])

xml = plistlib.dumps(profile, fmt=plistlib.FMT_XML)
for byte, stand_in in PLACEHOLDERS.items():
    xml = xml.replace(stand_in.encode("utf-8"), bytes([byte]))
assert b"\xee\x80" not in xml, "a placeholder leaked into the output"

out = here / "headroom.terminal"
out.write_bytes(xml)
print(f"wrote {out.relative_to(here.parent)}")

