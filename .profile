#!/bin/sh
# Runs on login

export TERMINAL="kitty"
export EDITOR="nvim"
export LESS="-XFRS"
export UNAME="$(uname)"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export LOCKSCREEN_ENABLED="true"

[[ -f ~/.profile_local ]] && . ~/.profile_local
