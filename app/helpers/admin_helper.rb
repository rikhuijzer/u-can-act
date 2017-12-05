# frozen_string_literal: true

module AdminHelper
  def file_headers!(name)
    file_name = "#{name}.csv"
    headers['Content-Type'] = 'text/csv'
    headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
  end

  def overview(group)
    @organization_overview.map do |organization|
      percentage_completed = 0
      if organization[:data][group][:total] > 0
        100 * organization[:data][group][:completed] / organization[:data][group][:total]       
      end
      {
        name: organization[:name],
        completed: organization[:data][group][:completed],
        percentage_completed: percentage_completed
      }
    end 
  end

  def streaming_headers!
    # nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'
    headers['Cache-Control'] ||= 'no-cache'
    headers.delete('Content-Length')
  end

  def date_string
    Time.zone.now.to_date.to_s
  end

  def idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end

  def questionnaire_select_options(questionnaires)
    result = [['Selecteer een vragenlijst...', '']]
    questionnaires.each do |questionnaire|
      result << [questionnaire.name, questionnaire.name]
    end
    result
  end
end
