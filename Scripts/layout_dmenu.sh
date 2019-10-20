ls -1 ~/.screenlayout | sed -e 's/.sh//g' -e 's/_/ /g' | dmenu -i -p "Layout Profile" | sed -e 's/ /_/g' -e 's/$/.sh/' -e 's/^/~\/.screenlayout\//' | bash
