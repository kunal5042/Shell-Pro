# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh-completions
autoload -U compinit && compinit

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to your function directories (dynamically determined)
export SHELL_PRO_DIR="$(cd "$(dirname "${(%):-%x:A}")" && pwd)"
export ZSH_CUSTOM="$SHELL_PRO_DIR/.zsh"

# set theme
ZSH_THEME="powerlevel10k/powerlevel10k"
# set themes
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Standard configuration option
# CASE_SENSITIVE="true"
# DISABLE_LS_COLORS="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_AUTO_TITLE="true"

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git 
  z 
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  you-should-use)

export HISTFILE="$ZDOTDIR/.zsh_history"
source $ZSH/oh-my-zsh.sh

# Source dotfiles bashrc if it exists
if [[ -f "$HOME/.dotfiles/bashrc" ]]; then
    source "$HOME/.dotfiles/bashrc"
fi

# Load custom configuration
source $ZSH_CUSTOM/custom-configuration.zsh

# Load custom functions
for file in $ZSH_CUSTOM/functions/**/*.(zsh|sh); do
  [ -f "$file" ] && source "$file"
done

# Load custom aliases
for file in $ZSH_CUSTOM/aliases/**/*.(zsh|sh); do
  [ -f "$file" ] && source "$file"
done

# Load custom theme powerlevel10k configuration if enabled
source $ZSH_CUSTOM/themes/powerlevel10k/.p10k.zsh

# To customize prompt, run `p10k configure` or edit $SHELL_PRO_DIR/.zsh/themes/powerlevel10k/.p10k.zsh.
[[ ! -f "$SHELL_PRO_DIR/.zsh/themes/powerlevel10k/.p10k.zsh" ]] || source "$SHELL_PRO_DIR/.zsh/themes/powerlevel10k/.p10k.zsh"
