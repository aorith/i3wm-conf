#!/usr/bin/env python3

from i3ipc import Connection, Event

i3 = Connection()


def on_window_focus(self, e):
    tree = self.get_tree()
    f = tree.find_focused()
    w = f.workspace()
    if w is None or f is None:
        return

    old_name = w.name
    num = str(w.num)
    new_name = num + ": " + f.window_class
    self.command(f'rename workspace "{old_name}" to "{new_name}"')


i3.on(Event.WINDOW_FOCUS, on_window_focus)

i3.main()
