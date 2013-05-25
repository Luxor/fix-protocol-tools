require 'term/ansicolor'
require 'fix_protocol_tools/messages_processor'

Term::ANSIColor::coloring = STDOUT.isatty

module FixProtocolTools
  class Runner
    DEFAULT_OPTIONS = {
        :verbose => false
    }

    def run!
      options = DEFAULT_OPTIONS.clone
      opt_parse = OptionParser.new do |opts|
        opts.banner = "Usage: fixless [options] [fixlogfile]"

        opts.on('-c', '--[no-]color', 'Generate color output') do |color|
          Term::ANSIColor::coloring = color
          options[:color] = color
        end

        opts.on('-l', '--[no-]less', 'Use less command for output') do |color|
          options[:less] = color
        end

        opts.on('--help', '-h', 'Display help message') do
          exit
        end
      end

      opt_parse.parse!

      MessagesProcessor.new(options).process
    end
  end
end
