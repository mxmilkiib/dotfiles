#!/usr/bin/env python3

import i3ipc
import sys

# Create the Connection object that can be used to send commands and subscribe
# to events.
i3 = i3ipc.Connection()

# Print the name of the focused window
focused = i3.get_tree().find_focused()
ws_left = focused.workspace().num - 1
ws_right = focused.workspace().num + 1
i3.command('move container to workspace $ws%s' % ws_right)
