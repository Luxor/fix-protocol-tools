require 'rexml/document'
require 'rexml/streamlistener'

module FixProtocolTools::Specification
  class Reader
    include REXML::StreamListener
    SPECIFICATION_PATH = File.join(File.expand_path(File.dirname(__FILE__)), 'xml')

    attr_reader :fields, :message_types, :enums, :max_field_length

    def self.read_defaults(fix_version)
      path = File.join(SPECIFICATION_PATH, fix_version.delete('.') + '.xml')
      read_file(path)
    end

    def self.read_file(path)
      reader = new

      File.open(path, 'r') do |file|
        REXML::Document.parse_stream(file, reader)
      end

      reader
    end

    def initialize
      @message_types = {}
      @fields = {}
      @enums = Hash.new { |h, k| h[k] = {} }

      @max_field_length = 0
    end

    def tag_start(tag_name, attrs)
      if message?(attrs, tag_name)
        @message_types[attrs['msgtype']] = attrs['name']
      end

      if field_definition?(attrs, tag_name)
        @current_field = attrs['number']
        @fields[attrs['number']] = attrs['name']
      end

      if enum_value?(attrs, tag_name)
        @enums[@current_field][attrs['enum']] = attrs['description']
      end

      if attrs.has_key? 'name'
        @max_field_length = [@max_field_length, attrs['name'].length].max
      end
    end

    private

    def field_definition?(attrs, tag_name)
      tag_name == 'field' && attrs.has_key?('number') && attrs.has_key?('name')
    end

    def enum_value?(attrs, tag_name)
      tag_name == 'value' && attrs.has_key?('enum')
    end

    def message?(attrs, tag_name)
      tag_name == 'message' && attrs.has_key?('name') != nil && attrs['msgtype'] != nil && attrs['msgcat'] != nil
    end
  end
end