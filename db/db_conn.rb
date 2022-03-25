def db_config
  {
    :adapter => 'postgresql',
    :encoding => 'utf8',
    :host => ENV['POSTGRES_HOST'],
    :username => ENV['POSTGRES_USERNAME'],
    :password => ENV['POSTGRES_PASSWORD'],
    :database => ENV['POSTGRES_DATABASE'],
    :schema => 'public'
  }
end

