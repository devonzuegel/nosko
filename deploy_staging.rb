def precompile_assets?
  loop do
    print 'Precompile assets? (Y/N)  '
    answer = gets.chomp
    return true  if answer.downcase == 'y'
    return false if answer.downcase == 'n'
    puts '  > Please respond with Y or N'
  end
end

if precompile_assets?
  puts 'Precompiling assets...'
  `RAILS_ENV=production bundle exec rake assets:precompile`
  puts 'Committing...'
  puts `git add .`
  puts `git commit -m 'Precompiles assets'`
end

puts `git push`
puts `/usr/local/heroku/bin/heroku run rake db:migrate --app nosko-staging`
exec '/usr/local/heroku/bin/heroku logs -t --app nosko-staging'