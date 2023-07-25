# Finabot - Telegram bot

## Example Output

Finabot on Telegram group looks something like this:

```
/latest

🟢 MSFT       350.92 ( 1.68%)
🔴 TROW       119.58 (-0.92%)
🟢 VZ          34.16 ( 0.53%)
🟢 O           63.38 ( 0.02%)
🔴 MO          45.48 (-0.25%)
🟢 ABNB       149.92 ( 1.56%)
🟢 SNOW       179.08 ( 2.45%)
🔴 SHOP        65.34 (-1.25%)
```

## Current status

- Works on just channel per bot (and fills my use case perfectly)
- Code is just one big file
- Class `Finabot` has just too many responsibilities
- Uses Yahoo Finance API through `basic_yahoo_finance` gem
- Not tested on channels

## How to run this

- Create the bot on Telegram
- Make the bot Inline so it replies on the group (like Irc bots back in the day)
- Invite the bot to a channel
- Start the finabot

You need a Telegram API token

```
    $ API_TOKEN=<your-telegram-api-token> ruby finabot.rb
```

## Persisted ticker symbols

When starting the bot, it loads the ticker symbols from `tickers.txt`. Finabot saves the ticker symbols into same file when ticker symbols are added or removed.

