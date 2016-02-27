# Nosko #

## Deployment Pipeline ##

Nosko relies upon Heroku's deployment pipeline. The structure is as follows:

1. Local development
2. Deploy to `nosko-staging` (staging heroku app) by running `rb deploy_staging.rb`
3. Promote `nosko-staging` to `nosko` (production heroku app) by running `rb deploy_production.rb`.