module AnalyticsInitializer
  def self.registered(app)
    app.use Rack::GoogleAnalytics, :tracker => 'UA-38448478-3'

  end
end
