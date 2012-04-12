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
    def initialize(opts)
      @opts = opts
    end
    private
    def self.process(installer, type, bundle)
      installer.run_callbacks(type.to_sym, bundle) do
        installer.run_callbacks(:process, bundle) do
          installer.send("#{bundle.type.to_s}_#{type}", bundle)
        end
      end
    end
    def self.process_all(definitions, type, name)
      installer = new(definitions[:opts])
      installer.run_callbacks(:all) do
        unless name.nil?
          bundle = definitions[:bundles][name]
          if(bundle.nil?)
            VimBundler.ui.warn "bundle #{name} not exists"
          else
            process(installer, type, definitions[:bundles][name])
          end
        else
          definitions[:bundles].each do |k, v|
            process(installer, type, v)
          end
        end
      end
      VimBundler.ui.confirm "all bundles processed"
    end
  end
end
