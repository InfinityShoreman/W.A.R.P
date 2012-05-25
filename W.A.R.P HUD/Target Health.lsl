/// Target Health

/// variables------
/// own health - master health variable updates this whenever health is changed
/// target - target circle script updates this variable whenever it changes
/// opponent(s) - the person(s) targeting the player. Will have to figure out what to do if there is more than one


/// methods------
/// on off
/// turns on/off depending on if there is currently a player selected.
/// off will just be a high transparency red or other relevant color

/// Get Health
/// upon aquiring a target this method sends a message to the target's hud with llRegionSayTo
/// to start sending health, also notifies to stop once target has been released (stopped targeting or changed target)

/// Send Health
/// sends health variable to opponent(s) once on first call and again whenever it updates

/// set health
/// set opponent health ring to proper size and calls the correct method to set the proper color phase.

/// full heal
/// sets to green phase and gives player 100% health

/// critical phase
/// red phase
/// orange phase
/// green phase

/// recieve link message
/// target circle script will send a message to this part whenever the target is updated, see
/// line 90 of the target circle script. This will then call the get health method.
/// master variable script will send a message to this part whenever the health variable changes,
/// this needs to be differentiated from the target message. The id field (the final "" in
/// message linked) can be used as a variable field to differentiate mesages.

/// listener(s)
/// recieve target health and calls set health method
/// recieve names of opponents that are calling for health updates

float health = 0.0; /// Goes from 0.0 to 1.00 with 0.0 being full health

integer comm_channel = 203041;

string message_damage = "DMG";

string owner_name = "";

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
    llOwnerSay("Opponent has died.");
    greenPhase();
    fullHeal();
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
    llSay(0, owner_name + " is critically injured!");
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
        owner_name = llKey2Name(llGetOwner());
        greenPhase();
        fullHeal();
        llListen(comm_channel, "", "", "");
    }

    link_message(integer source, integer num, string str, key id) {
        /// listens for damage and inflicts it on the player.
        if (str == message_damage) { damage(); }
    }

    listen(integer channel, string name, key id, string message) {
        if (message == message_damage) { damage(); }

    }
}
