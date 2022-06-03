#!/usr/bin/env bash

# Helper script to run python scripts that have packages without having to manually manage a venv
# Usage:
#   Run a script: ./venv-run.sh python my-script-with-packages.py
#   Open a repl:  ./venv-run.sh python

realpath_available=$(which realpath)
if [ "$realpath_available" = "" ]; then
  echo "This script relies on 'realpath', please install before running this script"
  exit 1
fi
basedir="$(dirname "$(realpath "$0")")" || exit
venv_dir="$basedir/.venv"
requirements_file="$basedir/requirements.txt"
venv_dir=".venv"
requirements_file="requirements.txt"

# NOTE: To prevent clobbering output of the wrapped command
#       We redirect venv-run specific output from stdout (1) to stderr (2)
#       This is what 1>&2 does

# Create venv if doesn't exist
if [ ! -d "$venv_dir" ]; then
  echo "venv does not exist, creating..." 1>&2
  python -m venv "$venv_dir" 1>&2
fi

# Activate venv
source "$venv_dir/bin/activate"

# Install any missing packages
if pip freeze -r "$requirements_file" 2>&1 | grep -q "is not installed" ; then
  echo "missing packages, installing..." 1>&2
  pip install -r "$requirements_file" 1>&2
fi

# Run command
exec "$@"
