module VimBundler
  autoload :CLI, 'vim-bundler/cli'
  autoload :DSL, 'vim-bundler/dsl'
  autoload :Installer, 'vim-bundler/installer'
  autoload :Git, 'vim-bundler/git'
  autoload :VimOrg, 'vim-bundler/vim_org'
  autoload :Local, 'vim-bundler/local'
  autoload :UI, 'vim-bundler/ui'
  autoload :Actions, 'vim-bundler/actions'
  autoload :Lock, 'vim-bundler/lock'

  class << self
    attr_accessor :ui
    def default_bundles_file
      'vim_bundles'
    end
  end
  include Git
  include VimOrg
  include Local
  include Lock
end
