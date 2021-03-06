require_relative "lib/s3_config/version"

Gem::Specification.new do |spec|
  spec.name          = "s3_config"
  spec.version       = S3Config::VERSION
  spec.authors       = ["labocho"]
  spec.email         = ["labocho@penguinlab.jp"]

  spec.summary       = "S3 config loader"
  spec.description   = "S3 config loader"
  spec.homepage      = "https://github.com/socioart/s3_config"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) {|f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "aws-sdk-s3", "~> 1.114"
end
