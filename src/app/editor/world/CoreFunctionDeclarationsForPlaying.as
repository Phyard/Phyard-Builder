package editor.world {

   import editor.trigger.*;

   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreClassIds;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.IdPool;
   
   import common.MultiplePlayerDefine;
   import common.Define;

   public class CoreFunctionDeclarationsForPlaying
   {

      private static var sFunctionDeclarations:Array = new Array (IdPool.NumPlayerFunctions);

      private static const sGlobalCodePackage:CodePackage = new CodePackage ("Global");
      private static const sWorldCodePackage:CodePackage = new CodePackage ("World");
      private static const sEntityCodePackage:CodePackage = new CodePackage ("Entity");
      
      private static var sNumberCodePackage:CodePackage;
      private static var sEntityShapeCodePackage:CodePackage;

      // ...

      public static function GetCodePackagesForShorterMenuBar ():Array
      {
         return [sGlobalCodePackage, sWorldCodePackage, sEntityCodePackage];
      }

      public static function GetCodePackagesForLongerMenuBar ():Array
      {
         return [sGlobalCodePackage, sNumberCodePackage, sWorldCodePackage, sEntityCodePackage, sEntityShapeCodePackage];
      }

      public static function Initialize ():void
      {

      //================================================
      // packages
      //================================================

         var class_common_package:CodePackage = new CodePackage ("Type Common", sGlobalCodePackage);
         var code_flow_package:CodePackage = new CodePackage ("Code Flow Control", sGlobalCodePackage);
         var bool_package:CodePackage   = new CodePackage ("Boolean", sGlobalCodePackage);
         var number_package:CodePackage   = new CodePackage ("Number", sGlobalCodePackage);
            var number_general_package:CodePackage         = new CodePackage ("General", number_package);
            var convert_package:CodePackage            = new CodePackage ("Conversion", number_package);
            //var to_string_package:CodePackage      = new CodePackage ("To/From String", number_package);
            var bitwise_package:CodePackage            = new CodePackage ("Bit-wise", number_package);
            var usual_number_package:CodePackage         = new CodePackage ("Usual", number_package);
            var trigonometry_package:CodePackage = new CodePackage ("Trigonometry", number_package);
            var random_package:CodePackage             = new CodePackage ("Random", number_package);
            var more_number_package:CodePackage      = new CodePackage ("More", number_package);
         var string_package:CodePackage = new CodePackage ("String", sGlobalCodePackage);
         var array_package:CodePackage   = new CodePackage ("Array", sGlobalCodePackage);
            var array_element_package:CodePackage   = array_package; // new CodePackage ("Element", array_package);
         var bytearray_package:CodePackage   = new CodePackage ("ByteArray", sGlobalCodePackage);
         var system_package:CodePackage = new CodePackage ("System", sGlobalCodePackage);
         var services_package_1:CodePackage = new CodePackage ("Services 1", sGlobalCodePackage);
         var services_package_2:CodePackage = new CodePackage ("Services 2 (Multiplayer)", sGlobalCodePackage);
         var services_package_3:CodePackage = new CodePackage ("Services 3 (Advertisement)", sGlobalCodePackage);

         var world_io_package:CodePackage  = new CodePackage ("IO", sWorldCodePackage);
         var world_scene_package:CodePackage  = new CodePackage ("Scene", sWorldCodePackage);
         var world_level_package:CodePackage  = new CodePackage ("Level", sWorldCodePackage);
         var ccat_package:CodePackage    = new CodePackage ("CCat", sWorldCodePackage);
         var world_appearance_package:CodePackage    = new CodePackage ("Appearance", sWorldCodePackage);
         var world_physics_package:CodePackage    = new CodePackage ("Physics", sWorldCodePackage);
         var world_camera_package:CodePackage    = new CodePackage ("Camera", sWorldCodePackage);
         var world_script_package:CodePackage    = new CodePackage ("Script Calling", sWorldCodePackage);
         var world_create_entity_package:CodePackage    = new CodePackage ("Create Entity", sWorldCodePackage);
         var world_sound_package:CodePackage    = new CodePackage ("Sound", sWorldCodePackage);
         var world_module_package:CodePackage    = new CodePackage ("Module", sWorldCodePackage);

         var entity_general_package:CodePackage    = new CodePackage ("General", sEntityCodePackage);
         var entity_is_subtype_package:CodePackage    = new CodePackage ("Type Judgment", sEntityCodePackage);
         var entity_common_package:CodePackage    = new CodePackage ("Common", sEntityCodePackage);
         var entity_as_task_package:CodePackage    = new CodePackage ("Task Status", sEntityCodePackage);
         var entity_shape_package:CodePackage = new CodePackage ("Shape", sEntityCodePackage);
             var shape_is_subtype_package:CodePackage    = new CodePackage ("Type Judgment", entity_shape_package);
             var shape_common_package:CodePackage    = new CodePackage ("Common", entity_shape_package);
             var shape_geometry_package:CodePackage = new CodePackage ("Geometry", entity_shape_package);
             //var shape_circle_package:CodePackage  = new CodePackage ("Circle", entity_shape_package);
             //var shape_rectangle_package:CodePackage  = new CodePackage ("Rectangle", entity_shape_package);
             //var shape_poly_package:CodePackage  = new CodePackage ("Poly Shape", entity_shape_package);
             //var shape_polygon_package:CodePackage  = new CodePackage ("Polygon", entity_shape_package);
             //var shape_polyline_package:CodePackage  = new CodePackage ("Polyline", entity_shape_package);
             var shape_appearance_package:CodePackage = new CodePackage ("Appearance", entity_shape_package);
                 var shape_body_appearance_package:CodePackage = new CodePackage ("Body", shape_appearance_package);
                 var shape_border_appearance_package:CodePackage = new CodePackage ("Border", shape_appearance_package);
             var shape_physics_properties_package_1:CodePackage = new CodePackage ("Physics Properties 1", entity_shape_package);
             var shape_physics_properties_package_2:CodePackage = new CodePackage ("Physics Properties 2", entity_shape_package);
             var shape_physics_dynamics_package:CodePackage = new CodePackage ("Physics Dynamics", entity_shape_package);
             var entity_shape_brothers_package:CodePackage = new CodePackage ("Brothers", entity_shape_package);
             var entity_shape_connections_package:CodePackage = new CodePackage ("Connections", entity_shape_package);
             var entity_shape_contaction_package:CodePackage = new CodePackage ("Contacts", entity_shape_package);
             var shape_text_package:CodePackage  = new CodePackage ("Text Shape", entity_shape_package);
                var shape_text_button_package:CodePackage  = new CodePackage ("Button", shape_text_package);
             var shape_module_package:CodePackage  = new CodePackage ("Module Shape", entity_shape_package);
         var entity_joint_package:CodePackage  = new CodePackage ("Joint", sEntityCodePackage);
         var entity_trigger_package:CodePackage  = new CodePackage ("Trigger", sEntityCodePackage);
         
         // ...
         
         sNumberCodePackage = number_package;
         sEntityShapeCodePackage = entity_shape_package;

      //================================================
      // functions
      //================================================

         if (Compile::Is_Debugging)
         {
            RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ForDebug, sGlobalCodePackage, "ForDevDebug", "@(#0, #1, #2, #3, #4) = ForDevDebug ($0, $1, $2, $3, $4)", null,
                          [
                             new VariableDefinitionEntity ("Shape"),
                             new VariableDefinitionNumber ("Gravity Angle"),
                             new VariableDefinitionBoolean ("Is Sensor"),
                             new VariableDefinitionString ("Text"),
                             new VariableDefinitionCollisionCategory ("Collision Category"),
                             new VariableDefinitionArray ("Array"),
                          ],
                          [
                             new VariableDefinitionEntity ("Shape"),
                             new VariableDefinitionNumber ("Gravity Angle"),
                             new VariableDefinitionBoolean ("Is Sensor"),
                             new VariableDefinitionString ("Text"),
                             new VariableDefinitionCollisionCategory ("Collision Category"),
                             new VariableDefinitionArray ("Array"),
                          ]
                       );
            RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetDebugString, sGlobalCodePackage, "GetDebugString", null, null,
                          null,
                          [
                             new VariableDefinitionString ("Debug String"),
                          ]
                       );
         }

      // special predefieds for internal using

         RegisterPreDefineFunctionDeclaration (CoreFunctionIds.ID_Void, null, "Action", "Action", null,
                     null,
                     null
                  );
         RegisterPreDefineFunctionDeclaration (CoreFunctionIds.ID_Bool, null, "Condition", "Condition", null,
                     null,
                     [
                              new VariableDefinitionBoolean ("Evaluation Result"),
                     ]
                  );

         RegisterPreDefineFunctionDeclaration (CoreFunctionIds.ID_EntityFilter, null, "Entity Filter", "Entity Filter", null,
                     [
                              new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                              new VariableDefinitionBoolean ("Filter Result"),
                     ]
                  );
         RegisterPreDefineFunctionDeclaration (CoreFunctionIds.ID_EntityPairFilter, null, "Entity Pair Filter", "Entity Pair Filter", null,
                     [
                              new VariableDefinitionEntity ("Entity 1"),
                              new VariableDefinitionEntity ("Entity 2"),
                     ],
                     [
                              new VariableDefinitionBoolean ("Filter Result"),
                     ]
                  );

      // global

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Return, code_flow_package, "Return", "Return", null,
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ReturnIfTrue, code_flow_package, "Return If True", "@Return if $0 is true", null,
                     [
                             new VariableDefinitionBoolean ("Bool Value", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ReturnIfFalse, code_flow_package, "Return If False", "@Return if $0 is false", null,
                     [
                             new VariableDefinitionBoolean ("Bool Value", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Comment, code_flow_package, "Comment Line", "@/* $0 */", "@/* $0 */",
                     [
                             new VariableDefinitionString ("Comment Text"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Blank, code_flow_package, "Blank Line", "@", "@",
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Removed, code_flow_package, "Removed Warning", "@(This function is removed)", "@(This function is removed)",
                     null,
                     null,
                     false
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_StartIf, code_flow_package, "If", "@If ($0 == $1)", "@If ($0 == $1)",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionBoolean ("Comparer", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     null,
                     true
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Else, code_flow_package, "Else", "@Else", "@Else",
                     null,
                     null,
                     true
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EndIf, code_flow_package, "End If", "@End If", "@End If",
                     null,
                     null,
                     true
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_StartWhile, code_flow_package, "While", "@While ($0 == $1)", "@While ($0 == $1)",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionBoolean ("Comparer", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     null,
                     true
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Break, code_flow_package, "Break", "Break", "Break",
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Continue, code_flow_package, "Continue", "Continue", "Continue",
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EndWhile, code_flow_package, "End While", "@End While", "@End While",
                     null,
                     null,
                     true
                  );

       // class common

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CommonAssign, class_common_package, "=", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionObject ("Source Object"),
                     ],
                     [
                             new VariableDefinitionObject ("Target Object"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CommonEquals, class_common_package, "==", "@#0 == $0", "@#0 == $0",
                     [
                             new VariableDefinitionObject ("Object 1"),
                             new VariableDefinitionObject ("Object 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CommonNewInstance, class_common_package, "New", "@#0 = New ($0)", "@#0 = New (($0))",
                     [
                             new VariableDefinitionClass ("Class"),
                     ],
                     [
                             new VariableDefinitionObject ("Object", null, {mAllowCoreClasses: false}),
                     ]
                  );


      // system

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds, system_package, "Get Program Milliseconds", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Milliseconds"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetCurrentDateTime, system_package, "Get Current Date Time", null, null,
                     [
                             new VariableDefinitionBoolean ("UTC (universal time)?"),
                     ],
                     [
                             new VariableDefinitionNumber ("Year"),
                             new VariableDefinitionNumber ("Month"),
                             new VariableDefinitionNumber ("Day"),
                             new VariableDefinitionNumber ("Hours"),
                             new VariableDefinitionNumber ("Minutes"),
                             new VariableDefinitionNumber ("Seconds"),
                             new VariableDefinitionNumber ("Milliseconds"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetDay, system_package, "Get Day In Week", null, null,
                     [
                             new VariableDefinitionBoolean ("UTC (universal time)?"),
                     ],
                     [
                             new VariableDefinitionNumber ("Day In Week (0 for Sunday)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetTimeZone, system_package, "Get Time Zone", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("The Time Zone [-12, +12]"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_IsKeyHold, system_package, "Is Key Held", "@#0 = Is the key (key code is $0) held?", null,
                     [
                             new VariableDefinitionNumber ("The Key", null, {mValueLists: Lists.mKeyCodeList}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Held?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_IsMouseButtonHold, system_package, "Is Left Mouse Button Held?", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Held?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_SetMouseVisible, system_package, "Set Mouse Visible", null, null,
                     [
                        new VariableDefinitionBoolean ("Visible?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetMouseGestureEnabled, system_package, "Enable Gesture Events", null, null,
                     [
                        new VariableDefinitionBoolean ("Enable Gesture Events?"),
                        new VariableDefinitionBoolean ("Draw Gesture?"),
                        new VariableDefinitionNumber ("Minimum Gesture Size (inches)"),
                        new VariableDefinitionNumber ("Gesture Color", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_IsAccelerometerSupported, system_package, "Is Accelerometer Supported", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Supported?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetAcceleration, system_package, "Get Acceleration", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Acceleration X"),
                        new VariableDefinitionNumber ("Acceleration Y"),
                        new VariableDefinitionNumber ("Acceleration Z"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetAppFileURL, system_package, "Get App File URL", null, null,
                     null,
                     [
                        new VariableDefinitionString ("App File URL"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_IsNativeApp, system_package, "Is Native App", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Native App?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetAppID, system_package, "Get App ID", null, null,
                     null,
                     [
                        new VariableDefinitionString ("App ID"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ExitApp, system_package, "Exit App", null, null,
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetScreenResolution, system_package, "Get Screen Resolution", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Width (pixels)"),
                        new VariableDefinitionNumber ("Height (pixels)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetScreenDPI, system_package, "Get Screen DPI", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("DPI (pixels per inch)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetOsNameString, system_package, "Get Operating System Name String", null, null,
                     null,
                     [
                        new VariableDefinitionString ("OS Name"),
                     ]
                  );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_OpenURL, system_package, "Open URL", null, null,
                     [
                        new VariableDefinitionString ("URL"),
                     ],
                     null
                  );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CopyToClipboard, system_package, "Copy To Clipboard", null, null,
                     [
                        new VariableDefinitionString ("Text To Copy"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetLanguageCode, system_package, "Get Native System Language Code", null, null,
                     null,
                     [
                        new VariableDefinitionString ("Language Code"),
                     ]
                  );

      // services

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_SubmitHighScore, services_package_1, "Submit High Score", null, null,
                     [
                             new VariableDefinitionNumber ("Score"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_SubmitKeyValue_Number, services_package_1, "Submit Property Value", null, null,
                     [
                             new VariableDefinitionString ("Property Name"),
                             new VariableDefinitionNumber ("Property Value"),
                     ],
                     null
                  );
                  
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ConnectToMultiplePlayerServer, services_package_2, "Connect To Multiple Player Server", null, null,
         //            null,
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CreateNewGameInstanceDefine, services_package_2, "Create Multiplayer Instance Define", null, null,
                     [
                             new VariableDefinitionString ("Fingerprint (0-30 chars)", null, {mMaxLength: 30}),
                             new VariableDefinitionNumber ("Number Of Players", null, {mValueLists: Lists.mMultiplePlayerInstanceNumberOfPlayersList}),
                     ],
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceDefine, "Created Multiplayer Instance Define"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CreateNewGameInstanceChannelDefine, services_package_2, "Create Instance Channel Define", null, null,
                     [
                             new VariableDefinitionNumber ("Channel Mode", null, {mValueLists: Lists.mMultiplePlayerChannelModeList}),
                             new VariableDefinitionNumber ("Turn Timeout (seconds, 0: unlimited)", null, {mMinValue: 0, mMaxValue: MultiplePlayerDefine.MaxTurnTimeoutInPractice}),
                     ],
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine, "Created Multiplayer Instance Channel Define")
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GameInstanceDefineSetChannelDefine, services_package_2, "Modify Channel Define Of Multiplayer Instance Define", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceDefine, "Multiplayer Instance Define"),
                             new VariableDefinitionNumber ("Channel Index", null, {mValueLists: Lists.mMultiplePlayerInstanceChannelList}),
                             new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine, "Created Instance Channel Define"),
                     ],
                     null
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CreateGameInstance, services_package_2, "Create New Multiplayer Instance", null, null,
         //            [
         //                    new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceDefine, "Multiplayer Instance Define"),
         //                    new VariableDefinitionString ("Password (max 30 chars, blank for public)", null, {mMaxLength: 30}),
         //            ],
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_JoinGameInstanceRandomly, services_package_2, "Join Multiplayer Instance Randomly", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceDefine, "Multiplayer Instance Define"),
                             //new VariableDefinitionBoolean ("Create New If No Availables"),
                     ],
                     null
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_JoinGameInstanceByInstanceID, services_package_2, "Join Multiplayer Instance By Instance ID", null, null,
         //            [
         //                    new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstanceDefine, "Multiplayer Instance Define"),
         //                    new VariableDefinitionString ("Instance ID"),
         //                    new VariableDefinitionString ("Password (if required)"),
         //            ],
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ExitGameInstance, services_package_2, "Exit Current Multiplayer Instance", null, null,
                     null,
                     null
                  );
                  
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_IsInMutiplayerPlayerStatus, services_package_2, "Am I In The Specified Player Status?", "@#0 = (My Multiplayer Status == $0)", "@#0 = (My Multiplayer Status == $0)",
                     [
                             new VariableDefinitionNumber ("The Specified Status", null, {mValueLists: Lists.mMultiplePlayerPlayerStatusList}),
                     ],
                     [
                             new VariableDefinitionBoolean ("In This Status?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_IsInGameInstancePhase, services_package_2, "Is Multiplayer Instance In The Specified Phase?", "@#0 = (Game Instance Phase == $0)", "@#0 = (Game Instance Phase == $0)",
                     [
                             new VariableDefinitionNumber ("The Specified Phase", null, {mValueLists: Lists.mMultiplePlayerInstancePhaseList}),
                     ],
                     [
                             new VariableDefinitionBoolean ("In This Phase?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetGameInstanceNumberOfSeats, services_package_2, "Get Number Of Seats In Multiplayer Instance", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Number Of Seats"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetMySeatIndexInGameInstance, services_package_2, "Get My Seat Index In Multiplayer Instance", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("My Seat Index"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetGameInstanceSeatInfo, services_package_2, "Get Multiplayer Instance Seat Info", null, null,
                     null,
                     [
                             new VariableDefinitionString ("Player Name"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_GetGameInstanceChannelSeatInfo, services_package_2, "Get Multiplayer Instance Channel Seat Info", null, null,
                     [
                             new VariableDefinitionNumber ("Channel Index", null, {mValueLists: Lists.mMultiplePlayerInstanceChannelList}),
                             new VariableDefinitionNumber ("Seat Index", null, {mMinValue: 0, mMaxValue: MultiplePlayerDefine.MaxNumberOfInstanceSeats - 1}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Channel Seat Enabled?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_SendGameInstanceChannelMessage, services_package_2, "Send Multiplayer Instance Channel Message", null, null,
                     [
                             new VariableDefinitionNumber ("Channel Index", null, {mValueLists: Lists.mMultiplePlayerInstanceChannelList}),
                             new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Data To Send"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_SendSignal_ChangeInstancePhase, services_package_2, "Send Signal To Change Multiplayer Instance Phase", null, null,
                     [
                             new VariableDefinitionNumber ("New Phase", null, {mValueLists: Lists.mMultiplePlayerInstancePhaseList}),
                     ],
                     null
                  );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_SetGlobalOptions, services_package_3, "Set Advertisement Global Options", null, null,
                     [
                             new VariableDefinitionString ("Test Device IDs (comma separated)"),
                             new VariableDefinitionBoolean ("This App is Child-Directed?"),
                             new VariableDefinitionNumber ("Gender", null, {mValueLists: Lists.mAdvertisementGenderList}),
                     ],
                     null
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_DestroyAllAds, services_package_3, "Destroy All Ads", null, null,
         //            null,
         //            null
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_HideAllAds, services_package_3, "Hide All Ads", null, null,
         //            null,
         //            null
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_ShowAllAds, services_package_3, "Show All Ads", null, null,
         //            null,
         //            null
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_IsAdProviderAvailable, services_package_3, "Is Advertisement Provider Available>", null, null,
         //            [
         //                    new VariableDefinitionString ("Advertisement Provider"),
         //            ],
         //            [
         //                    new VariableDefinitionBoolean ("Available?"),
         //            ]
         //         );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_CreateAd, services_package_3, "Create New Advertisement", null, null,
                     [
                             new VariableDefinitionString ("Advertisement Provider"),
                             new VariableDefinitionNumber ("Ad Type", null, {mValueLists: Lists.mAdvertisementTypeList}),
                             new VariableDefinitionString ("Ad Unit ID"),
                     ],
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ]
                  );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_DestroyAd, services_package_3, "Destroy Advertisement", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_CheckAdValidity, services_package_3, "Check Advertisement Validity", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     [
                             new VariableDefinitionString ("Result (blank means OK)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_PrepareAd, services_package_3, "Prepare Advertisement", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_IsAdReady, services_package_3, "Is Advertisement Ready", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Ready To Show?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_SetAdPosition, services_package_3, "Set Advertisement Position", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                             new VariableDefinitionNumber ("Position X", null, {mValueLists: Lists.mAdvertisementPositionTypeList}),
                             new VariableDefinitionNumber ("Position Y", null, {mValueLists: Lists.mAdvertisementPositionTypeList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_GetAdBoundsInPixels, services_package_3, "Get Advertisement Bounds In Device Pixels", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     [
                             new VariableDefinitionNumber ("X"),
                             new VariableDefinitionNumber ("Y"),
                             new VariableDefinitionNumber ("Width"),
                             new VariableDefinitionNumber ("Height"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_IsAdVisible, services_package_3, "Is Advertisement Visible", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Ad Visible?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_ShowAd, services_package_3, "Show Advertisement", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Advertisement_HideAd, services_package_3, "Hide Advertisement", null, null,
                     [
                             new VariableDefinitionOthers (CoreClassIds.ValueType_Advertisement, "Ad"),
                     ],
                     null
                  );

                  

      // string

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_Assign, string_package, "= (Assign String)", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionString ("Source String", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     [
                             new VariableDefinitionString ("Target String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_ConditionAssign, string_package, "?= (Condition Assign String)", "@#0 = ($0 is true) ? $1 : $2", "@#0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionString ("Source String 1", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionString ("Source String 2", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     [
                             new VariableDefinitionString ("Target String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_SwapValues, string_package, "Swap String Values", "@$0 <-> $1", null,
                     [
                             new VariableDefinitionString ("String 1 (reference)", null),
                             new VariableDefinitionString ("String 2 (reference)", null),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_Equals, string_package, "String == String?", "@#0 = String: ($0 == $1)", "@#0 = String: ($0 == $1)",
                     [
                             new VariableDefinitionString ("String 1"),
                             new VariableDefinitionString ("String 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_IsNull, string_package, "Is Null?", "@#0 = String ($0) is Null?", "IsNullString",
                     [
                             new VariableDefinitionString ("The String"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Null"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_Add, string_package, "String + String", "@#0 = $0 + $1", "@#0 = $0 + $1",
                     [
                             new VariableDefinitionString ("Source String 1", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionString ("Source String 2", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     [
                             new VariableDefinitionString ("Target String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_GetLength, string_package, "Get Length", "@#0 = GetStringLength ($0)", "@#0 = GetStringLength ($0)",
                     [
                             new VariableDefinitionString ("The String"),
                     ],
                     [
                             new VariableDefinitionNumber ("String Length"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_GetCharAt, string_package, "Get Char At", "@#0 = The ($1)th Char in String($0)", "@#0 = StringCharAt ($0, $1)",
                     [
                             new VariableDefinitionString ("The String"),
                             new VariableDefinitionNumber ("Char Index", null, {mMinValue: 0}),
                     ],
                     [
                             new VariableDefinitionString ("The Char"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_GetCharCodeAt, string_package, "Get Char Code At", "@#0 = The Code of ($1)th Char in String($0)", "@#0 = StringCharCodeAt ($0, $1)",
                     [
                             new VariableDefinitionString ("The String"),
                             new VariableDefinitionNumber ("Char Index", null, {mMinValue: 0}),
                     ],
                     [
                             new VariableDefinitionNumber ("Char Code"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_CharCode2Char, string_package, "Char Code -> Char", "@Char (#0) = From Char Code($0)", "@#0 = CharCode2Char ($0)",
                     [
                             new VariableDefinitionNumber ("Char Code"),
                     ],
                     [
                             new VariableDefinitionString ("The String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_ToLowerCase, string_package, "To Lower Case", null, null,
                     [
                             new VariableDefinitionString ("The Original String"),
                     ],
                     [
                             new VariableDefinitionString ("Lower Case String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_ToUpperCase, string_package, "To Upper Case", null, null,
                     [
                             new VariableDefinitionString ("The Original String"),
                     ],
                     [
                             new VariableDefinitionString ("Upper Case String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_IndexOf, string_package, "Index Of", null, null,
                     [
                             new VariableDefinitionString ("The String"),
                             new VariableDefinitionString ("The Substring"),
                             new VariableDefinitionNumber ("From Index", null, {mMinValue: 0, mMaxValue: 0x7fffffff}),
                     ],
                     [
                             new VariableDefinitionNumber ("Index"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_LastIndexOf, string_package, "Last Index Of", null, null,
                     [
                             new VariableDefinitionString ("The String"),
                             new VariableDefinitionString ("The Substring"),
                             new VariableDefinitionNumber ("From Index", null, {mMinValue: 0, mMaxValue: 0x7fffffff}),
                     ],
                     [
                             new VariableDefinitionNumber ("Last Index"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_Substring, string_package, "Substring", null, null,
                     [
                             new VariableDefinitionString ("The String"),
                             new VariableDefinitionNumber ("From Index (including)", null, {mMinValue: 0, mMaxValue: 0x7fffffff}),
                             new VariableDefinitionNumber ("To Index (excluding)", null, {mMinValue: 0, mMaxValue: 0x7fffffff}),
                     ],
                     [
                             new VariableDefinitionString ("The Substring"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_Split, string_package, "Split String", null, null,
                     [
                             new VariableDefinitionString ("The Input String"),
                             new VariableDefinitionString ("The Delimiter"),
                     ],
                     [
                             new VariableDefinitionArray ("Array of Substrings"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_String_Replace, string_package, "String Replace", null, null,
                     [
                             new VariableDefinitionString ("Original String"),
                             new VariableDefinitionString ("From Substring"),
                             new VariableDefinitionString ("To Substring"),
                             new VariableDefinitionBoolean ("Replace All Places?"),
                     ],
                     [
                             new VariableDefinitionString ("Result String"),
                     ]
                  );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Trace, string_package, "Trace", null, null,
                       [
                          new VariableDefinitionString ("Prefix Text", null, {mAllowVariablesOfOtherClasses: true}),
                          new VariableDefinitionString ("Content Text", null, {mAllowVariablesOfOtherClasses: true}),
                          //new VariableDefinitionBoolean ("Line Break?"),
                       ],
                       null
                    );

       // bool

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_Assign, bool_package, "= (Assign Boolean)", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionBoolean ("Source Boolean", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign, bool_package, "=? (Condition Assign Boolean)", "@#0 = ($0 is true) ? $1 : $2", "@#0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionBoolean ("Source Boolean 1", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionBoolean ("Source Boolean 2", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_SwapValues, bool_package, "Swap Boolean Values", "@$0 <-> $1", "SwapBooleanValues",
                     [
                             new VariableDefinitionBoolean ("Boolean 1 (reference)", null),
                             new VariableDefinitionBoolean ("Boolean 2 (reference)", null),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Boolean_ToString, bool_package, "Bool -> String", "@$0 -> #0", "BoolToString",
                     [
                             new VariableDefinitionBoolean ("The Bool"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean, bool_package, "Boolean == Boolean?",  "@#0 = Boolean: ($0 == $1)", "@#0 = Boolean: ($0 == $1)",
                     [
                             new VariableDefinitionBoolean ("Bool 1"),
                             new VariableDefinitionBoolean ("Bool 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_Invert, bool_package, "! (Invert)", "@#0 = ! $0", "@#0 = ! $0",
                     [
                             new VariableDefinitionBoolean ("Source Boolean"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Source Boolean"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_IsTrue, bool_package, "IsTrue?", "@#0 = ($0 == true)", null,
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_IsFalse, bool_package, "IsFalse?", "@#0 = ($0 == false)", null,
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_And, bool_package, "x && y (Bool And)", "@#0 = ($0 && $1)", "@#0 = ($0 && $1)",
                     [
                             new VariableDefinitionBoolean ("Bool 1"),
                             new VariableDefinitionBoolean ("Bool 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_Or, bool_package, "x || y (Bool Or)", "@#0 = ($0 || $1)", "@#0 = ($0 || $1)",
                     [
                             new VariableDefinitionBoolean ("Boolean 1"),
                             new VariableDefinitionBoolean ("Boolean 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_Not, bool_package, "! (Bool Not)", "@#0 = (! $0)", "@#0 = (! $0)",
                     [
                             new VariableDefinitionBoolean ("Input Boolean Value"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bool_Xor, bool_package, "!= (Bool Xor)", "@#0 = ($0 != $1)", "@#0 = ($0 != $1)",
                     [
                             new VariableDefinitionBoolean ("Boolean 1"),
                             new VariableDefinitionBoolean ("Boolean 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );

       // array

         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_IndexOf, array_package, "Index Of", null, null,
         //            [
         //                    new VariableDefinitionArray ("The Array"),
         //                    new VariableDefinitionObject ("Element Value"),
         //                    new VariableDefinitionNumber ("From Index", null, {mMinValue: 0, mMaxValue: 0x7fffffff}),
         //            ],
         //            [
         //                    new VariableDefinitionNumber ("Index"),
         //            ]
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_LastIndexOf, array_package, "Last Index Of", null, null,
         //            [
         //                    new VariableDefinitionArray ("The Array"),
         //                    new VariableDefinitionObject ("Element Value"),
         //                    new VariableDefinitionNumber ("From Index", null, {mMinValue: 0, mMaxValue: 0x7fffffff}),
         //            ],
         //            [
         //                    new VariableDefinitionNumber ("Last Index"),
         //            ]
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElement, array_package, "Set Array Element", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionObject ("Element Value"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElement, array_package, "Get Array Element", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionObject ("Element Value"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_Assign, array_package, "= (Array Assign)", "@#0 = $0", "@#0 = $0",
                     [
                              new VariableDefinitionArray ("Source"),
                     ],
                     [
                              new VariableDefinitionArray ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_ConditionAssign, array_package, "=? (Condition Assign)", "@#0 = ($0 is true) ? $1 : $2", "@#0 = ($0 is true) ? $1 : $2",
                     [
                              new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                              new VariableDefinitionArray ("True Source"),
                              new VariableDefinitionArray ("False Source"),
                     ],
                     [
                              new VariableDefinitionArray ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SwapValues, array_package, "Swap Array Values", "@$0 <-> $1", "SwapArrayValues",
                     [
                              new VariableDefinitionArray ("Array 1 (reference)", null),
                              new VariableDefinitionArray ("Array 2 (reference)", null),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_Equals, array_package, "Array == Array?", "@#0 = Array: ($0 == $1)", "@#0 = Array: ($0 == $1)",
                     [
                              new VariableDefinitionArray ("Array 1"),
                              new VariableDefinitionArray ("Array 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_ExactEquals, array_package, "Array === Array?", "@#0 = Array: ($0 === $1)", "@#0 = Array: ($0 === $1)",
                     [
                              new VariableDefinitionArray ("Array 1"),
                              new VariableDefinitionArray ("Array 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_Concat, array_package, "Array + Array", "@#0 = ($0 + $1)", "@#0 = ($0 + $1)",
                     [
                              new VariableDefinitionArray ("Array 1"),
                              new VariableDefinitionArray ("Array 2"),
                     ],
                     [
                              new VariableDefinitionArray ("Result Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_ToString, array_package, "Array -> String", "ArrayToString", "ArrayToString",
                     [
                              new VariableDefinitionArray ("Array"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_Create, array_package, "Create Array", null, null,
                     [
                              new VariableDefinitionNumber ("Initial Length"),
                              new VariableDefinitionObject ("Initial Element Value"),
                     ],
                     [
                              new VariableDefinitionArray ("Created Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_IsNull, array_package, "Is Null Array", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                     ],
                     [
                              new VariableDefinitionBoolean ("Is Null?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetLength, array_package, "Get Array Length", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                     ],
                     [
                              new VariableDefinitionNumber ("Array Length"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetLength, array_package, "Set Array Length", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Array Length"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SubArray, array_package, "Sub Array", null, null,
                     [
                              new VariableDefinitionArray ("The Input Array"),
                              new VariableDefinitionNumber ("Start Index"),
                              new VariableDefinitionNumber ("End Index"),
                     ],
                     [
                              new VariableDefinitionArray ("The Result Sub Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_RemoveElements, array_package, "Remove Array Elements", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("From Index"),
                              new VariableDefinitionNumber ("Number Of Elements To Remove"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_InsertElements, array_package, "Insert Array Elements", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("At Index"),
                              new VariableDefinitionNumber ("Number Of Elements To Insert"),
                              new VariableDefinitionObject ("Initial New Element Value"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SwapElements, array_package, "Swap Array Elements", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index 1"),
                              new VariableDefinitionNumber ("Element Index 2"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_Reverse, array_package, "Reverse Array", null, null,
                     [
                              new VariableDefinitionArray ("Array To Reverse"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithBoolean, array_element_package, "Set Element With Boolean", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionBoolean ("Element Value (Boolean)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsBoolean, array_element_package, "Get Element As Boolean", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionBoolean ("Element Value (Boolean)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithNumber, array_element_package, "Set Element With Number", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionNumber ("Element Value (Number)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsNumber, array_element_package, "Get Element As Number", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionNumber ("Element Value (Number)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithString, array_element_package, "Set Element With String", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionString ("Element Value (String)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsString, array_element_package, "Get Element As String", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionString ("Element Value (String)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithCCat, array_element_package, "Set Element With CCat", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionCollisionCategory ("Element Value (CCat)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsCCat, array_element_package, "Get Element As CCat", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionCollisionCategory ("Element Value (CCat)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithEntity, array_element_package, "Set Element With Entity", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionEntity ("Element Value (Entity)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsEntity, array_element_package, "Get Element As Entity", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionEntity ("Element Value (Entity)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithModule, array_element_package, "Set Element With Module", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionModule ("Element Value (Module)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsModule, array_element_package, "Get Element As Module", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionModule ("Element Value (Module)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithSound, array_element_package, "Set Element With Sound", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionSound ("Element Value (Sound)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsSound, array_element_package, "Get Element As Sound", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionSound ("Element Value (Sound)"),
                     ],
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_SetElementWithArray, array_element_package, "Set Element With Array", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                              new VariableDefinitionArray ("Element Value (Array)"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Array_GetElementAsArray, array_element_package, "Get Element As Array", null, null,
                     [
                              new VariableDefinitionArray ("The Array"),
                              new VariableDefinitionNumber ("Element Index"),
                     ],
                     [
                              new VariableDefinitionArray ("Element Value (Array)"),
                     ],
                     false
                  );

       // byte array
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArray_Create, bytearray_package, "Create Byte Array", null, null,
                     [
                              new VariableDefinitionNumber ("Initial Length"),
                     ],
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Created Byte Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArray_CreateFromBase64String, bytearray_package, "Create Byte Array From Base64 String", null, null,
                     [
                              new VariableDefinitionString ("Input Base64 String"),
                     ],
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Created Byte Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArray_ToBase64String, bytearray_package, "Byte Array To Base64 String", "ByteArray2Base64String", "ByteArray2Base64String",
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "The Byte Array"),
                     ],
                     [
                              new VariableDefinitionString ("Output Base64 String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArray_Compress, bytearray_package, "Compress Byte Array", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Input Byte Array"),
                     ],
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Compressed Byte Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArray_Uncompress, bytearray_package, "Uncompress Byte Array", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Input Byte Array"),
                     ],
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Uncompressed Byte Array"),
                     ]
                  );
         
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_Create, bytearray_package, "Create Byte Array Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "The Byte Array (can be null)"),
                     ],
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "Created Byte Array Stream"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_GetByteArray, bytearray_package, "Get Byte Array Of Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                     ],
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "The Byte Array"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_SetByteArray, bytearray_package, "Set Byte Array Of Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "New Byte Array"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_GetCursorPosition, bytearray_package, "Get Cursor Position Of Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                     ],
                     [
                              new VariableDefinitionNumber ("Cursor Position"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_SetCursorPosition, bytearray_package, "Set Cursor Position Of Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionNumber ("Cursor Position"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadByteArray, bytearray_package, "Read Byte Array From Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Byte Array To Fill"),
                              new VariableDefinitionNumber ("Offset To Fill"),
                              new VariableDefinitionNumber ("Number Of Bytes To Read (0 for all)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteByteArray, bytearray_package, "Write Byte Array Into Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Source Byte Array"),
                              new VariableDefinitionNumber ("Source Offset"),
                              new VariableDefinitionNumber ("Number Of Bytes To Write (0 for all)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadBoolean, bytearray_package, "Read Boolean From Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                     ],
                     [
                              new VariableDefinitionBoolean ("The Boolean Value"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteBoolean, bytearray_package, "Write Boolean Into Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionBoolean ("The Boolean Value"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadNumber, bytearray_package, "Read Number From Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionNumber ("Number Detail", null, {mValueLists:Lists.mNumberDetailList}),
                     ],
                     [
                              new VariableDefinitionNumber ("The Number Value"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteNumber, bytearray_package, "Write Number Into Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionNumber ("The Number Value"),
                              new VariableDefinitionNumber ("Number Detail", null, {mValueLists:Lists.mNumberDetailList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadUTF, bytearray_package, "Read String From Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                     ],
                     [
                              new VariableDefinitionString ("The String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteUTF, bytearray_package, "Write String Into Stream", null, null,
                     [
                              new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArrayStream, "The Byte Array Stream"),
                              new VariableDefinitionString ("The String"),
                     ],
                     null
                  );
         
       // math basic ops

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Assign, number_general_package, "= (Number Assign)", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionNumber ("Source"),
                     ],
                     [
                             new VariableDefinitionNumber ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ConditionAssign, number_general_package, "=? (Condition Assign)", "@#0 = ($0 is true) ? $1 : $2", "@#0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionNumber ("True Source"),
                             new VariableDefinitionNumber ("False Source"),
                     ],
                     [
                             new VariableDefinitionNumber ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_SwapValues, number_general_package, "Swap Number Values", "@$0 <-> $1", "SwapNumberValues",
                     [
                             new VariableDefinitionNumber ("Number 1 (reference)", null),
                             new VariableDefinitionNumber ("Number 2 (reference)", null),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Equals, number_general_package, "Number == Number?", "@#0 = Number: ($0 == $1)", "@#0 = Number: ($0 == $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_NotEqual, number_general_package, "Number != Number?", "@#0 = Number: ($0 != $1)", "@#0 = Number: ($0 != $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_LargerThan, number_general_package, "Number > Number?", "@#0 = ($0 > $1)", "@#0 = ($0 > $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_NotLessThan, number_general_package, "Number >= Number?", "@#0 = ($0 >= $1)", "@#0 = ($0 >= $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_SmallerThan, number_general_package, "Number < Number?", "@#0 = ($0 < $1)", "@#0 = ($0 < $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_NotMoreThan, number_general_package, "Number <= Number?", "@#0 = ($0 <= $1)", "@#0 = ($0 <= $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_IsNaN, number_general_package, "Is Not a Number?", null, "IsNaN",
                     [
                             new VariableDefinitionNumber ("The Number"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_IsInfinity, number_general_package, "Is Infinity Number?", null, "IsInfinity",
                     [
                             new VariableDefinitionNumber ("The Number"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Negative, number_general_package, "- x (Negative)", "@#0 = (- $0)", "@#0 = (- $0)",
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Inverse, number_general_package, "1.0 / x (Inverse)", "@#0 = (1.0 / $0)", "@#0 = (1.0 / $0)",
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Add, number_general_package, "x + y", "@#0 = $0 + $1", "@#0 = $0 + $1",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Subtract, number_general_package, "x - y", "@#0 = $0 - $1", "@#0 = $0 - $1",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Multiply, number_general_package, "x * y (Multiply)", "@#0 = $0 * $1", "@#0 = $0 * $1",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Divide, number_general_package, "x / y (Divide)", "@#0 = $0 / $1", "@#0 = $0 / $1",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Modulo, number_general_package, "x % y (Modulo)", "@#0 = $0 % $1", "@#0 = $0 % $1",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );

      // math / toString

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ToString, convert_package, "Number -> String", "@$0 -> #0", "NumberToString",
                     [
                             new VariableDefinitionNumber ("The Number"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ToExponential, convert_package, "Number -> Exponential String", null, null,
         //            [
         //                    new VariableDefinitionNumber ("The Number"),
         //                    new VariableDefinitionNumber ("Number of Fraction Digits"),
         //            ],
         //            [
         //                    new VariableDefinitionString ("Result"),
         //            ]
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ToFixed, convert_package, "Number -> To Fixed String", null, null,
                     [
                             new VariableDefinitionNumber ("The Number"),
                             new VariableDefinitionNumber ("Number of Fraction Digits"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ToPrecision, convert_package, "Number -> To Precision String", null, null,
                     [
                             new VariableDefinitionNumber ("The Number"),
                             new VariableDefinitionNumber ("Number of Precision Digits"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ToStringByRadix, convert_package, "Number -> String (By Radix)", "@$0 -> #0 by radix $1", "ToStringByRadix",
                     [
                             new VariableDefinitionNumber ("The Number"),
                             new VariableDefinitionNumber ("The Radix"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ParseFloat, convert_package, "Number <- String", "@$0 <- #0", "StringToNumber",
                     [
                             new VariableDefinitionString ("String"),
                     ],
                     [
                             new VariableDefinitionNumber ("The Number"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ParseInteger, convert_package, "Integer <- String", "@$0 <- #0 by radix $1", "StringToInteger",
                     [
                             new VariableDefinitionString ("String"),
                             new VariableDefinitionNumber ("The Radix ([2, 36])"),
                     ],
                     [
                             new VariableDefinitionNumber ("The Integer"),
                     ]
                  );

      // math / bitwise

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft, bitwise_package, "<< (ShiftLeft)", "@#0 = ($0 << $1)", "@#0 = ($0 << $1)",
                     [
                             new VariableDefinitionNumber ("Number to Shift"),
                             new VariableDefinitionNumber ("Shift Bits Count"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight, bitwise_package, ">> (ShiftRight)", "@#0 = ($0 >> $1)", "@#0 = ($0 >> $1)",
                     [
                             new VariableDefinitionNumber ("Number to Shift"),
                             new VariableDefinitionNumber ("Shift Bits Count"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned, bitwise_package, ">>> (ShiftRightUnsignedly)", "@#0 = ($0 >>> $1)", "@#0 = ($0 >>> $1)",
                     [
                             new VariableDefinitionNumber ("Number to Shift"),
                             new VariableDefinitionNumber ("Shift Bits Count"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_And, bitwise_package, "x & y (Bitwise And)", "@#0 = ($0 & $1)", "@#0 = ($0 & $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Or, bitwise_package, "x | y (Bitwise Or)", "@#0 = ($0 | $1)", "@#0 = ($0 | $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Not, bitwise_package, "~ x (Bitwise Not)", "@#0 = (~ $0)", "@#0 = (~ $0)",
                     [
                             new VariableDefinitionNumber ("Inout Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Xor, bitwise_package, "x ^ y (Bitwise Xor)", "@#0 = ($0 ^ $1)", "@#0 = ($0 ^ $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );

      // math / number trinomogetry

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_SinRadians, trigonometry_package, "Sin", "@#0 = Sin (Radians ($0))", "@#0 = Sin (Radians ($0))",
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ],
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_CosRadians, trigonometry_package, "Cos", "@#0 = Cos (Radians ($0))", "@#0 = Cos (Radians ($0))",
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ],
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_TanRadians, trigonometry_package, "Tan", "@#0 = Tan (Radians ($0))", "@#0 = Tan (Radians ($0))",
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ],
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ArcSinRadians, trigonometry_package, "ArcSin_Radians", "@Radians (#0) = ArcSin ($0)", "@Radians (#0) = ArcSin ($0)",
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"),
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ArcCosRadians, trigonometry_package, "ArcCos_Radians", "@Radians (#0) = ArcCos ($0)", "@Radians (#0) = ArcCos ($0)",
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"),
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ArcTanRadians, trigonometry_package, "ArcTan_Radians", "@Radians (#0) = ArcTan ($0)", "@Radians (#0) = ArcTan ($0)",
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"),
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_ArcTan2Radians, trigonometry_package, "ArcTan2_Radians", "@Radians (#0) = ArcTan2 ($0, $1)", "@Radians (#0) = ArcTan2 ($0, $1)",
                     [
                             new VariableDefinitionNumber ("y"),
                             new VariableDefinitionNumber ("x"),
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ]
                  );

      // math / random

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Random, random_package, "Fast Float Random", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Random Number [0.0, 1.0)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RandomRange, random_package, "Fast Float Random Between", null, null,
                     [
                             new VariableDefinitionNumber ("Min Number"),
                             new VariableDefinitionNumber ("Max Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Random Number"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RandomIntRange, random_package, "Fast Integer Random Between", null, null,
                     [
                             new VariableDefinitionNumber ("Min Integer Number"),
                             new VariableDefinitionNumber ("Max Integer Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Random Ingeter Number"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RngCreate, random_package, "Create Random Generator", null, null,
                     [
                             new VariableDefinitionNumber ("Random Generator Slot", null, {mValueLists: Lists.mRngIdList}),
                             new VariableDefinitionNumber ("Random Generator Method", null, {mValueLists: Lists.mRngMethodList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RngSetSeed, random_package, "Set Random Generator Seed", null, null,
                     [
                             new VariableDefinitionNumber ("Random Generator Slot", null, {mValueLists: Lists.mRngIdList}),
                             new VariableDefinitionNumber ("Seed ID"),
                             new VariableDefinitionNumber ("The Seed"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RngRandom, random_package, "Next Float Random", null, null,
                     [
                             new VariableDefinitionNumber ("Random Generator Slot", null, {mValueLists: Lists.mRngIdList}),
                     ],
                     [
                             new VariableDefinitionNumber ("Random Number [0.1, 1.0)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RngRandomRange, random_package, "Next Float Random Between", null, null,
                     [
                             new VariableDefinitionNumber ("Random Generator Slot", null, {mValueLists: Lists.mRngIdList}),
                             new VariableDefinitionNumber ("Min Number"),
                             new VariableDefinitionNumber ("Max Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Random Number"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RngRandomIntRange, random_package, "Next Integer Random Between", null, null,
                     [
                             new VariableDefinitionNumber ("Random Generator Slot", null, {mValueLists: Lists.mRngIdList}),
                             new VariableDefinitionNumber ("Min Integer Number"),
                             new VariableDefinitionNumber ("Max Integer Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Random Ingeter Number"),
                     ]
                  );

       // math / number convert

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Degrees2Radians, convert_package, "Degrees -> Radians", "@Degrees ($0) -> Radians (#0)", "DegreesToRadians",
                     [
                             new VariableDefinitionNumber ("Degrees"),
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Radians2Degrees, convert_package, "Radians -> Degrees", "@Radians ($0) -> Degrees (#0)", "RadiansToDegrees",
                     [
                             new VariableDefinitionNumber ("Radians"),
                     ],
                     [
                             new VariableDefinitionNumber ("Degrees"),
                     ]
                  );
          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Number2RGB, convert_package, "Color -> RGB", "@Color ($0) -> RGB (#0, #1, #2)", "Color2Rgb",
                     [
                             new VariableDefinitionNumber ("Number", null, {mIsColorValue: true}),
                     ],
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_RGB2Number, convert_package, "RGB -> Color", "@RGB ($0, $1, $2) -> Color (#0)", "RgbToColor",
                     [
                             new VariableDefinitionNumber ("Red (0-255)"),
                             new VariableDefinitionNumber ("Green (0-255)"),
                             new VariableDefinitionNumber ("Blue (0-255)"),
                     ],
                     [
                             new VariableDefinitionNumber ("Number", null, {mIsColorValue: true}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds, convert_package, "Milliseconds -> Minutes : Seconds", "@Milliseconds ($0) -> Minutes (#0) : Seconds (#1) : Milliseconds (#2)", "MillisecondsToMinutesAndSeconds",
                     [
                             new VariableDefinitionNumber ("Milliseconds", null, {mMinValue: 0.0}),
                     ],
                     [
                             new VariableDefinitionNumber ("Minitues"),
                             new VariableDefinitionNumber ("Seconds"),
                             new VariableDefinitionNumber ("Milliseconds"),
                     ]
                  );

     // math / usual

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Abs, usual_number_package, "Abs", "Abs", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Max, usual_number_package, "Max", "Max", null,
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Min, usual_number_package, "Min", "Min", null,
                     [
                             new VariableDefinitionNumber ("Number 1"),
                             new VariableDefinitionNumber ("Number 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Sqrt, usual_number_package, "Sqrt", "Sqrt", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Ceil, usual_number_package, "Ceil", "Ceil", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Floor, usual_number_package, "Floor", "Floor", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Round, usual_number_package, "Round", "Round", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Log, usual_number_package, "Log", "Log", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Exp, usual_number_package, "Exp", "Exp", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Power, usual_number_package, "Power", "Power", null,
                     [
                             new VariableDefinitionNumber ("Number"),
                             new VariableDefinitionNumber ("Power"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );

      // math / more
                  
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Number_Clamp, more_number_package, "Clamp", "@Clamp $0 Between $1 and $2", null,
                     [
                             new VariableDefinitionNumber ("Number to Clamp"),
                             new VariableDefinitionNumber ("Value Boundary 1"),
                             new VariableDefinitionNumber ("Value Boundary 2"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation, more_number_package, "Linear Interpolation", null, null,
                     [
                             new VariableDefinitionNumber ("Number x1"),
                             new VariableDefinitionNumber ("Number x2"),
                             new VariableDefinitionNumber ("Factor t"),
                     ],
                     [
                             new VariableDefinitionNumber ("Result (x1 * t + (1.0 - t) * x2)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor, more_number_package, "Color Linear Interpolation", null, null,
                     [
                             new VariableDefinitionNumber ("Color c1", null, {mIsColorValue: true}),
                             new VariableDefinitionNumber ("Color c2", null, {mIsColorValue: true}),
                             new VariableDefinitionNumber ("Factor t (0-1)", null, {mMinValue: 0.0, mMaxValue:1.0}),
                     ],
                     [
                             new VariableDefinitionNumber ("Result (c1 * t + (1.0 - t) * c2)", null, {mIsColorValue: true}),
                     ]
                  );
                  
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.Id_Math_XxPlusYy, more_number_package, "AxA + BxB", "@#0 = $0 * $0 + $1 * $1", "@#0 = $0 * $0 + $1 * $1",
         //            [
         //                    new VariableDefinitionNumber ("A"),
         //                    new VariableDefinitionNumber ("B"),
         //            ],
         //            [
         //                    new VariableDefinitionNumber ("AxA + BxB"),
         //            ]
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.Id_Math_XxMinusYy, more_number_package, "AxA - BxB", "@#0 = $0 * $0 - $1 * $1", "@#0 = $0 * $0 - $1 * $1",
         //            [
         //                    new VariableDefinitionNumber ("A"),
         //                    new VariableDefinitionNumber ("B"),
         //            ],
         //            [
         //                    new VariableDefinitionNumber ("AxA - BxB"),
         //            ]
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.Id_Math_GetPointDistance, more_number_package, "Get Point Distance", null, null,
                     [
                             new VariableDefinitionNumber ("Point 1 X"),
                             new VariableDefinitionNumber ("Point 1 Y"),
                             new VariableDefinitionNumber ("Point 2 X"),
                             new VariableDefinitionNumber ("Point 2 Y"),
                     ],
                     [
                             new VariableDefinitionNumber ("Distance"),
                     ]
                  );

      // game / design
                  
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_WriteSaveData, world_io_package, "Write Save Data", null, null,
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_LoadSaveData, world_io_package, "Load Save Data", null, null,
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_ResetSaveData, world_io_package, "Reset Save Data", null, null,
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_DeleteSaveData, world_io_package, "Delete Save Data", null, null,
                     null,
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_LoadLevel, world_scene_package, "Load Scene", null, null,
                     [
                        new VariableDefinitionScene ("Scene To Load"),
                        new VariableDefinitionNumber ("Scene Switching Style", null, {mValueLists: Lists.mSceneSwitchingStyleList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelByIdOffset, world_scene_package, "Get Scene By Index Offset", null, null,
                     [
                        new VariableDefinitionNumber ("Index Offset"),
                        new VariableDefinitionScene ("Relative-To Scene (null means current)"),
                     ],
                     [
                        new VariableDefinitionScene ("Result Scene"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelId, world_scene_package, "Get Scene Index", null, null,
                     [
                        new VariableDefinitionScene ("The Scene"),
                     ],
                     [
                        new VariableDefinitionNumber ("Scene Index"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelByKey, world_scene_package, "Get Scene By Key", null, null,
                     [
                        new VariableDefinitionString ("Scene Key"),
                     ],
                     [
                        new VariableDefinitionScene ("Result Scene"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelKey, world_scene_package, "Get Scene Key", null, null,
                     [
                        new VariableDefinitionScene ("The Scene"),
                     ],
                     [
                        new VariableDefinitionString ("Scene Key"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetCurrentLevel, world_scene_package, "Get Curent Scene", null, null,
                     null,
                     [
                        new VariableDefinitionScene ("Current Scene"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_IsNullLevel, world_scene_package, "Is Null Scene?", null, null,
                     [
                        new VariableDefinitionScene ("The Scene"),
                     ],
                     [
                        new VariableDefinitionBoolean ("Null Level?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SceneEquals, world_scene_package, "Scene == Scene?", "@#0 = Scene: ($0 == $1)", "@#0 = Scene: ($0 == $1)",
                     [
                        new VariableDefinitionScene ("Scene 1"),
                        new VariableDefinitionScene ("Scene 2"),
                     ],
                     [
                        new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_Scene2String, world_scene_package, "Scene -> String", "@$0 -> #0", "SceneToString",
                     [
                        new VariableDefinitionScene ("The Scene"),
                     ],
                     [
                        new VariableDefinitionString ("Result"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_MergeLevel, world_level_package, "Merge Scene Into Current Level", null, null,
                     [
                        new VariableDefinitionScene ("Scene To Merge"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_RestartLevel, world_level_package, "Restart Level", null, null,
                     [
                        new VariableDefinitionNumber ("Scene Switching Style", null, {mValueLists: Lists.mSceneSwitchingStyleList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelPaused, world_level_package, "Is Level Paused?", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Paused (false for playing)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelPaused, world_level_package, "Set Level Paused", null, null,
                     [
                        new VariableDefinitionBoolean ("Paused (false for playing)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetPlaySpeedX, world_level_package, "Get Play SpeedX", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Speed X"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetPlaySpeedX, world_level_package, "Set Play SpeedX", null, null,
                     [
                        new VariableDefinitionNumber ("Speed X ([0-9])", null, {mMinValue: 0, mMaxValue: 9}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetWorldScale, world_level_package, "Get World Scale", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("World Scale"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetWorldScale, world_level_package, "Set World Scale", null, null,
                     [
                        new VariableDefinitionNumber ("World Scale ([0.0625-16.0])", null, {mMinValue: 0.0625, mMaxValue: 16.0}),
                        new VariableDefinitionBoolean ("Changed Smoothly?"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds, world_level_package, "Get Level Running Milliseconds", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Running Milliseconds"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps, world_level_package, "Get Level Simulation Steps", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Simulation Steps"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetMousePosition, world_level_package, "Get Mouse Position", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Mouse X"),
                        new VariableDefinitionNumber ("Mouse Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_GetNumEntitiesPlacedInEditor, world_level_package, "Get Number Of Entities Placed In Editor", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Number Of Entities"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus, world_level_package, "Set Level Status", null, null,
                     [
                        new VariableDefinitionNumber ("Status", null, {mValueLists: Lists.mLevelStatusList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed, world_level_package, "Is Level Succeeded?", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Finshied?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed, world_level_package, "Is Level Failed", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Failed?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished, world_level_package, "Is Level Unfinished", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Unfinished?"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelBooleanProperty, world_level_package, "Set Level Boolean Property", null, null,
                     [
                        new VariableDefinitionNumber ("Property", null, {mValueLists: Lists.mLevelBooleanPropertyList}),
                        new VariableDefinitionBoolean ("Property Value"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelNumberProperty, world_level_package, "Set Level Number Property", null, null,
                     [
                        new VariableDefinitionNumber ("Property", null, {mValueLists: Lists.mLevelNumberPropertyList}),
                        new VariableDefinitionNumber ("Property Value"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelStringProperty, world_level_package, "Set Level String Property", null, null,
                     [
                        new VariableDefinitionNumber ("Property", null, {mValueLists: Lists.mLevelStringPropertyList}),
                        new VariableDefinitionString ("Property Value"),
                     ],
                     null
                  );

      // game / world / appearance
                  
          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_GetFilledColor, world_appearance_package, "Get Level Background Color", "@Color (#0) = Get Level Background Color ()", null,
                     null,
                     [
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_SetFilledColor, world_appearance_package, "Set Level Background Color", "@Set Level Background Color (Color ($0))", null,
                     [
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_GetFilledColorRGB, world_appearance_package, "Get Level Background Color RGB", "@RGB (#0, #1, #2) = Get Level Background Color ()", null,
                     null,
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_SetFilledColorRGB, world_appearance_package, "Set Level Background Color RGB", "@Set Level Background Color (RGB ($0, $1, $2))", null,
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_GetBorderColor, world_appearance_package, "Get Level Border Color", "@Color (#0) = Get Level Border Color ()", null,
                     null,
                     [
                             new VariableDefinitionNumber ("Border Color", null, {mIsColorValue: true}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_SetBorderColor, world_appearance_package, "Set Level Border Color", "@Set Level Border Color (Color ($0))", null,
                     [
                             new VariableDefinitionNumber ("Border Color", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_GetBorderColorRGB, world_appearance_package, "Get Level Border Color RGB", "@RGB (#0, #1, #2) = Get Level Border Color ()", null,
                     null,
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Level_SetBorderColorRGB, world_appearance_package, "Set Level Border Color RGB", "@Set Level Border Color (RGB ($0, $1, $2))", null,
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetAppWindowPadding, world_appearance_package, "Get App Window Padding In Device Pixels", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Left Pdding"),
                             new VariableDefinitionNumber ("Top Pdding"),
                             new VariableDefinitionNumber ("Right Pdding"),
                             new VariableDefinitionNumber ("Bottom Pdding"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetAppWindowPadding, world_appearance_package, "Set App Window Padding In Device Pixels", null, null,
                     [
                             new VariableDefinitionNumber ("Left Pdding"),
                             new VariableDefinitionNumber ("Top Pdding"),
                             new VariableDefinitionNumber ("Right Pdding"),
                             new VariableDefinitionNumber ("Bottom Pdding"),
                     ],
                     null                     
                  );

      // game / world / physics

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_IsPhysicsEngineEnabled, world_physics_package, "Is Physics Engine Enabled?", null, null,
                     null,
                     [
                             new VariableDefinitionBoolean ("Enabled?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetPhysicsEngineEnabled, world_physics_package, "Set Physics Engine Enabled", null, null,
                     [
                             new VariableDefinitionBoolean ("Enabled?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetRealtimeFPS, world_physics_package, "Get Realtime FPS", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Current FPS"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetPreferredFpsAndStepTimeLangth, world_physics_package, "Get Preferred Fps And Step Time Langth", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Prefered FPS"),
                             new VariableDefinitionNumber ("Step Time Length"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetPreferredFpsAndStepTimeLangth, world_physics_package, "Set Preferred Fps And Step Time Langth", null, null,
                     [
                             new VariableDefinitionNumber ("Prefered FPS"),
                             new VariableDefinitionNumber ("Step Time Length"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians, world_physics_package, "Set Gravity Acceleration By Radians", "@SetGravityAcceleration ($0, Radians($1))", null,
                     [
                             new VariableDefinitionNumber ("Magnitude"),
                             new VariableDefinitionNumber ("Angle Radians"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees, world_physics_package, "Set Gravity Acceleration By Degrees", "@SetGravityAcceleration ($0, Degrees($1))", null,
                     [
                             new VariableDefinitionNumber ("Magnitude"),
                             new VariableDefinitionNumber ("Angle Degrees"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector, world_physics_package, "Set Gravity Acceleration By Vector", "@SetGravityAcceleration (Vector($0, $1))", null,
                     [
                             new VariableDefinitionNumber ("gX"),
                             new VariableDefinitionNumber ("gY"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetGravityAcceleration_Vector, world_physics_package, "Get Gravity Acceleration By Vector", "@GetGravityAcceleration (Vector($0, $1))", null,
                     null,
                     [
                             new VariableDefinitionNumber ("gX"),
                             new VariableDefinitionNumber ("gY"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_UpdateShapeContactStatusInfos, world_physics_package, "Update Shape Contact Status Infos", null, null,
                     null,
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetPhysicsOnesAtPoint, world_physics_package, "Get Physics Shapes At Point", null, null,
                     [
                             new VariableDefinitionNumber ("Point X"),
                             new VariableDefinitionNumber ("Point Y"),
                     ],
                     [
                             new VariableDefinitionArray ("Physics Shapes"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetFirstIncomingIntersectionWithLineSegment, world_physics_package, "Get First Incoming Intersection With Line Segment", null, null,
                     [
                             new VariableDefinitionNumber ("Start Point X"),
                             new VariableDefinitionNumber ("Start Point Y"),
                             new VariableDefinitionNumber ("End Point X"),
                             new VariableDefinitionNumber ("End Point Y"),
                     ],
                     [
                             new VariableDefinitionArray ("First Incoming Intersection"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetFirstOutcomingIntersectionWithLineSegment, world_physics_package, "Get First Outcoming Intersection With Line Segment", null, null,
                     [
                             new VariableDefinitionNumber ("Start Point X"),
                             new VariableDefinitionNumber ("Start Point Y"),
                             new VariableDefinitionNumber ("End Point X"),
                             new VariableDefinitionNumber ("End Point Y"),
                     ],
                     [
                             new VariableDefinitionArray ("First Outcoming Intersection"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetIntersectedShapesWithLineSegment, world_physics_package, "Get Intersected Shapes With Line Segment", null, null,
                     [
                             new VariableDefinitionNumber ("Start Point X"),
                             new VariableDefinitionNumber ("Start Point Y"),
                             new VariableDefinitionNumber ("End Point X"),
                             new VariableDefinitionNumber ("End Point Y"),
                             new VariableDefinitionBoolean ("Including Half Intersecteds?"),
                     ],
                     [
                             new VariableDefinitionArray ("Intersected Shapes"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetIntersectionSegmentsWithLineSegment, world_physics_package, "Get Intersection Segments With Line Segment", null, null,
         //            [
         //                    new VariableDefinitionNumber ("Start Point X"),
         //                    new VariableDefinitionNumber ("Start Point Y"),
         //                    new VariableDefinitionNumber ("End Point X"),
         //                    new VariableDefinitionNumber ("End Point Y"),
         //            ],
         //            [
         //                    new VariableDefinitionArray ("First Outcoming Intersection"),
         //            ]
         //         );

         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetCoordinateSytemSettings, world_camera_package, "Get Coordinate Sytem Settings", null, null,
         //            null,
         //            [
         //                    new VariableDefinitionBoolean ("Is Right Hand?"),
         //                    new VariableDefinitionNumber ("Origin X (pixels)"),
         //                    new VariableDefinitionNumber ("Origin Y (Pixels)"),
         //                    new VariableDefinitionNumber ("Scale (pixels/meter)"),
         //            ]
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetCameraCenter, world_camera_package, "Get Camera Center In World Meters", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Camera Center X (meters)"),
                             new VariableDefinitionNumber ("Camera Center Y (meters)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetViewportSize, world_camera_package, "Get Viewport Size In World Unscaled Pixels", "@(#0, #1) = Get Size of Viewport", "GetViewportSizeInWorldUnscaledPixels",
                     null,
                     [
                             new VariableDefinitionNumber ("Width"),
                             new VariableDefinitionNumber ("Height"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetViewportBoundsInDevicePixels, world_camera_package, "Get Viewport Bounds In Device Pixels", null, null,
         //            null,
         //            [
         //                    new VariableDefinitionNumber ("Left"),
         //                    new VariableDefinitionNumber ("Top"),
         //                    new VariableDefinitionNumber ("Width"),
         //                    new VariableDefinitionNumber ("Height"),
         //            ]
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetViewportStretchScale, world_camera_package, "Get Viewport Stretch Scale", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Viewport Scale X"),
                             new VariableDefinitionNumber ("Viewport Scale Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetCurrentCamera, world_camera_package, "Set Current Camera", null, null,
                     [
                             new VariableDefinitionEntity ("The New Camera Entity", null, {mValidClasses: Filters.sCameraEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetCameraRotationByDegrees, world_camera_package, "Get Camera Rotation By Degrees", "@Degrees (#0) = Get Camera Rotation ()", null,
                     null,
                     [
                             new VariableDefinitionNumber ("Camera Rotation (degrees)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape, world_camera_package, "Follow Camera With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"),
                             new VariableDefinitionBoolean ("Smooth Following?"),
                             //new VariableDefinitionBoolean ("Follow Rotation?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape, world_camera_package, "Follow Camera Center X With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"),
                             new VariableDefinitionBoolean ("Smooth Following?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape, world_camera_package, "Follow Camera Center Y With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"),
                             new VariableDefinitionBoolean ("Smooth Following?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape, world_camera_package, "Follow Camera Rotation With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"),
                             new VariableDefinitionBoolean ("Smooth Following?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn, world_camera_package, "Fade Out Then Fade In", null, null,
                     [
                             new VariableDefinitionNumber ("Fade Color", null, {mIsColorValue: true}),
                             new VariableDefinitionNumber ("Fade Out Steps", null, {mMinValue: 0}),
                             new VariableDefinitionNumber ("Fade Staying Steps", null, {mMinValue: 1}),
                             new VariableDefinitionNumber ("Fade In Steps", null, {mMinValue: 0}),
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_CallScript, world_script_package, "Call Script", null, null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallScript, world_script_package, "Condition Call Script", "@If $0 is true, call $1, otherwise, call $2", null,
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script 1 to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}),
                             new VariableDefinitionEntity ("Script 2 to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes, world_script_package, "Call Script Multi Times", "@Call Script ($0) $1 Times", null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}),
                             new VariableDefinitionNumber ("Calling Times", null, {mMinValue: 0}),  // dengerous
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunction, world_script_package, "Call Boolean Function", null, null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Boolean Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction, world_script_package, "Condition Call Boolean Function", "@#0 = If $0 is true, call $1, otherwise, call $2", null,
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script 1 to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}),
                             new VariableDefinitionEntity ("Script 2 to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Bool Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes, world_script_package, "Call Bool Function Multi Times", "@Call Bool Function ($0) Multi Times", null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}),
                     ],
                     null
                  );

     // game / world / create ...

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_CreateExplosion, world_create_entity_package, "Create Explosion", null, null,
                     [
                              new VariableDefinitionNumber ("Explosion X"),
                              new VariableDefinitionNumber ("Explosion Y"),
                              new VariableDefinitionNumber ("Number of Particles (4-100)", null, {mMinValue: Define.MinNumParticls_CreateExplosion, mMaxValue: Define.MaxNumParticls_CreateExplosion}),
                              new VariableDefinitionNumber ("Life (steps)", null, {mMinValue:0}),
                              new VariableDefinitionNumber ("Particle Density", null, {mMinValue: 0.0}),
                              new VariableDefinitionNumber ("Particle Restitution", null, {mMinValue: 0.0, mMaxValue:1.0}),
                              new VariableDefinitionNumber ("Particle Speed", null, {mMinValue: 0.0}),
                              new VariableDefinitionNumber ("Particle Color", null, {mIsColorValue: true}),
                              new VariableDefinitionBoolean ("Are Particle Visible?"),
                              new VariableDefinitionCollisionCategory ("Particle Collision Category"),
                     ],
                     [
                              new VariableDefinitionNumber ("Number of Created Particles"),
                     ]
                  );

     // game / world / sound

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_PlaySound, world_sound_package, "Play Sound", null, null,
                     [
                              new VariableDefinitionSound ("Sound"),
                              new VariableDefinitionNumber ("Play Times", null, {mMinValue:0}),
                              new VariableDefinitionBoolean ("Crossing Levels?"),
                              /*new VariableDefinitionNumber ("Volume [0, 1])", null, {mMinValue: 0.0, mMaxValue:1.0}),*/ // to add
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_StopSounds_InLevel, world_sound_package, "Stop All In-Level Sounds", null, null,
                     null,
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_StopSound_CrossLevels, world_sound_package, "Stop Crosssing-Levels Sound", null, null,
                     [
                              new VariableDefinitionSound ("Sound (null for all)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_IsSoundEnabled, world_sound_package, "Is Sound Enabled?", null, null,
                     null,
                     [
                              new VariableDefinitionBoolean ("Enabled?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetSoundEnabled, world_sound_package, "Set Sound Enabled", null, null,
                     [
                              new VariableDefinitionBoolean ("Enable?"),
                     ],
                     null
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_GetGlobalSoundVolume, world_sound_package, "Get Global Sound Volume", null, null,
         //            null,
         //            [
         //                     new VariableDefinitionNumber ("Global Sound Volume [0, 1])", null, {mMinValue: 0.0, mMaxValue:1.0}),
         //            ]
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_World_SetGlobalSoundVolume, world_sound_package, "Set Sounds Enabled", null, null,
         //            [
         //                     new VariableDefinitionNumber ("Global Sound Volume [0, 1])", null, {mMinValue: 0.0, mMaxValue:1.0}),
         //            ],
         //            null
         //         );

     // game / world / module

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Module_Assign, world_module_package, "= (Assign Module)", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionModule ("Source Module"),
                     ],
                     [
                             new VariableDefinitionModule ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Module_Equals, world_module_package, "Module == Module?",  "@#0 = Module: ($0 == $1)", "@#0 = Module: ($0 == $1)",
                     [
                             new VariableDefinitionModule ("Module 1"),
                             new VariableDefinitionModule ("Module 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );

     // game / collision category

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_Assign, ccat_package, "= (Assign CCat)", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionCollisionCategory ("Source Collision Category"),
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign, ccat_package, "?= (Condition Assign CCat)", "@#0 = ($0 is true) ? $1 : $2", "@#0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionCollisionCategory ("Collision Category 1"),
                             new VariableDefinitionCollisionCategory ("Collision Category 2"),
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_SwapValues, ccat_package, "Swap Values", "@$0 <-> $1", "SwapCCatValues",
                     [
                             new VariableDefinitionCollisionCategory ("CCat 1 (reference)", null),
                             new VariableDefinitionCollisionCategory ("CCat 2 (reference)", null),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_IsNull, ccat_package, "Is Null?", "@#0 = CCat($0) is Null?", "IsNullCCat",
                     [
                             new VariableDefinitionCollisionCategory ("The CCat"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Null"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_ToString, ccat_package, "CCat -> String", "@$0 -> #0", "CCatToString",
                     [
                             new VariableDefinitionCollisionCategory ("The CCat"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_Equals, ccat_package, "CCat == CCat?",  "@#0 = CCat: ($0 == $1)", "@#0 = CCat: ($0 == $1)",
                     [
                             new VariableDefinitionCollisionCategory ("CCat 1"),
                             new VariableDefinitionCollisionCategory ("CCat 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally, ccat_package, "Set Collision Category Collide Internally", "@Set Collision Category ($0) Collide Internally ($1)", null,
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category"),
                             new VariableDefinitionBoolean ("Collide Internally?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends, ccat_package, "Set Collision Categories As Friends Or Not", "@Set Collision Categories ($0, $1) As Friends ($2)", null,
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category 1"),
                             new VariableDefinitionCollisionCategory ("Collision Category 2"),
                             new VariableDefinitionBoolean ("Friends?"),
                     ],
                     null
                  );
                  
     // game / entity

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_Assign, entity_general_package, "= (Assign Entity)", "@#0 = $0", "@#0 = $0",
                     [
                             new VariableDefinitionEntity ("Source Entity"),
                     ],
                     [
                             new VariableDefinitionEntity ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign, entity_general_package, "?= (Condition Assign Entity)", "@#0 = ($0 is true) ? $1 : $2", "@#0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result", null, {mAllowVariablesOfOtherClasses: true}),
                             new VariableDefinitionEntity ("Source Entity 1"),
                             new VariableDefinitionEntity ("Source Entity 2"),
                     ],
                     [
                             new VariableDefinitionEntity ("Target"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_SwapValues, entity_general_package, "Swap Values", "@$0 <-> $1", "SwapEntityValues",
                     [
                             new VariableDefinitionEntity ("Entity 1 (reference)", null),
                             new VariableDefinitionEntity ("Entity 2 (reference)", null),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsNull, entity_general_package, "Is Null?", "@#0 = Entity($0) is Null?", "IsNullEntity",
                     [
                             new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Null?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetEntityId, entity_common_package, "Get Entity Id", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                             new VariableDefinitionNumber ("Entity Id"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetEntityByIdOffset, entity_common_package, "Get Another Entity By Id Offset", null, null,
                     [
                             new VariableDefinitionEntity ("Base Entity"),
                             new VariableDefinitionNumber ("Id Offset"),
                             new VariableDefinitionBoolean ("Suppurt Runtime-Created Entity?"),
                     ],
                     [
                             new VariableDefinitionEntity ("Another Entity"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_ToString, entity_general_package, "Entity -> String", "@$0 -> #0", "EntityToString",
                     [
                             new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                             new VariableDefinitionString ("Result"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_Equals, entity_general_package, "Entity == Entity?",  "@#0 = Entity: ($0 == $1)", "@#0 = Entity: ($0 == $1)",
                     [
                             new VariableDefinitionEntity ("Entity 1"),
                             new VariableDefinitionEntity ("Entity 2"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,  entity_as_task_package, "Set Entity Task Status", "@Set Entity ($0) Task Status ($1)", null,
                     [
                        new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}),
                        new VariableDefinitionNumber ("Task Status", null, {mValueLists: Lists.mEntityTaskStatusList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed, entity_as_task_package, "Is Entity Task Failed?", "@#0 = Is Entity ($0) Task Failed?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Failed?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed, entity_as_task_package, "Is Entity Task Succeeded", "@#0 = Is Entity ($0) Task Successed?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Succeeded?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished, entity_as_task_package, "Is Entity Task Unfinished", "@#0 = Is Entity ($0) Task Unfinished?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Unfinished?"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity, entity_is_subtype_package, "Is Shape Component?", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Shape?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsJointEntity, entity_is_subtype_package, "Is Joint Component?", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Joint?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTriggerEntity, entity_is_subtype_package, "Is Trigger Component?", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Trigger Component?"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsVisible, entity_common_package, "Is Visible", "@#0 = Is $0 Visible?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Visible?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_SetVisible, entity_common_package, "Set Visible", "@Set Visibility ($1) of $0", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                             new VariableDefinitionBoolean ("Visible?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetAlpha, entity_common_package, "Get Alpha", "@#0 = Get Alpha of $0", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Alpha"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_SetAlpha, entity_common_package, "Set Alpha", "@Set Alpha ($1) of $0", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                             new VariableDefinitionNumber ("Alpha (0-1)", null, {mMinValue: 0.0, mMaxValue:1.0}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_AdjustAppearanceOrder, entity_common_package, "Adjust Appearance Order", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                             new VariableDefinitionBoolean ("To Top / To Bottom (true/false)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_AdjustAppearanceOrderRelativeTo, entity_common_package, "Adjust Appearance Order Relative To", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                             new VariableDefinitionEntity ("Relative-To Entity", null, {mValidClasses: Filters.sVisualEntityClasses}),
                             new VariableDefinitionBoolean ("Front Of / Behind Of (true/false)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsEnabled, entity_common_package, "Is Entity Enabled",  "@#0 = Is Entity ($0) Enabled?", null,
                     [
                             new VariableDefinitionEntity ("The Event Handler", null, {mValidClasses: Filters.sCanBeDisabledEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Enabled?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_SetEnabled, entity_common_package, "Set Entity Enabled", "@Set Entity ($0) Enabled ($1)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sCanBeDisabledEntityClasses}),
                             new VariableDefinitionBoolean ("Enabled?"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetPosition, entity_common_package, "Get Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("x"),
                             new VariableDefinitionNumber ("y"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_SetPosition, entity_common_package, "Set Position", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}),
         //                    new VariableDefinitionNumber ("x"),
         //                    new VariableDefinitionNumber ("y"),
         //            ],
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians, entity_common_package, "Get Rotation By Radians", "@Radians (#0) = Get Rotation ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (radians)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees, entity_common_package, "Get Rotation By Degrees", "@Degrees (#0) = Get Rotation ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (degrees)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetAccumulatedRotationByRadians, entity_common_package, "Get Accumulated Rotation By Radians", "@Radians (#0) = Get Accumulated Rotation ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Accumulated Rotation (radians)"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Clone, shape_common_package, "Clone Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("Target Position X"),
                             new VariableDefinitionNumber ("Target Position Y"),
                             new VariableDefinitionBoolean ("Clone Brothers?"),
                             new VariableDefinitionBoolean ("Clone Connected Movables?"),
                             new VariableDefinitionBoolean ("Clone Connected Statics?"),
                     ],
                     [
                             new VariableDefinitionEntity ("The Cloned Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint, shape_common_package, "World Point -> Local Point", "@World Point ($0, $1) -> Local Point (#0, #1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("World Point X"),
                             new VariableDefinitionNumber ("World Point Y"),
                     ],
                     [
                             new VariableDefinitionNumber ("Local Point X"),
                             new VariableDefinitionNumber ("Local Point Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint, shape_common_package, "Local Point -> World Point", "@Local Point ($0, $1) -> World Point (#0, #1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("Local Point X"),
                             new VariableDefinitionNumber ("Local Point Y"),
                     ],
                     [
                             new VariableDefinitionNumber ("World Point X"),
                             new VariableDefinitionNumber ("World Point Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_WorldVector2LocalVector, shape_common_package, "World Vector -> Local Vector", "@World Vector ($0, $1) -> Local Vector (#0, #1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("World Vector X"),
                             new VariableDefinitionNumber ("World Vector Y"),
                     ],
                     [
                             new VariableDefinitionNumber ("Local Vector X"),
                             new VariableDefinitionNumber ("Local Vector Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_LocalVector2WorldVector, shape_common_package, "Local Vector -> World Vector", "@Local Vector ($0, $1) -> World Vector (#0, #1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("Local Vector X"),
                             new VariableDefinitionNumber ("Local Vector Y"),
                     ],
                     [
                             new VariableDefinitionNumber ("World Vector X"),
                             new VariableDefinitionNumber ("World Vector Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_GetScale, entity_common_package, "Get Entity Scale",  null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Current Scale"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsDestroyed, entity_common_package, "Is Entity Destroyed", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mExceptClasses: Filters.sLogicEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Already Destroyed?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_Destroy, entity_common_package, "Destroy Entity", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mExceptClasses: Filters.sLogicEntityClasses}),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_Coincided, entity_common_package, "Are Two Entities Coincided?", "@Are Two Entities ($0, $1) Superimposed with Tolerances ($2, $3, $4)", null,
                     [
                        new VariableDefinitionEntity ("The Entity 1", null, {mValidClasses: Filters.sMoveableEntityClasses}),
                        new VariableDefinitionEntity ("The Entity 2", null, {mValidClasses: Filters.sMoveableEntityClasses}),
                        new VariableDefinitionNumber ("Tolerance Delta X", null, {mMinValue:0.0}),
                        new VariableDefinitionNumber ("Tolerance Delta Y", null, {mMinValue:0.0}),
                        new VariableDefinitionNumber ("Tolerance Delta Angle (degrees)", null, {mMinValue:0.0}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Superimposed?"),
                     ]
                  );

      // game / entity / shape

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity, shape_is_subtype_package, "Is Circle Shape?", null, "IsCircleShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Circle?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity, shape_is_subtype_package, "Is Rectangle Shape?", null, "IsRectangleShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Rectangle?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity, shape_is_subtype_package, "Is Polygon Shape?", null, "IsPolygonShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polygon?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity, shape_is_subtype_package, "Is Polyline Shape?", null, "IsPolylineShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polyline?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntity, shape_is_subtype_package, "Is Bomb Shape?", null, "IsBombShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Bomb?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntity, shape_is_subtype_package, "Is World Border?", null, "IsWorldBorder",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is World Border?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsCameraEntity, shape_is_subtype_package, "Is Camera?", null, "IsCamera",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Camera Entity?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTextShapeEntity, shape_is_subtype_package, "Is Text Shape?", null, "IsTextShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Text Shape Entity?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsModuleShapeEntity, shape_is_subtype_package, "Is Module Shape?", null, "IsModuleShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Module Shape Entity?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsButtonShapeEntity, shape_is_subtype_package, "Is Button Shape?", null, "IsButtonShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Button Shape Entity?"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetOriginalCIType, shape_appearance_package, "Get Original C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Original CI Type"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetOriginalCIType, shape_appearance_package, "Set Original C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Original CI Type", null, {mValueLists: Lists.mAiTypeList}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType, shape_appearance_package, "Get C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("CI Type"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType, shape_appearance_package, "Set C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses}),
                             new VariableDefinitionNumber ("CI Type", null, {mValueLists: Lists.mAiTypeList}),
                     ],
                     null
                  );

          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsShowBody, shape_body_appearance_package, "Is Shape Body Visible", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Body/Background Visible?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetShowBody, shape_body_appearance_package, "Set Shape Body Visible", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Body/Background Visible?"),
                     ],
                     null
                  );
          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetBodyTexture, shape_body_appearance_package, "Get Shape Body Texture", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionModule ("Texture Module", null, {mIsTextureValue: true}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetBodyTexture, shape_body_appearance_package, "Set Shape Body Texture", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                             new VariableDefinitionModule ("Texture Module", null, {mIsTextureValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetBodyTextureTransform, shape_body_appearance_package, "Set Shape Body Texture Transform", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Is Global Transform?"),
                             new VariableDefinitionNumber ("Texture Origin X"),
                             new VariableDefinitionNumber ("Texture Origin Y"),
                             new VariableDefinitionBoolean ("Is Texture Flipped?"),
                             new VariableDefinitionNumber ("Texture Rotation (degrees)"),
                             new VariableDefinitionNumber ("Texture Scale"),
                     ],
                     null
                  );
          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor, shape_body_appearance_package, "Get Shape Background Color", "@Color (#0) = Get Shape Background Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses, mGroundSelectable:false}),
                     ],
                     [
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor, shape_body_appearance_package, "Set Shape Background Color", "@Set Shape Background Color ($0, Color ($1))", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses, mGroundSelectable:false}),
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB, shape_body_appearance_package, "Get Shape Background Color RGB", "@RGB (#0, #1, #2) = Get Shape Background Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses, mGroundSelectable:false}),
                     ],
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB, shape_body_appearance_package, "Set Shape Background Color RGB", "@Set Shape Background Color ($0, RGB ($1, $2, $3))", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses, mGroundSelectable:false}),
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledOpacity, shape_body_appearance_package, "Get Shape Background Opacity", "@Set Shape Background Opacity ($0, $1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses, mGroundSelectable:false}),
                     ],
                     [
                             new VariableDefinitionNumber ("Background Opacity"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledOpacity, shape_body_appearance_package, "Set Shape Background Opacity", "@Set Shape Background Opacity ($0, $1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses, mGroundSelectable:false}),
                             new VariableDefinitionNumber ("Background Opacity"),
                     ],
                     null
                  );
          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsShowBorder, shape_border_appearance_package, "Is Shape Border Visible", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Border Visible?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetShowBorder, shape_border_appearance_package, "Set Shape Border Visible", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Border Visible?"),
                     ],
                     null
                  );
          RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderColor, shape_border_appearance_package, "Get Shape Border Color", "@Color (#0) = Get Shape Border Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses, mGroundSelectable:false}),
                     ],
                     [
                             new VariableDefinitionNumber ("Border Color", null, {mIsColorValue: true}),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderColor, shape_border_appearance_package, "Set Shape Border Color", "@Set Shape Border Color ($0, Color ($1))", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses, mGroundSelectable:false}),
                             new VariableDefinitionNumber ("Border Color", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderColorRGB, shape_border_appearance_package, "Get Shape Border Color RGB", "@RGB (#0, #1, #2) = Get Shape Border Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses, mGroundSelectable:false}),
                     ],
                     [
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderColorRGB, shape_border_appearance_package, "Set Shape Border Color RGB", "@Set Shape Border Color ($0, RGB ($1, $2, $3))", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses, mGroundSelectable:false}),
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderOpacity, shape_border_appearance_package, "Get Shape Border Opacity", "@Set Shape Border Opacity ($0, $1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses, mGroundSelectable:false}),
                     ],
                     [
                             new VariableDefinitionNumber ("Border Opacity"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderOpacity, shape_border_appearance_package, "Set Shape Border Opacity", "@Set Shape Border Opacity ($0, $1)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses, mGroundSelectable:false}),
                             new VariableDefinitionNumber ("Border Opacity"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCacheAsBitmap, shape_appearance_package, "Cache Shape As Bitmap", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Cache As Bitmap?"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled, shape_physics_properties_package_1, "Is Physics Enabled Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sSimpleVectorShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Physics Enabled?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor, shape_physics_properties_package_1, "Is Sensor", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Sensor?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor, shape_physics_properties_package_1, "Set Sensor", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Sensor?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsStatic, shape_physics_properties_package_1, "Is Static", null, null,
                     [
                             new VariableDefinitionEntity ("One Brother Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Static?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetStatic, shape_physics_properties_package_1, "Set Static", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Static?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsRotationFixed, shape_physics_properties_package_1, "Is Rotation Fixed", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Rotation Fixed?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetRotationFixed, shape_physics_properties_package_1, "Set Rotation Fixed", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Rotation Fixed?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSleeping, shape_physics_properties_package_1, "Is Sleeping", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Sleeping?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetSleeping, shape_physics_properties_package_1, "Set Sleeping", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Sleeping?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFriction, shape_physics_properties_package_1, "Get Friction", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("The Friction"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFriction, shape_physics_properties_package_1, "Set Friction", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("The Friction"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetRestitution, shape_physics_properties_package_1, "Get Restitution", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("The Restitution"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetRestitution, shape_physics_properties_package_1, "Set Restitution", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("The Restitution"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory, shape_physics_properties_package_2, "Get Collision Category", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory, shape_physics_properties_package_2, "Set Collision Category", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsCareAboutShapeEvent, shape_physics_properties_package_2, "Is Caring About Event?", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Event ID", null, {mValueLists: Lists.mShapeCaringAboutEventIdList}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Care About?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCareAboutShapeEvent, shape_physics_properties_package_2, "Set Caring About Event", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Event ID", null, {mValueLists: Lists.mShapeCaringAboutEventIdList}),
                             new VariableDefinitionBoolean ("Care About?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetLocalCentroid, shape_physics_properties_package_2, "Get Local Centroid", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Local Centroid X"),
                             new VariableDefinitionNumber ("Local Centroid Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetWorldCentroid, shape_physics_properties_package_2, "Get World Centroid", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Centroid of Brothers?"),
                     ],
                     [
                             new VariableDefinitionNumber ("World Centroid X"),
                             new VariableDefinitionNumber ("World Centroid Y"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetMass, shape_physics_properties_package_2, "Get Mass", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Mass of Brothers?"),
                     ],
                     [
                             new VariableDefinitionNumber ("Mass"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetMass, shape_physics_properties_package_2, "Set Mass", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Mass"),
         //                    //new VariableDefinitionBoolean ("Mass of Brothers?"),
         //            ],
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetInertia, shape_physics_properties_package_2, "Get Moment Of Inertia", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("MOI of Brothers?"),
                     ],
                     [
                             new VariableDefinitionNumber ("Moment Of Inertia"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetInertia, shape_physics_properties_package_2, "Set Moment Of Inertia", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Moment Of Inertia"),
         //                    //new VariableDefinitionBoolean ("MOI of Brothers?"),
         //            ],
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity, shape_physics_properties_package_2, "Get Density", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("The Density"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity, shape_physics_properties_package_2, "Set Density", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("The Density"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetLinearVelocity, shape_physics_dynamics_package, "Get Linear Velocity", "@Vector (#0, #1) = Get Linear Velocity ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Velocity X"),
                             new VariableDefinitionNumber ("Velocity Y"),
                     ]
               );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetLinearVelocity, shape_physics_dynamics_package, "Set Linear Velocity", "@Set Linear Velocity of $0 by Vector ($1, $2)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Velocity X"),
                             new VariableDefinitionNumber ("New Velocity Y"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector, shape_physics_dynamics_package, "Change Linear Velocity", "@Change Linear Velocity of $0 by Vector ($1, $2)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Delta Velocity X"),
                             new VariableDefinitionNumber ("Delta Velocity Y"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetAngularVelocityByRadians, shape_physics_dynamics_package, "Get Angular Velocity By Radians", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Angular Velocity (radians/s)"),
                     ]
               );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetAngularVelocityByDegrees, shape_physics_dynamics_package, "Get Angular Velocity By Degrees", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Angular Velocity (degrees/s)"),
                     ]
               );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAngularVelocityByRadians, shape_physics_dynamics_package, "Set Angular Velocity By Radians", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Angular Velocity (radians/s)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAngularVelocityByDegrees, shape_physics_dynamics_package, "Set Angular Velocity By Degrees", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Angular Velocity (degrees/s)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByRadians, shape_physics_dynamics_package, "Change Angular Velocity By Radians", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Delta Angular Velocity (radians/s)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByDegrees, shape_physics_dynamics_package, "Change Angular Velocity By Degrees", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Delta Angular Velocity (degrees/s)"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForce, shape_physics_dynamics_package, "Apply Step Force", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Force X"),
                             new VariableDefinitionNumber ("Force Y"),
                             new VariableDefinitionBoolean ("Is Local Force?"),
                             new VariableDefinitionBoolean ("Apply on Center of Brothers?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint, shape_physics_dynamics_package, "Apply Step Force At Local Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Force X"),
                             new VariableDefinitionNumber ("Force Y"),
                             new VariableDefinitionBoolean ("Is Local Force?"),
                             new VariableDefinitionNumber ("Local Point X"),
                             new VariableDefinitionNumber ("Local Point Y"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint, shape_physics_dynamics_package, "Apply Step Force At World Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Force X"),
                             new VariableDefinitionNumber ("Force Y"),
                             new VariableDefinitionBoolean ("Is Local Force?"),
                             new VariableDefinitionNumber ("World Point X"),
                             new VariableDefinitionNumber ("World Point Y"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque, shape_physics_dynamics_package, "Apply Step Torque", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Torque"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse, shape_physics_dynamics_package, "Apply Impulse", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Impulse X"),
                             new VariableDefinitionNumber ("Impulse Y"),
                             new VariableDefinitionBoolean ("Is Local Impulse?"),
                             new VariableDefinitionBoolean ("Apply on Center of Brothers?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint, shape_physics_dynamics_package, "Apply Impulse At Local Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Impulse X"),
                             new VariableDefinitionNumber ("Impulse Y"),
                             new VariableDefinitionBoolean ("Is Local Impulse?"),
                             new VariableDefinitionNumber ("Local Point X"),
                             new VariableDefinitionNumber ("Local Point Y"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint, shape_physics_dynamics_package, "Apply Impulse At World Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Impulse X"),
                             new VariableDefinitionNumber ("Impulse Y"),
                             new VariableDefinitionBoolean ("Is Local Impulse?"),
                             new VariableDefinitionNumber ("World Point X"),
                             new VariableDefinitionNumber ("World Point Y"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse, shape_physics_dynamics_package, "Apply Angular Impulse", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Angular Impulse"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Teleport, shape_common_package, "Teleport Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Target Position X"),
                             new VariableDefinitionNumber ("Target Position Y"),
                             new VariableDefinitionNumber ("Target Angle (degrees)"),
                             new VariableDefinitionBoolean ("Teleport Connected Movables?"),
                             new VariableDefinitionBoolean ("Teleport Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets, shape_common_package, "Teleport Shape By Offsets", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Offset X"),
                             new VariableDefinitionNumber ("Offset Y"),
                             new VariableDefinitionNumber ("Delta Angle (degrees)"),
                             new VariableDefinitionBoolean ("Teleport Connected Movables?"),
                             new VariableDefinitionBoolean ("Teleport Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                     ],
                     null,
                     false
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Translate, shape_common_package, "Move Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Offset X"),
                             new VariableDefinitionNumber ("Offset Y"),
                             new VariableDefinitionBoolean ("Move Connected Movables?"),
                             new VariableDefinitionBoolean ("Move Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_TranslateTo, shape_common_package, "Move Shape To", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Target Position X"),
                             new VariableDefinitionNumber ("Target Position Y"),
                             new VariableDefinitionBoolean ("Move Connected Movables?"),
                             new VariableDefinitionBoolean ("Move Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_RotateAroundWorldPoint, shape_common_package, "Rotate Shape Around World Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Around World Point X"),
                             new VariableDefinitionNumber ("Around World Point Y"),
                             new VariableDefinitionNumber ("Delta Angle (degrees)"),
                             new VariableDefinitionBoolean ("Rotate Connected Movables?"),
                             new VariableDefinitionBoolean ("Rotate Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                             new VariableDefinitionBoolean ("Rotate Linear Velocity?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_RotateToAroundWorldPoint, shape_common_package, "Rotate Shape To Around World Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Around World Point X"),
                             new VariableDefinitionNumber ("Around World Point Y"),
                             new VariableDefinitionNumber ("Target Angle (degrees)"),
                             new VariableDefinitionBoolean ("Rotate Connected Movables?"),
                             new VariableDefinitionBoolean ("Rotate Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                             new VariableDefinitionBoolean ("Rotate Linear Velocity?"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_Entity_IsFlipped, shape_common_package, "Is Entity Flipped",  "@#0 = Is Entity ($0) Flipped?", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Flippped?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_FlipSelf, shape_common_package, "Local Flip Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Flip Connected Movables?"),
                             new VariableDefinitionBoolean ("Flip Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                             new VariableDefinitionBoolean ("Flip Linear Velocity?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_FlipByWorldLinePoint, shape_common_package, "Flip Shape By World Line", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("One Line Point X"),
                             new VariableDefinitionNumber ("One Line Point Y"),
                             new VariableDefinitionNumber ("Line Normal X"),
                             new VariableDefinitionNumber ("Line Normal Y"),
                             new VariableDefinitionBoolean ("Flip Connected Movables?"),
                             new VariableDefinitionBoolean ("Flip Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                             new VariableDefinitionBoolean ("Flip Velocity?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ScaleWithFixedPoint, shape_common_package, "Scale Shape With Fixed Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionNumber ("Scale Ratio", null, {mMinValue: Define.kFloatEpsilon}),
                             new VariableDefinitionNumber ("Fixed Point X"),
                             new VariableDefinitionNumber ("Fixed Point Y"),
                             new VariableDefinitionBoolean ("Scale Connected Movables?"),
                             new VariableDefinitionBoolean ("Scale Connected Statics?"),
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?"),
                             new VariableDefinitionBoolean ("Conserve Momentum?"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetBrothers, entity_shape_brothers_package, "Get Shape Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("One Brother Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionArray ("Brothers (including self)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsAttchedWith, entity_shape_brothers_package, "Are Two Shapes Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Brothers?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Detach, entity_shape_brothers_package, "Break Away From Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape to Be Detached", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith, entity_shape_brothers_package, "Make Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith, entity_shape_brothers_package, "Break Away Then Make Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers, entity_shape_brothers_package, "Breakup All Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("One Brother Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_DestroyBrothers, entity_shape_brothers_package, "Destroy Brothers Group", null, null,
                     [
                             new VariableDefinitionEntity ("One Brother Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints, entity_shape_connections_package, "Breakup All Connections", null, null,
                     [
                        new VariableDefinitionEntity ("The Input Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetAllSisters, entity_shape_connections_package, "Get All Connected Shapes", null, null,
                     [
                             new VariableDefinitionEntity ("The Input Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionArray ("All Connected Shapes"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsConnectedWith, entity_shape_connections_package, "Are Two Shapes Connected", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Connected?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsConnectedWithGround, entity_shape_connections_package, "Is Connected With Ground?", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Connected With Ground?"),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetAllContactedShapes, entity_shape_contaction_package, "Get Contacted Shapes", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionArray ("Contacted Shapes"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsContactedWith, entity_shape_contaction_package, "Are Two Shapes Contacted", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionBoolean ("Contacted?"),
                     ]
                  );



      // game / entity / shape / text

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetText, shape_text_package, "Get Text", "@#0 = Get Text of $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                     ],
                     [
                             new VariableDefinitionString ("The Text String"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetText, shape_text_package, "Set Text", "@Set Text ($1) of $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                             new VariableDefinitionString ("New Text String", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendText, shape_text_package, "Append Text", "@Append Text ($1) to $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                             new VariableDefinitionString ("Text to Append", null, {mAllowVariablesOfOtherClasses: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine, shape_text_package, "Append New Line", "@Append New Line to $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetSize, shape_text_package, "Set Font Size", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                             new VariableDefinitionNumber ("New Font Size"),
                     ],
                     null
                  );
                  
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetColor, shape_text_package, "Set Text Color", "@Set Text Color ($0, Color ($1))", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                             new VariableDefinitionNumber ("New Color", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetColorByRGB, shape_text_package, "Set Text Color By RGB", "@RGB (#0, #1, #2) = Set Text Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}),
                             new VariableDefinitionNumber ("Red"),
                             new VariableDefinitionNumber ("Green"),
                             new VariableDefinitionNumber ("Blue"),
                     ],
                     null,
                     false
                  );
                  
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetHorizontalScrollPosition, shape_text_package, "Get Horizontal Scroll Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses, mExceptClasses: Filters.sTextButtonEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Horizontal Scroll Position"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetHorizontalScrollPosition, shape_text_package, "Set Horizontal Scroll Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses, mExceptClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("Horizontal Scroll Position"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetVerticalScrollPosition, shape_text_package, "Get Vertical Scroll Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses, mExceptClasses: Filters.sTextButtonEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Vertical Scroll Position"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetVerticalScrollPosition, shape_text_package, "Set Vertical Scroll Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses, mExceptClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("Vertical Scroll Position"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetMaxHorizontalScrollPosition, shape_text_package, "Get Max Horizontal Scroll Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses, mExceptClasses: Filters.sTextButtonEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Max Horizontal Scroll Position"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetMaxVerticalScrollPosition, shape_text_package, "Get Max Vertical Scroll Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses, mExceptClasses: Filters.sTextButtonEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Max Vertical Scroll Position"),
                     ]
                  );
                  
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetSize_MouseDown, shape_text_button_package, "Set Font Size For Mouse Down", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("New Font Size For Mouse Down"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetSize_MouseOver, shape_text_button_package, "Set Font Size For Mouse Over", null, null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("New Font Size For Mouse Over"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetColor_MouseDown, shape_text_button_package, "Set Text Color For Mouse Down", "@Set Text Color ($0, Color ($1)) For Mouse Down", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("New Color For Mouse Down", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetColor_MouseOver, shape_text_button_package, "Set Text Color For Mouse Over", "@Set Text Color ($0, Color ($1))", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("New Color For Mouse Over", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetColorByRGB_MouseOver, shape_text_button_package, "Set Text Color By RGB For Mouse Over", "@RGB (#0, #1, #2) = Set Text Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("Red For Mouse Over"),
                             new VariableDefinitionNumber ("Green For Mouse Over"),
                             new VariableDefinitionNumber ("Blue For Mouse Over"),
                     ],
                     null,
                     false
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetBackgroundColor_MouseDown, shape_text_button_package, "Set Text Background Color For Mouse Down", "@Set Text Background Color ($0, Color ($1)) For Mouse Down", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("New Color For Mouse Down", null, {mIsColorValue: true}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetBackgroundColor_MouseOver, shape_text_button_package, "Set Text Background Color For Mouse Over", "@Set Text Background Color ($0, Color ($1)) For Mouse Over", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextButtonEntityClasses}),
                             new VariableDefinitionNumber ("New Color For Mouse Over", null, {mIsColorValue: true}),
                     ],
                     null
                  );

      // game / entity / shape / circle

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeCircle_GetRadius, shape_geometry_package, "Get Circle Radius", "@#0 = Get Radius of Circle $0", "GetCircleRadius",
                     [
                             new VariableDefinitionEntity ("The Circle", null, {mValidClasses: Filters.sCircleShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("The Radius (meters)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeCircle_SetRadius, shape_geometry_package, "Set Circle Radius", null, null,
                     [
                             new VariableDefinitionEntity ("The Circle", null, {mValidClasses: Filters.sCircleShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Radius (meters)"),
                     ],
                     null
                  );

      // game / entity / shape / rectangle

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_GetSize, shape_geometry_package, "Get Rectangle Size", "@(#0, #1) = Get Size of Retangle $0", "GetRectangleSize",
                     [
                             new VariableDefinitionEntity ("The Rectangle", null, {mValidClasses: Filters.sRectangleShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Width (meters)"),
                             new VariableDefinitionNumber ("Height (meters)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_SetSize, shape_geometry_package, "Set Rectangle Size", null, null,
                     [
                             new VariableDefinitionEntity ("The Rectangle", null, {mValidClasses: Filters.sRectangleShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Width (meters)"),
                             new VariableDefinitionNumber ("New Height (meters)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_SetRoundCornerEnabled, shape_geometry_package, "Set Rectangle Round Corner Enabled", null, null,
                     [
                             new VariableDefinitionEntity ("The Rectangle", null, {mValidClasses: Filters.sRectangleShapeEntityClasses}),
                             new VariableDefinitionBoolean ("Enable Round Corner?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_SetRoundCornerEclipseSize, shape_geometry_package, "Set Rectangle Round Corner Eclipse Size In World Pixels", null, null,
                     [
                             new VariableDefinitionEntity ("The Rectangle", null, {mValidClasses: Filters.sRectangleShapeEntityClasses}),
                             new VariableDefinitionNumber ("Round Corner Eclipse Width (px)"),
                             new VariableDefinitionNumber ("Round Corner Eclipse Height (px)"),
                     ],
                     null
                  );

      // game / entity / shape / poly

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexCount, shape_geometry_package, "Get Poly Shape Vertexes Count", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("Vertex Count"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPosition, shape_geometry_package, "Get Poly Shape Vertex Local Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                             new VariableDefinitionNumber ("Vertex Index"),
                     ],
                     [
                             new VariableDefinitionNumber ("Local X"),
                             new VariableDefinitionNumber ("Local Y"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPosition, shape_geometry_package, "Set Poly Shape Vertex Local Position", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Vertex Index"),
         //                    new VariableDefinitionNumber ("Local X"),
         //                    new VariableDefinitionNumber ("Local Y"),
         //            ],
         //            null
         //         );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPosition, shape_geometry_package, "Get Poly Shape Vertex World Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                             new VariableDefinitionNumber ("Vertex Index"),
                     ],
                     [
                             new VariableDefinitionNumber ("World X"),
                             new VariableDefinitionNumber ("World Y"),
                     ]
                  );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPosition, shape_geometry_package, "Set Poly Shape Vertex World Position", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Vertex Index"),
         //                    new VariableDefinitionNumber ("World X"),
         //                    new VariableDefinitionNumber ("World Y"),
         //            ],
         //            null
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_InsertVertexByLocalPosition, shape_geometry_package, "Insert Poly Shape Vertex By Local Position", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Vertex Index"),
         //                    new VariableDefinitionNumber ("Local X"),
         //                    new VariableDefinitionNumber ("Local Y"),
         //            ],
         //            null
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_InsertVertexByWorldPosition, shape_geometry_package, "Insert Poly Shape Vertex By World Position", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Vertex Index"),
         //                    new VariableDefinitionNumber ("World X"),
         //                    new VariableDefinitionNumber ("World Y"),
         //            ],
         //            null
         //         );
         //RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_DeleteVertexAt, shape_geometry_package, "Delete Poly Shape Vertex", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
         //                    new VariableDefinitionNumber ("Vertex Index"),
         //            ],
         //            null
         //         );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPositions, shape_geometry_package, "Get Poly Shape Local Vertex Positions", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionArray ("Local Vertexes"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPositions, shape_geometry_package, "Set Poly Shape Local Vertex Positions", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                             new VariableDefinitionArray ("Local Vertexes"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPositions, shape_geometry_package, "Get Poly Shape World Vertex Positions", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionArray ("World Vertexes"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPositions, shape_geometry_package, "Set Poly Shape World Vertex Positions", null, null,
                     [
                             new VariableDefinitionEntity ("The Poly Shape", null, {mValidClasses: Filters.sPolyShapeEntityClasses}),
                             new VariableDefinitionArray ("World Vertexes"),
                     ],
                     null
                  );

      // game / entity / shape / thickness

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderThickness, shape_geometry_package, "Get Shape Border Thickness In World Meters", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("The Thickness (meters)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderThickness, shape_geometry_package, "Set Shape Border Thickness In World Meters", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sAeraShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Thickness (meters)"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCurveThickness, shape_geometry_package, "Get Curve Thickness In World Meters", null, null,
                     [
                             new VariableDefinitionEntity ("The Curve", null, {mValidClasses: Filters.sCurveShapeEntityClasses}),
                     ],
                     [
                             new VariableDefinitionNumber ("The Thickness (meters)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCurveThickness, shape_geometry_package, "Set Curve Thickness In World Meters", null, null,
                     [
                             new VariableDefinitionEntity ("The Curve", null, {mValidClasses: Filters.sCurveShapeEntityClasses}),
                             new VariableDefinitionNumber ("New Thickness (meters)"),
                     ],
                     null
                  );

      // game / entity / shape / module

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeModule_GetModule, shape_module_package, "Get Shape Module", null, null,
                     [
                        new VariableDefinitionEntity ("The Module Shape", null, {mValidClasses: Filters.sModuleShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionModule ("The Module"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeModule_ChangeModule, shape_module_package, "Change Shape Module", null, null,
                     [
                        new VariableDefinitionEntity ("The Module Shape", null, {mValidClasses: Filters.sModuleShapeEntityClasses}),
                        new VariableDefinitionModule ("The New Module"),
                        new VariableDefinitionEntity ("Loop To End Handler", null, {mValidClasses: Filters.sOnModuleLoopToEndHandlerEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_GetOverModule, shape_module_package, "Get Button Module Of Over State", null, null,
                     [
                        new VariableDefinitionEntity ("The Module Button", null, {mValidClasses: Filters.sModuleButtonShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionModule ("The Module Of Over State"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_ChangeOverModule, shape_module_package, "Change Button Module Of Over State", null, null,
                     [
                        new VariableDefinitionEntity ("The Module Button", null, {mValidClasses: Filters.sModuleButtonShapeEntityClasses}),
                        new VariableDefinitionModule ("The New Module Of Over State"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_GetDownModule, shape_module_package, "Get Button Module Of Down State", null, null,
                     [
                        new VariableDefinitionEntity ("The Module Button", null, {mValidClasses: Filters.sModuleButtonShapeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionModule ("The Module Of Down State"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_ChangeDownModule, shape_module_package, "Change Button Module Of Down State", null, null,
                     [
                        new VariableDefinitionEntity ("The Module Button", null, {mValidClasses: Filters.sModuleButtonShapeEntityClasses}),
                        new VariableDefinitionModule ("The New Module Of Down State"),
                     ],
                     null
                  );

      // game / entity / joint

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetJointConnectedShapes, entity_joint_package, "Get Joint Connected Shapes", null, null,
                      [
                        new VariableDefinitionEntity ("The Joint", null, {mValidClasses: Filters.sLimitsConfigureableJointEntityClasses}),
                     ],
                     [
                        new VariableDefinitionEntity ("Shape 1 (null for ground)", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionEntity ("Shape 2 (null for ground)", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ]
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled, entity_joint_package, "Set Joint Limits Enabled", null, null,
                     [
                        new VariableDefinitionEntity ("The Joint", null, {mValidClasses: Filters.sLimitsConfigureableJointEntityClasses}),
                        new VariableDefinitionBoolean ("Enabled?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled, entity_joint_package, "Set Joint Motor Enabled", null, null,
                     [
                        new VariableDefinitionEntity ("The Joint", null, {mValidClasses: Filters.sMotorConfigureableJointEntityClasses}),
                        new VariableDefinitionBoolean ("Enabled?"),
                     ],
                     null
                  );

        RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees, entity_joint_package, "Get Hinge Angle By Degrees", "@Degrees (#0) = Get Current Angle of Hinge ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Current Angle (degrees)"),
                     ]
                  );
        RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees, entity_joint_package, "Get Hinge Limits By Degrees", "@Degrees (#0, #1) = Get Limits of Hinge ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Angle (degrees)"),
                        new VariableDefinitionNumber ("Upper Angle (degrees)"),
                     ]
                  );
        RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees, entity_joint_package, "Set Hinge Limits by Degrees", "@Set Hinge ($0) Limits by Degrees ($1, $2)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}),
                        new VariableDefinitionNumber ("Lower Angle (degrees)"),
                        new VariableDefinitionNumber ("Upper Angle (degrees)"),
                     ],
                     null
                  );
        RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed, entity_joint_package, "Get Hinge Motor Speed by Degrees", "@Degrees/s (#0) = Get Motor Speed of Hinge ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Motor Speed (degrees/s)"),
                     ]
                  );
        RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed, entity_joint_package, "Set Hinge Motor Speed by Degrees", "@Set Hinge ($0) Motor Speed by Degrees ($1) /s", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}),
                        new VariableDefinitionNumber ("Motor Speed (degrees/s)"),
                     ],
                     null
                  );

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderTranslation, entity_joint_package, "Get Slider Translation", "@#0 = Get Current Translation of Slider ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Current Translation"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits, entity_joint_package, "Get Slider Limits", "@#0 = Get Limits of Slider ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Translation"),
                        new VariableDefinitionNumber ("Upper Translation"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits, entity_joint_package, "Set Slider Limits", "@Set Slider ($0) Limits ($1)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}),
                        new VariableDefinitionNumber ("Lower Translation"),
                        new VariableDefinitionNumber ("Upper Translation"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed, entity_joint_package, "Get Slider Motor Speed", "@#0 = Get Motor Speed of Slider ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Motor Speed (m/s)"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed, entity_joint_package, "Set Slider Motor Speed", "@Set Slider ($0) Motor Speed ($1)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}),
                        new VariableDefinitionNumber ("Motor Speed (m/s)"),
                     ],
                     null
                  );

      // trigger

         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer, entity_trigger_package, "Reset Timer", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_IsTimerPaused, entity_trigger_package, "Is Timer Paused", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}),
                     ],
                     [
                        new VariableDefinitionBoolean ("Paused?"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused, entity_trigger_package, "Set Timer Paused", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}),
                        new VariableDefinitionBoolean ("Paused?"),
                     ],
                     null
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_GetTimerInterval, entity_trigger_package, "Get Timer Interval", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}),
                     ],
                     [
                        new VariableDefinitionNumber ("Interval"),
                     ]
                  );
         RegisterCoreFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval, entity_trigger_package, "Set Timer Interval", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}),
                        new VariableDefinitionNumber ("Interval"),
                     ],
                     null
                  );
         
         // ...
         
     }

//===========================================================
// util functions
//===========================================================

      private static function RegisterPreDefineFunctionDeclaration (function_id:int, codePackage:CodePackage, function_name:String, poemCallingFormat:String, traditionalCallingFormat:String, param_defines:Array, return_defines:Array):void
      {
         if (function_id < 0)
            return;
         
         if (sFunctionDeclarations [function_id] != null)
            throw new Error ("Duplicated API ID: " + function_id);
         
         var functionDeclaration:FunctionDeclaration = new FunctionDeclaration_PreDefined (function_id, function_name, "", function_name, function_name, param_defines, return_defines);
         
         sFunctionDeclarations [function_id] = functionDeclaration;

         if (codePackage != null)
            codePackage.AddFunctionDeclaration (sFunctionDeclarations [function_id]);
      }

      private static function RegisterCoreFunctionDeclaration (function_id:int, codePackage:CodePackage, function_name:String, poemCallingFormat:String, traditionalCallingFormat:String, param_defines:Array, return_defines:Array, showUpInApiMenu:Boolean = true):void
      {
         if (function_id < 0)
            return;

         if (sFunctionDeclarations [function_id] != null)
            throw new Error ("Duplicated API ID: " + function_id);
         
         sFunctionDeclarations [function_id] = new FunctionDeclaration_Core (function_id, function_name, "", poemCallingFormat, traditionalCallingFormat, param_defines, return_defines, showUpInApiMenu);

         if (codePackage != null)
            codePackage.AddFunctionDeclaration (sFunctionDeclarations [function_id]);
      }

      public static function GetCoreFunctionDeclarationById (function_id:int):FunctionDeclaration_Core
      {
         if (function_id < 0 || function_id >= sFunctionDeclarations.length)
            return null;

         return sFunctionDeclarations [function_id] as FunctionDeclaration_Core;
      }

      public static function GetPreDefinedFunctionDeclarationById (function_id:int):FunctionDeclaration_PreDefined
      {
         if (function_id < 0 || function_id >= sFunctionDeclarations.length)
            return null;

         return sFunctionDeclarations [function_id] as FunctionDeclaration_PreDefined;
      }
   }
}
