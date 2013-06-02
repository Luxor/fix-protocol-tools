require 'term/ansicolor'
require 'fix_protocol_tools/messages_processor'


module FixProtocolTools
  class Runner
    DEFAULTS = {
        :color => Term::ANSIColor::coloring = STDOUT.isatty,
        :dictionary => ENV['FPT_DICT']
    }

    def initialize
       @options = DEFAULTS
    end

    def less!
      @options.merge!(:less => false)
      opt_parse = OptionParser.new do |opts|
        opts.banner = "Usage: fixless [options] [fixlogfile]"

        opts.on('-l', '--[no-]less', 'Use less command for output') do |color|
          @options[:less] = color
        end

        dictionary(opts)
        color(opts)
        help(opts)
      end

      opt_parse.parse!

      MessagesProcessor.new(@options).process
    end

    def grep!
      opt_parse = OptionParser.new do |opts|
        opts.banner = "Usage: fixgrep -v value [options] [fixlogfile]"

        opts.on('-v', '--v value') do |pattern|
          @options[:grep] = pattern
        end

        dictionary(opts)
        color(opts)
        help(opts)
      end

      opt_parse.parse!
      MessagesProcessor.new(@options).process
    end

    private

    def help(opts)
      opts.on('--help', '-h', 'Display help message') do
        puts opts
        exit
      end
    end

    def color(opts)
      opts.on('-c', '--[no-]color', 'Generate color output') do |color|
        Term::ANSIColor::coloring = color
        @options[:color] = color
      end
    end

    def dictionary(opts)
      opts.on('-d', '--dictionary PATH_TO_DICTIONARY', 'You can set up FPT_DICT env variable instead') do |dictionary|
        @options[:dictionary] = dictionary
      end
    end
  end
end
