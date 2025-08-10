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
XIncludeFile "main_panel.pbi"

UseModule Consts
UseModule SetupModule
UseModule FileUtils
UseModule Logger
UseModule StatusBarModule
UseModule MenuBarModule
UseModule ToolBarModule
UseModule NavigationPanelUI
UseModule MainPanelUI

UsePNGImageDecoder()

;-------- Support Routines & Variables --------
Define.i mainWindowId, menuBarId, toolBarId, statusBarId, navPanelId, mainPanelId, event
Define mainWindowLocation.WindowLocation
Define navPanelConfig.NavigationPanelConfigInfo
Define.i exitCode = #EXIT_SUCCESS

  Enumeration NavItemIds 
    #NAV_ITEM_Download
  EndEnumeration
;-------- Navigation Panel Callbacks --------

Procedure OnDownloadItemClicked()
  Shared mainWindowId
  PostEvent(#APP_EVENT_Download, mainWindowId, #PB_Ignore, #PB_Ignore)
EndProcedure
  
;┌───────────────────────────────────────────────────────────────────────────────────────────────
;│     Event Handlers    
;└───────────────────────────────────────────────────────────────────────────────────────────────

; Handles the resizing of the main window
;
; Note: calculates and resizes navigation panel and the display panel
;
Procedure OnResizeMainWindow()
  Shared mainWindowId, navPanelId, mainPanelId, statusBarId
  Protected.i mainWindowHeight, mainWindowWidth, panelX, panelWidth
  
  mainWindowHeight = WindowHeight(mainWindowId, #PB_Window_InnerCoordinate) - StatusBarHeight(statusBarId)
  mainWindowWidth = WindowWidth(mainWindowId, #PB_Window_InnerCoordinate)
  
  ; Resize the Nav Panel
  If IsGadget(navPanelId)
    ResizeGadget(navPanelId, 0, 0, #WND_MAIN_NavPanel_Width, mainWindowHeight)
  EndIf
  
  ; Resize the Display Panel
  If IsGadget(mainPanelId)
    panelX = #WND_MAIN_NavPanel_Width
    panelWidth = mainWindowWidth - panelX
    
    ResizeGadget(mainPanelId, panelX, 0, panelWidth, mainWindowHeight)
  EndIf
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
  
  Define.i hNavItemIcon, hNavItemHotIcon, hNavIconDisabledIcon
    
  ; Configure the navigation panel
  InitNavigationPanelConfig(@navPanelConfig)
  
  With navPanelConfig
    \BackgroundColor = NAV_PANEL_Background
    \ItemBackgroundColor = NAV_PANEL_Item_Background
    \ItemSelectedBackgroundColor = NAV_PANEL_Item_Selected_Background
    \ItemSelectedTextColor = NAV_PANEL_Item_Selected_Text
  EndWith
  
  SetNavigationPanelConfig(@navPanelConfig)
  
  hNavItemIcon = CatchImage(#PB_Any, ?ActionDownloadIcon)
  hNavItemHotIcon = CatchImage(#PB_Any, ?ActionDownloadHotIcon)
  hNavIconDisabledIcon = CatchImage(#PB_Any, ?ActionDownloadDisabledIcon)
  
  AddNavigationItem(#NAV_ITEM_Download, "Download", ImageID(hNavItemIcon), @OnDownloadItemClicked(), ImageID(hNavItemHotIcon), ImageID(hNavIconDisabledIcon)) 
  
  ; Create main window gadgets
  statusBarId = CreateAppStatusBar(mainWindowId)
  menuBarId = CreateAppMenuBar(mainWindowId)
  toolBarId = CreateAppToolBar(mainWindowId)
  navPanelId = CreateNavigationPanel(mainWindowId)
  mainPanelId = CreateMainPanel(mainWindowId)
  
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

DataSection  
  ActionDownloadIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/toolbar-menu/download@48px.png"   
  
  ActionDownloadHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/toolbar-menu/hot/download@48px.png" 
  
  ActionDownloadDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/toolbar-menu/disabled/download@48px.png"   
EndDataSection
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 122
; FirstLine = 88
; Folding = -
; EnableXP
; DPIAware