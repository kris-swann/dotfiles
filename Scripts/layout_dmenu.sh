ls -1 ~/.screenlayout | sed -e 's/.sh//g' -e 's/_/ /g' | dmenu | sed -e 's/ /_/g' -e 's/$/.sh/' -e 's/^/~\/.screenlayout\//' | bash
