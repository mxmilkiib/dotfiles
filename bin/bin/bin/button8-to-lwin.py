#!/usr/bin/python2
from pymouse import PyMouseEvent
from pykeyboard import PyKeyboard

k = PyKeyboard()
class MouseToButton(PyMouseEvent):
    def click(self, x, y, button, press):
        if button == 8:
            if press:    # press
                k.press_key(k.super_l_key)
            else:        # release
                k.release_key(k.windows_l_key)

C = MouseToButton()
C.run()
