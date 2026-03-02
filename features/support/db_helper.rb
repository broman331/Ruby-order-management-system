require 'pg'

class DbHelper
  def initialize
    @conn = PG.connect(
      host: ENV.fetch('DB_HOST', 'localhost'),
      port: ENV.fetch('DB_PORT', 15432),
      dbname: ENV.fetch('DB_NAME', 'orders_db'),
      user: ENV.fetch('DB_USER', 'postgres'),
      password: ENV.fetch('DB_PASSWORD', 'postgres')
    )
  end

  def execute_query(sql, params = [])
    @conn.exec_params(sql, params)
  end

  def get_order_by_id(order_id)
    execute_query('SELECT * FROM orders WHERE id = $1', [order_id]).to_a.first
  end

  def get_recent_error_logs(limit = 5)
    execute_query('SELECT * FROM error_logs ORDER BY created_at DESC LIMIT $1', [limit]).to_a
  end

  def close
    @conn.close if @conn
  end
end
