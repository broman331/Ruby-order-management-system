require 'pg'

module Db
  class << self
    def connection
      @connection ||= PG.connect(
        host: ENV.fetch('DB_HOST', 'localhost'),
        port: ENV.fetch('DB_PORT', 5432),
        dbname: ENV.fetch('DB_NAME', 'orders_db'),
        user: ENV.fetch('DB_USER', 'postgres'),
        password: ENV.fetch('DB_PASSWORD', 'postgres')
      )
    end

    def execute(sql, params = [])
      connection.exec_params(sql, params)
    end

    def log_error(message, details = nil)
      execute('INSERT INTO error_logs (error_message, details) VALUES ($1, $2)', [message, details])
    rescue => e
      puts "CRITICAL DB FAILURE: Cannot log to error_logs: #{e.message}"
    end
  end
end
