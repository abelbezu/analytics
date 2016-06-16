# Proctorserv Analytics Gem

Proctorserv Analytics is a collection of migrations, models, and sidekiq workers designed to maintain an audit log of all Proctorserv's sessions and session events.

### Inclusion

```ruby
gem 'proctorserv_analytics', :git => 'git@gitlab.proctorcam.com:analytics-gem', :require => 'analytics'
```

### (De)activation

By default, Analytics workers will perform their action. It can be toggled using the following:

```ruby
Analytics.active = false # deactivate
Analytics.active = true # (re)activate
```