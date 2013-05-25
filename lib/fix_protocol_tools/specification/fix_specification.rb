require 'fix_protocol_tools/specification/specification_reader'

module FixProtocolTools::Specification
  class Specification
    attr_reader :max_field_length

    def initialize(fix_version)
      reader = Reader.read_specification(fix_version)

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
