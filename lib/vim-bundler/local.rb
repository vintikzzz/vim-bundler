require 'active_support/concern'
module VimBundler
  module Local
    extend ActiveSupport::Concern
    module Installer
      extend ActiveSupport::Concern
      include VimBundler::Actions
      def local_install(bundle)
        dir = File.join(@opts[:bundles_dir], bundle.name)
        if Dir.exists?(dir)
          VimBundler.ui.info "#{bundle.name} already installed" 
          return
        end
        `ln -s #{bundle.local} #{dir}`
        if $?.to_i == 0 && post_action(dir, bundle)
          VimBundler.ui.info "#{bundle.name} installed"
        else
          VimBundler.ui.warn "#{bundle.name} not installed"
        end
      end
      def local_update(bundle)
        dir = File.join(@opts[:bundles_dir], bundle.name)
        unless Dir.exists?(dir)
          VimBundler.ui.warn "#{bundle.name} not found" 
          return
        end
        if post_action(dir, bundle)
          VimBundler.ui.info "#{bundle.name} updated"
        else
          VimBundler.ui.warn "#{bundle.name} not updated"
        end
      end
      def local_clean(bundle)
        dir = File.join(@opts[:bundles_dir], bundle.name)
        if Dir.exists?(dir)
          `unlink #{dir}`
          VimBundler.ui.info "#{bundle.name} removed"
        else
          VimBundler.ui.warn "#{bundle.name} not found"
        end
      end
    end
    module DSL
      extend ActiveSupport::Concern
      included do
        handler :local do |bundle|
          bundle.respond_to?(:local)
        end
      end
    end
    included do
      VimBundler::Installer.send(:include, VimBundler::Local::Installer)
      VimBundler::DSL.send(:include, VimBundler::Local::DSL)
    end
  end
end
