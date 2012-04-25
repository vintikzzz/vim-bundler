module VimBundler
  module Actions
    def clean
      if Dir.exists?(@dir)
        FileUtils.rm_rf(@dir)
      else
        raise "not found"
      end
    end
    def post_action
      return true if @bundle.block.nil?
      cur_dir = FileUtils.pwd
      FileUtils.cd(@dir)
      begin
        @bundle.block.call
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
