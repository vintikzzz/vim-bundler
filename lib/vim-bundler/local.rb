require 'active_support/concern'
module VimBundler
  module Local
    extend ActiveSupport::Concern
    module Installer
      extend ActiveSupport::Concern
      include VimBundler::Actions
      def local_install
        `ln -s #{@bundle.local} #{@dir}`
        raise "unable to make symlink" unless $?.to_i == 0
      end
      def local_update
      end
      def local_clean
        `unlink #{@dir}`
        raise "unable to make unlink" unless $?.to_i == 0
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
