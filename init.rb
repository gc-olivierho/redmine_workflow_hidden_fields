if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
  Rails.application.config.after_initialize do
    RedmineWorkflowHiddenFields.setup
  end
else
  require 'redmine'
  Rails.configuration.to_prepare do
    require 'issue'
    Issue.send(:prepend, RedmineWorkflowHiddenFields::IssuePatch)
    require_dependency 'issue_query'
    IssueQuery.send(:prepend, RedmineWorkflowHiddenFields::IssueQueryPatch)
    require 'issues_helper'
    IssuesHelper.send(:prepend, RedmineWorkflowHiddenFields::IssuesHelperPatch)
    require 'journal'
    Journal.send(:prepend, RedmineWorkflowHiddenFields::JournalPatch)
    require 'project'
    Project.send(:prepend, RedmineWorkflowHiddenFields::ProjectPatch)
    require 'query'
    Query.send(:prepend, RedmineWorkflowHiddenFields::QueryPatch)
    QueryColumn.send(:prepend, RedmineWorkflowHiddenFields::QueryColumnPatch)
    QueryCustomFieldColumn.send(:prepend, RedmineWorkflowHiddenFields::QueryCustomFieldColumnPatch)
    require 'workflow_permission'
    WorkflowPermission.send(:include, RedmineWorkflowHiddenFields::WorkflowPermissionPatch)
    require 'workflows_helper'
    WorkflowsHelper.send(:prepend, RedmineWorkflowHiddenFields::WorkflowsHelperPatch)
    require 'redmine/export/pdf/issues_pdf_helper'
    Redmine::Export::PDF::IssuesPdfHelper.send(:prepend, RedmineWorkflowHiddenFields::IssuesPdfHelperPatch)
  end
end

Redmine::Plugin.register :redmine_workflow_hidden_fields do
  requires_redmine :version_or_higher => '3.4.0'

  name 'Redmine Workflow Hidden Fields plugin'
  author 'Alexander Wais, David Robinson, et al.'
  description "Provides a 'hidden' issue field permission for workflows"
  version '0.5.1'
  url 'https://github.com/alexwais/redmine_workflow_hidden_fields'
  author_url 'http://www.redmine.org/issues/12005'
end
