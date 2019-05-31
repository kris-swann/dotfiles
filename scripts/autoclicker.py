import subprocess
import time
from pynput import keyboard
from pynput.mouse import Button, Controller

mouse = Controller()
quit = False

def on_press(key):
    key_char = getattr(key, 'char', None)
    key_name = getattr(key, '_name_', None)
    if key_char in ['q', 'c'] or key_name in ['esc', 'backspace']:
        global quit
        quit = True

with keyboard.Listener(on_press=on_press):
    while not quit:
        mouse.click(Button.left)
        time.sleep(0.001)  # in seconds
