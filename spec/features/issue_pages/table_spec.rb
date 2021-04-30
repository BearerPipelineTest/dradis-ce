require 'rails_helper'

describe 'issue pages' do
  describe '#index table' do
    subject { page }

    before do
      login_to_project_as_user

      @issue = create(
        :issue,
        text: "#[Title]#\nIssue1\n\n#[Risk]#\nHigh\n\n#[Description]#\nn/a",
        node: current_project.issue_library

      )
      visit project_issues_path(current_project)
    end
  end
end
