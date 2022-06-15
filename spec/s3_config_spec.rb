require "spec_helper"

RSpec.describe S3Config do
  it "has a version number" do
    expect(S3Config::VERSION).not_to be nil
  end

  describe ".load" do
    it "delegates S3Config::Config.load" do
      arg = Object.new
      r = Object.new
      expect(S3Config::Config).to receive(:load).with(arg).and_return(r)
      expect(S3Config.load(arg)).to eq r
    end
  end
end
