if [ -f ~/.prompt ]; then
  . ~/.prompt
fi

if [ -f ~/.alias ]; then
  . ~/.alias
fi

# No homebrew, you cannot send analytics
export HOMEBREW_NO_ANALYTICS=1
export PATH="/opt/homebrew/bin:/Users/jasonroelofs/.volta/bin:$PATH"

if [ -f `brew --prefix`/etc/profile.d/bash_completion.sh ]; then
  . `brew --prefix`/etc/profile.d/bash_completion.sh
fi

export EDITOR=vim

# Enable kernel history in Erlang/Elixir (OTP 20 and later)
export ERL_AFLAGS="-kernel shell_history enabled"

# Shut up macOS, I know
export BASH_SILENCE_DEPRECATION_WARNING=1

# Make mvim available on the command line
export PATH="/Applications/MacVim.app/Contents/bin:$PATH"

# Ruby from Homebrew
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# Client-specific environment variables that we don't check into `dev`
if [ -f ~/.client-env ]; then
  . ~/.client-env
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
