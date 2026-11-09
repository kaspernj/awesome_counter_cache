require "spec_helper"
require "yaml"

describe "path filter configuration" do
  config = YAML.load_file(File.expand_path("../peak_flow.yml", __dir__))
  builds = config.fetch("builds")

  # `bundle install`, `rails db:schema:load`, `rspec` and `rubocop` never open these, so a
  # delivery that touches only them should skip every lane.
  unread_by_every_build = [".github/**", ".gitignore", "MIT-LICENSE", "README.md"]

  # Every lane installs from the lockfile and the toolchain pin, so negating one of these
  # could skip a lane the change is able to break.
  read_by_every_build = ["Gemfile", "Gemfile.lock", "awesome_counter_cache.gemspec", "Rakefile", ".ruby-version"]

  it "declares paths for every build" do
    builds.each do |_identifier, build|
      paths = build.fetch("paths")

      expect(paths).to be_an(Array)
      expect(paths).not_to be_empty
      expect(paths).to all(be_a(String))
      expect(paths).to all(satisfy { |pattern| !pattern.strip.empty? })
    end
  end

  it "keeps every build on the deny-list shape so an unlisted path still runs it" do
    builds.each do |_identifier, build|
      expect(build.fetch("paths").first).to eq("**")
    end
  end

  it "never negates a path a build reads" do
    builds.each do |_identifier, build|
      negated = build.fetch("paths").map { |pattern| pattern.sub(/^!/, "") }

      expect(negated).not_to include(*read_by_every_build)
    end
  end

  it "skips every build for documentation and CI configuration only" do
    builds.each do |_identifier, build|
      expect(build.fetch("paths")).to include(*unread_by_every_build.map { |pattern| "!#{pattern}" })
    end
  end

  it "keeps the lint tooling config with the lint build" do
    expect(builds.fetch("linters").fetch("paths")).not_to include("!.rubocop.yml", "!.rubocop_todo.yml")

    builds.reject { |identifier, _build| identifier == "linters" }.each do |_identifier, build|
      expect(build.fetch("paths")).to include("!.rubocop.yml", "!.rubocop_todo.yml")
    end
  end
end
