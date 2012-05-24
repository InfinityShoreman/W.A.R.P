//TESTING CHANGES
/// Aim Detection -- IN TESTING

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
        /// helps to have this to actually make the sensor sense things
        llSensorRepeat("", NULL_KEY, AGENT, 15, PI, 0.3);
    }

    sensor(integer avatars_detected)
    {
        integer i                = 0;
        vector  current_position = ZERO_VECTOR;
        key     target_uuid      = NULL_KEY;
        vector  target_position  = ZERO_VECTOR;
        float   target_distance  = 0.0;

        for ( ; i < avatars_detected; ++i)
        {
            target_uuid = llDetectedKey(i);

            if (llGetAgentInfo(target_uuid) & AGENT_MOUSELOOK)
            {
                current_position = llGetPos();

                target_position = llDetectedPos(i);

                target_distance = llVecDist(current_position, target_position);

                if (llVecDist(current_position, target_position + llRot2Fwd(llDetectedRot(i)) * target_distance) <= 1.5)
                {
                    /// will call other necessary functions in the future as required
                }
            }
        }
    }
}
