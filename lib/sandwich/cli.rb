require 'optparse'
require 'sandwich/runner'
require 'sandwich/version'

module Sandwich
  # This class parses ARGV style command line options and starts a
  # configured {Sandwich::Runner}.
  class CLI
    def initialize
      @options = {}

      # default log level
      @options[:log_level] = :warn

      @optparse = OptionParser.new do |opts|
        opts.banner = 'Usage: sandwich [options] [sandwichfile [arguments]]'

        opts.on_tail('-v',
                     '--version',
                     'Show sandwich version') do
          puts "sandwich: #{Sandwich::VERSION}"
          exit
        end

        opts.on_tail('-h',
                     '--help',
                     'Show this message') do
          puts opts
          exit
        end

        opts.on('-l',
                '--log_level LEVEL',
                'Set the log level (debug, info, warn, error, fatal)') do |l|
          @options[:log_level] = l.to_sym
        end
      end
    end

    # Start Sandwich
    #
    # @param [Array] argv ARGV style command line options passed to sandwich
    # @return [void]
    def run(argv)
      unparsed_arguments = @optparse.order!(argv)

      # use first argument as sandwich script filename...
      recipe_filename = unparsed_arguments.shift

      # ...check for stdin...
      if recipe_filename.nil? || recipe_filename == '-'
        recipe_filename = '<STDIN>'
        recipe_file = STDIN.read
      else
        recipe_file = File.read(recipe_filename)
      end

      # ...and pass remaining arguments on to script
      ARGV.replace(unparsed_arguments)
      runner = Sandwich::Runner.new(recipe_file, recipe_filename)

      runner.run(@options[:log_level])
    end
  end
end
