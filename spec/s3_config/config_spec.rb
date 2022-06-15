require "spec_helper"

module S3Config
  RSpec.describe Config do
    describe ".load" do
      it "returns Config instance" do
        config = Config.load(
          {
            credentials: {
              access_key_id: "ACCESS_KEY_ID",
              secret_access_key: "SECRET_ACCESS_KEY",
            },
            region: "ap-northeast-1",
            bucket: "bucket-name",
          },
        )
        expect(config).to be_a Config
        expect(config.credentials).to eq(
          {
            access_key_id: "ACCESS_KEY_ID",
            secret_access_key: "SECRET_ACCESS_KEY",
          },
        )
        expect(config.region).to eq "ap-northeast-1"
        expect(config.bucket).to eq "bucket-name"
      end

      it "support string keys" do
        config = Config.load(
          {
            "credentials" => {
              "access_key_id" => "ACCESS_KEY_ID",
              "secret_access_key" => "SECRET_ACCESS_KEY",
            },
            "region" => "ap-northeast-1",
            "bucket" => "bucket-name",
          },
        )
        expect(config).to be_a Config
        expect(config.credentials).to eq(
          {
            access_key_id: "ACCESS_KEY_ID",
            secret_access_key: "SECRET_ACCESS_KEY",
          },
        )
        expect(config.region).to eq "ap-northeast-1"
        expect(config.bucket).to eq "bucket-name"
      end
    end

    let(:config) {
      Config.new(
        credentials: credentials,
        region: "ap-northeast-1",
        bucket: bucket,
      )
    }
    let(:credentials) {
      {
        access_key_id: "ACCESS_KEY_ID",
        secret_access_key: "SECRET_ACCESS_KEY",
      }
    }
    let(:bucket) { "bucket-name" }

    describe "create_client" do
      let(:client) { config.create_client }

      it "should be a Aws::S3::Client" do
        expect(client).to be_a ::Aws::S3::Client
        expect(client.config.credentials.credentials.access_key_id).to eq "ACCESS_KEY_ID"
        expect(client.config.credentials.credentials.secret_access_key).to eq "SECRET_ACCESS_KEY"
        expect(client.config.region).to eq "ap-northeast-1"
      end
    end

    describe "to_fog_credentials" do
      let(:fog_credentials) { config.to_fog_credentials }

      context "backet name includes ." do
        let(:credentials) { {} }
        let(:bucket) { "bucket.name" }

        it "path style is true" do
          expect(fog_credentials).to eq(
            {
              provider: "AWS",
              use_iam_profile: true,
              region: "ap-northeast-1",
              path_style: true,
            },
          )
        end
      end

      context "credentials is empty" do
        let(:credentials) { {} }

        it "uses iam profile" do
          expect(fog_credentials).to eq(
            {
              provider: "AWS",
              use_iam_profile: true,
              region: "ap-northeast-1",
              path_style: false,
            },
          )
        end
      end

      context "credentials has access_key_id, secret_access_key" do
        let(:credentials) {
          {
            access_key_id: "ACCESS_KEY_ID",
            secret_access_key: "SECRET_ACCESS_KEY",
          }
        }

        it "has keys" do
          expect(fog_credentials).to eq(
            {
              provider: "AWS",
              aws_access_key_id: "ACCESS_KEY_ID",
              aws_secret_access_key: "SECRET_ACCESS_KEY",
              region: "ap-northeast-1",
              path_style: false,
            },
          )
        end
      end

      context "credentials has profile" do
        let(:profile) {
          File.read("#{Dir.home}/.aws/credentials") =~ /^\[(.+)\]$/
          $~.captures.first
        }
        let(:credentials) {
          {
            profile: profile,
          }
        }

        it "has keys" do
          expect(fog_credentials[:provider]).to eq "AWS"
          expect(fog_credentials[:aws_access_key_id].size).to be > 0
          expect(fog_credentials[:aws_secret_access_key].size).to be > 0
          expect(fog_credentials[:region]).to eq "ap-northeast-1"
          expect(fog_credentials[:path_style]).to eq false
        end
      end
    end
  end
end
