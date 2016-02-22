require 's3_uploader'

namespace :codestats do
  desc "Code Coverage"
  task rubycritic: :environment do
    uploader = build_uploader
    dir = ENV['REPORT_DIR'] || Rails.root.join('tmp/rubycritic').to_s
    uploader.upload(dir, bucket)
    json = JSON.parse(File.read(Rails.root.join('tmp/rubycritic/report.json')))
    url = "https://s3.amazonaws.com/#{bucket}/#{project}/#{branch}/overview.html"
    Rake::Task["codestats:post_metric"].invoke('rubycritic', json['score'], url)
  end
end

def build_uploader
  S3Uploader::Uploader.new({
   s3_key: ENV['AWS_KEY'],
   s3_secret: ENV['AWS_SECRET_KEY'],
   destination_dir: "#{project}/#{branch}",
   region: ENV['AWS_REGION']
  })
end

def project
  ENV['CIRCLE_PROJECT_REPONAME']
end

def branch
  ENV['CIRCLE_BRANCH']
end

def bucket
  ENV['AWS_BUCKET']
end
