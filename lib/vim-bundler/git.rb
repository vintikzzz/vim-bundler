require 'active_support/concern'
module VimBundler
  module Git
    extend ActiveSupport::Concern
    module Installer
      extend ActiveSupport::Concern
      include VimBundler::Actions
      def git_install
        if @bundle.opts[:use_git_submodules]
          `#{@opts[:git_bin]} submodule add #{@bundle.git} #{@dir} 2>&1`
          raise "unable to add submodule" unless $?.to_i == 0
        else
          `#{@bundle.opts[:git_bin]} clone #{@bundle.git} #{@dir} 2>&1`
          raise "unable to clone" unless $?.to_i == 0
        end
      end
      def git_update
        `cd #{@dir} && #{@bundle.opts[:git_bin]} pull #{@bundle.git} 2>&1 && cd - `
        raise "unable to pull" unless $?.to_i == 0
      end
      def git_clean
        begin
          clean
        rescue StandardError => e
          raise e
        ensure
          if @bundle.opts[:git_bin]
            clean_config_file('.gitmodules')
            clean_config_file('.git/config')
            lines = File.readlines('.gitmodules')
            `#{@bundle.opts[:git_bin]} rm --cached #{@dir}`
          end
        end
      end
      private
      def clean_config_file(path)
        temp = []
        delete = false
        file = File.open(path, 'r') do |f|
          while (line = f.gets)
            delete = false if line.include?('[submodule')
            delete = true if line.include?(@bundle.name) && line.include?('[submodule')
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
