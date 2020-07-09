import re
from xkeysnail.transform import *

define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL,
    Key.LEFT_CTRL: Key.CAPSLOCK,
})

define_multipurpose_modmap({
    Key.LEFT_META: [Key.MUHENKAN, Key.LEFT_META],
})

define_keymap(None, {
    K("C-LEFT_BRACE"): [K("C-LEFT_BRACE"), K("MUHENKAN")],
}, "Global keymap")

define_keymap(lambda wm_class: wm_class in ("Google-chrome", "albert"), {
    # Cursor
    K("C-b"): with_mark(K("left")),
    K("C-f"): with_mark(K("right")),
    K("C-p"): with_mark(K("up")),
    K("C-n"): with_mark(K("down")),
    K("C-h"): with_mark(K("backspace")),
    # Beginning/End of line
    K("C-a"): with_mark(K("home")),
    K("C-e"): with_mark(K("end")),
    # Copy
    K("C-w"): [K("C-x"), set_mark(False)],
    K("M-w"): [K("C-c"), set_mark(False)],
    K("C-y"): [K("C-v"), set_mark(False)],
    # Delete
    K("C-d"): [K("delete"), set_mark(False)],
    # Kill line
    K("C-k"): [K("Shift-end"), K("C-x"), set_mark(False)],
    # Page
    K("M-LEFT_BRACE"): K("M-left"),
    K("M-RIGHT_BRACE"): K("M-right"),

    K("M-w"): K("C-w"),
    K("M-r"): K("C-r"),
    K("M-t"): K("C-t"),
    K("M-Shift-t"): K("C-Shift-t"),
    K("M-o"): K("C-o"),
    K("M-p"): K("C-p"),
    K("M-a"): K("C-a"),
    K("M-s"): K("C-s"),
    K("M-f"): K("C-f"),
    K("M-g"): K("C-g"),
    K("M-z"): K("C-z"),
    K("M-x"): K("C-x"),
    K("M-c"): K("C-c"),
    K("M-v"): K("C-v"),
    K("M-n"): K("C-n"),
}, "Default keymap")

define_keymap(lambda wm_class: wm_class in ("Boostnote"), {
    K("M-w"): K("C-w"),
    K("M-r"): K("C-r"),
    K("M-t"): K("C-t"),
    K("M-o"): K("C-o"),
    K("M-p"): K("C-p"),
    K("M-a"): K("C-a"),
    K("M-s"): K("C-s"),
    K("M-f"): K("C-f"),
    K("M-g"): K("C-g"),
    K("M-z"): K("C-z"),
    K("M-x"): K("C-x"),
    K("M-c"): K("C-c"),
    K("M-v"): K("C-v"),
    K("M-n"): K("C-n"),
}, "Boostnote keymap")

define_keymap(lambda wm_class: wm_class in ("Gnome-terminal"), {
    K("C-TAB"): K("C-PAGE_DOWN"),
    K("C-Shift-TAB"): K("C-PAGE_UP"),
})

define_conditional_modmap(lambda wm_class: wm_class.startswith("jetbrains-"), {
    Key.CAPSLOCK: Key.LEFT_CTRL,
    Key.LEFT_CTRL: Key.CAPSLOCK,

    Key.LEFT_ALT: Key.LEFT_META,
    # Key.RIGHT_ALT: Key.RIGHT_META,
    Key.LEFT_META: Key.LEFT_ALT,
})

define_keymap(lambda wm_class: wm_class.startswith("jetbrains-"), {
    K("Super-q"): K("M-q"),
})
