//Another Change ;)
//I hope this works..

/// Animation

integer rot = 0;

key owner_uuid = NULL_KEY;

attack()
{
    if      (rot == 0) {llStartAnimation("Diagonal Left Strike - .7 Seconds");}
    else if (rot == 1) {llStartAnimation("Diagonal Right Strike - .7 Seconds");}
    else if (rot == 2) {llStartAnimation("Overhead Strike - .7 Seconds");}
    else if (rot == 3) {llStartAnimation("High Kick - .7 Seconds");}
    else if (rot == 4) {llStartAnimation("Upper Right Strike - .7 Seconds");}
    else if (rot == 5) {llStartAnimation("Upward Left Strike - .7 Seconds");}

    rot++;

    if (rot == 6) { rot = 0; }
}

block()
{
    llStartAnimation("Basic Angle Block - .7 Seconds");
}

sheathe()
{
    llStartAnimation("Hip Sheathe - .7 Seconds");
    llStartAnimation("Hip Draw - .7 Seconds");
    llStartAnimation("Draw - .7 Seconds");
    llStartAnimation("Sheathe - .7 Seconds");
}

default
{
    state_entry()
    {
        owner_uuid = llGetOwner();
        llRequestPermissions(owner_uuid, PERMISSION_TRIGGER_ANIMATION);
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {
        integer perm = llGetPermissions();

        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            if (msg == "ANIM") { attack(); }
        }
        else
        {
            llRequestPermissions(owner_uuid, PERMISSION_TRIGGER_ANIMATION);

            if (msg == "ANIM") { attack(); }
        }
    }
}
