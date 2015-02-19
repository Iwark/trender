namespace :account do
  desc 'Create History'
  task update_history: :environment do
    result = Benchmark.realtime do
      Account.by_status(:on).order(:updated_at).limit(10).each do |account|
        account.update_history
      end
    end
    puts "account:update_history: #{result}s"
  end
end