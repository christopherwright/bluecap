Gem::Specification.new do |s|
  s.name          = 'bluecap'
  s.version       = '0.0.1'
  s.date          = '2012-07-19'
  s.summary       = 'Bluecap measures user engagement.'
  s.homepage      = 'https://github.com/christopherwright/bluecap'
  s.authors       = ['Christopher Wright']
  s.email         = 'christopherwright@gmail.com'

  s.files         = %w(README.md LICENSE)
  s.files        += Dir.glob("lib/**/*")
  s.files        += Dir.glob("bin/**/*")
  s.files        += Dir.glob("spec/**/*")
  s.executables  = ['bluecap']

  s.add_dependency 'redis',        '~> 3.0.1'
  s.add_dependency 'eventmachine', '~> 0.12.10'
  s.add_dependency 'multi_json',   '~> 1.3.6'

  s.description = <<description
    Bluecap is a Redis-backed system for measuring user engagement over time.
    It tracks events passed in from external systems, such as when a user
    creates an account, logs in or performs some other key action. Bluecap can
    also track arbitrary properties of users like A/B variants, IP address or
    location.
description
end
