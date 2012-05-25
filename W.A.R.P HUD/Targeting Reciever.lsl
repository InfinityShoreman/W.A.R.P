/// Targeting Receiver

/// methods
/// on/off switch for targetng
/// messages the targeting system to turn on or off (called on click), updates color for the following instances:
/// (on with target | on with no target | off)
/// Also, enters a blue color state for when it is first switched on but no avatars were detected

key owner_uuid = NULL_KEY;

integer sensor_on = FALSE;

integer detected = FALSE;

float arc = 0.0;

set_red() { llSetPrimitiveParams([PRIM_COLOR, 0, <1.0, 0.0, 0.0>, 0.7]); }

set_green() { llSetPrimitiveParams([PRIM_COLOR, 0, <0.0, 1.0, 0.0>, 0.7]); }

/// blue indicates an ambiguous intermediate state -- might be useful
set_blue() { llSetPrimitiveParams([PRIM_COLOR, 0, <0.0, 0.0, 1.0>, 0.5]); }

set_black() { llSetPrimitiveParams([PRIM_COLOR, 0, <0.0, 0.0, 0.0>, 0.3]); }

clear_text() { llSetText("", <0.0, 0.0, 0.0>, 1.0); }

turn_on_sound_effects() { llRegionSayTo(owner_uuid, 1112, "on"); }

turn_off_sound_effects() { llRegionSayTo(owner_uuid, 1112, "off"); }

turn_on_follower() { llRegionSayTo(owner_uuid, 96456, "on"); }

turn_off_follower() { llRegionSayTo(owner_uuid, 96456, "off"); }

set_text(float distance, key target_uuid) {
    string detected_target_info = llKey2Name(target_uuid) + " -- " + (string)distance + " Meters";
    llSetText(detected_target_info, <1.0, 0.0, 0.5>, 1.0);
}

notify_click_sensor(float distance, key target_uuid) {
    integer link_click_sensor = 2;
    llMessageLinked(link_click_sensor, (integer)distance, "Click Sensor", target_uuid);
}

switch_sensor_on() {
    llOwnerSay("TARGETING RECEIVER ON");
    sensor_on = TRUE;
    clear_text();
    llSensorRepeat("", NULL_KEY, AGENT, 15, arc, 0.33);
}

switch_sensor_off() {
    llOwnerSay("TARGETING RECEIVER OFF");
    sensor_on = FALSE;
    llSensorRemove();
    clear_text();
}

default {
    on_rez(integer start_param) { llResetScript(); }

    changed(integer change) {
        if (change & CHANGED_OWNER) { llResetScript(); }
    }

    state_entry() {
        owner_uuid = llGetOwner();
        arc = PI / 15.0;
        set_blue();
        turn_on_sound_effects();
        turn_on_follower();
        switch_sensor_on();
    }

    touch_start(integer num_detected) {
        if (sensor_on) {
            switch_sensor_off();
            set_black();
            turn_off_sound_effects();
            turn_off_follower();
        } else {
            set_blue();
            turn_on_sound_effects();
            turn_on_follower();
            switch_sensor_on();
        }
    }

    sensor(integer avatars_detected) {
        set_green();
        vector my_current_position      = llGetPos();
        vector detected_target_position = llDetectedPos(0);
        float  detected_target_distance = llVecDist(my_current_position, detected_target_position);
        string detected_target_uuid     = llDetectedKey(0);
        notify_click_sensor(detected_target_distance, detected_target_uuid);
        set_text(detected_target_distance, detected_target_uuid);
        detected = TRUE;
    }

    no_sensor() {
        if (detected) {
            notify_click_sensor(0, NULL_KEY);
            clear_text();
            set_red();
        }

        detected = FALSE;
    }
}