HOSTNAME="ti"
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME
sudo scutil --set ComputerName $HOSTNAME
dscacheutil -flushcache

# Create SSH key for GitHub etc.
# https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t ed25519 -C "psmuler@${HOSTNAME}.local"
cat ~/.ssh/id_ed25519.pub
echo 'Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519' >> ~/.ssh/config
ssh-add -K ~/.ssh/id_ed25519

# Install Homebrew
sudo -s
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
UNAME_MACHINE="$(uname -m)"
if [[ "$UNAME_MACHINE" == "arm64" ]]; then # なんで arm64 に限ってるのか正直わからんが、上のスクリプトに従っている
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Formulae
brew install emacs
brew install macos-trash
brew install mas
brew install n
brew install pyenv
brew install rbenv
brew install git
brew install git-lfs
brew install hub
brew install icecream
brew install tree
brew install nmap
brew install poppler

# Install the latest Node.js
sudo n latest

# Install the latest Python
latest_python_version=$(pyenv install --list | grep -E ' 3\.\d\.\d' | tail -n 1 | tr -d ' ')
pyenv install $latest_python_version
pyenv global $latest_python_version
echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
source ~/.zprofile

latest_ruby_version=$(rbenv install -L | grep -e '^\d.*\d$' | tail -n 1)
rbenv install $latest_ruby_version
rbenv global $latest_ruby_version
echo 'eval "$(rbenv init -)"' >> ~/.zprofile
source ~/.zprofile

# Casks
# brew install brew-cask
brew install 1password # because Mac App Store version does not support device license
brew install clipy
# brew install cmd-eikana
brew install google-chrome
brew install google-cloud-sdk
brew install iterm2
# brew install mactex-no-gui
# brew install mongodb-compass
brew install monitorcontrol
# brew install ngrok
brew install visual-studio-code
brew install zoom
brew install --cask figma
brew install --cask zotero
brew install --cask discord
brew install --cask dropbox
brew install --cask fujitsu-scansnap-home
brew install --cask beeper


# Set up menubar applications
# open -a /Applications/⌘英かな.app
open -a /Applications/Clipy.app
open -a Dropbox.app

# Set up screenshots location to Dropbox folder
defaults write com.apple.screencapture location ~/Dropbox/Screenshots
killall SystemUIServer

# Open Google Chrome to urge manual sign in before auto setting
open -a /Applications/Google\ Chrome.app

# Mac App Store applications
open -a /System/Applications/App\ Store.app # sign in manually
mas install 1258530160 # Focus To-Do: Pomodoro Timer
mas install 937984704  # Amphetamine

# Set up essential git config
git config --global user.email "zhmuler@gmail.com"
git config --global user.name "psmuler"
# git config --global pull.rebase false
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh > ~/.git-completion.zsh

# iTerm2 Shell Integration
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
source ~/.iterm2_shell_integration.zsh

# Set up macOS defaults
defaults write -g AppleShowScrollBars -string "WhenScrolling"
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # List view
defaults write com.apple.finder ShowPathbar -bool true
killall Finder

defaults import com.apple.dock /path/to/my-dock.plist
defaults write com.apple.dock show-recents -bool false
killall Dock
