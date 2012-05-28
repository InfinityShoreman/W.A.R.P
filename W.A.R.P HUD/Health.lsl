/// Health

float health = 0.0; /// Goes from 0.0 to 1.0 with 0.0 being full health

integer comm_channel = 203040;
integer opponent_health_channel = 203041;
integer sfx_channel  = 1112;

string message_damage = "DMG";
string message_spawn  = "spawn";

key owner_uuid    = NULL_KEY;
key opponent_uuid = NULL_KEY;

/// notifies soul meter to send your soul count to your opponent
notify_soul_meter(key uuid) {
    string message_dead   = "Dead";
    integer link_soul_meter = 3;
    llMessageLinked(link_soul_meter, 0, message_dead, uuid);
}

/// when you are hit then broadcast your health level to 
/// your opponent so that they can update their target health meter
broadcast_health_level(uuid) {
    llRegionSayTo(uuid, opponent_health_channel, (string)health);
}

fullHeal() { /// Heals to 100% health
    health = 0.0;

    llSetPrimitiveParams([PRIM_TYPE,
                          PRIM_TYPE_CYLINDER,
                          PRIM_HOLE_DEFAULT,  // hole_shape
                          <health, 1.0, 0.0>, // cut <-change the first number 0.00 is full 0.5 is half
                          1.0,                // hollow
                          <0.0, 0.0, 0.0>,    // twist
                          <1.0, 1.0, 0.0>,    // top_size
                          <0.0, 0.0, 0.0>]);  // top_Shear

    llRegionSayTo(owner_uuid, sfx_channel, message_spawn);
}

damage() { /// Takes standard damage (later will be multiplied by soul level)
    health = health + 0.025;

    llSetPrimitiveParams([PRIM_TYPE,
                          PRIM_TYPE_CYLINDER,
                          PRIM_HOLE_DEFAULT,  // hole_shape
                          <health, 1.0, 0.0>, // cut <-change the first number 0.00 is full 0.5 is half
                          1.0,                // hollow
                          <0.0, 0.0, 0.0>,    // twist
                          <1.0, 1.0, 0.0>,    // top_size
                          <0.0, 0.0, 0.0>]);  // top_Shear

    if      (health >= 0.98) { dead(); }
    else if (health >= 0.9)  { imminentDeath(); }
    else if (health >= 0.66) { redPhase(); }
    else if (health >= 0.33) { orangePhase(); }
    else                     { greenPhase(); }
}

dead() { /// Currently only announces death and resets status to green. Will later make a call to the soul script.
    llOwnerSay("You have died.");
    greenPhase();
    fullHeal();
    notify_soul_meter(opponent_uuid);
}

/// The following are stages for the health bar's color/actions
greenPhase() {
    llTargetOmega(<0.0, 0.0, 0.0>, PI, 0.05);
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <0.0, 1.0, 0.0>, 0.5]);
}

orangePhase() {
    llTargetOmega(<0.0, 0.0, 0.0>, PI, 0.05);
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <1.0, 0.5, 0.0>, 0.5]);
}

redPhase() {
    llTargetOmega(<0.0, 0.0, 0.0>, PI, 0.05);
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <1.0, 0.0, 0.0>, 0.9]);
}

imminentDeath() {
    llSay(0, llKey2Name(owner_uuid) + " is critically injured!");
    llTargetOmega(<0.0, 0.0, 0.9>, PI, 0.05);
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <1.0, 0.0, 0.0>, 0.9]);
}

/// Checks the current phase and returns it as a string.
string phaseCheck() {
    if (health >= 0.98) { return "Dead?"; }
    else if (health >= 0.9)  { return "imminentDeath"; }
    else if (health >= 0.66) { return "redPhase"; }
    else if (health >= 0.33) { return "orangePhase"; }
    else                     { return "greenPhase"; }
}

default {
    state_entry() {
        owner_uuid = llGetOwner();
        greenPhase();
        fullHeal();
        llListen(comm_channel, "", "", "");
    }

    touch_start(integer p) {
        /// Checks if the player is in critical condition, if so it allows the player to
        /// attempt a heal by exiting mouselook mode and clicking their now spinning healthbar.
        /// Continued use of this feature in later versions iffy.
        if (phaseCheck() == "imminentDeath") {
            greenPhase();
            fullHeal();
        } else {
            llOwnerSay("Try clicking in mouselook mode.");
        }
    }

    link_message(integer source, integer num, string str, key id) {
        /// listens for damage and inflicts it on the player.
        if (str == message_damage) { damage(); }
    }

    listen(integer channel, string name, key uuid, string message) {
        /// listens for damage inflicted upon you by your opponent
        if (message == message_damage) {
            damage();
            opponent_uuid = uuid;
            broadcast_health_level(opponent_uuid);
        }

    }
}
