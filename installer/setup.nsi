# Auto-generated by EclipseNSIS Script Wizard
# 2012-1-25 10:56:35

Name "My Emacs For Common Lisp"

SetCompressor /SOLID lzma

RequestExecutionLevel admin

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 0.2.0.0
!define COMPANY "Xiaofeng Yang"
!define URL ""

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-colorful.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "My Emacs For Common Lisp"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-colorful.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_LANGDLL_REGISTRY_ROOT HKLM
!define MUI_LANGDLL_REGISTRY_KEY ${REGKEY}
!define MUI_LANGDLL_REGISTRY_VALUENAME InstallerLanguage

# Included files
!include Sections.nsh
!include MUI2.nsh
!include LogicLib.nsh
!include WinMessages.nsh
!include "WordFunc.nsh"

 
# Reserved Files
!insertmacro MUI_RESERVEFILE_LANGDLL

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE comp_leave
!insertmacro MUI_PAGE_COMPONENTS

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE dir_leave
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile setup.exe
InstallDir C:\mefcl
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 0.2.0.0
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName "My Emacs For Common Lisp"
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription ""
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

####################################################################################################

!macro ShellExecWait verb app param workdir show exitoutvar ;only app and show must be != "", every thing else is optional
#define SEE_MASK_NOCLOSEPROCESS 0x40 
System::Store S
System::Call '*(&i60)i.r0'
System::Call '*$0(i 60,i 0x40,i $hwndparent,t "${verb}",t $\'${app}$\',t $\'${param}$\',t "${workdir}",i ${show})i.r0'
System::Call 'shell32::ShellExecuteEx(ir0)i.r1 ?e'
${If} $1 <> 0
    System::Call '*$0(is,i,i,i,i,i,i,i,i,i,i,i,i,i,i.r1)' ;stack value not really used, just a fancy pop ;)
    System::Call 'kernel32::WaitForSingleObject(ir1,i-1)'
    System::Call 'kernel32::GetExitCodeProcess(ir1,*i.s)'
    System::Call 'kernel32::CloseHandle(ir1)'
${EndIf}
System::Free $0
!if "${exitoutvar}" == ""
    pop $0
!endif
System::Store L
!if "${exitoutvar}" != ""
    pop ${exitoutvar}
!endif
!macroend

####################################################################################################

# Installer sections
Section -Emacs SEC_EMACS
    SetOutPath $INSTDIR\emacs
    SetOverwrite on
    File /r /x .gitignore /x .git ..\body\emacs\*
    File packages\emacs-24.2.7z
    File 7za.exe
    WriteRegStr HKLM "${REGKEY}\Components" Emacs 1

    
    !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\emacs-24.2.7z"' "" ${SW_HIDE} ""

    Delete "$OUTDIR\7za.exe" 
    Delete "$OUTDIR\emacs-24.2.7z"

    # x86 libraries - Tcl/Tk (requires by the starter)        
    SetOutPath $INSTDIR
    SetOverwrite on
    File packages\active.tcltk85.7z
    File 7za.exe
    
    !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\active.tcltk85.7z"' "" ${SW_HIDE} ""

    Delete "$OUTDIR\7za.exe" 
    Delete "$OUTDIR\active.tcltk85.7z"
    
    # Starter
    SetOutPath $INSTDIR
    SetOverwrite on
    File ..\starter\Launcher.exe
    File ..\starter\Launcher.exe.conf
    
    # Create Start Menu Item for the starter
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\My Emacs For Common Lisp.lnk" "$INSTDIR\Launcher.exe" "" $INSTDIR\Launcher.exe 0
    !insertmacro MUI_STARTMENU_WRITE_END
    
SectionEnd

;Section -Consolas SEC_CONSOLAS
;    SetOutPath $INSTDIR
;    SetOverwrite on
;    File packages\consolas.exe
;    
;    # Example: ..\7za.exe x -oclisp clisp-2.49.7z
;    # !insertmacro ShellExecWait "" '"$OUTDIR\consolas.exe"' '/S /v/qn' "" ${SW_HIDE} ""
;    ExecWait '"$OUTDIR\consolas.exe" /S /v/qn'
;
;    # Delete "$OUTDIR\consolas.exe" 
;SectionEnd

SectionGroup /e Implementations SECGRP0000
    Section /o "ECL 12.12.1" SEC_ECL
        SetOutPath $INSTDIR\ecl-mingw
        SetOverwrite on
        File packages\ecl-12.12.1-mingw.7z
        File ..\body\ecl-mingw\run-ecl32-mingw.bat
        File 7za.exe
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        # ExecWait '"$OUTDIR\7za.exe" x "-o$OUTDIR" "$OUTDIR\ecl-12.12.1-mingw.7z"'
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\ecl-12.12.1-mingw.7z"' "" ${SW_HIDE} ""
        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\ecl-12.12.1-mingw.7z"
        
        # Write starter tag
        SetOutPath $INSTDIR
        SetOverwrite on
        File ..\body\ECL.starter-mark
        
        WriteRegStr HKLM "${REGKEY}\Components" "ECL 12.12.1" 1
        
        # Create Start Menu Items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with ECL 12.12.1.lnk" "$INSTDIR\emacs\start-ecl32-mingw.bat" "" $INSTDIR\ecl-mingw\ecl.exe 0
        !insertmacro MUI_STARTMENU_WRITE_END
    SectionEnd
    
    Section /o "CLISP 2.49" SEC_CLISP
        SetOutPath $INSTDIR\clisp
        SetOverwrite on
        File packages\clisp-2.49.7z
        File ..\body\clisp\run-clisp.bat
        File ..\body\clisp\startup.lisp
        File 7za.exe
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        # ExecWait '"$OUTDIR\7za.exe" x "-o$OUTDIR" "$OUTDIR\clisp-2.49.7z"'
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\clisp-2.49.7z"' "" ${SW_HIDE} ""
        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\clisp-2.49.7z"
        
        # Write starter tag
        SetOutPath $INSTDIR
        SetOverwrite on
        File ..\body\CLISP.starter-mark
      
        WriteRegStr HKLM "${REGKEY}\Components" "CLISP 2.49" 1
        
        # Create Start Menu Items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with CLISP 2.49.lnk" "$INSTDIR\emacs\start-clisp.bat" "" $INSTDIR\clisp\clisp.exe 0
        !insertmacro MUI_STARTMENU_WRITE_END
    SectionEnd


    Section /o "ABCL 1.1.1" SEC_ABCL
        SetOutPath $INSTDIR\abcl
        SetOverwrite on
        File packages\abcl-1.1.1.7z
        File /r ..\body\abcl\*
        File 7za.exe
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\abcl-1.1.1.7z"' "" ${SW_HIDE} ""
        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\abcl-1.1.1.7z"
        
        # Write starter tag
        SetOutPath $INSTDIR
        SetOverwrite on
        File ..\body\ABCL.starter-mark
        
        WriteRegStr HKLM "${REGKEY}\Components" "ABCL 1.1.1" 1

        # Create Start Menu Items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with ABCL 1.1.1.lnk" "$INSTDIR\emacs\start-abcl.bat" "" $INSTDIR\emacs\bin\runemacs.exe 0
        !insertmacro MUI_STARTMENU_WRITE_END

    SectionEnd

    Section /o "Clozure CL 1.8" SEC_CCL
        SetOutPath $INSTDIR\ccl
        SetOverwrite on
        File packages\ccl-1.8.7z
        File ..\body\ccl\logo.ico
        File ..\body\ccl\run-ccl32.bat
        File ..\body\ccl\run-ccl64.bat
        File 7za.exe
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\ccl-1.8.7z"' "" ${SW_HIDE} ""
        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\ccl-1.8.7z"

        # svn 1.6.5 to update ccl        
        SetOutPath $INSTDIR
        File packages\svn-1.6.5.7z
        File 7za.exe
        File ..\body\update-ccl.bat
        
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\svn-1.6.5.7z"' "" ${SW_HIDE} ""
        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\svn-1.6.5.7z"
        
        # Write starter tag
        SetOutPath $INSTDIR
        SetOverwrite on
        File ..\body\CCL32.starter-mark
        File ..\body\CCL64.starter-mark
        File ..\body\CCLUpdater.starter-mark
        
        WriteRegStr HKLM "${REGKEY}\Components" "Clozure CL 1.8" 1

        # Create Start Menu Items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with Clozure CL 1.8 (x86).lnk" "$INSTDIR\emacs\start-ccl32.bat" "" $INSTDIR\ccl\logo.ico
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with Clozure CL 1.8 (x86_64).lnk" "$INSTDIR\emacs\start-ccl64.bat" "" $INSTDIR\ccl\logo.ico
        !insertmacro MUI_STARTMENU_WRITE_END

    SectionEnd

    Section /o "SBCL 1.1.4" SEC_SBCL
        SetOutPath $INSTDIR\sbcl
        SetOverwrite on
        File packages\sbcl-1.1.4.0-source.7z
        File 7za.exe
        File /r ..\body\sbcl\*
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x "-o$OUTDIR\source" "$OUTDIR\sbcl-1.1.4.0-source.7z"' "" ${SW_HIDE} ""
        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\sbcl-1.1.4.0-source.7z"
        
        # Write starter tag
        SetOutPath $INSTDIR
        SetOverwrite on
        File ..\body\SBCL32.starter-mark
        File ..\body\SBCL64.starter-mark
        
        WriteRegStr HKLM "${REGKEY}\Components" "SBCL 1.1.4" 1
        
        # Create Start Menu Items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with SBCL 1.1.4 (x86).lnk" "$INSTDIR\emacs\start-sbcl32.bat" "" $INSTDIR\emacs\bin\runemacs.exe 0
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Emacs with SBCL 1.1.4 (x86_64).lnk" "$INSTDIR\emacs\start-sbcl64.bat" "" $INSTDIR\emacs\bin\runemacs.exe 0
        !insertmacro MUI_STARTMENU_WRITE_END
        
    SectionEnd


SectionGroupEnd

SectionGroup /e Dependencies SECGRP0001
    Section -MinGW SEC_MINGW
        SetOutPath $INSTDIR\mingw
        SetOverwrite on
        File packages\mingw32-with-gcc-4.7.2,msys1.0.7z
        # File ..\body\mingw\setup.bat # NOT NEED NOW
        File 7za.exe
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\mingw32-with-gcc-4.7.2,msys1.0.7z"' "" ${SW_HIDE} ""
        # !insertmacro ShellExecWait "" '"$OUTDIR\setup.bat"' '' "" ${SW_HIDE} "" # NOT NEED NOW

        Delete "$OUTDIR\7za.exe" 
        # Delete "$OUTDIR\setup.bat"  # NOT NEED NOW
        Delete "$OUTDIR\mingw32-with-gcc-4.7.2,msys1.0.7z"
        
        # Write starter tag
        SetOutPath $INSTDIR
        SetOverwrite on
        File ..\body\MSYS.starter-mark
        
        WriteRegStr HKLM "${REGKEY}\Components" MinGW 1
        
        # Create Start Menu Items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\MSYS 1.0.lnk" "$INSTDIR\mingw\msys\1.0\msys.bat" "" "$INSTDIR\mingw\msys\1.0\msys.ico"
        !insertmacro MUI_STARTMENU_WRITE_END
        
    SectionEnd
    
    Section /o "JDK 7.0" SEC_JAVA
        SetOutPath $INSTDIR\jvm
        SetOverwrite on
        File packages\jvm.7z
        File 7za.exe
        
        # Example: ..\7za.exe x -oclisp clisp-2.49.7z
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\jvm.7z"' "" ${SW_HIDE} ""

        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\jvm.7z"
        
        WriteRegStr HKLM "${REGKEY}\Components" "JDK 7.0" 1
    SectionEnd
    
    Section /o "Extra libraries" SEC_EXTRA_LIBS
        # x86 libraries    
        SetOutPath $INSTDIR\lib32
        SetOverwrite on
        File /nonfatal /r /x .svn ..\body\lib32\*

        # x86 libraries - gtk        
        SetOutPath $INSTDIR\lib32\gtk
        SetOverwrite on
        File packages\gtk+-bundle_2.24.10-20120208_win32.zip
        File 7za.exe
        
        !insertmacro ShellExecWait "" '"$OUTDIR\7za.exe"' 'x -y "-o$OUTDIR" "$OUTDIR\gtk+-bundle_2.24.10-20120208_win32.zip"' "" ${SW_HIDE} ""

        Delete "$OUTDIR\7za.exe" 
        Delete "$OUTDIR\jvm.7z"
        Delete "$OUTDIR\gtk+-bundle_2.24.10-20120208_win32.zip"
                
        # x86_64 libraries    TODO more test here
        SetOutPath $INSTDIR\lib64
        SetOverwrite on
        File /nonfatal /r /x .svn ..\body\lib64\*
        
        WriteRegStr HKLM "${REGKEY}\Components" "Extra libraries" 1
    SectionEnd
    
    
SectionGroupEnd

Section -post SEC0003
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
    
    # 给所有文件赋予所有用户可以使用的权限（只在win7测试过，重点不知道那个BUILTIN\Users是否XP里面也一样）
    SetOutPath $INSTDIR
    !insertmacro ShellExecWait "" 'cmd.exe' '/c echo y|cacls "$OUTDIR\*.*"  /t /c /g BUILTIN\Users:F' "" ${SW_HIDE} ""
    
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.MinGW UNSEC_MINGW
    SetShellVarContext all 
    Delete /REBOOTOK $INSTDIR\MSYS.starter-mark
    RmDir /r /REBOOTOK $INSTDIR\mingw
    DeleteRegValue HKLM "${REGKEY}\Components" MinGW
SectionEnd

Section /o "-un.JDK 7.0" UNSEC_JAVA
    SetShellVarContext all 
    RmDir /r /REBOOTOK $INSTDIR\jvm
    DeleteRegValue HKLM "${REGKEY}\Components" "JDK 7.0"
SectionEnd

Section /o "-un.Extra libraries" UNSEC_EXTRA_LIBS
    SetShellVarContext all 
    RmDir /r /REBOOTOK $INSTDIR\lib32
    RmDir /r /REBOOTOK $INSTDIR\lib64
    DeleteRegValue HKLM "${REGKEY}\Components" "Extra libraries"
SectionEnd

Section /o "-un.ECL 12.12.1" UNSEC_ECL
    SetShellVarContext all 
    Delete /REBOOTOK $INSTDIR\ECL.starter-mark
    RmDir /r /REBOOTOK $INSTDIR\ecl-mingw
    DeleteRegValue HKLM "${REGKEY}\Components" "ECL 12.12.1"
SectionEnd

Section /o "-un.CLISP 2.49" UNSEC_CLISP
    SetShellVarContext all 
    Delete /REBOOTOK $INSTDIR\CLISP.starter-mark
    RmDir /r /REBOOTOK $INSTDIR\clisp
    DeleteRegValue HKLM "${REGKEY}\Components" "CLISP 2.49"
SectionEnd

Section /o "-un.ABCL 1.1.1" UNSEC_ABCL
    SetShellVarContext all 
    Delete /REBOOTOK $INSTDIR\ABCL.starter-mark
    RmDir /r /REBOOTOK $INSTDIR\abcl
    DeleteRegValue HKLM "${REGKEY}\Components" "ABCL 1.1.1"
SectionEnd

Section /o "-un.Clozure CL 1.8" UNSEC_CCL
    SetShellVarContext all 
    Delete /REBOOTOK $INSTDIR\CCL32.starter-mark
    Delete /REBOOTOK $INSTDIR\CCL64.starter-mark
    Delete /REBOOTOK $INSTDIR\CCLUpdater.starter-mark
    Delete /REBOOTOK $INSTDIR\update-ccl.bat
    RmDir /r /REBOOTOK $INSTDIR\ccl
    RmDir /r /REBOOTOK $INSTDIR\svn-1.6.5
    DeleteRegValue HKLM "${REGKEY}\Components" "Clozure CL 1.8"
SectionEnd

Section /o "-un.SBCL 1.1.4" UNSEC_SBCL
    SetShellVarContext all 
    Delete /REBOOTOK $INSTDIR\SBCL32.starter-mark
    Delete /REBOOTOK $INSTDIR\SBCL64.starter-mark
    RmDir /r /REBOOTOK $INSTDIR\sbcl
    DeleteRegValue HKLM "${REGKEY}\Components" "SBCL 1.1.4"
SectionEnd

Section /o -un.Emacs UNSEC_EMACS
    SetShellVarContext all 
    RmDir /r /REBOOTOK $INSTDIR\emacs
    RmDir /r /REBOOTOK $INSTDIR\Tcl
    Delete /REBOOTOK $INSTDIR\Launcher.exe
    Delete /REBOOTOK $INSTDIR\Launcher.exe.conf
    # DeleteRegValue HKEY_CURRENT_USER "Software\GNU\Emacs" "HOME"
    DeleteRegValue HKLM "${REGKEY}\Components" Emacs
SectionEnd

Section -un.post UNSEC0003
    SetShellVarContext all 
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /r /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
SectionEnd

##################################################################################################################
# Installer functions
##################################################################################################################

Var Last_SEC_ECL_state
Var Last_SEC_MINGW_state
Var Last_SEC_ABCL_state
Var Last_SEC_JAVA_state

Function .onInit
    InitPluginsDir
    SetShellVarContext all
    !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function CheckDependenciesJRE7
    Push $R0
    Push $R1
 
    # Check if SEC_ABCL was just selected then select SEC_JAVA
    SectionGetFlags ${SEC_ABCL} $R0
    IntOp $R0 $R0 & ${SF_SELECTED}
    IntOp $R1 $Last_SEC_ABCL_state & ${SF_SELECTED}
    IntCmp $R1 $R0 CHECK_SEC_JAVA SELECT_MINGW
  
  SELECT_MINGW:
    SectionGetFlags ${SEC_JAVA} $R0
    IntOp $R0 $R0 | ${SF_SELECTED}
    SectionSetFlags ${SEC_JAVA} $R0
    
    Goto End
    
  # Unselect SEC_ABCL if SEC_JAVA were unselected
  CHECK_SEC_JAVA:
    SectionGetFlags ${SEC_JAVA} $R0
    IntOp $R0 $R0 & ${SF_SELECTED}
    IntOp $R1 $Last_SEC_JAVA_state & ${SF_SELECTED}
    IntCmp $R0 $R1 End UNSELECT_ECL
    
  UNSELECT_ECL:
    SectionGetFlags ${SEC_ABCL} $R0
    IntOp $R1 ${SF_SELECTED} ~
    IntOp $R0 $R0 & $R1
    SectionSetFlags ${SEC_ABCL} $R0
 
  End:
    # save current state
    SectionGetFlags ${SEC_JAVA} $Last_SEC_JAVA_state
    SectionGetFlags ${SEC_ABCL} $Last_SEC_ABCL_state
 
    Pop $R1
    Pop $R0
FunctionEnd

Function .onSelChange
  Call CheckDependenciesJRE7
FunctionEnd

Function comp_leave
    Push $R0
    Push $R1
    
    # User should choose at least one implementation
    IntOp $R0 0 + 0
    
    SectionGetFlags ${SEC_ECL} $R1
    IntOp $R1 $R1 & ${SF_SELECTED}
    IntOp $R0 $R1 | $R0 
    
    SectionGetFlags ${SEC_CLISP} $R1
    IntOp $R1 $R1 & ${SF_SELECTED}
    IntOp $R0 $R1 | $R0 
    
    SectionGetFlags ${SEC_ABCL} $R1
    IntOp $R1 $R1 & ${SF_SELECTED}
    IntOp $R0 $R1 | $R0 
    
    SectionGetFlags ${SEC_CCL} $R1
    IntOp $R1 $R1 & ${SF_SELECTED}
    IntOp $R0 $R1 | $R0 
    
    SectionGetFlags ${SEC_SBCL} $R1
    IntOp $R1 $R1 & ${SF_SELECTED}
    IntOp $R0 $R1 | $R0
    
    # if $R0 = 0 then message and Abort
    IntCmp $R0 0 NoImplementationSelected 

    Pop $R1
    Pop $R0
    
    Goto End
  
  NoImplementationSelected:
    Pop $R1
    Pop $R0
  
    MessageBox MB_OK|MB_ICONEXCLAMATION "You should choose at least one implementation!"    
    Abort

  End:
FunctionEnd

Function dir_leave
    Push $R0
    Push $R1
    
    ${StrFilter} "$INSTDIR" "12" ",.\:()-_+=" "|" $R1
    StrCmp $R1 "$INSTDIR" ValidPath InvalidPath  

  ValidPath:
    Pop $R1
    Pop $R0
    
    Goto End
    
  InvalidPath:
    Pop $R1
    Pop $R0
  
    MessageBox MB_OK|MB_ICONEXCLAMATION "The installation path allows only the following characters: $\r$\n           digits letters ,.\:()-_+="    
    Abort
    
  End:
FunctionEnd

##################################################################################################################

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MUI_UNGETLANGUAGE
    !insertmacro SELECT_UNSECTION Emacs ${UNSEC_EMACS}
    !insertmacro SELECT_UNSECTION "ECL 12.12.1" ${UNSEC_ECL}
    !insertmacro SELECT_UNSECTION "CLISP 2.49" ${UNSEC_CLISP}
    !insertmacro SELECT_UNSECTION "ABCL 1.1.1" ${UNSEC_ABCL}
    !insertmacro SELECT_UNSECTION "Clozure CL 1.8" ${UNSEC_CCL}
    !insertmacro SELECT_UNSECTION "SBCL 1.1.4" ${UNSEC_SBCL}
    !insertmacro SELECT_UNSECTION MinGW ${UNSEC_MINGW}
    !insertmacro SELECT_UNSECTION "JDK 7.0" ${UNSEC_JAVA}
    !insertmacro SELECT_UNSECTION "Extra libraries" ${UNSEC_EXTRA_LIBS}    
FunctionEnd

# Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_EMACS} $(SEC_EMACS_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_ECL} $(SEC_ECL_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_CLISP} $(SEC_CLISP_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_ABCL} $(SEC_ABCL_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_CCL} $(SEC_CCL_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_SBCL} $(SEC_SBCL_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_MINGW} $(SEC_MINGW_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_JAVA} $(SEC_JAVA_DESC)
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_EXTRA_LIBS} $(SEC_EXTRA_LIBS_DESC)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Installer Language Strings
# TODO Update the Language Strings with the appropriate translations.

LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString SEC_EMACS_DESC ${LANG_ENGLISH} "Emacs 23.1"
LangString SEC_ECL_DESC ${LANG_ENGLISH} "Embeddable Common Lisp 12.12.1 compiled with gcc 4.7.2, requires MinGW"
LangString SEC_CLISP_DESC ${LANG_ENGLISH} "CLISP 2.49 (MinGW)"
LangString SEC_ABCL_DESC ${LANG_ENGLISH} "Armed Bear Common Lisp 1.1.1 with full source, requires JRE 7"
LangString SEC_CCL_DESC ${LANG_ENGLISH} "Clozure CL 1.8 (both x86, x86_64 are included)"
LangString SEC_SBCL_DESC ${LANG_ENGLISH} "Steel Bank Common Lisp 1.1.4 with threads support (full source, and both x86, x86_64 are included)"
LangString SEC_MINGW_DESC ${LANG_ENGLISH} "MinGW with MSYS 1.0 included"
LangString SEC_JAVA_DESC ${LANG_ENGLISH} "Java Development Kit 7.0"
LangString SEC_EXTRA_LIBS_DESC ${LANG_ENGLISH} "Useful DLLs required by some Common Lisp libraries (optional)"


