require "spec_helper"

describe AwesomeCounterCache do
  let(:user) { create :user }

  it "counts up" do
    expect(user.roles_count).to eq 0
    user.roles.create!
    expect(user.reload.roles_count).to eq 1
    user.roles.create!
    expect(user.reload.roles_count).to eq 2
  end

  it "counts down" do
    user.roles.create!
    user.roles.create!
    expect(user.reload.roles_count).to eq 2
    user.roles.first.destroy!
    expect(user.reload.roles_count).to eq 1
    user.roles.first.destroy!
    expect(user.reload.roles_count).to eq 0
  end

  it "changes counter cache based on changed delta magnitude" do
    expect(user.reload.important_tasks_count).to eq 0

    task = create :task, important: true, user: user

    expect(user.reload.important_tasks_count).to eq 1
    expect(user.reload.unimportant_tasks_count).to eq 0

    task.update!(important: false)

    expect(user.reload.important_tasks_count).to eq 0
    expect(user.reload.unimportant_tasks_count).to eq 1
  end

  it "reloads the initial value on reload" do
    task = create :task, important: true, user: user
    same_task = Task.find(task.id)

    expect(user.reload.important_tasks_count).to eq 1
    expect(user.reload.unimportant_tasks_count).to eq 0

    same_task.update!(important: false)

    expect(user.reload.important_tasks_count).to eq 0
    expect(user.reload.unimportant_tasks_count).to eq 1

    task.with_lock do
      task.update!(important: false)
    end

    expect(user.reload.important_tasks_count).to eq 0
    expect(user.reload.unimportant_tasks_count).to eq 1
  end

  it "overwrites reload but continues to let it work like before" do
    task = create :task, important: true, user: user
    expect(task.reload).to eq task
  end
end
