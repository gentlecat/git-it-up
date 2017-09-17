require 'logger'
require 'optparse'
require_relative 'git'

SLEEP_DURATION = 20 # seconds

$stdout.sync = true
log = Logger.new($stdout)
# TODO: Make logging level customizable using a command line argument
log.level = Logger::WARN

list_file = nil
OptionParser.new do |parser|
  parser.on('-l', '--list=MANDATORY' 'File with a repository list') do |list|
    list_file = list
  end
end.parse!

# Reading and validating the repository list
unless File.file? list_file
  puts "Unable to read file `#{list_file}`!"
  exit false
end
dirs = File.read(list_file).split(/\n/)
if dirs.length < 1 
  puts 'Repository list file is empty!'
end
dirs.each do |dir|
  log.debug "Checking if #{dir} is a git repository"
  unless Git.is_repo?(dir)
    puts "Directory `#{dir}` is not a git repository!"
    exit false
  end
end

# The main update loop
loop do
  dirs.each do |repo|
    Git.update! repo
  end
  sleep SLEEP_DURATION
end
