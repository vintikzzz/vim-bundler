require 'thor'
require 'thor/actions'
require 'fileutils'
require 'open-uri'
module VimBundler
  class CLI < Thor
    include Thor::Actions
    def initialize(*)
      super
      the_shell = (options["no-color"] ? Thor::Shell::Basic.new : shell)
      VimBundler.ui = UI.new(shell)
    end

    desc 'install [bundle]', 'Install vim bundles'
    def install(name = nil)
      VimBundler::Installer.install(definition, name)
    end
    desc 'update [bundle]', 'Update vim bundles'
    def update(name = nil)
      VimBundler::Installer.update(definition, name)
    end
    desc 'init', 'Initialize vim bundles'
    def init
      pathogen_path = 'autoload/pathogen.vim'
      unless File.exists? pathogen_path
        FileUtils.mkdir_p('autoload')
        open(pathogen_path, 'w+').write open('https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim').read
        VimBundler.ui.info "pathogen loaded"
      end
      unless Dir.exists?(definition[:opts][:bundles_dir])
        FileUtils.mkdir_p(definition[:opts][:bundles_dir])
        VimBundler.ui.info "bunldes dir created"
      end
      vimrc_file = definition[:opts][:vimrc_file]
      FileUtils.touch(vimrc_file) unless File.exists?(vimrc_file)
      prepend_line(vimrc_file, "call pathogen#helptags()")
      prepend_line(vimrc_file, "call pathogen#runtime_append_all_bundles()")
      VimBundler.ui.info "vimrc modified"
      VimBundler.ui.confirm "bundles inited"
    end
    desc 'clean [bundle]', 'Remove all bundles'
    def clean(name = nil)
      VimBundler::Installer.clean(definition, name)
    end
    desc 'list', 'List all installed bundles'
    def list
      definition[:bundles].each { |k, v| puts k }
    end
    private
    def definition
      file = File.join(FileUtils.pwd, VimBundler.default_bundles_file)
      @definition ||= VimBundler::DSL.eval(file).to_definition
    end
    def prepend_line(file, str)
      data = open(file, 'r+') do |f|
        while (line = f.gets)
          return if line.start_with?(str)
        end
        f.pos = 0
        temp = "#{str}\n#{f.read}"
        f.pos = 0
        f.write temp
      end
    end
  end
end
