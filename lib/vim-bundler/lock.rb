# encoding: UTF-8
require 'active_support/concern'
require 'yaml'
module VimBundler
  module Lock
    def self.default_lock_file
      file = File.join(FileUtils.pwd, VimBundler.default_bundles_file) + ".lock"
    end
    def self.merge_lock!(definitions)
      data = {}
      file = VimBundler::Lock.default_lock_file
      data = YAML.load_file(file) if File.exists?(file)
      data.each do |k, v| 
        v[:name] = k
        v[:block] = nil
        v[:installed] = true
        bundle = OpenStruct.new(v)
        bundle.define_singleton_method :opts do
          v[:opts]
        end
        data[k] = bundle
      end
      definitions[:bundles].merge! data
      definitions
    end
    extend ActiveSupport::Concern
    module Installer
      extend ActiveSupport::Concern
      def write_to_lock
        file = VimBundler::Lock.default_lock_file
        data = {}
        data = YAML.load_file(file) if File.exists?(file)
        hash = @bundle.marshal_dump
        hash[:opts] = @bundle.opts
        data[hash[:name].to_s] = hash.select { |k, v| not [:name, :block].include? k }
        File.open(file, 'w') { |f| f.write(data.to_yaml) }
      end
      def remove_from_lock
        file = VimBundler::Lock.default_lock_file
        data = {}
        data = YAML.load_file(file) if File.exists?(file)
        data.delete(@bundle.name.to_s)
        File.open(file, 'w') { |f| f.write(data.to_yaml) }
      end
      included do
        set_callback :install, :after,  :write_to_lock
        set_callback :clean,   :after,  :remove_from_lock
        YAML::ENGINE.yamler = 'syck'
      end
    end
    module CLI
      extend ActiveSupport::Concern
      private
      def definition_with_lock
        VimBundler::Lock.merge_lock!(definition_without_lock)
      end
      def prepare_name_with_lock(bundle)
        suffix = bundle.installed.nil? ? " (not installed)" : ""
        bundle.name + suffix 
      end
      included do
        alias_method_chain :definition, :lock
        alias_method_chain :prepare_name, :lock
      end
    end
    included do
      VimBundler::Installer.send(:include, VimBundler::Lock::Installer)
      VimBundler::CLI.send(:include, VimBundler::Lock::CLI)
    end
  end
end
