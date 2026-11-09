require "spec_helper"
require "yaml"

describe "path filter configuration" do
  config = YAML.load_file(File.expand_path("../peak_flow.yml", __dir__))
  builds = config.fetch("builds")

  it "declares paths for every build" do
    builds.each do |_identifier, build|
      paths = build.fetch("paths")

      expect(paths).to be_an(Array)
      expect(paths).not_to be_empty
      expect(paths).to all(be_a(String))
      expect(paths).to all(satisfy { |pattern| !pattern.strip.empty? })
    end
  end

  it "keeps every build covering the source its suite runs" do
    builds.each do |_identifier, build|
      expect(build.fetch("paths")).to include("lib/**", "spec/**", "Gemfile", "Gemfile.lock", "awesome_counter_cache.gemspec")
    end
  end

  it "keeps the lint tooling config with the lint build" do
    expect(builds.fetch("linters").fetch("paths")).to include(".rubocop.yml", ".rubocop_todo.yml")

    builds.reject { |identifier, _build| identifier == "linters" }.each do |_identifier, build|
      expect(build.fetch("paths")).not_to include(".rubocop.yml", ".rubocop_todo.yml")
    end
  end

  it "leaves documentation and CI configuration outside every build" do
    builds.each do |_identifier, build|
      expect(build.fetch("paths")).not_to include("README.md", "MIT-LICENSE", ".github/dependabot.yml")
    end
  end
end
