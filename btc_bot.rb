require 'rubygems'
require 'httparty'
require 'timers'

$stdout.sync = true

class BTCNotifier

  attr_accessor :hipchat_api, :last_price, :current_price, :avg_price, :timer, :timing_interval, :gdax_btc, :gdax_eth, :gemini_btc, :gemini_eth#, :gdax_ltc

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

    body = {message_format: 'text', message: price_message, color: color}

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

    bitcoinaverage  = HTTParty.get("https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")
    @current_price  = bitcoinaverage['last']
    @avg_price      = bitcoinaverage['averages']['day']
  
    gdax            = HTTParty.get("https://apiv2.bitcoinaverage.com/exchanges/ticker/gdax")
    @gdax_btc       = gdax['symbols']['BTCUSD']['last']
    @gdax_eth       = gdax['symbols']['ETHUSD']['last']

    gemini          = HTTParty.get("https://apiv2.bitcoinaverage.com/exchanges/ticker/gemini")
    @gemini_btc     = gemini['symbols']['BTCUSD']['last']
    @gemini_eth     = gemini['symbols']['ETHUSD']['last']

#    gdax_api        = HTTParty.get("https://api.gdax.com/products/LTC-USD/trades")
#    @gdax_ltc       = gdax_api[0]['price']

  rescue => e
    puts e
  end

  def price_message
    "(bitcoin) IX: $%.2f | 24h: $%.2f | GDAX: $%.2f | GEM: $%.2f || (ethereum) GDAX: $%.2f | GEM: $%.2f || litecoin: broken conn" % [current_price, avg_price, gdax_btc, gemini_btc, gdax_eth, gemini_eth]#, gdax_ltc]
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
