class NagiosAlertSerializer < ActiveModel::Serializer
  attributes :ip, :nagios_alerts

  def nagios_alerts
    [].tap do |alert|
      object.alerts.each do |a|
        alert << send(a)
      end
    end
  end

  def processing
    {}.tap do |response|
      response['processing:notes'] = {}
      processing_date = ImporterRun.where(source_model: object.ip, destination_model: 'processing:notes').maximum(:completed_at)
      response['processing:notes']['status'] = (processing_date && within_a_day(processing_date)) ? 'OK' : 'CRITICAL'
      response['processing:notes']['last_success'] = processing_date
    end
  end

  def import
    {}.tap do |response|
      response['import:oracle:all'] = {}
      response['import:oracle:all']['status'] = (ImporterRun.last_update && within_a_day(ImporterRun.last_update)) ? 'OK' : 'CRITICAL'
      response['import:oracle:all']['last_success'] = ImporterRun.last_update
    end
  end

  def cache
    {}.tap do |response|
      response['cache:warm'] = {}
      cache_warm_date = ImporterRun.where(source_model: object.ip, destination_model: 'cache:warm').maximum(:completed_at)
      response['cache:warm']['status'] = (cache_warm_date && within_a_day(cache_warm_date)) ? 'OK' : 'CRITICAL'
      response['cache:warm']['last_success'] = cache_warm_date
    end
  end

  def within_a_day(date)
    Time.now - 24.hours < date
  end
end
