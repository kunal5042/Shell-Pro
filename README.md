# Shell-Pro

A portable shell environment setup that provides a consistent, feature-rich terminal experience across any machine.

## 🚀 Quick Setup

Clone this repository and run the setup script:

```bash
git clone <your-repo-url> ~/Shell-Pro
cd ~/Shell-Pro
chmod +x setup.sh
./setup.sh
```

That's it! Restart your terminal and enjoy your enhanced shell environment.

## ✨ Features

- **Oh My Zsh** integration with powerful plugins
- **Powerlevel10k** theme for a beautiful, informative prompt  
- **Custom configurations** organized in modular files
- **AWS utilities** for cloud development workflows
- **Auto-suggestions** for faster command completion
- **Portable setup** that works on any Unix-like system

## 📁 Structure

```
Shell-Pro/
├── .zshrc                    # Main zsh configuration
├── setup.sh                 # Automated setup script
├── .zsh/                     # Custom configurations
│   ├── aliases/             # Custom aliases
│   ├── functions/           # Custom functions (AWS, etc.)
│   ├── plugins/             # Custom plugins
│   ├── themes/              # Theme configurations
│   └── custom-configuration.zsh
└── README.md
```

## 🛠 What the Setup Script Does

1. **Installs Oh My Zsh** if not already present
2. **Verifies** that custom plugins and themes are available in the repo
3. **Backs up** your existing .zshrc (if any)
4. **Applies** the Shell-Pro .zshrc configuration  
5. **Installs Nerd Fonts** (automatically on macOS via Homebrew, Linux via package managers)
6. **Sets zsh** as your default shell

## 🎯 Customization

### Adding Custom Aliases
Add your aliases to `.zsh/aliases/` directory:
```bash
echo "alias myalias='my command'" > .zsh/aliases/my-aliases.zsh
```

### Adding Custom Functions  
Add functions to `.zsh/functions/` directory:
```bash
mkdir -p .zsh/functions/category
echo "function myfunction() { echo 'Hello World' }" > .zsh/functions/category/myfunction.zsh
```

### Configuring Powerlevel10k
Run the configuration wizard:
```bash
p10k configure
```

## 🔧 Requirements

- **Git** (for cloning and theme installation)
- **Curl** (for Oh My Zsh installation)  
- **Zsh** (usually pre-installed on macOS/Linux)

### Platform-Specific:
- **macOS**: Homebrew (optional, for automatic Nerd Font installation)
- **Linux**: Package manager (apt/yum/dnf/pacman) with sudo access (optional, for automatic font installation)

## 🌟 Tips

- **Everything is included** - No internet required after cloning! Plugins and themes travel with the repo
- **Completely portable** - Works regardless of where you clone the repo
- **Offline-ready** - All dependencies are bundled, perfect for air-gapped environments
- **Version controlled** - Your plugin/theme versions are locked and consistent across machines
- The `.dotfiles/bashrc` integration is optional and won't break if not present
- All paths are dynamically determined, no hardcoded user paths

## 🤝 Contributing

Feel free to add your own custom functions, aliases, or configurations to enhance this setup!

---

**Enjoy your enhanced shell experience! 🎉**