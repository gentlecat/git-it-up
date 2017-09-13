require 'logger'
require_relative 'git'

REPO_DIR = ARGV[0].freeze
Dir.chdir(REPO_DIR)

Git.update_remote
if Git.outdated?
  print 'Repository is outdated. Updating...'
  Git.pull
  print " Done.\n"
else
  print "Repository is up to date.\n"
end
