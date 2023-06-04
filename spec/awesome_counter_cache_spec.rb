require "spec_helper"

describe AwesomeCounterCache do
  let(:account) { create :account }
  let(:another_user) { create :user }
  let(:project) { create :project, account: account }
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

    expect(user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)

    task.update!(important: false)

    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 1)
  end

  it "changes counter cache based on changed delta magnitude (with an account)" do
    expect(user.reload.important_tasks_count).to eq 0

    task = create :task, important: true, project: project, user: user

    expect(account.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)
    expect(user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)

    task.update!(important: false)

    expect(account.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 1)
    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 1)
  end

  it "reloads the initial value on reload" do
    task = create :task, important: true, user: user
    same_task = Task.find(task.id)

    expect(user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)

    same_task.update!(important: false)

    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 1)

    task.with_lock do
      task.update!(important: false)
    end

    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 1)
  end

  it "overwrites reload but continues to let it work like before" do
    task = create :task, important: true, user: user
    expect(task.reload).to eq task
  end

  it "reduces one and increases another when a relationship is changed" do
    task = create :task, important: true, user: user

    expect(user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)
    expect(another_user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 0)

    task.update!(user: another_user)

    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 0)
    expect(another_user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)
  end

  it "decreases one and ignores the invalid when a relationship is changed to an invalid record" do
    task = create :task, important: true, user: user

    expect(user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)

    task.update!(user_id: 123)

    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 0)
  end

  it "reduces one and increases another + updates delta magintude when a relationship is unchanged togehter with an attribute" do
    task = create :task, important: true, user: user

    expect(user.reload).to have_attributes(important_tasks_count: 1, unimportant_tasks_count: 0)
    expect(another_user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 0)

    task.update!(important: false, user: another_user)

    expect(user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 0)
    expect(another_user.reload).to have_attributes(important_tasks_count: 0, unimportant_tasks_count: 1)
  end
end
