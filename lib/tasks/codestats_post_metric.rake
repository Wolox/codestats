require 'httparty'

namespace :codestats do
  desc "Code Coverage"
  task :post_metric, [:metric_name, :value, :url] do |t, args|
    post_data(metric_data(args[:metric_name], args[:value], args[:url], args[:minimum]))
  end
end

def post_data(data)
  result = HTTParty.post(
    ENV['CODESTATS_URL'],
    body: data,
    headers: { "Authorization" => ENV['CODESTATS_TOKEN']}
  )
end

def metric_data(name, value, url, minimum)
  {
    metric: {
      branch_name: ENV['CIRCLE_BRANCH'],
      name: name,
      value: value,
      url: url,
      minimum: minimum
    }
  }
end
