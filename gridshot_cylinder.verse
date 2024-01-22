
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
gridshot_shape_tag1:= class(tag) {}
gridshot_sphere_tag1 := class(tag) {}

gridshot_shape_tag2 := class(tag) {}
gridshot_sphere_tag2 := class(tag) {}

gridshot_shape_tag3 := class(tag) {}
gridshot_sphere_tag3 := class(tag) {}

gridshot_shape_tag4:= class(tag) {}
gridshot_sphere_tag4 := class(tag) {}

gridshot_shape_tag5 := class(tag) {}
gridshot_sphere_tag5 := class(tag) {}

gridshot_shape_tag6 := class(tag) {}
gridshot_sphere_tag6 := class(tag) {}

gridshot_shape_tag7 := class(tag) {}
gridshot_sphere_tag7 := class(tag) {}

gridshot_shape_tag8 := class(tag) {}
gridshot_sphere_tag8 := class(tag) {}

gridshot_shape_tag9 := class(tag) {}
gridshot_sphere_tag9 := class(tag) {}

gridshot_shape_tag10 := class(tag) {}
gridshot_sphere_tag10 := class(tag) {}

gridshot_shape_tag11 := class(tag) {}
gridshot_sphere_tag11 := class(tag) {}

gridshot_shape_tag12 := class(tag) {}
gridshot_sphere_tag12 := class(tag) {}


# A Verse-authored creative device that can be placed in a level
gridshot_cylinder := class(creative_device):

    @editable
    PropManipulatorMain1:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain2:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain3:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain4:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain5:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain6:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain7:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain8:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain9:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain10:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain11:prop_manipulator_device = prop_manipulator_device{}

    @editable
    PropManipulatorMain12:prop_manipulator_device = prop_manipulator_device{}


    @editable
    PropManipulatorSecondary1:prop_manipulator_device = prop_manipulator_device{}

    @editable
    StartZone:mutator_zone_device = mutator_zone_device{}


    @editable
    HUDMSGDevice:hud_message_device = hud_message_device{}
    

    SetDynamicText<localizes>(value:string) : message = "{value}"

    var BulletsHit : float = 0.0
    var BulletsNotHit : float = 0.0
    CreatedUI:logic = false
    var AccuracyTextBlock:text_block = text_block{DefaultTextColor := Black}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        StartZone.AgentEntersEvent.Subscribe(PlayerEntersZone)
        StartZone.AgentExitsEvent.Subscribe(PlayerExitsZone)

    PlayerEntersZone(Agent:agent):void=
        ResetAccuracy()

        PropManipulatorMain1.DamagedEvent.Subscribe(TagsSphere1)
        PropManipulatorMain2.DamagedEvent.Subscribe(TagsSphere2)
        PropManipulatorMain3.DamagedEvent.Subscribe(TagsSphere3)
        PropManipulatorMain4.DamagedEvent.Subscribe(TagsSphere4)
        PropManipulatorMain5.DamagedEvent.Subscribe(TagsSphere5)
        PropManipulatorMain6.DamagedEvent.Subscribe(TagsSphere6)
        PropManipulatorMain7.DamagedEvent.Subscribe(TagsSphere7)
        PropManipulatorMain8.DamagedEvent.Subscribe(TagsSphere8)
        PropManipulatorMain9.DamagedEvent.Subscribe(TagsSphere9)
        PropManipulatorMain10.DamagedEvent.Subscribe(TagsSphere10)
        PropManipulatorMain11.DamagedEvent.Subscribe(TagsSphere11)
        PropManipulatorMain12.DamagedEvent.Subscribe(TagsSphere12)

        PropManipulatorSecondary1.DamagedEvent.Subscribe(OnItemNotDamaged)

        CreatePlayerUI(Agent)

    PlayerExitsZone(Agent:agent):void=
        PropManipulatorMain1.DamagedEvent.Subscribe(TagsSphere1).Cancel
        PropManipulatorMain2.DamagedEvent.Subscribe(TagsSphere2).Cancel
        PropManipulatorMain3.DamagedEvent.Subscribe(TagsSphere3).Cancel
        PropManipulatorMain4.DamagedEvent.Subscribe(TagsSphere4).Cancel
        PropManipulatorMain5.DamagedEvent.Subscribe(TagsSphere5).Cancel
        PropManipulatorMain6.DamagedEvent.Subscribe(TagsSphere6).Cancel
        PropManipulatorMain7.DamagedEvent.Subscribe(TagsSphere7).Cancel
        PropManipulatorMain8.DamagedEvent.Subscribe(TagsSphere8).Cancel
        PropManipulatorMain9.DamagedEvent.Subscribe(TagsSphere9).Cancel
        PropManipulatorMain10.DamagedEvent.Subscribe(TagsSphere10).Cancel
        PropManipulatorMain11.DamagedEvent.Subscribe(TagsSphere11).Cancel
        PropManipulatorMain12.DamagedEvent.Subscribe(TagsSphere12).Cancel
        PropManipulatorSecondary1.DamagedEvent.Subscribe(OnItemNotDamaged).Cancel

        AccuracyText := SetDynamicText("")
        AccuracyTextBlock.SetText(AccuracyText)
    
    # First row of hits
    TagSphereWithTag1(Agent:agent, shapeTag:tag, sphereTag:tag, yPosition:float):void=
        ShapeObjects := GetCreativeObjectsWithTag(shapeTag)
        for (ShapeObject:ShapeObjects, Shape := creative_prop[ShapeObject]):
            TagView := Shape.GetTags()
            if (TagView.Has[sphereTag]):
                Print("Sphere found!")
                spawn{Shape.MoveTo(
                    vector3{
                        X := Random.GetRandomFloat(3788.0, 4208.0), # RED
                        Y := yPosition, # GREEN
                        Z := Random.GetRandomFloat(2080.0, 2404.0) # BLUE
                    }, 
                    rotation{}, 
                    0.1)
                }
                OnItemDamaged(Agent)
            
    TagsSphere1(Agent:agent):void=
        TagSphereWithTag1(Agent, gridshot_shape_tag1{}, gridshot_sphere_tag1{}, 7740.0)
    
    TagsSphere2(Agent:agent):void=
        TagSphereWithTag1(Agent, gridshot_shape_tag2{}, gridshot_sphere_tag2{}, 7800.0)
    
    TagsSphere3(Agent:agent):void=
        TagSphereWithTag1(Agent, gridshot_shape_tag3{}, gridshot_sphere_tag3{}, 7864.0)

    # Second row of hits
    TagSphereWithTag2(Agent:agent, shapeTag:tag, sphereTag:tag, xPosition:float):void=
        ShapeObjects := GetCreativeObjectsWithTag(shapeTag)
        for (ShapeObject:ShapeObjects, Shape := creative_prop[ShapeObject]):
            TagView := Shape.GetTags()
            if (TagView.Has[sphereTag]):
                Print("Sphere found!")
                spawn{Shape.MoveTo(
                    vector3{
                        X := xPosition, # RED
                        Y := Random.GetRandomFloat(8360.0, 7940.0), # GREEN
                        Z := Random.GetRandomFloat(2080.0, 2404.0) # BLUE
                    }, 
                    rotation{}, 
                    0.1)
                }
                OnItemDamaged(Agent)

    TagsSphere4(Agent:agent):void=
        TagSphereWithTag2(Agent, gridshot_shape_tag4{}, gridshot_sphere_tag4{}, 3552.0)
    
    TagsSphere5(Agent:agent):void=
        TagSphereWithTag2(Agent, gridshot_shape_tag5{}, gridshot_sphere_tag5{}, 3616.0)
    
    TagsSphere6(Agent:agent):void=
        TagSphereWithTag2(Agent, gridshot_shape_tag6{}, gridshot_sphere_tag6{}, 3676.0)


    # Third row of hits
    TagSphereWithTag3(Agent:agent, shapeTag:tag, sphereTag:tag, yPosition:float):void=
        ShapeObjects := GetCreativeObjectsWithTag(shapeTag)
        for (ShapeObject:ShapeObjects, Shape := creative_prop[ShapeObject]):
            TagView := Shape.GetTags()
            if (TagView.Has[sphereTag]):
                Print("Sphere found!")
                spawn{Shape.MoveTo(
                    vector3{
                        X := Random.GetRandomFloat(3800.0, 4224.0), # RED
                        Y := yPosition, # GREEN
                        Z := Random.GetRandomFloat(2080.0, 2404.0) # BLUE
                    }, 
                    rotation{}, 
                    0.1)
                }
                OnItemDamaged(Agent)
    TagsSphere7(Agent:agent):void=
        TagSphereWithTag3(Agent, gridshot_shape_tag7{}, gridshot_sphere_tag7{}, 8432.0)
    
    TagsSphere8(Agent:agent):void=
        TagSphereWithTag3(Agent, gridshot_shape_tag8{}, gridshot_sphere_tag8{}, 8492.0)

    TagsSphere9(Agent:agent):void=
        TagSphereWithTag3(Agent, gridshot_shape_tag9{}, gridshot_sphere_tag9{}, 8556.0)
    

    # Forth row of hits
    TagSphereWithTag4(Agent:agent, shapeTag:tag, sphereTag:tag, xPosition:float):void=
        ShapeObjects := GetCreativeObjectsWithTag(shapeTag)
        for (ShapeObject:ShapeObjects, Shape := creative_prop[ShapeObject]):
            TagView := Shape.GetTags()
            if (TagView.Has[sphereTag]):
                Print("Sphere found!")
                spawn{Shape.MoveTo(
                    vector3{
                        X := xPosition, # RED
                        Y := Random.GetRandomFloat(8364.0, 7932.0), # GREEN
                        Z := Random.GetRandomFloat(2080.0, 2404.0) # BLUE
                    }, 
                    rotation{}, 
                    0.1)
                }
                OnItemDamaged(Agent)
    
    TagsSphere10(Agent:agent):void=
        TagSphereWithTag4(Agent, gridshot_shape_tag10{}, gridshot_sphere_tag10{}, 4344.0)

    TagsSphere11(Agent:agent):void=
        TagSphereWithTag4(Agent, gridshot_shape_tag11{}, gridshot_sphere_tag11{}, 4404.0)
    
    TagsSphere12(Agent:agent):void=
        TagSphereWithTag4(Agent, gridshot_shape_tag12{}, gridshot_sphere_tag12{}, 4464.0)
    

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
