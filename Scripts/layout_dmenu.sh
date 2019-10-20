options=$(ls -1 ~/.screenlayout | sed -e 's/.sh//g' -e 's/_/ /g' -e '$ a Manual (arandr)')
result=$(echo "$options" | dmenu -i -p "Layout Profile")

if [ "$result" == 'Manual (arandr)' ]; then
  arandr
elif [[ "$result" ]]; then
  layout_file_path=$(echo "$result" | sed -e 's/ /_/g' -e 's/$/.sh/' -e 's/^/~\/.screenlayout\//')
  (exec "$layout_file_path")
fi
