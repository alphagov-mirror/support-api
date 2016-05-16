class ServiceFeedbackAggregator

  def run(date)
    @date = date
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute(create_aggregate)
      ActiveRecord::Base.connection.execute(copy_to_archive)
    end
  end

private
  def create_aggregate
    <<-SQL
    INSERT INTO anonymous_contacts (
      type,
      path,
      created_at,
      updated_at,
      service_satisfaction_rating,
      details
    )
    SELECT
      'AggregatedServiceFeedback',
      path,
      DATE_TRUNC('day',created_at),
      DATE_TRUNC('day',created_at),
      service_satisfaction_rating,
      count(service_satisfaction_rating)
      FROM anonymous_contacts
      WHERE type = 'ServiceFeedback'
      AND created_at >= '#{@date}'
      AND created_at < '#{@date + 1.day}'
      GROUP BY 2, 3, 5;
    SQL
  end

  def copy_to_archive
    <<-SQL
    INSERT INTO archived_service_feedbacks (
      type,
      slug,
      created_at,
      service_satisfaction_rating
    )
    SELECT
      'ServiceFeedback',
      slug,
      DATE_TRUNC('day',created_at),
      service_satisfaction_rating
    FROM anonymous_contacts
    WHERE type = 'ServiceFeedback'
    AND created_at >= '#{@date}'
    AND created_at < '#{@date + 1.day}'
    SQL
  end
end
