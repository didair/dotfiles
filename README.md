# Arch Linux Dotfiles

This repository contains configuration files and setup scripts for my Arch Linux systems.

## Installation

To install dotfiles on a new system:

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make scripts executable
chmod +x install.sh update.sh scripts/*.sh */setup.sh

# Run the installation script
./install.sh [--minimal|--full] [--desktop|--thinkpad]
```

### Installation options:

- `--minimal`: Installs only the base configuration without desktop environment
- `--full`: Installs everything including desktop environment (default)
- `--desktop` or `--thinkpad`: Installs PC-specific configurations and packages

## Updating

To update your dotfiles on an existing system:

```bash
cd ~/dotfiles
./update.sh [--pull] [--desktop|--thinkpad]
```

### Update options:

- `--pull`: Pulls latest changes from the Git repository before updating
- `--desktop` or `--thinkpad`: Updates PC-specific configurations

## Backing up Current Configuration

To back up your current configurations to the repository:

```bash
cd ~/dotfiles
./scripts/backup.sh [--desktop|--thinkpad]
```

## Configuration Details

### Included Configurations

1. **Neovim**: Modern Neovim configuration with LSP support
2. **Zsh**: Shell configuration with Oh My Zsh and useful plugins
3. **i3**: Tiling window manager configuration
4. **Package Management**: Lists of packages for different purposes

### Customization

Each application's setup is modular and can be customized independently:

1. Edit the configuration files in the respective directories
2. Run the specific setup script or run the update script to apply changes

### Adding a New Application

To add configuration for a new application:

1. Create a new directory for the application
2. Add configuration files to the directory
3. Create a `setup.sh` script for linking the files
4. Update the main `install.sh` and `update.sh` scripts to include the new application

## PC-Specific Configuration

For machine-specific settings, you can:

1. Create custom package lists in `apps/custom-[name].txt`
2. Use the `--[name]` flag when running the installation or update scripts
3. Create machine-specific branches if you need more divergent configurations

## Troubleshooting

- If a configuration file is not being linked correctly, check the permissions and run the specific setup script manually
- Look at the backup directory created during installation for any replaced files
- For any issues, submit a bug report on the repository

## License

This project is licensed under the MIT License. See the LICENSE file for details.
