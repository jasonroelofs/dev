if [ -f ~/.prompt ]; then
  . ~/.prompt
fi

if [ -f ~/.alias ]; then
  . ~/.alias
fi

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/Cellar/cdargs/1.35/contrib/cdargs-bash.sh ]; then
  . `brew --prefix`/Cellar/cdargs/1.35/contrib/cdargs-bash.sh
fi

export EDITOR=vim

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
