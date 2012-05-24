/// Person Follow Script

/// TEST AGAIN

/// Avatar Follower script, by Dale Innis
/// Do with this what you will, no rights reserved
/// See https://wiki.secondlife.com/wiki/AvatarFollower for instructions and notes

integer CHANNEL = 96456;  /// That's "f" for "follow", haha

float RANGE = 2.0;   /// Meters away that we stop walking towards
float TAU = 0.2;     /// Make smaller for more rushed following

float LIMIT = 60.0;   /// Approximate limit (lower bound) of llMoveToTarget

integer target_uuid = 0;

integer announced = FALSE;

string message_attack = "Attack";

integer follow_on = TRUE;

notify_sfx() {  llMessageLinked(LINK_THIS, 0, message_attack, ""); }

stop_following()
{
    llTargetRemove(target_uuid);
    llStopMoveToTarget();
}

turn_off()
{
    llOwnerSay("Systems Offline.");
    follow_on = FALSE;
}

turn_on()
{
    llOwnerSay("Systems Online.");
    follow_on = TRUE;
}

start_following(key target_key)
{
    list answer = llGetObjectDetails(target_key, [OBJECT_POS]);

    if (answer != [])
    {
        announced = FALSE;

        vector targetPos = llList2Vector(answer, 0);

        vector current_position = llGetPos();

        float dist = llVecDist(targetPos, current_position);

        if (dist > RANGE)
        {
            target_uuid = llTarget(targetPos, RANGE);

            if (dist > LIMIT)
            {
                targetPos = current_position + LIMIT * llVecNorm( targetPos - current_position ) ;
            }

            llMoveToTarget(targetPos, TAU);
        }
    }
}

default
{
    on_rez(integer start_param) { llResetScript(); }

    changed(integer change) { if (change & CHANGED_OWNER) { llResetScript(); } }

    state_entry() { llListen(CHANNEL, "", "", ""); }

    listen(integer channel, string name, key uuid, string message)
    {
        if      (message == "off")    { turn_off(); }
        else if (message == "on")     { turn_on(); }
        else if (message != NULL_KEY) { if (follow_on) { llMessageLinked(LINK_THIS, 0, "ANIM", "" ); start_following(message); } }
    }

    at_target(integer tnum, vector tpos, vector ourpos)
    {
        stop_following();
        notify_sfx();
    }

}