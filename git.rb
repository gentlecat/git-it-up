# Utility functions for working with Git repositories
require 'logger'


module Git
  module_function

  UP_TO_DATE_MSG = 'Your branch is up-to-date'.freeze
  BEHIND_MSG = 'Your branch is behind'.freeze

  # TODO: Consolidate logger definitions in one place (see update.rb file)
  @@log = Logger.new($stdout)
  @@log.level = Logger::INFO

  def update!(repo_dir)
    Dir.chdir(repo_dir) do
      Git.check_remote
      if Git.outdated?
        @@log.info "Repository `#{repo_dir}` is outdated. Updating..."
        Git.pull
        @@log.info "Updated `#{repo_dir}`."
      else
        @@log.info "Repository `#{repo_dir}` is up to date."
      end
    end
  end

  def pull
    run_cmd('pull')
  end

  def check_remote
    run_cmd('remote update')
  end

  # Checks if a directory is a Git repository.
  # One caveat is that it will consider `dir` as a repository even if it's
  # just a subdirectory of an existing repository.
  def is_repo?(dir)
    is_repo = false
    Dir.chdir(dir) do
      is_repo = `git rev-parse --is-inside-work-tree`.chomp == 'true'
    end
    is_repo
  end

  def outdated?
    status_msg = status
    status_rows = status_msg.split(/\n/)
    if status_rows.length < 2
      @@log.fail "Cannot parse unexpected status message:\n#{status_msg}"
    end
    return false if status_rows[1].start_with?(UP_TO_DATE_MSG)
    return true if status_rows[1].start_with?(BEHIND_MSG)
    @@log.fail "Unexpected status message:\n#{status_msg}"
  end

  # Get status of the repository
  def status
    run_cmd('status -uno')
  end

  # Runs a git command in the current working directory and returns its output.
  # Execution stops if command fails.
  def run_cmd(git_cmd)
    cmd = "git #{git_cmd}"
    output = `#{cmd}`.chomp
    exit_status = $?.exitstatus
    if exit_status > 1
      @@log.fail "Command `#{cmd} has failed. Exit status: #{exit_status}`"
    end
    output
  end

end
