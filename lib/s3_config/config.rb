require "aws-sdk-s3"

module S3Config
  Config = Struct.new(:credentials, :region, :bucket, keyword_init: true) do
    class << self
      def load(hash)
        config = new
        hash.each do |k, v|
          raise "Cannot recognize configutation #{k.inspect}" unless members.include?(k.to_sym)

          config[k] = deep_symbolize_keys(v)
        end
        config
      end

      def deep_symbolize_keys(o)
        case o
        when Array
          o.map {|e| deep_symbolize_keys(e) }
        when Hash
          o.each_with_object({}) do |(k, v), h|
            h[k.to_sym] = deep_symbolize_keys(v)
          end
        else
          o
        end
      end
    end

    def create_client
      Aws::S3::Client.new(credentials.merge(region: region))
    end

    def to_fog_credentials
      if credentials == {}
        {
          provider: "AWS",
          use_iam_profile: true,
          region: region,
          path_style: path_style,
        }
      else
        c = create_client
        {
          provider: "AWS",
          aws_access_key_id: c.config.credentials.credentials.access_key_id,
          aws_secret_access_key: c.config.credentials.credentials.secret_access_key,
          region: region,
          path_style: path_style,
        }
      end
    end

    def path_style
      # バケット名に . が含まれる場合、バケット名をサブドメインにできないため、共通のドメインの下に、パスにバケット名を含む URL になる。
      # path_style でこれを明示しないと fog-aws が警告のログを url 生成ごとに出力するので、抑制する。
      # https://github.com/fog/fog-aws/blob/v3.5.2/lib/fog/aws/storage.rb#L287
      # https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
      bucket.include?(".")
    end
  end
end
