require "spec_helper"

describe AwesomeCounterCache do
  let(:user) { create :user }

  it "counts up" do
    expect(user.roles_count).to eq 0

    user.roles.create!
    expect(user.roles_count).to eq 1

    user.roles.create!
    expect(user.roles_count).to eq 2
  end

  it "counts down" do
    user.roles.create!
    user.roles.create!
    expect(user.roles_count).to eq 2

    user.roles.first.destroy!
    expect(user.roles_count).to eq 1

    user.roles.first.destroy!
    expect(user.roles_count).to eq 0
  end
end
