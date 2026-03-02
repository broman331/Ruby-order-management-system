After do |scenario|
  if scenario.failed?
    begin
      puts "\n=========================================================="
      puts "❌ Scenario Failed: #{scenario.name}"
      puts "🔍 Agentic Self-Healing: Retrieving latest error logs from PostgreSQL DB..."
      
      # Utilizing our existing DbHelper
      error_logs = @db_helper.get_recent_error_logs(5)
      
      if error_logs.empty?
        puts "   No recent error logs found in database."
      else
        puts "   -- Database Error Logs (Last #{error_logs.size} entries) --"
        error_logs.each do |log|
          puts "   [#{log['created_at']}] ERROR: #{log['error_message']} | Details: #{log['details']}"
        end
      end
    rescue => e
      puts "⚠️ Failed to fetch error logs from Database: #{e.message}"
    ensure
      puts "==========================================================\n"
    end
  end
  
  @db_helper&.close
end
