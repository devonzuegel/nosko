def permission_granted?(question)
  loop do
    print "#{question} (Y/N)  "
    answer = gets.chomp
    return true  if answer.downcase == 'y'
    return false if answer.downcase == 'n'
    puts '  > Please respond with Y or N'
  end
end

if permission_granted?('Promote `nosko-staging` (staging) to `nosko` (production)?')
  puts 'Promoting...'
  puts `/usr/local/heroku/bin/heroku pipelines:promote --app nosko-staging`
  puts 'Migrating...'
  puts `/usr/local/heroku/bin/heroku run rake db:migrate --app nosko`
end

if permission_granted?('Open heroku logs?')
  puts 'Opening heroku logs...'
  exec '/usr/local/heroku/bin/heroku logs -t --app nosko-production'
end