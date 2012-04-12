module VimBundler
  module Actions
    def clean(bundle)
      dir = File.join(@opts[:bundles_dir], bundle.name)
      if Dir.exists?(dir)
        FileUtils.rm_rf(dir)
        VimBundler.ui.info "#{bundle.name} removed"
      else
        VimBundler.ui.warn "#{bundle.name} not found"
      end
    end
    def post_action(dir, bundle)
      return true if bundle.block.nil?
      cur_dir = FileUtils.pwd
      FileUtils.cd(dir)
      begin
        bundle.block.call
      rescue
        FileUtils.cd(cur_dir)
        return false
      end
      FileUtils.cd(cur_dir)
      return false unless $?.to_i == 0
      true
    end
  end
end
