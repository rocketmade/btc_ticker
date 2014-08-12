require 'rubygems'
require 'httparty'
require 'timers'

$stdout.sync = true

class BTCNotifier

  attr_accessor :hipchat_api, :last_price, :current_price, :avg_price, :timer, :timing_interval

  def initialize
    @hipchat_api     = "https://api.hipchat.com/v2/room/#{ENV['HIPCHAT_ROOM']}/notification?auth_token=#{ENV['HIPCHAT_TOKEN']}"
    @timer           = Timers::Group.new
    @timing_interval = (ENV['TIMING_INTERVAL'] || 60).to_i
  end

  def notify!
    timer.every(timing_interval) { send_notification }
    loop { timer.wait }
  end

  def send_notification
    return unless get_prices!

    body = {message: price_message, color: color}

    response = HTTParty.post hipchat_api,
      body:    body.to_json,
      headers: { 'content-type' => 'application/json' }

    if response.code == 204
      puts "Posted #{body} to hipchat"
    else
      puts "Error posting to hipchat: #{response.code} #{response.body}"
    end
  end

private

  def get_prices!
    @last_price     = current_price

    bitcoinaverage  = HTTParty.get("https://api.bitcoinaverage.com/ticker/global/USD/")
    @current_price  = bitcoinaverage['last']
    @avg_price      = bitcoinaverage['24h_avg']
  rescue => e
    puts e
  end

  def price_message
    "Current: $%.2f/BTC | 24 hour average: $%.2f/BTC" % [current_price, avg_price]
  end

  def color
    return 'yellow' unless @last_price

    if @last_price > @current_price
      'red'
    elsif @current_price > @last_price
      'green'
    else
      'yellow'
    end
  end
end

BTCNotifier.new.notify!
