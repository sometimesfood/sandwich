require 'mixlib/cli'
require 'sandwich/runner'

module Sandwich
  class CLI
    include Mixlib::CLI

    option :help,
      :short        => '-h',
      :long         => '--help',
      :description  => 'Show this message',
      :boolean      => true,
      :on           => :tail,
      :show_options => true,
      :exit         => 0

    option :file,
      :short       => '-f FILE',
      :long        => '--file FILE',
      :description => 'Read recipe from FILE, defaults to standard input',
      :default     => '-',
      :on          => :head

    def run(argv)
      parse_options(argv)
      if config[:file] == '-'
        runner = Sandwich::Runner.new(STDIN.read)
      else
        file = File.read(config[:file])
        runner = Sandwich::Runner.new(file)
      end
      runner.run(:debug)
    end
  end
end
