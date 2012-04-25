require 'spec_helper.rb'
describe VimBundler::VimOrg::Installer do
  before :each do
    `rm -rf bundle`
    `rm -rf vim_bundles.lock`
  end
  let :dsl do
    dsl = VimBundler::DSL.new
  end
  let :definitions do
    dsl.bundle 'indexed-search', :vim_script_id => 7062
    dsl.to_definition
  end
  context "when #install" do
    before do
      VimBundler::Installer.process_all definitions, :install
    end
    it "loads bundle vim.org" do
      File.exists?("bundle/indexed-search").should be_true
    end
  end
  context "when #update" do
    before do
      VimBundler::Installer.process_all definitions, :install
      VimBundler::Installer.process_all definitions, :update
    end
    it "updates bundle" do
      pending "don't know how to check update"
    end
  end
  context "when #clean" do
    before do
      VimBundler::Installer.process_all definitions, :install
      VimBundler::Installer.process_all definitions, :clean
    end
    it "deletes bundle folder" do
      File.exists?("bundle/indexed-search").should_not be_true
    end
  end
  context "when use as option" do
    let :dsl do
      dsl = VimBundler::DSL.new
    end
    let :definitions do
      dsl.bundle 'vrackets', :vim_script_id => 16753, :as => :plugin
      dsl.to_definition
    end
    context "when #install" do
      before do
        VimBundler::Installer.process_all definitions, :install
      end
      it "loads bundle vim.org" do
        File.exists?("bundle/vrackets/plugin").should be_true
      end
    end

  end
end
