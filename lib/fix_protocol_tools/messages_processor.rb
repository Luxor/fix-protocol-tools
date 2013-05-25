require 'term/ansicolor'
require 'logger'
require 'fix_protocol_tools/specification/fix_specification'

module FixProtocolTools
  class MessagesProcessor
    include Term::ANSIColor
    MESSAGE_DELIMITER = "\x01"

    def initialize(options)
      @spec = nil
      @is_even_line = true
      @output = init_output_chanel options
    end

    def process()
      buffer = nil

      ARGF.each do |line|
        line = line.gsub(/\r/, '').chomp
        if buffer
          buffer += line
          if buffer =~ /8=FIX.*[A\x01]10=\d+/
            process_line(buffer)
            buffer = nil
          end
        else
          if line =~ /8=FIX/ && !(line =~ /[A\x01]10=\d+/)
            buffer = line
          else
            process_line(line)
          end
        end
      end

      process_line(buffer) if buffer

      @output.close
    end

    private

    def print_line(line)
      @output.puts(@is_even_line ? green(line) : line)
      @is_even_line = !@is_even_line
    end

    def process_line(line)
      fields = fix_message_fields(line.gsub('^A', MESSAGE_DELIMITER))
      return unless fields

      @spec ||= resolve_specification(fields)
      @output.puts(yellow('        =-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=        '))

      fields.each do |field_id, value_id|
        field_name = @spec.field_name(field_id) || field_id
        field_name_padding = @spec.max_field_length - field_name.length - 2

        print_line(format_line(field_id, field_name, field_name_padding, value_id))
      end
    end

    def format_line(field_id, field_name, padding, value_id)
      if @spec.message_type?(field_id)
        formatted_row(field_id, value_id, field_name, red(@spec.message_type(value_id)), padding)
      else
        formatted_row(field_id, value_id, field_name, @spec.enum_value(field_id, value_id), padding)
      end
    end

    def formatted_row(field_id, value_id, field_name, value_name, field_name_padding)
      field_name + '  =  '.rjust(field_name_padding) + value_name +
          '  '.rjust(35 - value_name.length) +
          field_id.rjust(5 - field_id.length) + '  =  ' + value_id
    end

    def resolve_specification(fields)
      fix_version = fields[0].last
      Specification::Specification.new(fix_version)
    end

    def fix_message_fields(line)
      start_index = line.index("8=FIX")
      end_index = line.rindex(MESSAGE_DELIMITER)

      if start_index || end_index
        line[start_index, end_index].split(MESSAGE_DELIMITER).map do |pair|
          pair.strip.split '='
        end
      else
        nil
      end
    end

    def init_output_chanel(options)
      if options[:less]
        cmd = 'less'
        cmd += ' -r' if options[:color]
        IO.popen(cmd, 'w')
      else
        STDOUT
      end
    end
  end
end
