# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vim-bundler}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Pavel Tatarsky}]
  s.date = %q{2012-04-25}
  s.description = %q{This gem provides a simple way to manage your vim bundles (aka plugins).
If you are familiar with ruby gem bundler - you are familar with vim-bundler.}
  s.email = %q{fazzzenda@mail.ru}
  s.executables = [%q{vbundle}]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "GuardFile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/vbundle",
    "lib/vim-bundler.rb",
    "lib/vim-bundler/actions.rb",
    "lib/vim-bundler/cli.rb",
    "lib/vim-bundler/dsl.rb",
    "lib/vim-bundler/git.rb",
    "lib/vim-bundler/installer.rb",
    "lib/vim-bundler/local.rb",
    "lib/vim-bundler/lock.rb",
    "lib/vim-bundler/ui.rb",
    "lib/vim-bundler/vim_org.rb",
    "spec/lib/vim-bundler/git_spec.rb",
    "spec/lib/vim-bundler/local_spec.rb",
    "spec/lib/vim-bundler/vim_org_spec.rb",
    "spec/spec_helper.rb",
    "vim-bundler.gemspec"
  ]
  s.homepage = %q{http://github.com/vintikzzz/vim-bundler}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Bundler for vim}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.1.0.beta1"])
      s.add_runtime_dependency(%q<thor>, [">= 0.14.6"])
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.1.0.beta1"])
      s.add_dependency(%q<thor>, [">= 0.14.6"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.1.0.beta1"])
    s.add_dependency(%q<thor>, [">= 0.14.6"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

