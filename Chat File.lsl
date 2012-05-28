//Adding this file so we can leave eachother messages when necessary.

If you ask me I think we've gone too far ahead of ourselves.  Maybe we should roll it 
back and test the HUD with one item of functionality at a time?  Also, maybe we shouldn't
go any furthur until we have this outline down pat?

**************************************************************************************************
* Current Outline																	
* Feel free to flesh this out as required
* prim names and variables aren't exact
**************************************************************************************************

A) | name: Targeting Receiver | channel: N/A | link: 1 |
	1) Switch system on/off
		1) Cut Targeting Receiver on
			1) Notify SFX
			
			2) Notify Follower
			
			3) Initialize Sensor
			
			4) Set Targeting Receiver color to blue (indicates an ambiguous state)
			
		2) Cut targeting system off
			1) Notify SFX
			
			2) Notify Follower
			
			3) Remove Sensor
			
			4) Set Targeting Receiver color to black

	2) Scans for nearby avatars (15 meter range)
		1) Avatar Detected
			1) Notify Click_Sensor of target_distance & target_uuid
			
			2) Displays target distance and target name on HUD
	
			3) Sets Targeting Receiver to green
	
		2) No avatar detected
			1) Notify Click_Sensor with null distance and NULL_KEY
			
			2) Clears display
	
			3) Sets Targeting Receiver to red
	
B) | name: Click_Sensor | channel: N/A | link: 2 |
	1) Takes control of user's left mouse button

	2) Watches for left mouse clicks
		1) if clicked and target_uuid is not equal to NULL_KEY 
			the notify SFX of target_distance and Follower of 
			target_uuid.  Also, inform target that they have been
			attacked so that they may update their health/soul meters

C) | name: Health_Meter | channel: 203040 | link: |
	1) listens for message_damage on health_channel
	
	2) send your opponent your current health_level
	
	3) upon death
		1) send message_death to soul meter
		
		2) notify the opponent who killed you on opponent_health_meter_channel
	
		3) send the opponent who killed you your soul count
	
D) | name: Opponent Health Meter | channel: 203041 | link: N/A |
	
E) | name: Soul Meter | channel: N/A | link: |
	
F) | name: SFX | channel: 1112 | link: N/A |
	
G) | name: Follower | channel: 96456 | link: N/A |


**************************************************************************************************
	