require "s3_config/version"

module S3Config
  class Error < StandardError; end
  # Your code goes here...

  def self.load(hash)
    Config.load(hash)
  end
end

require "s3_config/config"
