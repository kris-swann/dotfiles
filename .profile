#!/bin/sh
# ~/.profile
#
# Runs on login
# This file is not read by bash if ~/.bash_profile or ~/.bash_login exists

export TERMINAL="kitty"
export EDITOR="nvim"
export LESS="-XFRS"
export UNAME="$(uname)"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export LOCKSCREEN_ENABLED="true"

# Update PATH for system-wide purposes
# User scripts
if [ -d "$HOME/Scripts" ] ; then
    PATH="$HOME/Scripts:$PATH"
fi
# Local binaries (appimages, etc)
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
# Local binaries from installers
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

[[ -f ~/.profile_local ]] && . ~/.profile_local
