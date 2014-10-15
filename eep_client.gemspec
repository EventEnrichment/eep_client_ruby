Gem::Specification.new do |s|
  s.name = 'eep_client'
  s.version = '0.0.1'
  s.date = '2014-10-13'
  s.summary = 'Event Enrichment Platform (EEP) REST API client'
  s.description = 'A client library for sending and clearing Events via the Event Enrichment Platform (EEP) REST API'
  s.authors = ['Mike Lewis']
  s.email = 'mike@eventenrichment.com'
  s.files = ['lib/eep_client.rb', 'lib/eep_client/const.rb', 'lib/eep_client/response.rb']
  s.homepage = 'http://rubygems.org/gems/eep_client'
  s.license = 'Apache License, Version 2.0'
  s.add_dependency 'json'
end
