
class ImporterRun < WritableDashboardRecord

  scope :recent, ->{ where(ImporterRun.arel_table[:started_at].gteq(Time.now - 26.hours)) }
  scope :successful, ->{ where(error_trace: nil) }
  scope :productive, ->{ where(arel_table[:records_created].gt(0).or(arel_table[:records_updated].gt(1))) }
  scope :source_model, ->(*source){ where(source_model: [*source].flatten.map(&:to_s)) }
  scope :destination_model, ->(*dest){ where(destination_model: [*dest].flatten.map(&:to_s)) }
  scope :nagios_alerts, ->{ select(:source_model).where(destination_model:['cache:warm','processing:notes']).group(:source_model) }
  scope :check_start_cache_warm, ->{ where("completed_at >= ?", Time.zone.now.beginning_of_day).where(destination_model: ['Note', 'Feature']) }

  # The ID sequence on importer_runs is constantly out of sync, we don't know why
  def self.next_id
    maximum(:id).to_i + 1
  end

  def self.ok?
    success_count == 9
  end

  def self.success_count
    recent.successful.pluck(:source_model, :destination_model).uniq.count
  end

  def self.last_update
    models = [Case, Feature, Note, Policy]
    destination_model(models).successful.productive.maximum(:completed_at)
  end

end
