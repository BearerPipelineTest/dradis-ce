json.recordsTotal current_project.issues.count
json.recordsFiltered @issues.count
json.data @issues do |issue|
  json.partial! 'issue', issue: issue
end
