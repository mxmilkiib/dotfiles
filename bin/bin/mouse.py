import curses, sys, signal

curses.setupterm()
stdscr = curses.initscr()
curses.noecho()
stdscr.keypad(True)

out = ''

def quit():
    stdscr.keypad(0)
    curses.echo()
    curses.nocbreak()
    curses.endwin()
    sys.exit(out)
signal.signal(signal.SIGINT, lambda signal, frame: quit())

def display(c):
    s = '{}\n'.format(str(c))
    stdscr.addstr(s)
    global out
    out += s

b5 = getattr(curses, 'BUTTON5_PRESSED', 0)
curses.mousemask(curses.ALL_MOUSE_EVENTS | b5 | curses.BUTTON4_PRESSED | curses.A_LOW)

while True:
    c = stdscr.getch()
    if c == curses.KEY_MOUSE:
        c = curses.getmouse()[4]
        try:
            display(c)
        except:
            stdscr.addstr('?\n')
    elif c == ord('q'):
        quit()
