module DashboardPlatform
  class Resources::HiddenColumns < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!('Record not found', 404)
    end

    helpers do
      def update_hidden_columns(params)
        error = false
        HiddenColumn.where(column_name: params.keys).each do |column|
          error = assign_column(column)
        end
        !error
      end

      def assign_column(column)
        user_column = UserHiddenColumn.find_or_initialize_by(user_id: current_user.id, hidden_column_id: column.id)
        user_column.display = !params[column.column_name]
        error = true unless user_column.save
        error
      end
    end

    resource :hidden_columns do
      get do
        user_columns = UserHiddenColumn.where(user_id: current_user.id).select(:id, :hidden_column_id, :display)
        columns = HiddenColumn.all.select(:id, :column_name, :display)
        columns.each do |column|
          user_column = user_columns.where(hidden_column_id: column.id).first
          column.display = user_column.display if user_column
        end
      end

      post do
        update_hidden_columns(params)
      end

      put do
        update_hidden_columns(params)
      end
    end
  end
end
