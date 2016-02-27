loop do
  print 'About to promote `nosko-staging` (staging) to `nosko` (production). Continue?  '
  answer = gets.chomp
  return true  if answer.downcase == 'y'
  return false if answer.downcase == 'n'
  puts '  > Please respond with Y or N'
end

puts 'Promoting...'
puts `/usr/local/heroku/bin/heroku pipelines:promote --app nosko-staging`
puts 'Migrating...'
puts `/usr/local/heroku/bin/heroku run rake db:migrate --app nosko`
puts 'Opening logs...'
exec '/usr/local/heroku/bin/heroku logs -t --app nosko'