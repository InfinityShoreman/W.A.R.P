/// Click sensor

key owner_uuid = NULL_KEY;

string message_damage = "DMG";

string  detected_target_name     = "";
string  detected_target_distance = "";
key     detected_target_uuid     = NULL_KEY;

integer channel_opponent_health = 203040;
integer channel_sfx             = 1112;
integer channel_follower        = 96456;

default
{
    on_rez(integer start_param) { llResetScript(); }

    changed(integer change)
    {
        if      (change & CHANGED_TELEPORT) { llResetScript(); }
        else if (change & CHANGED_OWNER)    { llResetScript(); }
    }

    state_entry()
    {
        owner_uuid = llGetOwner();
        llRequestPermissions(owner_uuid, PERMISSION_TAKE_CONTROLS);
    }

    run_time_permissions(integer perm)
    {
        if (PERMISSION_TAKE_CONTROLS == perm) { llTakeControls(CONTROL_ML_LBUTTON, TRUE, TRUE); }
        else                                  { llResetScript(); }
    }

    link_message(integer sener_number, integer distance, string identifier, key target_uuid)
    {
        if (identifier == "Click Sensor")
        {
            detected_target_name     = llKey2Name(target_uuid);
            detected_target_distance = (string)distance;
            detected_target_uuid     = target_uuid;
        }
    }

    control(key id, integer level, integer edge)
    {
        if (detected_target_name)
        {
            if (level & edge & CONTROL_ML_LBUTTON)
            {
                llRegionSayTo(owner_uuid,           channel_follower,        detected_target_uuid);
                llRegionSayTo(owner_uuid,           channel_sfx,             detected_target_distance);
                llRegionSayTo(detected_target_uuid, channel_opponent_health, message_damage); 
            }
        }
    }
}