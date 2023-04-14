#!/bin/bash
scrot -s  -l color="#92f86d",width=3,mode=edge,opacity=50 -e  'xclip -selection clip-board -t image/png $f ; rm $f'

# Selection area scerenshot with scrot.
# Selected region screenshot is saved in the HOME directory and deleted instantly afterwards.
# mode=MODE, MODE is either "classic" or "edge". "classic" is deprecated and troublesome.
