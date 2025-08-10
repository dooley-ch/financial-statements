;╔═════════════════════════════════════════════════════════════════════════════════════════════════
;║     consts.pbi                                                                           
;╠═════════════════════════════════════════════════════════════════════════════════════════════════
;║     Created: 09-08-2025 
;║
;║     Copyright (c) 2025 James Dooley <james@dooley.ch>
;║
;║     History:
;║     07-09-2025: Initial version
;╚═════════════════════════════════════════════════════════════════════════════════════════════════

DeclareModule Consts
  
  ;-------- Application --------
  #APP_TITLE$ = "Financial Data Loader"
  #APP_VERSION$ = "1.0.1"
  #APP_LOG_FILE$ = "app.log"
  #APP_CFG_FILE$ = "app.ini"
  #APP_ORGANISATION$ = "dooley.ch"
  #APP_DATA_FOLDER$ = "financial-statements-loader"
    
  ;-------- Main Window --------
  #WND_MAIN_cfg_name = "main-window"
  #WND_MAIN_default_X = 50
  #WND_MAIN_default_Y = 50
  #WND_MAIN_min_width = 900
  #WND_MAIN_min_height = 600
  #WND_MAIN_max_width = 1200
  #WND_MAIN_max_height = 800
  
  #WND_MAIN_NavPanel_Width = 175
  
  ;-------- Exit Codes --------
  #EXIT_SUCCESS                  = 0
  #EXIT_GENERAL_ERROR            = 1
  #EXIT_LOGGING_FAILED           = 126
  #EXIT_COMMAND_WND_NOT_CREATED  = 127
  #EXIT_FATAL_ERROR              = 128
  
  ;-------- Application Events --------
  Enumeration #PB_Event_FirstCustomValue + 5000
    #APP_EVENT_Quit
    #APP_EVENT_Download
    #APP_EVENT_Import
    #APP_EVENT_Build
    #APP_EVENT_Publish
    #APP_EVENT_Setup
    #APP_EVENT_Manual
    #APP_EVENT_About
  EndEnumeration
  
  ;-------- Menu & ToolBar IDs --------
  Enumeration 
    #File_Quit
    #Action_Download
    #Action_Import
    #Action_Publish
    #Action_Build
    #Action_Preferences
    #Help_Manual
    #Help_About
  EndEnumeration
  ;-------- Gadget Colors --------
  Define.l NAV_PANEL_Background = RGB($75, $75, $75)
  Define.l NAV_PANEL_Item_Background = RGB($9E, $9E, $9E)
  Define.l NAV_PANEL_Item_Selected_Background = RGB($42, $A5, $F5)
  Define.l NAV_PANEL_Item_Selected_Text = RGB($FF, $FF, $FF)
  
  Define.l MAIN_PANEL_Background = RGB($9E, $9E, $9E)
  
  Define.l WND_Background = RGB($9E, $9E, $9E)
  
EndDeclareModule

Module Consts
EndModule
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 66
; FirstLine = 40
; Folding = -
; EnableXP
; DPIAware