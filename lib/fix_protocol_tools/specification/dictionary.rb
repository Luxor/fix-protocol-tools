require 'fix_protocol_tools/specification/reader'

module FixProtocolTools::Specification
  class Dictionary
    attr_reader :max_field_length

    def initialize(reader)
      @enums = reader.enums
      @fields = reader.fields
      @message_types = reader.message_types
      @max_field_length = reader.max_field_length
    end

    def field_name(field_number)
      @fields[field_number]
    end

    def message_type?(tag)
      tag == '35'
    end

    def message_type(tag35)
      @message_types[tag35]
    end

    def sender?(tag)
      tag == '49'
    end

    def target?(tag)
      tag == '56'
    end

    def heartbeat?(tag, value)
      message_type?(tag) && value == '0'
    end

    def enum_value(field, enum_id)
      enum = @enums[field]

      if enum and enum.has_key?(enum_id)
        enum[enum_id]
      else
        enum_id
      end
    end
  end
end
