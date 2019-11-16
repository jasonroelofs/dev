Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
Pry.commands.alias_command 'f', 'finish'

Pry.config.commands.command(/^$/, 'repeat last command') do
  __pry__.input = StringIO.new(Pry.history.to_a.last)
end
