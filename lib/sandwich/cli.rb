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

    def initialize
      self.class.banner("Usage: #{$0} [options] [FILE]")
      super
    end

    # Start Sandwich
    #
    # @param [Array] argv ARGV style command line options passed to sandwich
    # @return [void]
    def run(argv)
      unparsed_arguments = parse_options(argv)
      if unparsed_arguments.empty?
        # no file name supplied, read from STDIN
        runner = Sandwich::Runner.new(STDIN.read)
      else
        # arguments supplied, use first one as filename...
        recipe_filename = unparsed_arguments.shift
        recipe_file = File.read(recipe_filename)
        # ...and pass remaining arguments on to script
        # FIXME: switches ('--foo', '-f', ...) get eaten up by mixlib-cli
        ARGV.replace(unparsed_arguments)
        runner = Sandwich::Runner.new(recipe_file)
      end
      runner.run(config[:log_level])
    end
  end
end
