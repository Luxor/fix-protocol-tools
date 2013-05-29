require 'term/ansicolor'
require 'fix_protocol_tools/messages_processor'


module FixProtocolTools
  class Runner
    @coloring = Term::ANSIColor::coloring = STDOUT.isatty


    def less!
      options = {:less => false, :color => @coloring}
      opt_parse = OptionParser.new do |opts|
        opts.banner = "Usage: fixless [options] [fixlogfile]"

        color(options, opts)
        help(opts)

        opts.on('-l', '--[no-]less', 'Use less command for output') do |color|
          options[:less] = color
        end
      end

      opt_parse.parse!

      MessagesProcessor.new(options).process
    end

    def grep!
      options = {:color => @coloring}
      opt_parse = OptionParser.new do |opts|
        opts.banner = "Usage: fixgrep -v value [options] [fixlogfile]"

        opts.on('-v', '--v value') do |pattern|
          options[:grep] = pattern
        end

        color(options, opts)
        help(opts)
      end

      opt_parse.parse!
      MessagesProcessor.new(options).process
    end

    private

    def help(opts)
      opts.on('--help', '-h', 'Display help message') do
        puts opts
        exit
      end
    end

    def color(options, opts)
      opts.on('-c', '--[no-]color', 'Generate color output') do |color|
        Term::ANSIColor::coloring = color
        options[:color] = color
      end
    end
  end
end
