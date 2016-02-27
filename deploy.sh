RAILS_ENV=production bundle exec rake assets:precompile
git add .
git commit -m 'Precompiles assets'
git push
heroku run rake db:migrate --app nosko-staging