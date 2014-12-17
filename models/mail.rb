require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['app32603030@heroku.com'],
    :password => ENV['rnpibuym'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end