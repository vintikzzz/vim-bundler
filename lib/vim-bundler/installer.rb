require 'active_support/callbacks'
module VimBundler
  class Installer
    include ActiveSupport::Callbacks
    define_callbacks :process, :all
    def self.define_actions(*args)
      args.each do |a|
        self.define_callbacks a
        self.define_singleton_method a do |d, name|
          process_all(d, a.to_s, name)
        end
      end
    end
    define_actions :install, :update, :clean
    def initialize(opts, bundle, type)
      @opts   = opts
      @bundle = bundle
      @type   = type
      @dir    = File.join(@opts[:bundles_dir], @bundle.name)
    end
    set_callback :install, :before, :check_installed
    set_callback :update,  :before, :check_dir
    set_callback :process, :after,  :final_message
    set_callback :all,     :after,  :all_final_message
    def final_message
      VimBundler.ui.info "#{@bundle.name} #{@type}ed" 
    end
    def check_installed
      if Dir.exists?(@dir)
        raise "already installed" 
      end
    end
    def check_dir
      unless Dir.exists?(@dir)
        raise "not found" 
      end
    end
    def process
      begin
        run_callbacks :process do
          run_callbacks @type do
            send("#{@bundle.type.to_s}_#{@type}")
          end
        end
      rescue StandardError => e
        VimBundler.ui.warn "#{@bundle.name} #{e.message}"
      end
    end
    def self.process_all(definitions, type, name = nil)
      FileUtils.mkdir_p(definitions[:opts][:bundles_dir])
      unless name.nil?
        bundle = definitions[:bundles][name]
        if(bundle.nil?)
          VimBundler.ui.warn "bundle #{name} not exists"
        else
          new(definitions[:opts], bundle, type).process
        end
      else
        definitions[:bundles].each do |k, bundle|
          new(definitions[:opts], bundle, type).process
        end
      end
      VimBundler.ui.confirm "all bundles processed"
    end
  end
end
