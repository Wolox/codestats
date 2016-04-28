require 'json'
require 'httparty'

namespace :codestats do
  desc "Code Coverage"
  task code_coverage: :environment do
    json = JSON.parse(File.read(Rails.root.join('coverage/.last_run.json')))
    code_coverage = json['result']['covered_percent']
    Rake::Task["codestats:post_metric"].invoke('code_coverage', code_coverage, nil, 70)
  end
end
