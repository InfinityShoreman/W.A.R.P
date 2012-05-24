/// sfx

/// GITHUB RULES!

string sfx_critHit  = "W.A.R.P sfx_critHit";
string sfx_swordHit = "W.A.R.P sfx_swordHit";
string sfx_heavyHit = "W.A.R.P sfx_heavyHit";
string sfx_attacked = "W.A.R.P sfx_attacked";
string sfx_spawn    = "W.A.R.P sfx_spawn";

string message_attack = "Attack";
string message_spawn  = "Spawn";

integer CHANNEL = 1112;

integer distance = 0;

integer sfx_on = TRUE;

spawn() { if (sfx_on) { llPlaySound(sfx_spawn, 1.0); } }

attack()
{
    if      (distance > 10) { llPlaySound(sfx_critHit,  1.0); }
    else if (distance > 5)  { llPlaySound(sfx_heavyHit, 1.0); }
    else                    { llPlaySound(sfx_swordHit, 1.0); }
}

turn_on()
{
    sfx_on = TRUE;
    llListen(CHANNEL, "", "", "");
    spawn();
    llOwnerSay("SFX On");
}

turn_off()
{
    sfx_on = FALSE;
    llOwnerSay("SFX Off");
}

default
{
    on_rez(integer start_param) { llResetScript(); }

    changed(integer change)
    {
        if (change & CHANGED_OWNER) { llResetScript(); }
    }

    state_entry()
    {
        //llPreloadSound(sfx_critHit);
        //llPreloadSound(sfx_swordHit);
        //llPreloadSound(sfx_heavyHit);
        //llPreloadSound(sfx_attacked);
        //llPreloadSound(sfx_spawn);

        turn_on();
    }

    listen(integer channel, string name, key uuid, string message)
    {
        if      (message == "off") { turn_off(); }
        else if (message == "on" ) { turn_on(); }
        else                       { distance = (integer)message; }
    }

    link_message(integer sender_num, integer num, string message, key uuid)
    {
        if      (message == message_attack) { attack(); }
        else if (message == message_spawn)  { spawn(); }
    }
}