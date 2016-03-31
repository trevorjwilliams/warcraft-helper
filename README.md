# warcraft-helper
Foreward: I haven't actually used this script in a year or so, and it's a bit dated as a result.  Just want to submit it to version control in case I choose to return to it later.

Simple autohotkey script for automating a few quality-of-life things when playing World of Warcraft.  Specifically:
- Starts a logging app at the same time as WoW (was originally World of Logs, but should be updated to handle [Warcraft Logs](https://www.warcraftlogs.com).)
- Closes the logging app when the WoW client closes.
- Deletes the WoW log file upon client termination (probably can be left to the logging client these days.)
- Adds button-spamming logic to make the most of your GCDs and save you from RSI
  - Certain keys (defined by "spambinds") are spammed until one of several other specific keys (defined by "stopbinds") are pressed.
  - **f1** toggles all button-repeating behavior.
  - **enter** suspends button-repeating for a period of time, as you're likely trying to type a message.