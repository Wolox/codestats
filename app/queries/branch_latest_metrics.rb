class BranchLatestMetrics < SimpleDelegator
  def find
    Metric.find_by_sql([sql, id])
  end

  def sql
    'SELECT m1.*
    FROM metrics m1
    WHERE m1.branch_id = ?
      AND NOT EXISTS (SELECT 1
                      FROM metrics m2
                      WHERE m2.name = m1.name
                      AND m2.created_at > m1.created_at
                      AND m2.branch_id = m1.branch_id)'
  end
end
