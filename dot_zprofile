# SSH agent
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)"
fi

ssh-add ~/.ssh/GitHub >/dev/null 2>&1
