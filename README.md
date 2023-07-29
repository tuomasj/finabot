# Finabot - Telegram bot

## Example Output

Finabot on Telegram (or command-line mode!) looks something like this when running command `/latest`. Finabot uses Yahoo Finance API so all ticker symbols must use the same format as Yahoo Finance uses. For example, in Nasdaq OMX Helsinki ticker symbols use `.HE` in the end, such as `WITTED.HE` or `KEMPOWR.HE`.

```
msft    338.37  2.31% 🟢
trow    126.79  8.27% 🟢
vz       34.03 -1.43% 🔴
witted    3.05  1.32% 🟢
kempow   40.87 -0.10% 🔴
tsla    266.44  4.20% 🟢
```

## Current status

- Please understand that this is just an experimental bot, run this at your own risk
- It is completely under mercy of Yahoo Finance API
- Works on just channel per bot (and fills my use case perfectly)
- Code is just one big file
- Class `Finabot` has just too many responsibilities
- Uses Yahoo Finance API through `basic_yahoo_finance` gem
- Not tested on Telegram channels
- Probably works just on happy case path
- It does not have any error handling, it just crashes

## How to run this

### Running locally

If you want to run this locally without connecting to Telegram, use `--cli` option.

```
    $ ruby finabot.rb --cli
```

or running from command-line

```
    $ ruby finabot.rb /help
    $ ruby finabot.rb /add WITTED.HE
    $ ruby finabot.rb /latest
    $ ruby finabot.rb /info WITTED.HE
```

Same commands work, so start with `/help`.

### Running as Telegram bot

- Create the bot on Telegram [Telegram Bots](https://core.telegram.org/bots)
- Grab the Telegram API token
- Make the bot Inline so it replies on the group (like Irc bots back in the day)
- Invite the bot to a channel
- Start the finabot with command-line argument `--telegram`

```
    $ API_TOKEN=<your-telegram-api-token> ruby finabot.rb --telegram
```

- Test with `/help` command, type it on the group and the bot should print the list of available commands. Remember, you run the bot at your own risk.

## Persisted Ticker Symbols

When starting the bot, it loads the ticker symbols from `tickers.txt`. Finabot saves the ticker symbols into same file when ticker symbols are added or removed.

