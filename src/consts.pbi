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
  #APP_COPYRIGHT_NOTICE = "Copyright © 2025 James A. Dooley"
      
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
  
  ;-------- Main Window --------
  #WND_MAIN_cfg_name = "main-window"
  #WND_MAIN_default_X = 50
  #WND_MAIN_default_Y = 50
  #WND_MAIN_min_width = 900
  #WND_MAIN_min_height = 600
  #WND_MAIN_max_width = 1200
  #WND_MAIN_max_height = 800
  
  #WND_MAIN_NavPanel_Width = 175
  
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
  
  ;-------- Dialog --------
  #DLG_WINDOW_FLAGS = #PB_Window_TitleBar | #PB_Window_WindowCentered | #PB_Window_SystemMenu
  #DLG_DEFAULT_GADGET_PADDING = 5
  
  #DLG_DEFAULT_BUTTON_HEIGHT = 25
  #DLG_DEFAULT_BUTTON_WIDTH = 100
  #DLG_DEFAULT_IMAGE_BUTTON_HEIGHT = 28
  #DLG_DEFAULT_IMAGE_BUTTON_WIDTH = 28
  
  ;-------- Gadget Colors --------
  Define.l NAV_PANEL_Background = RGB($E6, $4A, $19)
  Define.l NAV_PANEL_Item_Background = RGB($FF, $57, $22)
  Define.l NAV_PANEL_Item_Selected_Background = RGB($3F, $51, $B5)
  Define.l NAV_PANEL_Item_Selected_Text = RGB($FF, $FF, $FF)
  
  Define.l MAIN_PANEL_Background = RGB($FF, $57, $22)
  
  Define.l WND_Background = RGB($FF, $57, $22)
  
  ;-------- Panel Values --------
  #PANEL_TITLE_BAR_HEIGHT = 36
  #PANEL_TITLE_BAR_IMAGE_HEIGHT = 50
  #PANEL_TITLE_BAR_IMAGE_WIDTH = 50
  #PANEL_TITLE_BAR_TEXT_HEIGHT = 20
  #PANEL_DEFAULT_GADGET_PADDING = 5
  #PANEL_ACTION_BAR_WIDTH = 160
  
  Define.l PANEL_TITLE_BAR_Background = NAV_PANEL_Item_Selected_Background
  Define.l PANEL_TITLE_Color = RGB($FF, $FF, $FF)
EndDeclareModule

Module Consts
EndModule
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 89
; FirstLine = 61
; Folding = -
; EnableXP
; DPIAware