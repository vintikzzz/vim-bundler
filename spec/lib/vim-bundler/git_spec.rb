require 'spec_helper.rb'
describe VimBundler::Git::Installer do
  context "when don't use submodule" do
    before :each do
      `rm -rf bundle`
      `rm -rf vim_bundles.lock`
    end
    let :dsl do
      dsl = VimBundler::DSL.new
    end
    let :definitions do
      dsl.bundle "snipmate", :git => "git://github.com/msanders/snipmate.vim.git"
      dsl.to_definition
    end
    context "when #install" do
      before do
        VimBundler::Installer.process_all definitions, :install
      end
      it "loads bundle from git repo" do
        `git status bundle/snipmate`.should ~ /branch\smaster/
      end
    end
    context "when #update" do
      before do
        VimBundler::Installer.process_all definitions, :install
        VimBundler::Installer.process_all definitions, :update
      end
      it "updates git repo" do
        pending "don't know how to check update"
      end
    end
    context "when #clean" do
      before do
        VimBundler::Installer.process_all definitions, :install
        VimBundler::Installer.process_all definitions, :clean
      end
      it "deletes bundle folder" do
        File.exists?("bundle/snipmate").should_not be_true
      end
    end
  end
  context "when use submodule" do
    before :each do
      `rm -rf bundle`
      `rm -rf vim_bundles.lock`
      `rm -rf .gitmodules`
      `git rm --cached bundle/snipmate`
    end
    let :dsl do
      dsl = VimBundler::DSL.new
      dsl.use_git_submodules true
      dsl
    end
    let :definitions do
      dsl.bundle "snipmate", :git => "git://github.com/msanders/snipmate.vim.git"
      dsl.to_definition
    end
    context "when #install" do
      before do
        VimBundler::Installer.process_all definitions, :install
      end
      it "adds new submodule" do
        string = File.open('.gitmodules', 'rb') { |file| file.read }
        string.should ~ /snipmate/
      end
    end
    context "when #update" do
      before do
        VimBundler::Installer.process_all definitions, :install
        VimBundler::Installer.process_all definitions, :update
      end
      it "updates submodule" do
        pending "don't know how to check update"
      end
    end
    context "when #clean" do
      before do
        VimBundler::Installer.process_all definitions, :install
        VimBundler::Installer.process_all definitions, :clean
      end
      it "deletes bundle folder" do
        File.exists?("bundle/snipmate").should_not be_true
      end
      it "removes submodule" do
        string = File.open('.gitmodules', 'rb') { |file| file.read }
        string.should_not ~ /snipmate/
      end
    end

  end
end
