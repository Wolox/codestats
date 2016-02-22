require 'json'
require 'httparty'

namespace :codestats do
  desc "Code Coverage"
  task code_coverage: :environment do
    json = JSON.parse(File.read(Rails.root.join('coverage/.last_run.json')))
    code_coverage = json['result']['covered_percent']
    post_data(code_coverage)
  end
end

def post_data(code_coverage)
  result = HTTParty.post(
    ENV['CODESTATS_URL'],
    body: metric_data(code_coverage),
    headers: { "Authorization" => ENV['CODESTATS_TOKEN']}
  )
end

def metric_data(value)
  {
    metric: {
      branch_name: ENV['CIRCLE_BRANCH'],
      name: 'code_coverage',
      value: value
    }
  }
end
