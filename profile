if [ -f ~/.prompt ]; then
  . ~/.prompt
fi

if [ -f ~/.alias ]; then
  . ~/.alias
fi

if [ -f `brew --prefix`/etc/profile.d/bash_completion.sh ]; then
  . `brew --prefix`/etc/profile.d/bash_completion.sh
fi

export EDITOR=vim

# No homebrew, you cannot send analytics
export HOMEBREW_NO_ANALYTICS=1

# Enable kernel history in Erlang/Elixir (OTP 20 and later)
export ERL_AFLAGS="-kernel shell_history enabled"

# Shut up macOS, I know
export BASH_SILENCE_DEPRECATION_WARNING=1

# Make mvim available on the command line
export PATH="/Applications/MacVim.app/Contents/bin:$PATH"

# ASDF
export PATH="~/.asdf/shims:$PATH"

# Client-specific environment variables that we don't check into `dev`
if [ -f ~/.client-env ]; then
  . ~/.client-env
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
