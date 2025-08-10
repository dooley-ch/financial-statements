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
XIncludeFile "navigation_panel.pbi"

UseModule Consts
UseModule SetupModule
UseModule FileUtils
UseModule Logger
UseModule StatusBarModule
UseModule MenuBarModule
UseModule ToolBarModule
UseModule NavigationPanelUI

;-------- Support Routines & Variables --------
Define.i mainWindowId, menuBarId, toolBarId, statusBarId, navPanelId, displayPanelId, event
Define mainWindowLocation.WindowLocation
Define navPanelConfig.NavigationPanelConfigInfo
Define.i exitCode = #EXIT_SUCCESS

;┌───────────────────────────────────────────────────────────────────────────────────────────────
;│     Event Handlers    
;└───────────────────────────────────────────────────────────────────────────────────────────────

; Handles the resizing of the main window
;
; Note: calculates and resizes navigation panel and the display panel
;
Procedure OnResizeMainWindow()
  Shared mainWindowId, navPanelId, statusBarId
  Protected.i mainWindowHeight, mainWindowWidth
  
  mainWindowHeight = WindowHeight(mainWindowId, #PB_Window_InnerCoordinate) - StatusBarHeight(statusBarId)
  mainWindowWidth = WindowWidth(mainWindowId, #PB_Window_InnerCoordinate)
  
  ; Resize the Nav Panel
  If IsGadget(navPanelId)
    ResizeGadget(navPanelId, 0, 0, #WND_MAIN_NavPanel_Width, mainWindowHeight)
  EndIf
  
  ; Resize the Display Panel
  
EndProcedure

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
  
  ; Configure the navigation panel
  InitNavigationPanelConfig(@navPanelConfig)
  
  With navPanelConfig
    \BackgroundColor = NAV_PANEL_Background
    \ItemBackgroundColor = NAV_PANEL_Item_Background
    \ItemSelectedBackgroundColor = NAV_PANEL_Item_Selected_Background
    \ItemSelectedTextColor = NAV_PANEL_Item_Selected_Text
  EndWith
  
  SetNavigationPanelConfig(@navPanelConfig)
  
  statusBarId = CreateAppStatusBar(mainWindowId)
  menuBarId = CreateAppMenuBar(mainWindowId)
  toolBarId = CreateAppToolBar(mainWindowId)
  navPanelId = CreateNavigationPanel(mainWindowId)
  
  Repeat
    event = WaitWindowEvent()
    
    Select event
      Case #APP_EVENT_Download
        Debug "Download Action"
      Case #APP_EVENT_Setup
        Debug "Setup Action"
      Case #APP_EVENT_Manual
        Debug "Manual Action"
      Case #APP_EVENT_About
        Debug "About Action"
      Case #PB_Event_SizeWindow
        OnResizeMainWindow()
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
; CursorPosition = 111
; FirstLine = 72
; Folding = -
; EnableXP
; DPIAware