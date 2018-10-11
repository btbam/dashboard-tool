module DataSyncHelper
  extend ActiveSupport::Concern
  
  def save
    raise 'DataSync Classes cannot save'
  end

  def create
    raise 'DataSync Classes cannot create'
  end

  def update
    raise 'DataSync Classes cannot update'
  end

  def delete
    raise 'DataSync Classes cannot delete'
  end
end
