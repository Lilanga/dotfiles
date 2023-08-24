#!/bin/sh

if [ -z "$USER" ]; then
  USER=$(id -un)
fi

echo >&2 "====================================================================="
echo >&2 " Setting up codespaces environment"
echo >&2 ""
echo >&2 " USER        $USER"
echo >&2 " HOME        $HOME"
echo >&2 "====================================================================="

cd $HOME

# Make passwordless sudo work
export SUDO_ASKPASS=/bin/true

mv .gitconfig .gitconfig.private

# install fish shell
sudo apt-get install -y fish
sudo chsh -s /usr/bin/fish $USER

# Install tree-sitter-cli
npm i tree-sitter-cli

# Install fzf
FZF_VERSION=0.42.0
mkdir -p ~/bin
curl -L https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz | tar xzC $HOME/bin

# Install nerdfont
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
cd ~/ || return

# Install ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb

# Install bottom
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.4/bottom_0.9.4_amd64.deb
sudo dpkg -i bottom_0.9.4_amd64.deb

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Install neovim
NVIM_VERSION=0.9.1
sudo apt-get update -y
sudo apt-get install -y fuse libfuse2
curl -L -o $HOME/bin/nvim https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage
chmod a+x $HOME/bin/nvim

# Install astrovim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

export PATH="$HOME/bin:$PATH"
source ~/.bashrc
