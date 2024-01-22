
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
tracking_shape_tag1 := class(tag) {}
tracking_sphere_tag1 := class(tag) {}

# A Verse-authored creative device that can be placed in a level
tracking_sphere := class(creative_device):

    @editable
    PropManipulatorMain1:prop_manipulator_device = prop_manipulator_device{}


    @editable
    PropManipulatorSecondary1:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary2:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary3:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary4:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorSecondary5:prop_manipulator_device = prop_manipulator_device{}


    @editable
    StartZone:mutator_zone_device = mutator_zone_device{}


    @editable
    HUDMSGDevice:hud_message_device = hud_message_device{}
    

    SetDynamicText<localizes>(value:string) : message = "{value}"

    var BulletsHit : float = 0.0
    var BulletsNotHit : float = 0.0
    CreatedUI:logic = false
    var AccuracyTextBlock:text_block = text_block{DefaultTextColor:=White}


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        StartZone.AgentEntersEvent.Subscribe(PlayerEntersZone)
        StartZone.AgentExitsEvent.Subscribe(PlayerExitsZone)
        SphereMovement()

    PlayerEntersZone(Agent:agent):void=
        PropManipulatorMain1.DamagedEvent.Subscribe(OnItemDamaged)
        PropManipulatorSecondary1.DamagedEvent.Subscribe(OnItemNotDamaged)
        PropManipulatorSecondary2.DamagedEvent.Subscribe(OnItemNotDamaged)
        PropManipulatorSecondary3.DamagedEvent.Subscribe(OnItemNotDamaged)
        PropManipulatorSecondary4.DamagedEvent.Subscribe(OnItemNotDamaged)
        PropManipulatorSecondary5.DamagedEvent.Subscribe(OnItemNotDamaged)


        CreatePlayerUI(Agent)
    
    PlayerExitsZone(Agent:agent):void=
        PropManipulatorMain1.DamagedEvent.Subscribe(OnItemDamaged).Cancel
        PropManipulatorSecondary1.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        PropManipulatorSecondary2.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        PropManipulatorSecondary3.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        PropManipulatorSecondary4.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        PropManipulatorSecondary5.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel
        
        AccuracyText := SetDynamicText("")
        AccuracyTextBlock.SetText(AccuracyText)

    SphereMovement()<suspends>:void=
        loop:
            TagsSphere()
            Sleep(0.3)

    TagsSphere():void=
        ShapeObjects := GetCreativeObjectsWithTag(tracking_shape_tag1{})

        for (ShapeObject : ShapeObjects, Shape := creative_prop[ShapeObject]):
            TagView := Shape.GetTags()

            if (TagView.Has[tracking_sphere_tag1{}]):
                spawn{Shape.MoveTo(
                    vector3{
                        X := Random.GetRandomFloat(3544.0, 3120.0), 
                        Y := Random.GetRandomFloat(10352.0, 9980.0), 
                        Z := Random.GetRandomFloat(1488.0, 1920.0)
                    }, 
                    rotation{}, 0.9)
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
                else:
                    # Calculate accuracy and update the UI
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