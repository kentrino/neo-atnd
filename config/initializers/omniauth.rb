Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.full_host = 'https://atnd.h-kento.jp'
  end

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
