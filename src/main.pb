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
XIncludeFile "setup_ui.pbi"
XIncludeFile "messageboxes.pbi"
XIncludeFile "about_ui.pbi"

UseModule Consts
UseModule SetupModule
UseModule FileUtils
UseModule Logger
UseModule StatusBarModule
UseModule MenuBarModule
UseModule ToolBarModule
UseModule NavigationPanelUI
UseModule MainPanelUI
UseModule SetupUI
UseModule MessageBoxeaUI
UseModule AboutUI

UsePNGImageDecoder()

;-------- Support Routines & Variables --------
Define.i hMainWindowId, hMenuBarId, hToolBarId, hStatusBarId, hNavPanelId, hMainPanelId, event
Define mainWindowLocation.WindowLocation
Define navPanelConfig.NavigationPanelConfigInfo
Define.i exitCode = #EXIT_SUCCESS

  Enumeration NavItemIds 100 
    #NAV_ITEM_Download
    #NAV_ITEM_Import
    #NAV_ITEM_Build
    #NAV_ITEM_Publish
  EndEnumeration
  
;-------- Navigation Panel Callbacks --------

Procedure OnDownloadItemClicked()
  Shared hMainWindowId
  PostEvent(#APP_EVENT_Download, hMainWindowId, #PB_Ignore, #PB_Ignore)
EndProcedure

Procedure OnImportItemClicked()
  Shared hMainWindowId
  PostEvent(#APP_EVENT_Import, hMainWindowId, #PB_Ignore, #PB_Ignore)
EndProcedure

Procedure OnBuildItemClicked()
  Shared hMainWindowId
  PostEvent(#APP_EVENT_Build, hMainWindowId, #PB_Ignore, #PB_Ignore)
EndProcedure

Procedure OnPublishItemClicked()
  Shared hMainWindowId
  PostEvent(#APP_EVENT_Publish, hMainWindowId, #PB_Ignore, #PB_Ignore)
EndProcedure

;-------- Functionality --------

Procedure OnShowAboutDialog()
  Shared hMainWindowId
  
  If Not ShowAboutDialog(hMainWindowId)
    LogError(AboutUIError())
  EndIf
EndProcedure

Procedure OnOpenSetupDialog()
  Shared hMainWindowId
  
  If Not OpenSettingsDialog(hMainWindowId)
    LogError(SetupUIError())
  EndIf
EndProcedure

;┌───────────────────────────────────────────────────────────────────────────────────────────────
;│     Event Handlers    
;└───────────────────────────────────────────────────────────────────────────────────────────────

; Handles the resizing of the main window
;
; Note: calculates and resizes navigation panel and the display panel
;
Procedure OnResizeMainWindow()
  Shared hMainWindowId, hNavPanelId, hMainPanelId, hStatusBarId
  Protected.i mainWindowHeight, mainWindowWidth, panelX, panelWidth
  
  mainWindowHeight = WindowHeight(hMainWindowId, #PB_Window_InnerCoordinate) - StatusBarHeight(hStatusBarId)
  mainWindowWidth = WindowWidth(hMainWindowId, #PB_Window_InnerCoordinate)
  
  ; Resize the Nav Panel
  If IsGadget(hNavPanelId)
    ResizeGadget(hNavPanelId, 0, 0, #WND_MAIN_NavPanel_Width, mainWindowHeight)
  EndIf
  
  ; Resize the Display Panel
  If IsGadget(hMainPanelId)
    panelX = #WND_MAIN_NavPanel_Width
    panelWidth = mainWindowWidth - panelX
    
    ResizeGadget(hMainPanelId, panelX, 0, panelWidth, mainWindowHeight)
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

hMainWindowId = OpenWindow(#PB_Any, mainWindowLocation\X, mainWindowLocation\Y, mainWindowLocation\Width, mainWindowLocation\Height, #APP_TITLE$ + " (" + #APP_VERSION$ + ")", #MainWindowFlags)
If IsWindow(hMainWindowId)
  WindowBounds(hMainWindowId, #WND_MAIN_min_width, #WND_MAIN_min_height, #WND_MAIN_max_width, #WND_MAIN_max_height)
  SetWindowColor(hMainWindowId, WND_Background)
  
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
  
  hNavItemIcon = CatchImage(#PB_Any, ?ActionImportIcon)
  hNavItemHotIcon = CatchImage(#PB_Any, ?ActionImportHotIcon)
  hNavIconDisabledIcon = CatchImage(#PB_Any, ?ActionImportDisabledIcon)
  AddNavigationItem(#NAV_ITEM_Import, "Import", ImageID(hNavItemIcon), @OnImportItemClicked(), ImageID(hNavItemHotIcon), ImageID(hNavIconDisabledIcon)) 
  
  hNavItemIcon = CatchImage(#PB_Any, ?ActionBuildIcon)
  hNavItemHotIcon = CatchImage(#PB_Any, ?ActionBuildHotIcon)
  hNavIconDisabledIcon = CatchImage(#PB_Any, ?ActionBuildDisabledIcon)
  AddNavigationItem(#NAV_ITEM_Build, "Build", ImageID(hNavItemIcon), @OnBuildItemClicked(), ImageID(hNavItemHotIcon), ImageID(hNavIconDisabledIcon)) 
  
  hNavItemIcon = CatchImage(#PB_Any, ?ActionPublishIcon)
  hNavItemHotIcon = CatchImage(#PB_Any, ?ActionPublishHotIcon)
  hNavIconDisabledIcon = CatchImage(#PB_Any, ?ActionPublishDisabledIcon)
  AddNavigationItem(#NAV_ITEM_Publish, "Publish", ImageID(hNavItemIcon), @OnPublishItemClicked(), ImageID(hNavItemHotIcon), ImageID(hNavIconDisabledIcon)) 
  
  ; Create main window gadgets
  hStatusBarId = CreateAppStatusBar(hMainWindowId)
  hMenuBarId = CreateAppMenuBar(hMainWindowId)
  hToolBarId = CreateAppToolBar(hMainWindowId)
  hNavPanelId = CreateNavigationPanel(hMainWindowId)
  hMainPanelId = CreateMainPanel(hMainWindowId)
  
  Define exitApp.b = #False
  
  Repeat
    event = WaitWindowEvent()
    
    Select event
      Case #APP_EVENT_Download
        Debug "Download Action"
      Case #APP_EVENT_Import
        Debug "Import Action"
      Case #APP_EVENT_Build
        Debug "Build Action"
      Case #APP_EVENT_Publish
        Debug "Publish Action"
      Case #APP_EVENT_Setup
        OnOpenSetupDialog()
      Case #APP_EVENT_Manual
        Debug "Manual Action"
      Case #APP_EVENT_About
        OnShowAboutDialog()
      Case #PB_Event_SizeWindow
        OnResizeMainWindow()
      Case #PB_Event_CloseWindow, #APP_EVENT_Quit
        exitApp = ConfirmActionMessage(hMainWindowId, "Are you sure you'd like to exit the application?")
    EndSelect
  Until exitApp
  
  With mainWindowLocation
    \X = WindowX(hMainWindowId, #PB_Window_FrameCoordinate)
    \Y = WindowY(hMainWindowId, #PB_Window_FrameCoordinate)
    \Height = WindowHeight(hMainWindowId, #PB_Window_InnerCoordinate)
    \Width = WindowWidth(hMainWindowId, #PB_Window_InnerCoordinate)
  EndWith
  
  StoreWindowLocation(#WND_MAIN_cfg_name, @mainWindowLocation)
  
  CloseWindow(hMainWindowId)
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
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/download@48px.png"   
  
  ActionDownloadHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/hot/download@48px.png" 
  
  ActionDownloadDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/disabled/download@48px.png"   
  
  ActionImportIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/import@48px.png"   
  
  ActionImportHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/hot/import@48px.png" 
  
  ActionImportDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/disabled/import@48px.png"  
  
  ActionBuildIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/build@48px.png"   
  
  ActionBuildHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/hot/build@48px.png" 
  
  ActionBuildDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/disabled/build@48px.png" 
  
  ActionPublishIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/publish@48px.png"   
  
  ActionPublishHotIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/hot/publish@48px.png" 
  
  ActionPublishDisabledIcon:
  IncludeBinary #PB_Compiler_FilePath + "res/nav-panel/disabled/publish@48px.png"  
EndDataSection
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 239
; FirstLine = 84
; Folding = --
; EnableXP
; DPIAware