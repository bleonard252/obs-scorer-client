# OBS Scorer Client 2.0

*For the legacy version, see [this branch](https://github.com/bleonard252/obs-scorer-client/tree/old-master/). The old version, compatible with obs-websockets protocol v4, is also available in web builds as [legacy.html](https://bleonard252.github.io/obs-scorer-client/legacy.html).*

This version of OBS Scorer Client is a **feature-complete full rewrite** of my original OBS Scorer Client in Flutter.

OBS Scorer Client can do the following when paired with a recent version of OBS Studio (which comes with obs-websockets built-in, running protocol v5; **\*** indicates a new feature over legacy):
* Show a convenient summary of the scoreboard front and center.**\***
* Show, increment**\***, and manually change the home and away scores.
* Show and increment the home and away timeouts.
* Show, increment, manually change, start, and stop the game clock.
* Change the quarter/period between 1st, 2nd, 3rd, 4th, and overtime.
* Football: Change the current downs and distance (i.e. 1st & 10) with handy shortcuts.
* Configure the source names to use any text sources you provide.
