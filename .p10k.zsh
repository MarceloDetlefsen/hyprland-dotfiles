# Minimal shell prompt.
# Kept in this filename for compatibility with the existing repo layout.
autoload -Uz colors && colors

PROMPT='%F{blue}%n@%m%f %F{cyan}%~%f %# '
RPROMPT='%F{yellow}%*%f'
