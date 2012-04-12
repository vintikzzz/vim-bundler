require 'active_support/concern'
module VimBundler
  module Git
    extend ActiveSupport::Concern
    module Installer
      extend ActiveSupport::Concern
      include VimBundler::Actions
      def git_install(bundle)
        dir = File.join(@opts[:bundles_dir], bundle.name)
        if Dir.exists?(dir)
          VimBundler.ui.info "#{bundle.name} already installed" 
          return
        end
        if @opts[:use_git_submodules]
          `#{@opts[:git_bin]} submodule add #{bundle.git} #{dir} 2>&1`
        else
          `#{@opts[:git_bin]} clone #{bundle.git} #{dir} 2>&1`
        end
        if $?.to_i == 0 && post_action(dir, bundle)
          VimBundler.ui.info "#{bundle.name} installed"
        else
          VimBundler.ui.warn "#{bundle.name} not installed"
        end
      end
      def git_update(bundle)
        dir = File.join(@opts[:bundles_dir], bundle.name)
        unless Dir.exists?(dir)
          VimBundler.ui.warn "#{bundle.name} not found" 
          return
        end
        `cd #{dir} && #{@opts[:git_bin]} pull #{bundle.git} 2>&1 && cd - `
        if $?.to_i == 0 && post_action(dir, bundle)
          VimBundler.ui.info "#{bundle.name} updated"
        else
          VimBundler.ui.warn "#{bundle.name} not updated"
        end
      end
      def git_clean(bundle)
        clean(bundle)
        if @opts[:use_git_submodules]
          clean_config_file('.gitmodules', bundle)
          clean_config_file('.git/config', bundle)
          lines = File.readlines('.gitmodules')
          dir = File.join(@opts[:bundles_dir], bundle.name)
          `#{@opts[:git_bin]} rm --cached #{dir}`
        end
      end
      private
      def clean_config_file(path, bundle)
        temp = []
        delete = false
        file = File.open(path, 'r') do |f|
          while (line = f.gets)
            delete = false if line.include?('[submodule')
            delete = true if line.include?(bundle.name) && line.include?('[submodule')
            temp << line unless delete
          end
        end
        file = File.open(path, 'w') do |f|
          temp.each do |line|
            f.write line
          end
        end
      end
    end
    module DSL
      extend ActiveSupport::Concern
      included do
        handler :git do |bundle|
          bundle.respond_to?(:git)
        end
        option :use_git_submodules, false
        option :git_bin, 'git'
      end
    end
    included do
      VimBundler::Installer.send(:include, VimBundler::Git::Installer)
      VimBundler::DSL.send(:include, VimBundler::Git::DSL)
    end
  end
end
