if [ -f ~/.prompt ]; then
  . ~/.prompt
fi

if [ -f ~/.alias ]; then
  . ~/.alias
fi

if [ -f `brew --prefix`/etc/profile.d/bash_completion.sh ]; then
  . `brew --prefix`/etc/profile.d/bash_completion.sh

  for COMPLETION in `brew --prefix`/etc/bash_completion.d/*; do
    [[ -r "$COMPLETION" ]] && source "$COMPLETION"
  done
fi

if [ -f `brew --prefix`/Cellar/cdargs/1.35/contrib/cdargs-bash.sh ]; then
  . `brew --prefix`/Cellar/cdargs/1.35/contrib/cdargs-bash.sh
fi

export EDITOR=vim

# Always start Vagrant with vmware
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

# No homebrew, you cannot send analytics
export HOMEBREW_NO_ANALYTICS=1

# Never ever ever ever EVER run Spring on a Rails project
export DISABLE_SPRING=1

# Enable kernel history in Erlang/Elixir (OTP 20 and later)
export ERL_AFLAGS="-kernel shell_history enabled"

# Shut up macOS, I know
export BASH_SILENCE_DEPRECATION_WARNING=1

# Client-specific environment variables that we don't check into `dev`
if [ -f ~/.client-env ]; then
  . ~/.client-env
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
