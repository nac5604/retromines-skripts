# new_ride.sk
# VM1
# 7/24/22

# Command to ride a player.
command /ride <string> [<player>]:
    cooldown: 10 seconds
    cooldown message: &cWoah there hoss...
    permission: ride
    trigger:

        # Argument "request"

        # Check to see if the requested player is online,
        # If the player is online, then make a new request query.
        # Send an ride invite to the target player.
        if arg-1 is "request":
            if arg-2 is online:
                set {ride.Requests::%player's uuid%} to arg-2
                
                send formatted "&b%player% &7wants to ride you! <command:/ride accept %player%>&b&nClick here<reset> &7to allow them." to arg-2
            else:
                send "&cThat player is not online." to player

        # Argument "accept"

        # Check to see if the player is online, and if the player has sent you a request.
        # If the player is within a certain distance of you (to avoid teleportation exploits).
        # Make the player ride you.
        else if arg-1 is "accept":
            if arg-2 is online:
                if {ride.Requests::*} contains arg-2's uuid:
                    if distance between arg-2 and player is less than 5:
                        delete {ride.Requests::%arg-2's uuid%}
                        teleport arg-2 to player
                        wait 3 ticks
                        make arg-2 ride player
                        send "&a%arg-2% is now riding you!" to player
                        send "&aYou are now riding %player%" to arg-2
                    else:
                        send "&cYou are not close enough to %player% to ride them!" to arg-2
                        send "&cYou are not close enough to %arg-2% to ride them!" to player

                else:
                    send "&cThat player has not requested to ride you." to player
            else:
                send "&cThat player is not online." to player

# Right click request functionality.
on right click on a player:
    player is sneaking
    player has permission "ride"
    make player execute command "/ride request %target player%"

# REQUIRES SKBEE
on tab complete for "/ride":
    set tab completions for position 1 to "accept" and "request"
