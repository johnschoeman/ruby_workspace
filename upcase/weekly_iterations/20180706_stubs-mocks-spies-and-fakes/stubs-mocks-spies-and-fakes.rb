require 'rspec'
require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end


describe '#solution' do
  # stubs
  it "delegates to its clone" do
    clone = double("clone")
    solution = double("solution")
    allow(clone).to receive(:solution).and_return(solution)
    participation = Participation.new(clone: clone)

    result = participation.solution

    # expect(result).to eq(solution)
  end

  # mocks
  it "delegates to its clone" do
    clone = double("clone")
    solution = double("solution")
    expect(clone).to receive(:solution).and_return(solution)
    participation = Participation.new(clone: clone)

    result = participation.solution

    # expect(result).to eq(solution)
  end

  # mocks
  it "delegates to its clone" do
    clone = double("clone")
    solution = double("solution")
    allow(clone).to receive(:solution).and_return(solution)
    participation = Participation.new(clone: clone)

    result = participation.solution

    expect(clone).to have_received(:solution)
    # expect(result).to eq(solution)
  end
end

describe "#create_clone" do
  # stub
  it "tells the Git server to clone an exercise" do
    exercise = double("exercise")
    git_server = double("git_server")
    allow(git_server).to receive(:create_clone).with(exercise)
    participation = Participation.new(
      exercise: exercise,
      git_server: git_server
    )

    participation.create_clone
  end

# mock 
  it "tells the Git server to clone an exercise" do
    exercise = double("exercise")
    git_server = double("git_server")
    expect(git_server).to receive(:create_clone).with(exercise)
    participation = Participation.new(
      exercise: exercise,
      git_server: git_server
    )

    participation.create_clone
  end

# spy
  it "tells the Git server to clone an exercise" do
    exercise = double("exercise")
    git_server = double("git_server")
    allow(git_server).to receive(:create_clone).with(exercise)
    participation = Participation.new(
      exercise: exercise,
      git_server: git_server
    )

    participation.create_clone

    expect(git_server).to have_received(:create_clone).with(exercise)
  end
end

describe "#notify" do
  it "delivers a new comment notification" do
    comment = FactoryBot.build(:comment)
    notification = double("notification")
    allow(notification).to receive(:delivier)
    allow(CommentNotifier).
      to receive(:new).
      with(comment: comment).
      and_return(notification)

    comment.notify

    expect(notification).to have_received(:deliver)
  end
end

# fakes
# - simple example, a stub/spy would be better
describe "#create_fork" do
  it "executes a fork command" do
    shell = FakeShell.new
    repository = Repository.new(shell, "example.com", "source/path")

    repository.create_fork("target/path")

    expect(shell).to have_executed_command(
      "ssh git@example.com fork source/path target/path"
    )
  end
end

# - more complicated example
describe "#diff" do
  it "performs a diff in the local directory" do
    diff = "--- +++"
    shell = FakeShell.new
    shell.fake_command(%r{git diff}) { diff }
    Repository = Repository.new(shell, "example.com", "source/path")

    result = repository.diff("some_sha")

    expect(shell).to have_executed_command(
      "git diff some_sha --unified=10000"
    )
    expect(result).to eq(diff)
  end
end

describe "#commit" do
  it "performs a commit in a local checkout" do
    state = CommitState.new
    shell = FakeShell.new
    shell.fake_command(%r{git add -A}) { state.add }
    shell.fake_command(%r{git commit -m "(.*)"}) { |text| state.commit text }
    shell.fake_command(%r{git push}) { state.puth }
    repository = Respository.new(shell, "example.com", "source/path")

    repository.commit("Message") { FileUtils.touch("example.txt") }

    expect(state.added).to eq(["example.txt"])
    expect(state.commited).to eq(state.added)
    expect(state.pushed).to eq(state.committed)
    expect(state.message).to eq("Message")
  end
end
class Participation
  attr_reader :clone

  def initialize(clone: nil, exercise: nil, git_server: nil)
    @clone = clone
    @git_server = git_server
    @exercise = exercise
  end

  def solution
    clone.solution
    "clone.solution"
  end

  def create_clone
    @git_server.create_clone(@exercise)
  end
end

class Comment
  attr_accessor :id

  def notify
  end
end

class CommentNotifier

end

FactoryBot.define do
  factory :comment
end
