//Adding this file so we can leave eachother messages when necessary.

Targeting Receiver
	1) Switch system on/off

	2) Scans for nearby avatars (15 meter range)
		
		1) Avatar Detected
			1) Notify Click_Sensor of target distance & target uuid
			
		2) No avatar detected
			1) Notify Click_Sensor with null distance and NULL_KEY
	
	3) Displays target distance and target name on HUD
	

Click_Sensor
	1) Takes control of user's left mouse button

	2) Watches for left mouse clicks
		1) if clicked and target_uuid is not equal to NULL_KEY 
			the notify SFX of target_distance and Follower of 
			target_uuid.  Also, inform target that they have been
			attacked so that they may update their health/soul meters
		
Health_Meter
	1) listens for message_damage on health_channel
	
	2) send your opponent your current health_level
	
	3) upon death, send message_death to soul meter
	
	4) upon death, notify the opponent who killed you
	   and send them your soul count.