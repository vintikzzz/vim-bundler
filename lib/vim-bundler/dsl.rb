require 'ostruct'
module VimBundler
  class DSL
    def self.eval(file)
      builder = new
      builder.instance_eval(File.open(file, "rb") { |f| f.read })
      builder
    end
    def self.defaults
      @defaults ||= {}
    end
    def self.handlers
      @handlers ||= {}
    end
    def self.option(name, default = nil)
      defaults[name] = default
      define_method("#{name.to_s}") do |val|
        opts = instance_variable_get('@opts')
        opts[name] = val
      end
    end
    def self.handler(name, &block)
      handlers[name] = block
    end
    option :vimrc_file, 'vimrc'
    option :vim_bin_path, '/usr/bin/vim'
    option :bundles_dir, 'bundle'
    def initialize
      @bundles = {}
      @opts = {}
      self.class.defaults.each { |k, v| @opts[k] = v }
    end
    def bundle(*args, &block)
      bundle = OpenStruct.new(args[1])
      bundle.name = args[0]
      bundle.block = block
      self.class.handlers.each do |k, v|
        if v.call(bundle)
          bundle.type = k
          @bundles[bundle.name] = bundle
          break
        end
      end
    end
    def to_definition
      {
        :bundles => @bundles,
        :opts => @opts
      }
    end
  end
end
