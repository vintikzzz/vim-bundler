require 'spec_helper.rb'
describe VimBundler::Local::Installer do
  before :each do
    `rm -rf bundle`
    `rm -rf vim_bundles.lock`
  end
  let :dsl do
    dsl = VimBundler::DSL.new
  end
  let :definitions do
    dsl.bundle 'spec', :local => "spec"
    dsl.to_definition
  end
  context "when #install" do
    before do
      VimBundler::Installer.process_all definitions, :install
    end
    it "creates symlink" do
      `ls -al bundle/spec`.should ~ /-> spec/
    end
  end
  context "when #update" do
    before do
      VimBundler::Installer.process_all definitions, :install
      VimBundler::Installer.process_all definitions, :update
    end
    it "does nothing" do
      `ls -al bundle/spec`.should ~ /-> spec/
    end
  end
  context "when #clean" do
    before do
      VimBundler::Installer.process_all definitions, :install
      VimBundler::Installer.process_all definitions, :clean
    end
    it "unlinks folder" do
      `ls -al bundle/spec 2>/dev/null`.should be_empty
    end
  end
end
