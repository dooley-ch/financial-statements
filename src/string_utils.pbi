;╔═════════════════════════════════════════════════════════════════════════════════════════════════
;║     string_utils.pbi                                                                           
;╠═════════════════════════════════════════════════════════════════════════════════════════════════
;║     Created: 26-06-2025 
;║
;║     Copyright (c) 2025 James Dooley <james@dooley.ch>
;║
;║     History:
;║     29-06-2025: Initial version
;╚═════════════════════════════════════════════════════════════════════════════════════════════════
DeclareModule StringUtils
  
  ; Returns True if the two given strings are the same
  Macro StrSame(value1, value2)
    (Bool(LCase(value1) = LCase(value2)))
  EndMacro
  
  ; Returns true if the given string begins with a given prefix, regardless of case
  Macro StrStartsWith(value, prefix)
    (Bool(Len(prefix) And (LCase(Left(value, Len(prefix))) = LCase(prefix))))
  EndMacro
  
  ; Returns true if the given string ends with a given prefix, regardless of case
  Macro StrEndsWith(value, suffix)
    (Bool(Len(suffix) And (LCase(Right(value, Len(suffix))) = LCase(suffix))))
  EndMacro
  
  ; Returns true if the string is empty
  Macro EmptyStr(value)
    (Bool(value = ""))
  EndMacro

EndDeclareModule

Module StringUtils
  EnableExplicit

  ;┌───────────────────────────────────────────────────────────────────────────────────────────────
  ;│     Public     
  ;└───────────────────────────────────────────────────────────────────────────────────────────────
EndModule
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - arm64)
; ExecutableFormat = Console
; CursorPosition = 32
; Folding = --
; EnableXP
; DPIAware