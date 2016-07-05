# coding: utf-8
require 'xmlsimple'

module QuickRadioPlaylist
  KEYS = %w[ title artist ]

  module Run
    extend self

    def create_output(substitutions)
      File.open 'var/template_sample.html', 'r' do |f_template|
        lines = f_template.readlines
        File.open 'var/output.html', 'w' do |f_out|
          lines.each{|e| f_out.print substitutions.run e}
        end
      end
    end

    def run
      song_currently_playing = Snapshot.new.values
      substitutions = Substitutions.new song_currently_playing
      create_output substitutions
    end
  end

  class Snapshot
    attr_reader :values

    def initialize
      values_from_xml_get unless defined? @@values
      @values = @@values
    end

    protected

    def values_from_xml_get
      relevant_hash = xml_tree['Events'].first['SS32Event'].first
      @@values = KEYS.map{|k| relevant_hash[k].first.strip}
    end

    def xml_tree
# See http://xml-simple.rubyforge.org/
      result = XmlSimple.xml_in 'var/input.xml', { KeyAttr: 'name' }
#     puts result
#     print result.to_yaml
      result
    end
  end

  class Substitutions
    def initialize(current_values)
      @substitutions = KEYS.map{|e| "[#{e} here]"}.zip current_values
    end

    def run(s)
      @substitutions.each{|input,output| s = s.gsub input, output}
      s
    end
  end
end