---
title: PalWorld RCON Notes
---

## RCON Commands

| Command                            | Description                                                                                            |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------ |
| /Shutdown {Seconds} {MessageText}  | Gracefully shuts down server with an optional timer and/or message to notify players in your server.   |
| /DoExit                            | Forcefully shuts down the server immediately. It is not recommended to use this option                 |
| /Broadcast {MessageText}           | Broadcasts a message to all players in the server.                                                     |
| /KickPlayer {PlayerUID or SteamID} | Kicks player from the server. Useful for getting a player's attention with moderation.                 |
| /BanPlayer {PlayerUID or SteamID}  | Bans player from the server. The Player will not be able to rejoin the server until they are unbanned. |
| /ShowPlayers                       | Shows information on all connected players.                                                            |
| /Info                              | Shows server information.                                                                              |
| /Save                              | Save the world data to disk.                                                                           |

## In-Game Only Commands

| Command                                  | Description                                 |
| ---------------------------------------- | ------------------------------------------- |
| /TeleportToPlayer {PlayerUID or SteamID} | Immediately teleport to the target player.  |
| /TeleportToMe {PlayerUID or SteamID}     | Immediately teleports target player to you. |
