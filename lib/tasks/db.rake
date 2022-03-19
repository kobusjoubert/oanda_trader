namespace :db do
  # bin/rake db:clear_all_activities
  desc 'Destroy all activities'
  task clear_all_activities: :environment do
    Activity.destroy_all
    p 'All activities destroyed!'
  end

  # bin/rake db:clear_old_activities
  desc 'Destroy all old activities'
  task clear_old_activities: :environment do
    Activity.where('created_at < ?', 6.months.ago).destroy_all
    p 'Old activities destroyed!'
  end

  # bin/rake "db:clear_worker_activities[0001]"
  desc 'Destroy all activities by worker name'
  task :clear_worker_activities, [:worker_name] => [:environment] do |task, args|
    Activity.where(user_strategy: UserStrategy.where(strategy: Strategy.find_by_worker_name!(args.worker_name))).destroy_all
    p "All activities for #{args.worker_name} destroyed!"
  end

  # bin/rake "db:clear_white_worker_activities[0001]"
  desc 'Destroy all white activities by worker name'
  task :clear_white_worker_activities, [:worker_name] => [:environment] do |task, args|
    Activity.where(user_strategy: UserStrategy.where(strategy: Strategy.find_by_worker_name!(args.worker_name))).default.destroy_all
    p "All white activities for #{args.worker_name} destroyed!"
  end

  # bin/rake "db:clear_yellow_worker_activities[0001]"
  desc 'Destroy all yellow activities by worker name'
  task :clear_yellow_worker_activities, [:worker_name] => [:environment] do |task, args|
    Activity.where(user_strategy: UserStrategy.where(strategy: Strategy.find_by_worker_name!(args.worker_name))).warning.destroy_all
    p "All yellow activities for #{args.worker_name} destroyed!"
  end
end
