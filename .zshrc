# Use powerline
USE_POWERLINE="true"

# Has weird character width
# Example:
#    is not a diamond

HAS_WIDECHARS="false"

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# Cargo binaries
export PATH="$HOME/.cargo/bin:$PATH"

# Mostrar una foto al abrir la terminal
# if [[ $- == *i* ]]; then
#   kitten icat /home/chelo/Imágenes/Cloud.png
# fi

# Mostrar info del sistema (solo en shells interactivos)
# if [[ $- == *i* ]]; then
#   fastfetch --logo arch
# fi

# Pokemon random al abrir la terminal (Kitty / Zsh)
# if [[ $- == *i* ]] && command -v pokeget >/dev/null 2>&1; then
#   pokeget random
# fi

# Iniciar Agente SSH siempre
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Shortcut para el server de Bodega de Licores
alias server-bodega="ssh -i ~/.ssh/AWS root@34.174.123.107"
