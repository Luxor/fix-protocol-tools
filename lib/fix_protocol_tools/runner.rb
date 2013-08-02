require 'term/ansicolor'
require 'fix_protocol_tools/messages_processor'


module FixProtocolTools
  class Runner
    DEFAULTS = {
        :color => Term::ANSIColor::coloring = STDOUT.isatty,
        :dictionary => ENV['FPT_DICT'],
        :highlights => ENV['FPT_HIGHLIGHTS'],
        :heartbeats => false
    }

    def initialize
      @options = DEFAULTS
    end

    def run!
      opt_parse = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] [file]"

        opts.on('--dictionary PATH_TO_DICTIONARY', 'You can set up FPT_DICT env variable instead') do |dictionary|
          @options[:dictionary] = dictionary
        end

        opts.on('--highlight field1,field2', Array, 'Highlight number of fields, you can set FPT_HIGHLIGHTS env variable instead') do |highlights|
          @options[:highlights] = highlights
        end

        opts.on('-c', '--[no-]color', 'Generate color output') do |color|
          Term::ANSIColor::coloring = color
          @options[:color] = color
        end

        opts.on('--grep', 'Grep by field id or name') do |pattern|
          @options[:grep] = pattern
        end

        opts.on('--[no-]heartbeats', 'Show full report on heartbeat messages') do |heartbeats|
          @options[:heartbeats] = heartbeats
        end

        opts.on_tail('-h', '--help', 'Display help message') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Display version message') do
          puts FixProtocolTools::VERSION
          exit
        end
      end

      opt_parse.parse!

      ARGV.each do |f|
        unless File.exists?(f)
          puts "File #{f} does not exists"
          exit false
        end
      end

      MessagesProcessor.new(@options).process
    end
  end
end
