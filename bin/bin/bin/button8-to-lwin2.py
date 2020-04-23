#!/usr/bin/python3.6
# -*- coding: utf-8 -*-

"""
Sort of mini driver.
Read a specific InputDevice (my_mouse),
monitoring for special thumb button
Use uinput (virtual driver) to create a mini keyboard
Send ctrl keystroke on that keyboard
"""

from evdev import InputDevice, categorize, ecodes
import uinput

# Initialize keyboard, choosing used keys
ctrl_keyboard = uinput.Device([
    uinput.KEY_KEYBOARD,
    uinput.KEY_LEFTMETA,
    uinput.KEY_F13,
    ])

# Sort of initialization click (not sure if mandatory)
# ( "I'm-a-keyboard key" )
ctrl_keyboard.emit_click(uinput.KEY_KEYBOARD)

# Useful to list input devices
#for i in range(0,15):
#    dev = InputDevice('/dev/input/event{}'.format(i))
#    print(dev)

# Declare device patch.
# I made a udev rule to assure it's always the same name
dev = InputDevice('/dev/my_mouse')
#print(dev)
ctrlkey_on = False

# Infinite monitoring loop
for event in dev.read_loop():
    # My thumb button code (use "print(event)" to find)
    if event.code == 280 :
        # Button status, 1 is down, 0 is up
        if event.value == 1:
            ctrl_keyboard.emit(uinput.KEY_LEFTMETA, 1)
            ctrlkey_on = True
        elif event.value == 0:
            ctrl_keyboard.emit(uinput.KEY_LEFTMETA, 0)
            ctrlkey_on = False
