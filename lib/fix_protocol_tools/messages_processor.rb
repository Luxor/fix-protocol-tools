require 'term/ansicolor'
require 'logger'
require 'fix_protocol_tools/specification/dictionary'

module FixProtocolTools
  class MessagesProcessor
    include Term::ANSIColor
    MESSAGE_DELIMITER = "\x01"

    def initialize(options)
      @spec = nil
      @is_even_line = true
      @output = init_output_chanel options
      @grep = options[:grep]

      if options[:dictionary]
        @spec = Specification::Dictionary.new(Specification::Reader.read_file(options[:dictionary]))
      end
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

    def print_row(line)
      @output.puts(@is_even_line ? green(line) : line)
      @is_even_line = !@is_even_line
    end

    def process_line(line)
      fields = fix_message_fields(line.gsub('^A', MESSAGE_DELIMITER))
      return unless fields

      @spec ||= resolve_specification(fields)
      rows = []
      is_found = @grep.nil?
      message_name = 'Undefined'
      sender = 'Undefined'
      target = 'Undefined'

      fields.each do |field_id, value_id|
        field_name = @spec.field_name(field_id) || field_id
        field_name_padding = @spec.max_field_length - field_name.length - 2
        value_name = if @spec.message_type?(field_id)
                       message_name = @spec.message_type(value_id)
                     else
                       @spec.enum_value(field_id, value_id)
                     end
        sender = value_name if @spec.sender? field_id
        target = value_name if @spec.target? field_id

        if @grep && (value_name.include?(@grep) || value_id.include?(@grep))
          value_name = red(value_name)
          is_found = true
        end

        rows << formatted_row(field_id, value_id, field_name, value_name, field_name_padding)
      end

      if is_found
        @is_even_line = false
        @output.puts ''
        @output.puts("[#{red(message_name + " #{sender} >>> #{target}")}]" +
                         yellow(" =-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=        "))
        rows.each { |row| print_row(row) }
      end
    end

    def formatted_row(field_id, value_id, field_name, value_name, field_name_padding)
      field_name + '  =  '.rjust(field_name_padding) + value_name +
          '  '.rjust(35 - value_name.length) +
          field_id + '=' + value_id
    end

    def resolve_specification(fields)
      fix_version = fields[0].last
      Specification::Dictionary.new(Specification::Reader.read_defaults(fix_version))
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

