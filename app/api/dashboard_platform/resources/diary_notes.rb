module DashboardPlatform
  class Resources::DiaryNotes < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!('Record not found', 404)
    end

    helpers do
      def create_diary_notification(note)
        return unless current_user.adjuster?
        target_user_id = User.find_by(dashboard_adjuster_id: note.feature.current_adjuster).try(:id)
        triggering_user_id = current_user.id

        return unless target_user_id
        Notification.create(
          notification: note,
          triggering_user_id: triggering_user_id,
          target_user_id: target_user_id,
          dashboard_compound_key: note.dashboard_compound_key
        )
      end
    end

    resource :diary_notes do
      params do
        mutually_exclusive :dashboard_manager_id, :dashboard_adjuster_id
      end
      get do
        if params[:dashboard_manager_id]
          # Find all the user_ids of the manager and their adjusters
          user_ids = User.where(dashboard_manager_id: params[:dashboard_manager_id]).pluck(:id)
        elsif params[:dashboard_adjuster_id]
          # Find the adjuster and their manager's user_ids
          # Get all displayable diary notes for those ids
          adjuster_user = User.select(:id, :dashboard_manager_id).find_by(dashboard_adjuster_id: params[:dashboard_adjuster_id])
          if adjuster_user
            manager_user = User.select(:id).find_by(dashboard_manager_id: adjuster_user.dashboard_manager_id, dashboard_adjuster_id: nil)
            if manager_user
              user_ids = [adjuster_user.try(:id), manager_user.try(:id)]
            end
          end
        else
          if current_user.adjuster
            # Get the user's ID and their manager's ID
            manager_id = User.select(:id).find_by(dashboard_manager_id: current_user.adjuster.manager_id,
                                                  dashboard_adjuster_id: nil)
            user_ids = [current_user.id, manager_id.try(:id)] if manager_id
          else
            # Get the user's ID and their adjusters' IDs
            user_ids = User.where(dashboard_manager_id: current_user.dashboard_manager_id).pluck(:id)
          end
        end

        DiaryNote.where(user_id: user_ids).displayable.order('created_at desc')
      end

      get ':id' do
        note = DiaryNote.by_dashboard_compound_key(params[:id]).displayable.order(updated_at: :desc)
        can?(:read, note) ? note : status(403)
      end

      post do
        return status(403) unless can?(:create, DiaryNote)
        labels = []
        if params[:diary_note_types]
          labels = params[:diary_note_types].map { |label| DiaryNoteType.find_by(name: label.downcase) }
        end
        note = DiaryNote.create(
          diary: params[:diary],
          dashboard_compound_key: params[:feature_id],
          user_id: current_user.id,
          diary_note_types: labels.compact
        )
        create_diary_notification(note)
        Rails.cache.delete("feature/#{note.dashboard_compound_key}")
        return status(400) unless note.persisted?
        note
      end

      # always do deletes as a post
      post ':id' do
        note = DiaryNote.displayable.find(params[:id])
        return status(403) unless can?(:destroy, note)
        Rails.cache.delete("feature/#{note.dashboard_compound_key}")
        note.update(deleted: true)
        { last_manager_note: NoteSerializer.new(note.feature.last_manager_note),
          last_adjuster_note: NoteSerializer.new(note.feature.last_adjuster_note),
          last_diary_note: DiaryNoteSerializer.new(note.feature.last_diary_note) }
      end

      put ':id' do
        note = DiaryNote.displayable.find(params[:id])
        return status(403) unless can?(:update, note)
        note.update(
          diary: params[:diary].nil? ? note.diary : params[:diary]
        )
        Rails.cache.delete("feature/#{note.dashboard_compound_key}")
        note
      end
    end
  end
end
