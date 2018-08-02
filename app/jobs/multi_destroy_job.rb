class MultiDestroyJob < ApplicationJob
  include ActivityTracking

  queue_as :dradis_project

  def perform(author_email:, ids:, klass:, project_id:, uid:)
    # FIXME: migrate logs#uid to uuid ?
    logger = Log.new(uid: uid)

    project = Project.find(project_id)

    PaperTrail.whodunnit = author_email

    items = klass.constantize.where(id: ids)

    logger.write do
      "Deleting #{items.count} #{klass.pluralize}"
    end

    ActiveRecord::Base.transaction do
      items.each do |item|
        if item.destroy
          track_destroyed(item, User.find_by_email(author_email), project)
          logger.write { "Deleted #{item.class} #{item.id}..." }
        end
      end
    end

    logger.write { 'Worker process completed.' }
  end
end
