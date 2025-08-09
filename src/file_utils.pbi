;╔═════════════════════════════════════════════════════════════════════════════════════════════════
;║     file_utils.pbi                                                                           
;╠═════════════════════════════════════════════════════════════════════════════════════════════════
;║     Created: 29-06-2025 
;║
;║     Copyright (c) 2025 James Dooley <james@dooley.ch>
;║
;║     History:
;║     29-06-2025: Initial version
;╚═════════════════════════════════════════════════════════════════════════════════════════════════
DeclareModule FileUtils
  
  Declare.s MakePath(basePart$, value$) ; Constructs a file or folder path from the supplied parts using the system path separator
  Declare.b FileExists(value$)          ; Checks if a file exists
  Declare.b FolderExists(value$)        ; Checks if a folder exists
  
  Declare.s GetApplicationDataFolder() ; Returns the application's data folder

EndDeclareModule

Module FileUtils
  EnableExplicit
  
  UseModule Consts
  
  ; Sets the path separator for the given operating system
  CompilerIf (#PB_Compiler_OS = #PB_OS_Windows) 
    #PATH_SEPARATOR = "\"
  CompilerElse
    #PATH_SEPARATOR = "/"
  CompilerEndIf
  
  ; Flags for checking the return value of the FileSize function
  #FileSize_FileNotFound = -1
  #FileSize_Directory = -2
  
  ; Returns true if the given string ends with a given prefix, regardless of case
  Macro StrEndsWith(value, suffix)
    (Bool(Len(suffix) And (LCase(Right(value, Len(suffix))) = LCase(suffix))))
  EndMacro
  
  ;┌───────────────────────────────────────────────────────────────────────────────────────────────
  ;│     Public     
  ;└───────────────────────────────────────────────────────────────────────────────────────────────
  
  ; Constructs a file or folder path from the supplied parts using the system path separator
  Procedure.s MakePath(basePart$, value$) 
    If StrEndsWith(basePart$, #PATH_SEPARATOR)
      ProcedureReturn basePart$ + value$
    EndIf
    
    ProcedureReturn basePart$ + #PATH_SEPARATOR + value$
  EndProcedure
  
  ; Checks if a file exists
  Procedure.b FileExists(value$) 
    ProcedureReturn Bool(FileSize(value$) <> #FileSize_FileNotFound)
  EndProcedure
  
  ; Checks if a folder exists
  Procedure.b FolderExists(value$)  
    ProcedureReturn (Bool(FileSize(value$) = #FileSize_Directory))
  EndProcedure
  
  Procedure.s GetApplicationDataFolder()
    Protected homeFolder$ = GetHomeDirectory()
    Protected orgDataFolder$ = MakePath(homeFolder$, #APP_ORGANISATION$)
    Protected appDataFolder$ = MakePath(orgDataFolder$, #APP_DATA_FOLDER$)
    
    If Not FolderExists(orgDataFolder$)
      If Not CreateDirectory(orgDataFolder$)
        Debug "Failed to create application organisation folder - check permissions"
      EndIf
    EndIf
    
    If Not FolderExists(appDataFolder$)
      If Not CreateDirectory(appDataFolder$)
        Debug "Failed to create application data folder - check permissions"
      EndIf
    EndIf
    
    ProcedureReturn appDataFolder$
  EndProcedure
  
EndModule
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 20
; Folding = --
; EnableXP
; DPIAware