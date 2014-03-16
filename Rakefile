require "bundler/gem_tasks"

Dir.glob('lib/tasks/*.rake').each {|r| import r}

task :console do
  require 'pry'
  require 'forex'
  ARGV.clear
  Pry.start
end
