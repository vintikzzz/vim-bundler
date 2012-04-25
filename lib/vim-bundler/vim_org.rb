require 'active_support/concern'
require 'open-uri'
module VimBundler
  module VimOrg
    extend ActiveSupport::Concern
    module Installer
      extend ActiveSupport::Concern
      include VimBundler::Actions
      def vim_org_install
        FileUtils.mkdir_p(@dir)
        f = open("http://www.vim.org/scripts/download_script.php?src_id=#{@bundle.vim_script_id}")
        local_file = f.meta["content-disposition"].gsub(/attachment; filename=/,"")

        # if local_file.end_with? 'tar.gz'
          # data = open(File.join(dir, local_file), 'w')
          # data.write f.read
          # data.close
          # `tar xvfz #{data.path}`
        # end
        if local_file.end_with? 'vim'
          as = @bundle.respond_to?(:as) ? @bundle.as.to_s : 'plugin'
          FileUtils.mkdir_p(File.join(@dir, as))
          data = open(File.join(@dir, as, local_file), 'w')
          data.write f.read
          data.close
        end
      end
      def vim_org_update
        clean
        vim_org_install
      end
      def vim_org_clean
        clean
      end
    end
    module DSL
      extend ActiveSupport::Concern
      included do
        handler :vim_org do |bundle|
          bundle.respond_to?(:vim_script_id)
        end
      end
    end
    included do
      VimBundler::Installer.send(:include, VimBundler::VimOrg::Installer)
      VimBundler::DSL.send(:include, VimBundler::VimOrg::DSL)
    end
  end
end
