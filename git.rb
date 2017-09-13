# Utility functions for working with a git repository
module Git
  module_function

  UP_TO_DATE_MSG = 'Your branch is up-to-date'.freeze
  BEHIND_MSG = 'Your branch is behind'.freeze

  def pull
    run_cmd('pull')
  end

  def update_remote
    run_cmd('remote update')
  end

  def outdated?
    status_msg = status
    status_rows = status_msg.split(/\n/)
    if status_rows.length < 2
      puts "Cannot parse unexpected status message:\n#{status_msg}"
      exit(false)
    end
    return false if status_rows[1].start_with?(UP_TO_DATE_MSG)
    return true if status_rows[1].start_with?(BEHIND_MSG)
    puts "Unexpected status message:\n#{status_msg}"
    exit(false)
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
      puts "Command `#{cmd} has failed. Exit status: #{exit_status}`"
      exit(false)
    end
    output
  end

end
