
using { /Fortnite.com/UI }
using { /Fortnite.com/Devices }
using { /Verse.org }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Colors/NamedColors }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }


# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.
peak_shape_dummy_tag1 := class(tag) {}
peak_dummy_tag1 := class(tag) {}

# A Verse-authored creative device that can be placed in a level
peak_practice:= class(creative_device):

    # Creative devices used to manipulate the gameplay
    @editable
    PropManipulatorMain1:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary1:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary2:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary3:prop_manipulator_device = prop_manipulator_device{}

    @editable
    StartZone:mutator_zone_device = mutator_zone_device{}

    @editable
    HUDMSGDevice:hud_message_device = hud_message_device{}
    

    # Setting the default value for the message device
    SetDynamicText<localizes>(value:string) : message = "{value}"


    # Declaring variables
    var BulletsHit : float = 0.0
    var BulletsNotHit : float = 0.0
    CreatedUI : logic = false
    var AccuracyTextBlock : text_block = text_block{DefaultTextColor := White}
    

    
    # Start of the Verse script
    OnBegin<override>()<suspends>:void=
        # Initiate the devices on player entering/exiting the zone
        StartZone.AgentEntersEvent.Subscribe(PlayerEntersZone)
        StartZone.AgentExitsEvent.Subscribe(PlayerExitsZone)

        # Call the function which keeps the Dummy movement
        DummyMovement()

    # Initiate the devices on player entering the mutator zone
    PlayerEntersZone(Agent:agent):void=
        # Reset the accuracy
        ResetAccuracy()

        PropManipulatorMain1.DamagedEvent.Subscribe(OnItemDamaged)
        PropManipulatorSecondary1.DamagedEvent.Subscribe(OnItemNotDamaged)
        PropManipulatorSecondary2.DamagedEvent.Subscribe(OnItemNotDamaged)
        PropManipulatorSecondary3.DamagedEvent.Subscribe(OnItemNotDamaged)


        # Create the UI for the player
        CreatePlayerUI(Agent)

    # Stop the devices on player exiting the mutator zone
    PlayerExitsZone(Agent:agent):void=
        PropManipulatorMain1.DamagedEvent.Subscribe(OnItemDamaged).Cancel
        PropManipulatorSecondary1.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        PropManipulatorSecondary2.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        PropManipulatorSecondary3.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel

        # Hide the accurracy text when exiting the zone
        AccuracyText := SetDynamicText("")
        AccuracyTextBlock.SetText(AccuracyText)

        

    DummyMovement()<suspends>:void=
        loop:
            TagsDummy1()
            Sleep(0.5)


    TagsDummy1():void=
        ShapeObjects := GetCreativeObjectsWithTag(peak_shape_dummy_tag1{})

        for (ShapeObject : ShapeObjects, Shape := creative_prop[ShapeObject]):
            TagView := Shape.GetTags()

            var positionX : float = Random.GetRandomFloat(1716.0, 1284.0)
            var positionY : float = Random.GetRandomFloat(8132.0, 8340.0)
            var positionZ : float = Random.GetRandomFloat(1244.0, 1284.0)
                
            # Adjust X, Y, Z value if it's less than 50
            if (positionX < 50.0):
                set positionX += 100.0

            if (positionY < 50.0):
                set positionY += 100.0

            if (positionZ < 50.0):
                set positionZ += 100.0

            if (TagView.Has[peak_dummy_tag1{}]):
                spawn{
                    Shape.MoveTo(
                        vector3{
                            X := positionX, 
                            Y := positionY, 
                            Z := positionZ
                        }, 
                        rotation{}, 
                        0.7)
                    }

    OnItemDamaged(Agent:agent):void=
        set BulletsHit += 1.0
        CreatePlayerUI(Agent)

    OnItemNotDamaged(Agent:agent):void=
        set BulletsNotHit += 1.0
        CreatePlayerUI(Agent)
        
    CreatePlayerUI(Agent:agent):void=
        if (ThePlayer:player = player[Agent]):
            if (PlayerUI := GetPlayerUI[ThePlayer]):
                if (CreatedUI = false):
                    # Create Accuracy UI for the first time
                    AccuracyWidget := CreateAccuracyUI(AccuracyTextBlock)
                    PlayerUI.AddWidget(AccuracyWidget)

                    Accuracy := CalculateAccuracy()

                    AccuracyText := SetDynamicText("🎯 {Accuracy}%")
                    AccuracyTextBlock.SetText(AccuracyText)

                    

    


    # Function to calculate accuracy
    CalculateAccuracy():string=
        var AccuracyFloat : float = 0.0
        var AccuracyInt : int = 0

        if (BulletsNotHit + BulletsHit > 0.0):
            set AccuracyFloat = BulletsHit / (BulletsNotHit + BulletsHit) * 100

            if (Value := Round[AccuracyFloat]):
                set AccuracyInt = Value 

            # Cap the accuracy between 0% and 100%
            if (AccuracyInt < 0):
                return ToString(0)
            else if (AccuracyInt > 100):
                return ToString(100)
            else:
                return ToString(AccuracyInt)
        else:
            return "Calculating... "

    # Function to reset the accuracy
    ResetAccuracy():void=
        set BulletsHit = 0.0
        set BulletsNotHit = 0.0

    # Function to create or update the accuracy UI
    CreateAccuracyUI(TextBlock:text_block):canvas=
        UICanvas:canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.05, Y := 0.2}, Maximum := vector2{X := 0.05, Y := 0.2}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.05, Y := 0.2}
                    SizeToContent := true
                    Widget := TextBlock

