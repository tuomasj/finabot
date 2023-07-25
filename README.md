# Finabot - Telegram bot

## Example Output

Finabot on Telegram group looks something like this when running command `/latest`

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

- Please understand that this is just an experimental bot, run this at your own risk
- Works on just channel per bot (and fills my use case perfectly)
- Code is just one big file
- Class `Finabot` has just too many responsibilities
- Uses Yahoo Finance API through `basic_yahoo_finance` gem
- Not tested on channels
- Probably works just on happy case path
- It does not have any error handling, it just crashes

## How to run this

- Create the bot on Telegram (Telegram Bots)[https://core.telegram.org/bots]
- Grab the Telegram API token
- Make the bot Inline so it replies on the group (like Irc bots back in the day)
- Invite the bot to a channel
- Start the finabot

```
    $ API_TOKEN=<your-telegram-api-token> ruby finabot.rb
```

- Test with `/help` command, type it on the group and the bot should print the list of available commands

## Persisted Ticker Symbols

When starting the bot, it loads the ticker symbols from `tickers.txt`. Finabot saves the ticker symbols into same file when ticker symbols are added or removed.

