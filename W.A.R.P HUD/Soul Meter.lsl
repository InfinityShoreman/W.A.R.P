/// Soul Meter

/// When the soul_count increases or decreases the hud then calls the soul meter with a link_message.
/// The second parameter of the link_message contains an integer of the current soul_count.
///The Soul Meter script then updates the soul meter accordingly.

string message_update = "Update";
string message_dead   = "Dead";

integer master_soul_count = 1;

integer channel_soul_meter = 192837;

update_soul_meter(integer soul_count) {
    if      (soul_count > 100) { soul_count = 100; }
    else if (soul_count < 5)   { soul_count = 5; }

    float increment = (soul_count * 0.01 - 1.0) * -1.0;

    llSetPrimitiveParams([PRIM_TYPE,
                          PRIM_TYPE_CYLINDER,
                          PRIM_HOLE_DEFAULT,     // hole_shape
                          <increment, 1.0, 0.0>, // cut <-change the first number 0.0 is full 0.5 is half
                          0.95,                  // hollow
                          <0.0, 0.0, 0.0>,       // twist
                          <1.0, 1.0, 0.0>,       // top_size
                          <0.0, 0.0, 0.0>]);     // top_Shear
}

default {
    link_message(integer source, integer soul_count, string message, key target_uuid) {
        if (message == message_update) {
            master_soul_count = soul_count;
            update_soul_meter(soul_count);
        } else if (message == message_dead) {
            /// broadcast soul count to opponent who killed you
            llRegionSayTo(target_uuid, channel_soul_meter, (string)master_soul_count);
        }
    }
}
