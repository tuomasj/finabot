require 'set'
require 'basic_yahoo_finance'
require 'telegram/bot'
require 'json'

class Finabot
  class Tickers
    FILENAME="tickets.txt"

    def initialize(tickers = Tickers.default_tickers)
      @tickers = Set.new(tickers)
    end

    def add(ticker_symbol)
      @tickers.add(ticker_symbol.strip.upcase)
      persist
    end

    def remove(ticker_symbol)
      @tickers.delete(ticker_symbol.strip.upcase)
      persist
    end

    def to_a
      @tickers.to_a
    end

    def persist
      IO.write(self.class.filename, self.to_a.join(","))
    end

    def self.default_tickers
      if File.exist?(self.filename)
        IO.read(self.filename).split(",").map(&:strip).map(&:upcase)
      else
        []
      end
    end

    def self.filename
      FILENAME
    end
  end

  class Stock
    attr_reader :query

    def initialize
      @query = BasicYahooFinance::Query.new
    end

    def current_quotes(tickers)
      quotes = query.quotes(tickers, 'price')
      return {symbol: "INVALID TICKER", latest_price: 0, previous_close: 0 } if quotes.nil?
      quotes.map do |symbol, data|
        {
          symbol: symbol,
          latest_price: data["regularMarketPrice"]["raw"],
          previous_close: data["regularMarketPreviousClose"]["raw"]
        }
      end
    end

    def company_information(ticker)
      # grab only price and financial data
      query.quotes(ticker, "price").values.first.merge(query.quotes(ticker, "financialData").values.first)
    end
  end

  module Utils
    def self.percentage(latest, previous)
      ((latest - previous) / previous) * 100
    end

    def self.price_indicator(latest, previous)
      diff =  latest - previous
      if diff >= 0
        "🟢"
      else
        "🔴"
      end
    end

    def self.spacer
      "===================================="
    end

    def self.line_feed
      "\n"
    end

    def self.formatting
      "```"
    end
  end

  attr_reader :tickers, :stocks

  COMMANDS = [:help, :latest, :list, :add, :remove, :info]

  def initialize
    @tickers = Tickers.new
    @stocks = Stock.new
  end

  def current_quotes
    stocks.current_quotes(tickers.to_a)
  end

  def add_ticker(ticker_symbol)
    case ticker_symbol
    when Array
      ticker_symbol.map {|ticker| tickers.add(ticker)}
    when String
      tickers.add(ticker_symbol)
    end
  end

  def remove_ticker(ticker_symbol)
    case ticker_symbol
    when Array
      ticker_symbol.map {|ticker| tickers.remove(ticker)}
    when String
      tickers.remove(ticker_symbol)
    end
  end

  def company_information(ticker)
    stocks.company_information(ticker)
  end

  def string_to_arrow(params)
    return [] if params.nil? || params == ""
    params.gsub(" ", "").split(",").map(&:strip)
  end

  def process_command(input, params = "")

    return if input.nil?
    return if input[0] != "/"

    command, params = input[1..-1].split(" ", 2)

    if COMMANDS.include?(command.downcase.to_sym)
      run_command(command.downcase.to_sym, string_to_arrow(params))
    else
      "Commands available:\n#{COMMANDS.join(", ")}"
    end
  end

  def run_command(command, params)
    send(command, params) if respond_to? command
  end

  def help(params)
    [
      Utils.spacer,
      "/list - show the list of tickers",
      "/latest - show latest stock prices",
      "/add [ticker(s)] - add a ticker to list",
      "/remove [ticker(s)] - remove a ticker from a list",
      "/info [ticker] - show details on stock"
    ].join(Utils.line_feed)
  end

  def list(params = nil)
    [
      "Current tickers:",
      tickers.to_a.join(", ")
    ].join(Utils.line_feed)
  end

  def add(tickers)
    add_ticker(tickers)
    "Ticker(s) $#{tickers} added"
  end

  def remove(tickers)
    remove_ticker(tickers)
    "Ticker(s) #{tickers} removed"
  end

  def latest(params)
    stocks = current_quotes
    msg = [
      stocks.map do |stock|
                    [
                      Utils.price_indicator(stock[:latest_price], stock[:previous_close]),
                      sprintf("%-8.8s %8.2f (%5.2f%%)\n", stock[:symbol], stock[:latest_price], Utils.percentage(stock[:latest_price], stock[:previous_close])),
                    ].join(" ")
                  end,
    ].join
    [
      Utils.formatting,
      Utils.line_feed,
      msg,
      Utils.formatting
    ].join
  end

  def info(tickers)
    ticker = tickers.first
    [
      "{",
      company_information(ticker).map do |key,value|
        "  #{key}: #{value}"
      end.join("\n"),
      "}"
    ].join("\n")

  end

end



# starts here

Telegram::Bot::Client.run(ENV["API_TOKEN"]) do |bot|
  bot.listen do |message|

    case message
    when Telegram::Bot::Types::Message
      msg = finabot.process_command(message.text)
      if msg != nil && msg.size > 0
        bot.api.send_message(
                            chat_id: message.chat.id,
                            text: msg,
                            parse_mode: "Markdown"
                          )
      end
    end

  end
end
