require 'mixlib/cli'
require 'sandwich/runner'
require 'sandwich/version'

module Sandwich
  # This class parses ARGV style command line options and starts a
  # configured {Sandwich::Runner}.
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

    option :log_level,
      :short        => '-l LEVEL',
      :long         => '--log_level LEVEL',
      :description  => 'Set the log level (debug, info, warn, error, fatal)',
      :default      => :warn,
      :proc         => lambda { |l| l.to_sym }

    option :version,
      :short       => '-v',
      :long        => '--version',
      :description => 'Show sandwich version',
      :boolean     => true,
      :proc        => lambda { |v| puts "sandwich: #{Sandwich::Version}" },
      :exit        => 0

    # Start Sandwich
    #
    # @param [Array] argv ARGV style command line options passed to sandwich
    # @return [void]
    def run(argv)
      parse_options(argv)
      if config[:file] == '-'
        runner = Sandwich::Runner.new(STDIN.read)
      else
        file = File.read(config[:file])
        runner = Sandwich::Runner.new(file)
      end
      runner.run(config[:log_level])
    end
  end
end
