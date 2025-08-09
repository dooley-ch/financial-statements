;╔═════════════════════════════════════════════════════════════════════════════════════════════════
;║     main.pb                                                                           
;╠═════════════════════════════════════════════════════════════════════════════════════════════════
;║     Created: 09-08-2025 
;║
;║     Copyright (c) 2025 James Dooley <james@dooley.ch>
;║
;║     History:
;║     09-08-2025: Initial version
;╚═════════════════════════════════════════════════════════════════════════════════════════════════
EnableExplicit

;-------- Modules --------
XIncludeFile "consts.pbi"
XIncludeFile "string_utils.pbi"
XIncludeFile "file_utils.pbi"
XIncludeFile "setup.pbi"
XIncludeFile "logger.pbi"
XIncludeFile "statusbar.pbi"
XIncludeFile "menubar.pbi"
XIncludeFile "toolbar.pbi"

UseModule Consts
UseModule SetupModule
UseModule FileUtils
UseModule Logger
UseModule StatusBarModule
UseModule MenuBarModule
UseModule ToolBarModule

;-------- Support Routines & Variables --------
Define.i mainWindowId, menuBarId, toolBarId, statusBarId, navPanelId, displayPanelId, event
Define mainWindowLocation.WindowLocation
Define.i exitCode = #EXIT_SUCCESS

;┌───────────────────────────────────────────────────────────────────────────────────────────────
;│     Start up     
;└───────────────────────────────────────────────────────────────────────────────────────────────

;-------- Setup logging --------
SetLoggingFileName(MakePath(GetApplicationDataFolder(), #APP_LOG_FILE$))
If Not LogStart()
  End #EXIT_LOGGING_FAILED 
EndIf  

;┌───────────────────────────────────────────────────────────────────────────────────────────────
;│     Main Loop     
;└───────────────────────────────────────────────────────────────────────────────────────────────
#MainWindowFlags = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar

GetWindowLocation(#WND_MAIN_cfg_name, @mainWindowLocation)

mainWindowId = OpenWindow(#PB_Any, mainWindowLocation\X, mainWindowLocation\Y, mainWindowLocation\Width, mainWindowLocation\Height, #APP_TITLE$, #MainWindowFlags)
If IsWindow(mainWindowId)
  WindowBounds(mainWindowId, #WND_MAIN_min_width, #WND_MAIN_min_height, #WND_MAIN_max_width, #WND_MAIN_max_height)
  
  statusBarId = CreateAppStatusBar(mainWindowId)
  menuBarId = CreateAppMenuBar(mainWindowId)
  toolBarId = CreateAppToolBar(mainWindowId)
  
  Repeat
    event = WaitWindowEvent()
    
    Select event
      Case #PB_Event_CloseWindow, #APP_EVENT_Quit
        Break
    EndSelect
  Until #False
  
  With mainWindowLocation
    \X = WindowX(mainWindowId, #PB_Window_FrameCoordinate)
    \Y = WindowY(mainWindowId, #PB_Window_FrameCoordinate)
    \Height = WindowHeight(mainWindowId, #PB_Window_InnerCoordinate)
    \Width = WindowWidth(mainWindowId, #PB_Window_InnerCoordinate)
  EndWith
  
  SetWindowLocation(#WND_MAIN_cfg_name, @mainWindowLocation)
  
  CloseWindow(mainWindowId)
Else
  exitCode = #EXIT_COMMAND_WND_NOT_CREATED
EndIf

;┌───────────────────────────────────────────────────────────────────────────────────────────────
;│     Clean up & Exit     
;└───────────────────────────────────────────────────────────────────────────────────────────────
;-------- End Logging --------
LogEnd()

;-------- Terminate --------
End #EXIT_SUCCESS
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 26
; FirstLine = 16
; EnableXP
; DPIAware