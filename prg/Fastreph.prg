///////////////////////////////////////////////////////////////////////////////
//
//  FastRepH.PRG
//
//  Copyright:
//       Spirin Sergey, Paritet Soft, (c) 1992-2008. All rights reserved.
//  
//  Contents:
//       Source File for frReportManager and other classes for 
//       "FastReport for [x]Harbour"
//   
///////////////////////////////////////////////////////////////////////////////


#pragma BEGINDUMP

#include "windows.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbapirdd.h"
#include "hbxvm.h"

typedef void *pointer;

typedef void (*proc_)(void);
typedef void (*proc_I)(long param1);
typedef void (*proc_IP) (int funcnum, pointer adr);
typedef void (*proc_C)(char * param);
typedef void (*proc_IC)(int param1, char * param2);
typedef void (*proc_CC)(char * param1, char * param2);
typedef void (*proc_CCC)(char * param1, char * param2, char * param3);
typedef void (*proc_IIII)(long param1, long param2, long param3, long param4);

typedef LONG (*func__I)(void);
typedef LONG (*func_I_I)(long param);
typedef LONG (*func_C_I)(char * param);
typedef LONG (*func_II_I)(long param1, long param2);
typedef LONG (*func_IC_I)(long param1, char * param2);
typedef LONG (*func_CC_I)(char * param1, char * param2);
typedef LONG (*func_CCC_I)(char * param1, char * param2, char * param3);
typedef LONG (*func_CCI_I)(char * param1, char * param2, long param3);
typedef LONG (*func_III_I)(long param1, long param2, long param3);
typedef LONG (*func_CIII_I)(char * param1, long param2, long param3, long param4);

typedef LONG (*func_CICCCCCCCC_I)(char * param1, long param2, char * param3, char * param4, char * param5,
                                  char * param6, char * param7, char * param8, char * param9, char * param10);

   
HB_FUNC( FRLOAD )
{
   hb_retnl((long)(HMODULE)LoadLibrary((char *)hb_parc(1)));  
}

HB_FUNC( GETFRPROCADDRESS )
{
   hb_retnl((long)(FARPROC)GetProcAddress((HMODULE)hb_parnl(1) , (char *)hb_parc(2)));
}

HB_FUNC( FRUNLOAD )
{
   FreeLibrary((HMODULE)hb_parnl(1));
}


HB_FUNC( CALL_PROC_ )
{
   proc_ CurProc = (proc_)hb_parnl(1);
   CurProc();
}

HB_FUNC( CALL_PROC_I )
{   
   proc_I CurProc = (proc_I)hb_parnl(1);
   CurProc(hb_parnl(2));
}

HB_FUNC( CALL_PROC_C )
{   
   proc_C CurProc = (proc_C)hb_parnl(1);
   CurProc((char *)hb_parc(2));
}

HB_FUNC( CALL_PROC_IC )
{   
   proc_IC CurProc = (proc_IC)hb_parnl(1);
   CurProc(hb_parnl(2), (char *)hb_parc(3));
}

HB_FUNC( CALL_PROC_CC )
{   
   proc_CC CurProc = (proc_CC)hb_parnl(1);
   CurProc((char *)hb_parc(2), (char *)hb_parc(3));
}

HB_FUNC( CALL_PROC_CCC )
{   
   proc_CCC CurProc = (proc_CCC)hb_parnl(1);
   CurProc((char *)hb_parc(2), (char *)hb_parc(3), (char *)hb_parc(4));
}


HB_FUNC( CALL_PROC_IIII )
{   
   proc_IIII CurProc = (proc_IIII)hb_parnl(1);
   CurProc(hb_parnl(2), hb_parnl(3), hb_parnl(4), hb_parnl(5));
}


HB_FUNC( CALL_FUNC__I )
{     
   func__I CurFunc = (func__I)hb_parnl(1);     
   hb_retnl(CurFunc());
}

HB_FUNC( CALL_FUNC_I_I )
{     
   func_I_I CurFunc = (func_I_I)hb_parnl(1);     
   hb_retnl(CurFunc(hb_parnl(2)));
}

HB_FUNC( CALL_FUNC_C_I )
{
   func_C_I CurFunc = (func_C_I)hb_parnl(1);     
   hb_retnl(CurFunc((char *)hb_parc(2)));
}

HB_FUNC( CALL_FUNC_II_I )
{     
   func_II_I CurFunc = (func_II_I)hb_parnl(1);     
   hb_retnl(CurFunc(hb_parnl(2), hb_parnl(3)));
}

HB_FUNC( CALL_FUNC_IC_I )
{     
   func_IC_I CurFunc = (func_IC_I)hb_parnl(1);     
   hb_retnl(CurFunc(hb_parnl(2), (char *)hb_parc(3)));
}

HB_FUNC( CALL_FUNC_CC_I )
{     
   func_CC_I CurFunc = (func_CC_I)hb_parnl(1);     
   hb_retnl(CurFunc((char *)hb_parc(2), (char *)hb_parc(3)));
}

HB_FUNC( CALL_FUNC_CCC_I )
{     
   func_CCC_I CurFunc = (func_CCC_I)hb_parnl(1);     
   hb_retnl(CurFunc((char *)hb_parc(2), (char *)hb_parc(3), (char *)hb_parc(4)));
}

HB_FUNC( CALL_FUNC_CCI_I )
{     
   func_CCI_I CurFunc = (func_CCI_I)hb_parnl(1);     
   hb_retnl(CurFunc((char *)hb_parc(2), (char *)hb_parc(3), hb_parnl(4)));
}

HB_FUNC( CALL_FUNC_III_I )
{   
   func_III_I CurFunc = (func_III_I)hb_parnl(1);     
   hb_retnl(CurFunc(hb_parnl(2), hb_parnl(3), hb_parnl(4)));
}

HB_FUNC( CALL_FUNC_CIII_I )
{     
   func_CIII_I CurFunc = (func_CIII_I)hb_parnl(1);     
   hb_retnl(CurFunc((char *)hb_parc(2), hb_parnl(3), hb_parnl(4), hb_parnl(5)));
}

HB_FUNC( CALL_FUNC_CICCCCCCCC_I )
{     
   func_CICCCCCCCC_I CurFunc = (func_CICCCCCCCC_I)hb_parnl(1);     
   hb_retnl(CurFunc((char *)hb_parc(2), hb_parnl(3), (char *)hb_parc(4), (char *)hb_parc(5), (char *)hb_parc(6), (char *)hb_parc(7), (char *)hb_parc(8),
                    (char *)hb_parc(9), (char *)hb_parc(10), (char *)hb_parc(11)));
}


USHORT TmpGetWA( AREAP area, void * ptr)
{   
   proc_I CurFunc = (proc_I)ptr;
   CurFunc(area->uiArea);  
   return 0;
}

long GetPAOptions(char * opt)
{  strcpy(opt, "227078209018115119019067064069218186161172089234214070110117037156248190034095088177245181054170022035219121155107237077212003");
   return 1;  
}

HB_FUNC( INITENGINE )
{

   proc_IP InitEng = (proc_IP)GetProcAddress((HMODULE)hb_parnl(1) , "InitEngine");
   
   if (InitEng)
   {
      InitEng(1, hb_itemNew);
      InitEng(2, hb_itemRelease);
      InitEng(3, hb_itemPutNI);
      InitEng(4, hb_itemGetNI);
      
      InitEng(6, hb_dynsymGetSymbol);
           
      InitEng(10, hb_itemType);
      InitEng(11, hb_itemGetPtr);
      InitEng(12, hb_itemGetNL);
      InitEng(13, hb_itemGetND);
      InitEng(14, hb_itemGetDS);
      InitEng(15, hb_itemGetL);
      InitEng(16, hb_itemGetCLen);
      InitEng(17, hb_itemCopyC);
      InitEng(18, hb_itemArrayGet);
      InitEng(19, hb_arrayLen);
      InitEng(20, hb_itemPutPtr);
      InitEng(21, hb_itemPutNL);
      InitEng(22, hb_itemPutND);
      InitEng(23, hb_itemPutDS);
      InitEng(24, hb_itemPutL);
      InitEng(25, hb_itemPutC);
      InitEng(26, hb_itemArrayNew);
      InitEng(27, hb_itemArrayPut);
      InitEng(28, hb_vmPush);
      InitEng(29, hb_vmPushSymbol);
      InitEng(30, hb_vmPushNil);
      InitEng(31, hb_dynsymFindSymbol);
      InitEng(32, hb_vmDo);
      InitEng(33, hb_param);
      InitEng(34, hb_itemClear);
   
      InitEng(35, hb_macroCompile);   
      InitEng(36, hb_macroRun);
      InitEng(37, hb_macroDelete);
      
      InitEng(38, hb_xvmRetValue);
   
      InitEng(39, hb_rddGetCurrentWorkAreaNumber);
      InitEng(40, hb_rddSelectWorkAreaNumber);
      InitEng(41, hb_rddGetFieldValue);
      InitEng(42, hb_rddPutFieldValue);
      InitEng(43, hb_itemGetNLL);
      InitEng(44, hb_itemPutNLL);
      InitEng(45, hb_itemCopy);
      InitEng(46, GetPAOptions);
   
      InitEng(47, hb_vmFunction);
      InitEng(48, hb_vmEvalBlock);
      InitEng(49, hb_vmEvalBlockV);
      InitEng(50, hb_vmEvalBlockOrMacro);
      InitEng(51, hb_itemPutCL);
      InitEng(52, hb_rddIterateWorkAreas);
      InitEng(53, TmpGetWA);

#ifdef HB_IT_DATETIME 
#ifdef __XHARBOUR__ 
      InitEng(54, hb_itemGetDTS);
      InitEng(55, hb_itemPutDTS); 
      InitEng(56, (pointer)2);
#else 
      InitEng(54, hb_itemGetTS);
      InitEng(55, hb_itemPutTS); 
      InitEng(56, (pointer)1);
#endif 
#else 
      InitEng(54, NULL);
      InitEng(55, NULL);
      InitEng(56, NULL);
#endif 


   }

}

 
              
#pragma ENDDUMP

#include "hbclass.ch"
#include "error.ch"
#include "common.ch"
#include "FastRepH.ch"

EXTERNAL EVAL
EXTERNAL DBSKIP
EXTERNAL ALIAS
EXTERNAL DBUSEAREA
EXTERNAL DBCLOSEAREA
EXTERNAL ORDSCOPE
EXTERNAL BOF
EXTERNAL EOF
EXTERNAL DBGOBOTTOM     
EXTERNAL DBGOTOP        
EXTERNAL DBDELETE       
EXTERNAL DBGOTO         
EXTERNAL SELECT        
EXTERNAL DBSELECTAREA   
EXTERNAL SET            
EXTERNAL ORDSETFOCUS    
EXTERNAL DBAPPEND       
EXTERNAL DBRLOCK        
EXTERNAL NETERR         
EXTERNAL DBUNLOCK       
EXTERNAL RECNO          
EXTERNAL ORDCONDSET     
EXTERNAL ORDCOUNT       
EXTERNAL ORDLISTADD     
EXTERNAL ORDNAME        
EXTERNAL ORDKEY         
EXTERNAL ORDFOR         
EXTERNAL ORDLISTCLEAR   
EXTERNAL DBSEEK         
EXTERNAL LASTREC        
EXTERNAL DBSETRELATION  
EXTERNAL DBCLEARRELATION
EXTERNAL DBSETFILTER    
EXTERNAL DBCLEARFILTER  
EXTERNAL __DBLOCATE     
EXTERNAL __MVGET
EXTERNAL __MVPUT
EXTERNAL __MVEXIST


//////////////////////////////////////////////////////////////////////
// frReportManager - this class is the main one.
//                   The class has all necessary methods for report
//                   loading and saving, design and viewing etc.
//////////////////////////////////////////////////////////////////////

CLASS frReportManager
   Hidden:
     VAR  _InitSyst, _FrNotifyError, _CloseSyst, _SetIcon, _SetTitle, _SetVisualActions,;
          _LoadLangRes, _ShowReport, _PrepareReport, _ShowPreparedReport, _DesignReport,;
          _LoadFromFile, _LoadFromResource, _LoadFromBlob, _SaveToFile, _SaveToBlob, _Clear,;
          _LoadFPFile, _SaveToFPFile, _SetFormatSettings,;
          _LoadStyleSheet, _Print, _GetErrors,;
          _DoExport, _GetProperty, _SetProperty, _SetEventHandler, _AddFunction,;
          _AddVariable, _SetVariable, _GetVariable, _DeletVariable, _DeletCategory,;
          _SetScriptVar, _GetScriptVar, _Calc, _SetWorkArea, _SetMasterDetail, _SetResyncPair,;
          _SetUserDataSet, _Resync, _SetFieldAliases, _RemoveDataSet, _ClearDataSets,;
          _ClearMasterDetail, _ClearResyncPair, _SetADOConnectStr, _SetADOConnectPartStr,;
          _StartManualBuild, _MemoAt, _SetDefaultFontProperty, _NewPage, _SetManualObjProperty,;
          _LineAt, _PictureAt, _SendMail, _frMsgBox, _frInputBox, _LoadFromString, _SaveToString,;
          _SetFileName, _SetTabTreeExpanded, _NewReport, _AddPage, _AddBand, _AddGlobalDsToReport,;
          _SetObjProperty, _AddMemo, _AddLine, _AddPicture, _LoadStyleSheetFromString, _GetGlobalDSList,;
          _IsObjectExists, _CreateFRObject, _EnumAllObjects, _GetPropList, _PrepareScript,;
          _AddReport, _SelectReport, _RemoveReport, _ClearReports, _SetTxtDataSet


      METHOD PrepareCalls

   EXPORTED:
      
      VAR bSaveError                // Save Error handler 
      CLASSVAR frSystHandle  init 0      // Handle of FastReport-dll
      VAR PrintOptions              // look frPrintOptions class
      VAR PreviewOptions            // look frPreviewOptions class
      VAR EngineOptions             // look frEngineOptions class
      VAR ReportOptions             // look frReportOptions class
      CLASSVAR bDbStruct init NIL
     
      METHOD Init
      METHOD FrNotifyError
      METHOD SetIcon
      METHOD SetTitle
      METHOD SetVisualActions
      METHOD LoadLangRes
      METHOD SetFormatSettings
      METHOD DestroyFR      
                  
      METHOD ShowReport
      METHOD ShowPreparedReport
      METHOD PrepareReport
      METHOD DesignReport
      METHOD LoadFromFile
      METHOD LoadFromResource
      METHOD LoadFromBlob
      METHOD LoadFromString
      METHOD SaveToFile
      METHOD SaveToBlob
      METHOD SaveToString
      METHOD SetFileName
      METHOD Clear
      METHOD LoadFPFile
      METHOD SaveToFPFile
      METHOD AddReport
      METHOD SelectReport
      METHOD RemoveReport
      METHOD ClearReports
      
      METHOD Print
      METHOD GetErrors
      METHOD DoExport
      METHOD LoadStyleSheet
      METHOD LoadStyleSheetFromString

      METHOD GetProperty
      METHOD SetProperty       
      METHOD SetEventHandler
      METHOD AddFunction
      METHOD SetObjProperty

      METHOD AddVariable
      METHOD SetVariable
      METHOD GetVariable
      METHOD DeleteVariable
      METHOD DeleteCategory

      METHOD SetScriptVar
      METHOD GetScriptVar
      METHOD Calc

      METHOD SetWorkArea
      METHOD SetMasterDetail
      METHOD SetResyncPair
      METHOD SetUserDataSet
      METHOD SetTxtDataSet
      METHOD SetFieldAliases
      METHOD Resync
      METHOD ClearMasterDetail
      METHOD ClearResyncPair    
      METHOD RemoveDataSet
      METHOD ClearDataSets
      METHOD SetADOConnectStr
      METHOD SetADOConnectPartStr

      METHOD StartManualBuild
      METHOD MemoAt
      METHOD SetDefaultFontProperty
      METHOD NewPage
      METHOD SetManualObjProperty
      METHOD LineAt
      METHOD PictureAt

      METHOD NewReport
      METHOD AddPage
      METHOD AddBand
      METHOD AddGlobalDsToReport
      METHOD GetGlobalDSList
      METHOD AddMemo
      METHOD AddLine
      METHOD AddPicture

      METHOD IsObjectExists
      METHOD CreateFRObject
      METHOD EnumAllObjects
      METHOD GetPropList
      METHOD PrepareScript
      
      METHOD SendMail  
      METHOD InputBox
      METHOD SetTabTreeExpanded
        
ENDCLASS


////////////////////////////////////////////////////////////////////////
/////////////--start of frReportManager class--/////////////////////////
////////////////////////////////////////////////////////////////////////
//  Init()
////////////////////////////////////////////////////////////////////////


METHOD Init( cOptionalPath ) class frReportManager  
LOCAL oError

   IF ::frSystHandle == 0
      cOptionalPath := IF(cOptionalPath <> NIL, cOptionalPath, "FrSystH.dll")  
      ::frSystHandle := FrLoad(cOptionalPath)
      IF ::frSystHandle <> 0 
         ::PrepareCalls()
         Call_Func__I(::_InitSyst)
   
         ::PrintOptions := frPrintOptions():New( self )
         ::PreviewOptions := frPreviewOptions():New( self )
         ::EngineOptions := frEngineOptions():New( self )
         ::ReportOptions := frReportOptions():New( self )
      ELSE         
         oError := ErrorNew()
         oError:GenCode     := EG_OPEN
         oError:Severity    := ES_ERROR
         oError:subSystem   := "FRH" 
         oError:SubCode     := 2012
         oError:Description := "Can not load FRH library"
         oError:FileName    := cOptionalPath
         oError:CanDefault  := .F.
         Eval(ErrorBlock(), oError)
      ENDIF         
   ENDIF

RETURN self


////////////////////////////////////////////////////////////////////////
//  DestroyFR() - destroy all FastReport objects and unload "FRsyst.dll"
////////////////////////////////////////////////////////////////////////

METHOD DestroyFR() class frReportManager

    ::PrintOptions := NIL
    ::PreviewOptions := NIL
    ::EngineOptions := NIL
    ::ReportOptions := NIL

    Call_Func__I(::_CloseSyst)   
    FrUnload(::frSystHandle)
    ::frSystHandle := 0
RETURN self


////////////////////////////////////////////////////////////////////////
//  PrepareCalls()
////////////////////////////////////////////////////////////////////////

METHOD PrepareCalls() class frReportManager    
   
   InitEngine(::frSystHandle)
   ::_InitSyst := GetFrProcAddress(::frSystHandle, "InitSyst")
   ::_CloseSyst := GetFrProcAddress(::frSystHandle, "CloseSyst")
   ::_FrNotifyError := GetFrProcAddress(::frSystHandle, "FrNotifyError")
   ::_SetIcon := GetFrProcAddress(::frSystHandle, "SetIcon")
   ::_SetTitle := GetFrProcAddress(::frSystHandle, "SetTitle")
   ::_SetVisualActions := GetFrProcAddress(::frSystHandle, "SetVisualActions")
   ::_LoadLangRes := GetFrProcAddress(::frSystHandle, "LoadLangRes")
   ::_SetFormatSettings := GetFrProcAddress(::frSystHandle, "SetFormatSettings")
   ::_ShowReport := GetFrProcAddress(::frSystHandle, "ShowReport")
   ::_PrepareReport := GetFrProcAddress(::frSystHandle, "PrepareReport")
   ::_ShowPreparedReport := GetFrProcAddress(::frSystHandle, "ShowPreparedReport")
   ::_DesignReport := GetFrProcAddress(::frSystHandle, "DesignReport")
   ::_LoadFromFile := GetFrProcAddress(::frSystHandle, "LoadFromFile")
   ::_LoadFromResource := GetFrProcAddress(::frSystHandle, "LoadFromResource")
   ::_LoadFromBlob := GetFrProcAddress(::frSystHandle, "LoadFromBlob")
   ::_LoadFromString := GetFrProcAddress(::frSystHandle, "LoadFromString")
   ::_SaveToFile := GetFrProcAddress(::frSystHandle, "SaveToFile")
   ::_SaveToBlob := GetFrProcAddress(::frSystHandle, "SaveToBlob")
   ::_SaveToString := GetFrProcAddress(::frSystHandle, "SaveToString")
   ::_SetFileName := GetFrProcAddress(::frSystHandle, "SetFileName")
   ::_AddReport := GetFrProcAddress(::frSystHandle, "AddReport")
   ::_SelectReport := GetFrProcAddress(::frSystHandle, "SelectReport")
   ::_RemoveReport := GetFrProcAddress(::frSystHandle, "RemoveReport") 
   ::_ClearReports := GetFrProcAddress(::frSystHandle, "ClearReports")
   ::_Clear := GetFrProcAddress(::frSystHandle, "Clear")
   ::_LoadFPFile := GetFrProcAddress(::frSystHandle, "LoadFPFile")
   ::_SaveToFPFile := GetFrProcAddress(::frSystHandle, "SaveToFPFile")
   ::_LoadStyleSheet := GetFrProcAddress(::frSystHandle, "LoadStyleSheet")
   ::_LoadStyleSheetFromString := GetFrProcAddress(::frSystHandle, "LoadStyleSheetFromString")
   ::_Print := GetFrProcAddress(::frSystHandle, "Print")
   ::_GetErrors := GetFrProcAddress(::frSystHandle, "GetErrors")
   ::_DoExport := GetFrProcAddress(::frSystHandle, "DoExport")
   ::_GetProperty := GetFrProcAddress(::frSystHandle, "GetProperty")
   ::_SetProperty := GetFrProcAddress(::frSystHandle, "SetProperty")
   ::_SetObjProperty := GetFrProcAddress(::frSystHandle, "SetObjProperty")
   ::_SetEventHandler := GetFrProcAddress(::frSystHandle, "SetEventHandler")
   ::_AddFunction := GetFrProcAddress(::frSystHandle, "AddFunction")
   ::_AddVariable := GetFrProcAddress(::frSystHandle, "AddVariable")
   ::_SetVariable := GetFrProcAddress(::frSystHandle, "SetVariable")
   ::_GetVariable := GetFrProcAddress(::frSystHandle, "GetVariable")
   ::_DeletVariable := GetFrProcAddress(::frSystHandle, "DeletVariable")
   ::_DeletCategory := GetFrProcAddress(::frSystHandle, "DeletCategory")
   ::_SetScriptVar := GetFrProcAddress(::frSystHandle, "SetScriptVar")
   ::_GetScriptVar := GetFrProcAddress(::frSystHandle, "GetScriptVar")
   ::_Calc := GetFrProcAddress(::frSystHandle, "Calc")
   ::_SetWorkArea := GetFrProcAddress(::frSystHandle, "SetWorkArea")
   ::_SetMasterDetail := GetFrProcAddress(::frSystHandle, "SetMasterDetail")
   ::_SetResyncPair := GetFrProcAddress(::frSystHandle, "SetResyncPair")
   ::_SetUserDataSet := GetFrProcAddress(::frSystHandle, "SetUserDataSet")
   ::_Resync := GetFrProcAddress(::frSystHandle, "Resync")
   ::_SetFieldAliases := GetFrProcAddress(::frSystHandle, "SetFieldAliases")
   ::_RemoveDataSet := GetFrProcAddress(::frSystHandle, "RemoveDataSet")
   ::_ClearDataSets := GetFrProcAddress(::frSystHandle, "ClearDataSets")
   ::_ClearMasterDetail := GetFrProcAddress(::frSystHandle, "ClearMasterDetail")
   ::_ClearResyncPair := GetFrProcAddress(::frSystHandle, "ClearResyncPair")
   ::_SetADOConnectStr := GetFrProcAddress(::frSystHandle, "SetADOConnectStr")
   ::_SetADOConnectPartStr := GetFrProcAddress(::frSystHandle, "SetADOConnectPartStr")
   ::_StartManualBuild := GetFrProcAddress(::frSystHandle, "StartManualBuild")
   ::_MemoAt := GetFrProcAddress(::frSystHandle, "MemoAt")
   ::_SetDefaultFontProperty := GetFrProcAddress(::frSystHandle, "SetDefaultFontProperty")
   ::_NewPage := GetFrProcAddress(::frSystHandle, "NewPage")
   ::_SetManualObjProperty := GetFrProcAddress(::frSystHandle, "SetManualObjProperty")
   ::_LineAt := GetFrProcAddress(::frSystHandle, "LineAt")
   ::_PictureAt := GetFrProcAddress(::frSystHandle, "PictureAt")
   ::_NewReport := GetFrProcAddress(::frSystHandle, "NewReport")
   ::_AddPage := GetFrProcAddress(::frSystHandle, "AddPage")
   ::_AddBand := GetFrProcAddress(::frSystHandle, "AddBand")
   ::_AddGlobalDsToReport := GetFrProcAddress(::frSystHandle, "AddGlobalDsToReport")
   ::_GetGlobalDSList := GetFrProcAddress(::frSystHandle, "GetGlobalDSList")
   ::_AddMemo := GetFrProcAddress(::frSystHandle, "AddMemo")
   ::_AddLine := GetFrProcAddress(::frSystHandle, "AddLine")
   ::_AddPicture := GetFrProcAddress(::frSystHandle, "AddPicture")
   ::_IsObjectExists := GetFrProcAddress(::frSystHandle, "IsObjectExists")
   ::_CreateFRObject := GetFrProcAddress(::frSystHandle, "CreateFRObject")
   ::_EnumAllObjects := GetFrProcAddress(::frSystHandle, "EnumAllObjects")
   ::_GetPropList := GetFrProcAddress(::frSystHandle, "GetPropList")
   ::_PrepareScript := GetFrProcAddress(::frSystHandle, "PrepareScript")   
   ::_SendMail := GetFrProcAddress(::frSystHandle, "SendMail")
   ::_frMsgBox := GetFrProcAddress(::frSystHandle, "frMessageBox")
   ::_frInputBox := GetFrProcAddress(::frSystHandle, "frInputBox")
   ::_SetTabTreeExpanded := GetFrProcAddress(::frSystHandle, "SetTabTreeExpanded")
   ::_SetTxtDataSet := GetFrProcAddress(::frSystHandle, "SetTxtDataSet")

RETURN NIL


////////////////////////////////////////////////////////////////////////
//  FrNotifyError() - technical method to notify FR about runtime error
////////////////////////////////////////////////////////////////////////

METHOD FrNotifyError(oError) class frReportManager
LOCAL cMessage, cCaption

   Call_Proc_(::_FrNotifyError)

   cCaption := iif( oError:severity > ES_WARNING, "Error", "Warning" )
   
  
   IF ValType( oError:subsystem ) == "C"
      cMessage := oError:subsystem()
   ELSE
      cMessage := "???"
   ENDIF

   IF ValType( oError:subCode ) == "N"
      cMessage := cMessage + "/" + LTrim( Str( oError:subCode ) )
   ELSE
      cMessage := cMessage + "/???"
   ENDIF
   
   IF ValType( oError:description )  == "C"
      cMessage := cMessage + "  " + oError:description
   ENDIF
   
   DO CASE
   CASE !Empty( oError:filename )
      cMessage := cMessage + ": " + oError:filename
   CASE !Empty( oError:operation )
      cMessage := cMessage + ": " + oError:operation
   ENDCASE

   Call_Func_CCI_I(::_FrMsgBox, cMessage, cCaption, iif( oError:severity > ES_WARNING, 16, 48))

RETURN .T.


///////////////////////////////////////////////////////////////////////////
//  SetIcon() -  the numeric resource ID of the icon of FastReport-windows.
//               or string resource name
///////////////////////////////////////////////////////////////////////////

METHOD SetIcon(xValue) class frReportManager
LOCAL lRes
   IF ValType(xValue) = "C"
      lRes := Call_Func_IC_I(::_SetIcon, 0, xValue) == 1
   ELSE
      lRes := Call_Func_IC_I(::_SetIcon, xValue, NIL) == 1
   ENDIF
RETURN lRes


///////////////////////////////////////////////////////////////////////////
//  SetTitle() -  Title of taskbar FastReport-window
///////////////////////////////////////////////////////////////////////////

METHOD SetTitle(cTitle) class frReportManager
RETURN Call_Func_C_I(::_SetTitle, cTitle) == 1


//////////////////////////////////////////////////////////////////////////////
//  SetVisualActions() - Define action which will execute before and after
//                       such methods as ShowReport, DesignReport etc.
//                       nAction - The following values are available:
//                         FR_ACT_NONE(0) - no action
//                         FR_ACT_HIDE(1) -
//                                SetAppWindow():hide()
//                                   METHOD
//                                SetAppWindow():show()      
//                         FR_ACT_DISABLE(2) -
//                                SetAppWindow():disable()
//                                   METHOD
//                                SetAppWindow():enable()      
//                         FR_ACT_USER(3)
//                                bBeforeAction
//                                  METHOD
//                                bAfterAction
//                         Default - FR_ACT_NONE
//
//                       lTaskListToFalse - if true:
//                                SetAppWindow():taskList := .f.
//                                   METHOD
//                                SetAppWindow():taskList := .t.
//                         Default - False
//////////////////////////////////////////////////////////////////////////////

METHOD SetVisualActions(nAction, lTaskListToFalse, bBeforeAction, bAfterAction) class frReportManager
MEMVAR tmp_ParamB, tmp_ParamA
PRIVATE tmp_ParamB, tmp_ParamA  
   IF nAction == FR_ACT_USER 
     tmp_ParamB := bBeforeAction
     tmp_ParamA := bAfterAction
   ENDIF  
   lTaskListToFalse := IF(lTaskListToFalse <> NIL, IF(lTaskListToFalse, 1, 0), 0)
RETURN Call_Func_II_I(::_SetVisualActions, nAction, lTaskListToFalse) == 1


///////////////////////////////////////////////////////////////////////////
//  LoadLangRes() - Load language resource file
///////////////////////////////////////////////////////////////////////////

METHOD LoadLangRes(cLangFile) class frReportManager
RETURN Call_Func_C_I(::_LoadLangRes, cLangFile) == 1


///////////////////////////////////////////////////////////////////////////
//  SetFormatSettings() - Set Settings for Format functions in FRH
///////////////////////////////////////////////////////////////////////////

METHOD SetFormatSettings(nSetting, xValue) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := xValue
   CALL_PROC_I(::_SetFormatSettings, nSetting)
RETURN NIL


//////////////////////////////////////////////////////////////////////////
//  ShowReport() - Starts a report and displays a result in the preview
//                 window. If the "nNotClear" parameter is equal to
//                 "FR_NOTCLEARLASTREPORT"(1) then a report will be added
//                 to the previously constructed one, otherwise the
//                 previously constructed report is cleared (by default).
//////////////////////////////////////////////////////////////////////////

METHOD ShowReport(nNotClear) class frReportManager
   ::bSaveError := ErrorBlock( {|oError| ::FrNotifyError(oError) })    
   nNotClear := IF(nNotClear <> NIL, nNotClear, 0)
   Call_Func_I_I(::_ShowReport, nNotClear)
   ErrorBlock( ::bSaveError )
RETURN self

///////////////////////////////////////////////////////////////////////////
//  PrepareReport() - Starts a report without a preview window. 
//                    nNotClear - the same as in ShowReport()
///////////////////////////////////////////////////////////////////////////

METHOD PrepareReport(nNotClear)  class frReportManager
LOCAL RES
   ::bSaveError := ErrorBlock( {|oError| ::FrNotifyError(oError) })    
   nNotClear := IF(nNotClear <> NIL, nNotClear, 0)
   RES := Call_Func_I_I(::_PrepareReport, nNotClear) == 1
   ErrorBlock( ::bSaveError )
RETURN RES


///////////////////////////////////////////////////////////////////////////
//  ShowPreparedReport() - Displays the report, which was previously built 
//                         via the "PrepareReport" call.                     
///////////////////////////////////////////////////////////////////////////

METHOD ShowPreparedReport()  class frReportManager
   ::bSaveError := ErrorBlock( {|oError| ::FrNotifyError(oError) })    
   Call_Func__I(::_ShowPreparedReport)
   ErrorBlock( ::bSaveError )
RETURN self


////////////////////////////////////////////////////////////////////////
//  DesignReport() - Calls the report designer
////////////////////////////////////////////////////////////////////////

METHOD DesignReport() class frReportManager
   ::bSaveError := ErrorBlock( {|oError| ::FrNotifyError(oError) })    
   Call_Func__I(::_DesignReport) 
   ErrorBlock( ::bSaveError )
RETURN self


////////////////////////////////////////////////////////////////////////
//  LoadFromFile() - Loads a report from a file with given name. 
//                   Returns .t. if the file is loaded successfully
////////////////////////////////////////////////////////////////////////

METHOD LoadFromFile(cFileName) class frReportManager
RETURN Call_Func_C_I(::_LoadFromFile, cFileName) == 1 


////////////////////////////////////////////////////////////////////////
//  LoadFromResource() - Loads a report from a resource with given name or number. 
//                       Returns .t. if the report is loaded successfully
////////////////////////////////////////////////////////////////////////

METHOD LoadFromResource(xValue) class frReportManager
LOCAL lRes
   IF ValType(xValue) = "C"
      lRes := Call_Func_IC_I(::_LoadFromResource, 0, xValue) == 1
   ELSE
      lRes := Call_Func_IC_I(::_LoadFromResource, xValue, NIL) == 1
   ENDIF
RETURN lRes


////////////////////////////////////////////////////////////////////////
//  LoadFromBlob() - Loads a report from a memo or blob field. 
//                   Returns .t. if the file is loaded successfully
////////////////////////////////////////////////////////////////////////

METHOD LoadFromBlob(nWorkArea, cFieldName) class frReportManager
RETURN Call_Func_IC_I(::_LoadFromBlob, nWorkArea, cFieldName) == 1 


////////////////////////////////////////////////////////////////////////
//  LoadFromString() - Loads a report from a character string. 
//                     Returns .t. if the file is loaded successfully
////////////////////////////////////////////////////////////////////////

METHOD LoadFromString(cString) class frReportManager
RETURN Call_Func_C_I(::_LoadFromString, cString) == 1 


////////////////////////////////////////////////////////////////////////
//  SaveToFile() - Saves a report to a file with given name. 
////////////////////////////////////////////////////////////////////////

METHOD SaveToFile(cFileName) class frReportManager
   Call_Proc_C(::_SaveToFile, cFileName)
RETURN self


////////////////////////////////////////////////////////////////////////
//  SaveToBlob() - Saves a report to a memo or blob field.             
////////////////////////////////////////////////////////////////////////

METHOD SaveToBlob(nWorkArea, cFieldName) class frReportManager
RETURN Call_Proc_IC(::_SaveToBlob, nWorkArea, cFieldName)


////////////////////////////////////////////////////////////////////////
//  SaveToString() - Saves a report to a character string.             
////////////////////////////////////////////////////////////////////////

METHOD SaveToString() class frReportManager
MEMVAR tmp_Result
PRIVATE tmp_Result := ""
   CALL_PROC_(::_SaveToString)
RETURN tmp_Result


METHOD SetFileName(cFileName) class frReportManager
   CALL_PROC_C(::_SetFileName, cFileName)
RETURN NIL


METHOD AddReport() class frReportManager

RETURN Call_Func__I(::_AddReport)


METHOD SelectReport(nReport) class frReportManager

RETURN CALL_FUNC_I_I(::_SelectReport, nReport)


METHOD RemoveReport(nReport) class frReportManager
   CALL_PROC_I(::_RemoveReport, nReport)
RETURN NIL

METHOD ClearReports() class frReportManager
   CALL_PROC_(::_ClearReports)
RETURN NIL



////////////////////////////////////////////////////////////////////////
//  Clear() - Clears a report. 
////////////////////////////////////////////////////////////////////////

METHOD Clear() class frReportManager
   Call_Proc_(::_Clear)
RETURN self


////////////////////////////////////////////////////////////////////////
//  LoadFPFile() -     Loads a prepared report from a saved FP3-file. 
//                     Returns .t. if the file is loaded successfully
////////////////////////////////////////////////////////////////////////

METHOD LoadFPFile(cFileName) class frReportManager
RETURN Call_Func_C_I(::_LoadFPFile, cFileName) == 1 


///////////////////////////////////////////////////////////////////////////
//  SaveToFPFile() - Saves a prepared report to a FP3-file with given name. 
///////////////////////////////////////////////////////////////////////////

METHOD SaveToFPFile(cFileName) class frReportManager
   Call_Proc_C(::_SaveToFPFile, cFileName)
RETURN self


////////////////////////////////////////////////////////////////////////
//  LoadStyleSheet() - Loads Style Sheet
////////////////////////////////////////////////////////////////////////

METHOD LoadStyleSheet(cFileName) class frReportManager
   Call_Proc_C(::_LoadStyleSheet, cFileName)
RETURN self

METHOD LoadStyleSheetFromString(cString) class frReportManager
   Call_Proc_C(::_LoadStyleSheetFromString, cString)
RETURN self


////////////////////////////////////////////////////////////////////////////
//  Print() - Prints a report. See frPrintOptions class.
//            lDialogIsChild - if true then PrintDialog will be the child of
//                               current foreground window
//                    Default -False
////////////////////////////////////////////////////////////////////////////

METHOD Print(lDialogIsChild) class frReportManager
LOCAL RES
  ::bSaveError := ErrorBlock( {|oError| ::FrNotifyError(oError) })    
  lDialogIsChild := IF(lDialogIsChild <> nil, IF(lDialogIsChild, 1, 0), 0) 
  RES := Call_Func_I_I(::_Print, lDialogIsChild) == 1 
  ErrorBlock( ::bSaveError )
RETURN RES


////////////////////////////////////////////////////////////////////////
// GetErrors() - Get Errors list. Impotant in silent mode.
////////////////////////////////////////////////////////////////////////

METHOD GetErrors() class frReportManager
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func__I(::_GetErrors)
RETURN tmp_RetVal


////////////////////////////////////////////////////////////////////////
// DoExport() - Exports a report using the specified export filter 
//              object. Possible values of Param:
//
//                  PDFExport, HTMLExport, RTFExport, CSVExport,
//                  XLSExport, DotMatrixExport, BMPExport, JPEGExport,
//                  TIFFExport, GIFExport, SimpleTextExport, MailExport,
//                  XMLExport, TXTExport
//
////////////////////////////////////////////////////////////////////////

METHOD DoExport(cExportObjectName) class frReportManager
  Call_Proc_C(::_DoExport, cExportObjectName)
RETURN Self


////////////////////////////////////////////////////////////////////////
// GetProperty()/  Universal functions that set or return any property 
// SetProperty() - (except object property) of any Fast Report object. 
//                   Possible values of sObjectName:
//
//                  Report, Designer,
//                  PDFExport, HTMLExport, RTFExport, CSVExport,
//                  XLSExport, DotMatrixExport, BMPExport, JPEGExport,
//                  TIFFExport, GIFExport, SimpleTextExport, MailExport
//
//                  For properties of objects that is property of this
//                  "main" objects '.'-delimeter must be used. For
//                  example:
//                    "Designer.DefaultFont"
//
//                  For full list of values for sPropName param see Fast
//                  Report documentation:
//                   http://www.fast-report.com/en/documentation/
// 
//                  Examples:
//                    SetProperty("Report", "ScriptLanguage", "PascalScript")
//                    SetProperty("PDFExport", "FileName", "My file.pdf")
//                    SetProperty("PDFExport", "ShowDialog", .f.)
//
//                  For Delphi enumerated types and set type use its
//                  string representation, for example:
//                    SetProperty("Designer.DefaultFont", "Style", "[fsBold, fsItalic]")
//                 
////////////////////////////////////////////////////////////////////////

METHOD GetProperty(sObjectName, sPropName) class frReportManager
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_CC_I(::_GetProperty, sObjectName, sPropName)
RETURN tmp_RetVal

METHOD SetProperty(sObjectName, sPropName, Value) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := Value
RETURN Call_Func_CC_I(::_SetProperty, sObjectName, sPropName) == 1


METHOD SetObjProperty(cObjectName, cPropName, cObjToSetName) class frReportManager
RETURN Call_Func_CCC_I(::_SetObjProperty, cObjectName, cPropName, cObjToSetName) == 1



////////////////////////////////////////////////////////////////////////
//  SetEventHandler() - Set Event Handler (codeblock) to Fast Report 
//                      event. Possible values of params:
//          sObjectName - Report:
//                          sPropName: OnAfterPrint(sObjName), 
//                                     OnAfterPrintReport(), 
//                                     OnBeforeConnect(sConnectName), 
//                                     OnBeforePrint(sObjName), 
//                                     OnBeginDoc(), 
//                                     OnClickObject(sObjName, nButton), 
//                                     OnEndDoc(), 
//                                     OnGetValue(sVarName) -> VarValue ,
//                                     OnManualBuild -- !!! not implemented yet!, 
//                                     OnMouseOverObject(sObjName),
//                                     OnPreview(),
//                                     OnPrintPage(nCopyNo), 
//                                     OnPrintReport(),
//                                     OnProgress(nProgressType, nProgress),
//                                     OnProgressStop(nProgressType, nProgress),
//                                     OnProgressStart(nProgressType, nProgress),
//                                     OnUserFunction(sMethodName, aParams) -> xResult 
//
//         sObjectName - Designer:
//                          sPropName: OnInsertObject(),
//                                     OnLoadReport(),
//                                     OnSaveReport(bSaveAs),
//                                     OnShow(),
//                                     OnShowStartupScreen()
//
//         Example:
//            SetEventHandler("Report", "OnProgress", {|x,y|MyShowProgress(x, y)})
//
//         To clear EventHandler pass NIL as bEventHandler param
//
////////////////////////////////////////////////////////////////////////

METHOD SetEventHandler(cObjectName, cPropName, bEventHandler) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := bEventHandler
RETURN Call_Func_CC_I(::_SetEventHandler, cObjectName, cPropName) == 1


////////////////////////////////////////////////////////////////////////
//  AddFunction() - Adds a user function to the list of the functions 
//                  available in the report. OnUserFunction-event handler 
//                  must be assigned. 
//                    cFunction - function declaration in Pascal syntax.
//                    
////////////////////////////////////////////////////////////////////////

METHOD AddFunction(cFunction, cCategory, cDescription) class frReportManager
   Call_Proc_CCC(::_AddFunction, cFunction, IF(cCategory <> NIL, cCategory, "") , IF(cDescription <> NIL, cDescription, ""))
RETURN Self


/////////////////////////////////////////////////////////////////////////
//  AddVariable() - Adds a user variable to the list of the variables
//                  available in the report. 
//
//    IMPOTANT:  When accessing a report variable its value is calculated 
//               if it is of string type. That means the variable which 
//               value is "GetXppVar(SomeVar)"  will return a value of 
//               SomeVar - variable, but not the "GetXppVar(SomeVar)" string. 
//               You should be careful when assigning a string-type values 
//               to report variables. Simple string value must be in 
//               Pascal string quotes - '
//                Examples for xValue:
//                  "GetXppVar(SomeVar)"  -> Value of SomeVar
//                  "'GetXppVar(SomeVar)'" -> string  
//
/////////////////////////////////////////////////////////////////////////

METHOD AddVariable(cCategory, cName, xValue) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := xValue
   Call_Proc_CC(::_AddVariable, cCategory, cName)
RETURN Self


/////////////////////////////////////////////////////////////////////////
//  SetVariable() - Modify a user variables value
/////////////////////////////////////////////////////////////////////////

METHOD SetVariable(cName, xValue) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := xValue
   Call_Proc_C(::_SetVariable, cName)
RETURN Self


/////////////////////////////////////////////////////////////////////////
//  GetVariable() - Get a user variables value
/////////////////////////////////////////////////////////////////////////

METHOD GetVariable(cName) class frReportManager
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_GetVariable, cName)
RETURN tmp_RetVal
      

/////////////////////////////////////////////////////////////////////////
//  DeleteVariable() - Delete a user variable
/////////////////////////////////////////////////////////////////////////
            
METHOD DeleteVariable(cName) class frReportManager
   Call_Proc_C(::_DeletVariable, cName)
RETURN Self


/////////////////////////////////////////////////////////////////////////
//  DeletCategory() - delete a category with ALL its variables.
/////////////////////////////////////////////////////////////////////////
      
METHOD DeleteCategory(cCategory) class frReportManager
   Call_Proc_C(::_DeletCategory, cCategory)
RETURN Self


/////////////////////////////////////////////////////////////////////////
//  SetScriptVar()/ - Get or Set script variable
//  GetScriptVar
//                  Instead of report variables, script variables are 
//                  not visible in the report variables list and is not 
//                  calculated. You can define them using FastScript 
//                  methods
/////////////////////////////////////////////////////////////////////////
      
METHOD SetScriptVar(sName, xValue)  class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := xValue
   Call_Proc_C(::_SetScriptVar, sName)
RETURN Self
            
METHOD GetScriptVar(sName) class frReportManager
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_GetScriptVar, sName)
RETURN tmp_RetVal


/////////////////////////////////////////////////////////////////////////
//  Calc() - Calculates the any FastScript expression and returns the 
//           result.
/////////////////////////////////////////////////////////////////////////
      
METHOD Calc(sExpression) class frReportManager
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_Calc, sExpression)
RETURN tmp_RetVal

             
////////////////////////////////////////////////////////////////////////////
//  SetWorkArea() - Add WorkArea or modify params of WorkArea. 
//                  sFrAlias     - any string that will represent WorkArea in FR
//                  nWorkArea    - number of WorkArea
//                  lOem         - data in oem codepage (default - .f.)
//                  aRangeParams - Range Params. Array with 3 elements:
//                    1 element - FR_RB_FIRST(0) or FR_RB_CURRENT(1)
//                    2 element - FR_RE_LAST(0) or FR_RE_CURRENT(1) or FR_RE_COUNT(2)
//                    3 element - A number of records in the WorkArea, 
//                                if the second element = FR_RE_COUNT.
//                      Default - {FR_RB_FIRST, FR_RE_LAST, 0}
////////////////////////////////////////////////////////////////////////////

METHOD SetWorkArea(cFrAlias, nWorkArea, lOem, aRangeParams) class frReportManager
LOCAL Res := .f.
MEMVAR tmp_Params
PRIVATE tmp_Params := aRangeParams  
   IF (nWorkArea)->(Used())   
      lOem := IF(lOem <> NIL, IF(lOem, 1, 0), 0)  
      aRangeParams := IF(aRangeParams <> NIL, 1, 0)
      Res := Call_Func_CIII_I(::_SetWorkArea, cFrAlias, nWorkArea, lOem, aRangeParams) == 1
   ENDIF
RETURN Res


////////////////////////////////////////////////////////////////////////
//  SetMasterDetail() - Creating master/detail relationships
//                      between two WorkAreas (Delphi realization based on
//                      "DbScope" - XBase++ functions).
//
//                      Example - SetMasterDetail("Customers", "Orders", {||Customers->CustNo})
////////////////////////////////////////////////////////////////////////

METHOD SetMasterDetail(cMasterAlias, cDetailAlias, bScopeValue) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := bScopeValue 
RETURN Call_Func_CC_I(::_SetMasterDetail, cMasterAlias, cDetailAlias) == 1 


////////////////////////////////////////////////////////////////////////////
//  SetResyncPair() - When DbRelation-relationships is set in XBase++
//                    code, you need notify FastReport about it.
//                    
//                    It means that after  changing of parent workarea cursor 
//                    position, child dataset resynchronize its cursor position 
//                    with XBase++ data.
////////////////////////////////////////////////////////////////////////////

METHOD SetResyncPair(cParentAlias, cChildlAlias) class frReportManager
RETURN Call_Func_CC_I(::_SetResyncPair, cParentAlias, cChildlAlias) == 1 


////////////////////////////////////////////////////////////////////////
//  SetUserDataSet() - Add or modify UserDataSet. UserDataSet allows 
//                     constructing reports, which are not connected 
//                     to the data from DB, but do receive data from 
//                     other sources (for example, array, file, etc.). 
////////////////////////////////////////////////////////////////////////

METHOD SetUserDataSet(sFrAlias, sFields, bGoTop, bSkipPlus1, bSkipMinus1, ;
                                                bCheckEOF, bGetValue)  class frReportManager
MEMVAR tmp_Params
PRIVATE tmp_Params := {bGoTop, bSkipPlus1, bSkipMinus1, bCheckEOF, bGetValue}
RETURN Call_Func_CC_I(::_SetUserDataSet, sFrAlias, sFields) == 1 


////////////////////////////////////////////////////////////////////////
//  SetTxtDataSet() - Add or modify TxtDataSet. TxtDataSet allows 
//                    work with big txt-files by lines.
////////////////////////////////////////////////////////////////////////


METHOD SetTxtDataSet(sFrAlias, sFileName) class frReportManager
RETURN Call_Func_CC_I(::_SetTxtDataSet, sFrAlias, sFileName) == 1 


////////////////////////////////////////////////////////////////////////
//  Resync() - method for resynchronize the dataset with underlying 
//             physical data when making XBase++ calls that may change 
//             the workarea cursor position.            
////////////////////////////////////////////////////////////////////////

METHOD Resync(cFrAlias) class frReportManager
RETURN Call_Func_C_I(::_Resync, cFrAlias) == 1 

///////////////////////////////////////////////////////////////////////////////////////
//  SetFieldAliases() - Set symbolic names of data set fields and 
//                      show/hide some fields. For example:
//         SetFieldAliases("Customers", "CUSTNO=Cust No;Company;ADDR1=Address;Phone")
//
//         Only 4 fields will be visible, CUSTNO and ADDR1 will be visible as 'Cust No'
//         and 'Address'
///////////////////////////////////////////////////////////////////////////////////////

METHOD SetFieldAliases(cFrAlias, cFieldAliases) class frReportManager
RETURN Call_Func_CC_I(::_SetFieldAliases, cFrAlias, cFieldAliases) == 1 


////////////////////////////////////////////////////////////////////////
//  RemoveDataSet() - Remove WorkArea or UserDataSet from Fast Report 
//                    data list.
////////////////////////////////////////////////////////////////////////

METHOD RemoveDataSet(cFrAlias) class frReportManager
RETURN Call_Func_C_I(::_RemoveDataSet, cFrAlias) == 1 


////////////////////////////////////////////////////////////////////////
//  ClearDataSets() - Remove All WorkAreas and UserDataSets from Fast 
//                    Report data list.
////////////////////////////////////////////////////////////////////////

METHOD ClearDataSets() class frReportManager
   Call_Proc_(::_ClearDataSets)
RETURN self


////////////////////////////////////////////////////////////////////////
//  ClearMasterDetail() - Remove  master/detail relationships
//                        between two WorkAreas 
////////////////////////////////////////////////////////////////////////

METHOD ClearMasterDetail(cDetailAlias) class frReportManager
   Call_Proc_C(::_ClearMasterDetail, cDetailAlias) 
RETURN self


////////////////////////////////////////////////////////////////////////
//  ClearResyncPair() -   Remove  "resync" relationships
//                        between two WorkAreas 
////////////////////////////////////////////////////////////////////////

METHOD ClearResyncPair(cParentAlias, cChildlAlias) class frReportManager
RETURN Call_Func_CC_I(::_ClearResyncPair, cParentAlias, cChildlAlias) == 1 


////////////////////////////////////////////////////////////////////////
//  SetADOConnectStr() - Set ConnectionString for ADO-DataBase object 
////////////////////////////////////////////////////////////////////////

METHOD SetADOConnectStr(sFrAlias, sStr) class frReportManager
RETURN Call_Func_CC_I(::_SetADOConnectStr, sFrAlias, sStr) == 1 


/////////////////////////////////////////////////////////////////////////////////
//  SetADOConnectPartStr() - Set only one part of ConnectionString 
//                           for ADO-DataBase object. For examle:
//     SetADOConnectPartStr("ADODatabase1", "Data Source", SomeFile)
/////////////////////////////////////////////////////////////////////////////////

METHOD SetADOConnectPartStr(sFrAlias, sKey, sValue) class frReportManager
RETURN Call_Func_CCC_I(::_SetADOConnectPartStr, sFrAlias, sKey, sValue) == 1 


/////////////////////////////////////////////////////////////////////////////////
//
// ManualBuild - section
//
/////////////////////////////////////////////////////////////////////////////////


METHOD StartManualBuild(bManualBlock, nOrientation, nPaperSize, nUnits) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := bManualBlock      
   nOrientation := IF(nOrientation <> NIL, nOrientation, 0)
   nPaperSize := IF(nPaperSize <> NIL, nPaperSize, -1)
   nUnits := IF(nUnits <> NIL, nUnits, FR_PIXELS)
   Call_Func_III_I(::_StartManualBuild, nOrientation, nPaperSize, nUnits)
RETURN NIL


METHOD MemoAt(cStr, nLeft, nTop, nWidth, nHeight) class frReportManager
MEMVAR tmp_Param, tmp_Result
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}, tmp_Result := ""
   Call_Func_C_I(::_MemoAt, cStr)
RETURN tmp_Result


METHOD SetDefaultFontProperty(cPropName, xValue)  class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := xValue
   Call_Func_C_I(::_SetDefaultFontProperty, cPropName)
RETURN NIL


METHOD NewPage() class frReportManager
   Call_Proc_(::_NewPage)
RETURN NIL


METHOD SetManualObjProperty(cObjName, cPropName, xValue)  class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := xValue
   Call_Func_CC_I(::_SetManualObjProperty, cObjName, cPropName)
RETURN NIL


METHOD LineAt(nLeft, nTop, nWidth, nHeight)  class frReportManager
MEMVAR tmp_Param, tmp_Result
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}, tmp_Result := ""
   Call_Func__I(::_LineAt)
RETURN tmp_Result


METHOD PictureAt(cFileName, nLeft, nTop, nWidth, nHeight) class frReportManager
MEMVAR tmp_Param, tmp_Result
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}, tmp_Result := ""
   Call_Func_C_I(::_PictureAt, cFileName)
RETURN tmp_Result


/////////////////////////////////////////////////////////////////////////////////
//
// Manual report creation section
//
/////////////////////////////////////////////////////////////////////////////////


METHOD NewReport(cPageName) class frReportManager
   CALL_PROC_C(::_NewReport, cPageName)
RETURN NIL


METHOD AddPage(cPageName) class frReportManager
   CALL_PROC_C(::_AddPage, cPageName)
RETURN NIL


METHOD AddBand(cBandName, cParentPage, nBandType) class frReportManager
RETURN CALL_FUNC_CCI_I(::_AddBand, cBandName, cParentPage, nBandType) > 0


METHOD AddGlobalDsToReport(cDataSetName) class frReportManager
RETURN CALL_FUNC_C_I(::_AddGlobalDsToReport, cDataSetName) > 0


METHOD GetGlobalDSList() class frReportManager
MEMVAR tmp_Result
PRIVATE tmp_Result := ""
   CALL_PROC_(::_GetGlobalDSList)
RETURN tmp_Result


METHOD AddMemo(cParent, cName, cStr, nLeft, nTop, nWidth, nHeight) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}   
RETURN Call_Func_CCC_I(::_AddMemo, cParent, cName, cStr) > 0


METHOD AddLine(cParent, cName, nLeft, nTop, nWidth, nHeight)  class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}   
RETURN Call_Func_CC_I(::_AddLine, cParent, cName) > 0


METHOD AddPicture(cParent, cName, cFileName, nLeft, nTop, nWidth, nHeight) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}   
RETURN Call_Func_CCC_I(::_AddPicture, cParent, cName, cFileName) > 0


METHOD IsObjectExists(cObjName) class frReportManager
RETURN CALL_FUNC_C_I(::_IsObjectExists, cObjName) > 0


METHOD CreateFRObject(cClassName, cParent, cName, nLeft, nTop, nWidth, nHeight) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := {nLeft, nTop, nWidth, nHeight}       
RETURN CALL_FUNC_CCC_I(::_CreateFRObject, cClassName, cParent, cName) > 0
    
      
METHOD EnumAllObjects(bEnumBlock) class frReportManager
MEMVAR tmp_Param
PRIVATE tmp_Param := bEnumBlock
   CALL_PROC_(::_EnumAllObjects)
RETURN NIL      

      
METHOD GetPropList(cObjName) class frReportManager
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal := ""
   CALL_PROC_C(::_GetPropList, cObjName)
RETURN tmp_RetVal


METHOD PrepareScript() class frReportManager
   CALL_PROC_(::_PrepareScript)
RETURN NIL


/////////////////////////////////////////////////////////////////////////////////
//
// tech methods
//
/////////////////////////////////////////////////////////////////////////////////


METHOD SendMail(cServer, nPort, cUserField, cPasswordField,; 
       cFromField, cToField, cSubjectField, cCompanyField,;
       cTextField, cFileNames)  class frReportManager
MEMVAR tmp_Result
PRIVATE tmp_Result := ""   

   Call_Func_CICCCCCCCC_I(::_SendMail, cServer, nPort, cUserField, cPasswordField,; 
       cFromField, cToField, cSubjectField, cCompanyField, cTextField, cFileNames)
RETURN tmp_Result


METHOD InputBox(cCaption, cPrompt, cDefault) class frReportManager
MEMVAR tmp_Result
PRIVATE tmp_Result := ""

   Call_Func_CCC_I(::_frInputBox, cCaption, cPrompt, cDefault)
RETURN tmp_Result


METHOD SetTabTreeExpanded(nTabTreeViews, lExpand) class frReportManager
RETURN Call_Func_II_I(::_SetTabTreeExpanded, nTabTreeViews, IF(lExpand, 1, 0))



//METHOD FrMsgBox(cText, cCaption, nFlag) class frReportManager   
//RETURN Call_Func_CCI_I(cText, cCaption, nFlag)




//////////////////////////////////////////////////////////////////////
// frEngineOptions - A set of properties related to the FastReport 
//                   engine: 
//////////////////////////////////////////////////////////////////////

CLASS frEngineOptions
   HIDDEN:
       VAR frManager, _SetConvertNulls, _SetDoublePass, _SetPrintIfEmpty, _SetSilentMode,;
           _SetNewSilentMode, _SetMaxMemSize, _SetTempDir, _SetUseFileCache
                                 
       METHOD PrepareCalls
   EXPORTED:
       METHOD Init       
       METHOD SetConvertNulls
       METHOD SetDoublePass       
       METHOD SetPrintIfEmpty
       METHOD SetSilentMode
       METHOD SetNewSilentMode
       METHOD SetMaxMemSize
       METHOD SetTempDir
       METHOD SetUseFileCache
ENDCLASS

////////////////////////////////////////////////////////////////////////
/////////////--start of frEngineOptions class--/////////////////////////
////////////////////////////////////////////////////////////////////////
// Init()
////////////////////////////////////////////////////////////////////////

METHOD Init(oManager) class frEngineOptions
   ::frManager := oManager
   ::PrepareCalls()
RETURN self


////////////////////////////////////////////////////////////////////////
// PrepareCalls()
////////////////////////////////////////////////////////////////////////

METHOD PrepareCalls()  class frEngineOptions

   ::_SetConvertNulls := GetFrProcAddress(::frManager:frSystHandle, "SetConvertNulls")
   ::_SetDoublePass := GetFrProcAddress(::frManager:frSystHandle, "SetDoublePass")
   ::_SetPrintIfEmpty := GetFrProcAddress(::frManager:frSystHandle, "SetPrintIfEmpty")
   ::_SetSilentMode := GetFrProcAddress(::frManager:frSystHandle, "SetSilentMode")
   ::_SetNewSilentMode := GetFrProcAddress(::frManager:frSystHandle, "SetNewSilentMode")
   ::_SetMaxMemSize := GetFrProcAddress(::frManager:frSystHandle, "SetMaxMemSize")
   ::_SetTempDir := GetFrProcAddress(::frManager:frSystHandle, "SetTempDir")
   ::_SetUseFileCache := GetFrProcAddress(::frManager:frSystHandle, "SetUseFileCache")

RETURN NIL


////////////////////////////////////////////////////////////////////////
// SetConvertNulls() - Converts the "Null" value of the DB field into 
//                    "0", "False," or empty string, depending on the 
//                    field type.   Default - True
////////////////////////////////////////////////////////////////////////

METHOD SetConvertNulls(lConvert)  class frEngineOptions
  Call_Proc_I(::_SetConvertNulls, IF(lConvert <> NIL, IF(lConvert, 1, 0) , 1))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetDoublePass() - Makes a report a two-pass one. Default - False
////////////////////////////////////////////////////////////////////////

METHOD SetDoublePass(lDouble) class frEngineOptions
  Call_Proc_I(::_SetDoublePass, IF(lDouble <> NIL, IF(lDouble, 1, 0) , 0))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetPrintIfEmpty() - Defines, whether it is necessary to print a blank
//                     report (one which containing no data lines). 
////////////////////////////////////////////////////////////////////////

METHOD SetPrintIfEmpty(lPrint) class frEngineOptions 
  Call_Proc_I(::_SetPrintIfEmpty, IF(lPrint <> NIL, IF(lPrint, 1, 0) , 1))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetSilentMode() - "Silent" mode. Thus all messages about errors are 
//                   stored in the Errors property, without displaying 
//                   any messages on the screen. Default - False
////////////////////////////////////////////////////////////////////////

METHOD SetSilentMode(lSilent) class frEngineOptions
  Call_Proc_I(::_SetSilentMode, IF(lSilent <> NIL, IF(lSilent, 1, 0) , 0))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetNewSilentMode() - The following values are available: 
//                      FR_SIM_MESSAGEBOXES (0)
//                      FR_SIM_RETHROW      (1)
//                      FR_SIM_SILENT       (2)
////////////////////////////////////////////////////////////////////////

METHOD SetNewSilentMode(nMode) class frEngineOptions
   Call_Proc_I(::_SetNewSilentMode, nMode)
RETURN NIL


////////////////////////////////////////////////////////////////////////
// SetMaxMemSize() - The maximum size of memory in Mbytes, allocated to 
//                   the report pages' cache. It becomes useful in cases 
//                   when the "UseFileCashe" property is equal to True. 
//                   If a report begins to occupy more memory during 
//                   construction, caching of the constructed report 
//                   pages into a temporary file is performed. This 
//                   property is inexact and allows only approximate 
//                   determination of the memory limit. Default - 10
////////////////////////////////////////////////////////////////////////

METHOD SetMaxMemSize(nSize) class frEngineOptions
   Call_Proc_I(::_SetMaxMemSize, nSize)
RETURN self


////////////////////////////////////////////////////////////////////////
// SetTempDir() - Specifies a path to the directory for storing 
//                temporary files
////////////////////////////////////////////////////////////////////////

METHOD SetTempDir(sDir)  class frEngineOptions //->OldValue
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetTempDir, IF(sDir <> NIL, sDir, ""))
RETURN tmp_RetVal


////////////////////////////////////////////////////////////////////////
// SetUseFileCache() - Defines, whether it is necessary to use report 
//                     pages caching into the file.
////////////////////////////////////////////////////////////////////////

METHOD SetUseFileCache(lUse)  class frEngineOptions
   Call_Proc_I(::_SetUseFileCache, IF(lUse <> NIL, IF(lUse, 1, 0) , 0))
RETURN self


/////////////--end of frEngineOptions class--////////////////////////////



//////////////////////////////////////////////////////////////////////
// frPrintOptions - a set of properties, which relate to the report
//                  printing
//////////////////////////////////////////////////////////////////////

CLASS frPrintOptions
   HIDDEN:
       VAR frManager, _SetCopies, _SetCollate, _SetPageNumbers, _SetPrinter, _SetPrintPages,; 
           _SetShowDialog, _SetReverse, _ClearOptions  
       
       METHOD PrepareCalls
   EXPORTED:
       METHOD Init
       METHOD SetCopies(nCopies) INLINE Call_Func_I_I(::_SetCopies, IF(nCopies <> NIL, nCopies, -1))
       METHOD SetCollate
       METHOD SetPageNumbers
       METHOD SetPrinter
       METHOD SetPrintPages(nPages) INLINE Call_Func_I_I(::_SetPrintPages, IF(nPages <> NIL, nPages, -1))
       METHOD SetShowDialog
       METHOD SetReverse
       METHOD ClearOptions
ENDCLASS



////////////////////////////////////////////////////////////////////////
/////////////--start of frPrintOptions class--//////////////////////////
////////////////////////////////////////////////////////////////////////
// Init()
////////////////////////////////////////////////////////////////////////

METHOD Init(oManager) class frPrintOptions
   ::frManager := oManager
   ::PrepareCalls()
RETURN self


////////////////////////////////////////////////////////////////////////
// PrepareCalls()
////////////////////////////////////////////////////////////////////////

METHOD PrepareCalls() class frPrintOptions
    
   ::_SetCopies := GetFrProcAddress(::frManager:frSystHandle, "SetCopies")
   ::_SetCollate := GetFrProcAddress(::frManager:frSystHandle, "SetCollate")
   ::_SetPageNumbers := GetFrProcAddress(::frManager:frSystHandle, "SetPageNumbers")
   ::_SetPrinter := GetFrProcAddress(::frManager:frSystHandle, "SetPrinter")
   ::_SetPrintPages := GetFrProcAddress(::frManager:frSystHandle, "SetPrintPages")
   ::_SetShowDialog := GetFrProcAddress(::frManager:frSystHandle, "SetShowDialog")
   ::_SetReverse := GetFrProcAddress(::frManager:frSystHandle, "SetReverse")
   ::_ClearOptions := GetFrProcAddress(::frManager:frSystHandle, "ClearOptions")

RETURN NIL


////////////////////////////////////////////////////////////////////////
// SetCopies - A number of the printable copies by default. default - 1
////////////////////////////////////////////////////////////////////////

// Move to inline
//METHOD SetCopies(nCopies) class frPrintOptions   // ->OldValue  
//RETURN Call_Func_I_I(::_SetCopies, IF(nCopies <> NIL, nCopies, -1))


//////////////////////////////////////////////////////////////////////
// SetCollate - whether to collate the copies. Default - True
//////////////////////////////////////////////////////////////////////

METHOD SetCollate(lCollate) class frPrintOptions // ->OldValue  
   lCollate := IF(lCollate <> NIL, IF(lCollate, 1, 0), 2)  
RETURN IF(Call_Func_I_I(::_SetCollate, lCollate) == 1, .t., .f.) 


//////////////////////////////////////////////////////////////////////
// SetPageNumbers - Page numbers, which are to be printed. 
//                  For example, "1,3,5-12,17-". default - ""
//////////////////////////////////////////////////////////////////////

METHOD SetPageNumbers(sParam) class frPrintOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal := ""
   Call_Func_IC_I(::_SetPageNumbers, IF(sParam <> NIL, 1, 0),IF(sParam <> NIL, sParam, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////
// SetPrinter - Get or set printer name. Default - default printer
//////////////////////////////////////////////////////////////////////

METHOD SetPrinter(sPrinter) class frPrintOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal := ""
   Call_Func_IC_I(::_SetPrinter, IF(sPrinter <> NIL, 1, 0),IF(sPrinter <> NIL, sPrinter, ""))  
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////
// SetPrintPages - Defines the pages to be printed. 
//                 The following values are available (look FastRep.ch): 
//                 FR_PP_ALL  - all  (Value - 0)
//                 FR_PP_ODD  - odd  (Value - 1)
//                 FR_PP_EVEN - even (Value - 2)
//                   default - FR_PP_ALL
//////////////////////////////////////////////////////////////////////

// Move to inline
// METHOD SetPrintPages(nPages) class frPrintOptions // ->OldValue  
// RETURN Call_Func_I_I(::_SetPrintPages, IF(nPages <> NIL, nPages, -1))


//////////////////////////////////////////////////////////////////////
// SetShowDialog - Whether to display a print dialog. Default - True
//////////////////////////////////////////////////////////////////////

METHOD SetShowDialog(lShow) class frPrintOptions // ->OldValue  
   lShow := IF(lShow <> NIL, IF(lShow, 1, 0), 2)  
RETURN IF(Call_Func_I_I(::_SetShowDialog, lShow) == 1, .t., .f.)


//////////////////////////////////////////////////////////////////////
//  SetReverse - get or set reports reverse. Default - False
//////////////////////////////////////////////////////////////////////

METHOD SetReverse(lReverse) class frPrintOptions // ->OldValue  
   lReverse := IF(lReverse <> NIL, IF(lReverse, 1, 0), 2)  
RETURN IF(Call_Func_I_I(::_SetReverse, lReverse) == 1, .t., .f.)


//////////////////////////////////////////////////////////////////////
//  ClearOptions - set all options to default values
//////////////////////////////////////////////////////////////////////

METHOD ClearOptions() class frPrintOptions
   Call_Proc_(::_ClearOptions)
RETURN self

/////////////--end of frPrintOptions class--////////////////////////////




//////////////////////////////////////////////////////////////////////
// frPreviewOptions - A set of properties, relating to the report 
//                    preview
//////////////////////////////////////////////////////////////////////

CLASS frPreviewOptions
   HIDDEN:
       VAR frManager, _SetAllowEdit, _SetButtons, _SetDoubleBuffered, _SetMaximized, _SetBounds,;
           _SetOutlineVisible, _SetOutlineExpand, _SetOutlineWidth, _SetShowCaptions, _SetZoom,;
           _SetZoomMode, _SetPictureCacheInFile, _SetModal, _SetRemoveReportOnClose

       METHOD PrepareCalls
   EXPORTED:
       METHOD Init
       METHOD SetAllowEdit
       METHOD SetButtons
       METHOD SetDoubleBuffered
       METHOD SetMaximized
       METHOD SetBounds
       METHOD SetOutlineVisible
       METHOD SetOutlineExpand
       METHOD SetOutlineWidth
       METHOD SetShowCaptions
       METHOD SetZoom
       METHOD SetZoomMode
       METHOD SetModal
       METHOD SetPictureCacheInFile
       METHOD SetRemoveReportOnClose
ENDCLASS



////////////////////////////////////////////////////////////////////////
/////////////--start of frPreviewOptions class--////////////////////////
////////////////////////////////////////////////////////////////////////
// Init()
////////////////////////////////////////////////////////////////////////

METHOD Init(oManager) class frPreviewOptions
   ::frManager := oManager
   ::PrepareCalls()
RETURN self


////////////////////////////////////////////////////////////////////////
// PrepareCalls()
////////////////////////////////////////////////////////////////////////

METHOD PrepareCalls() class frPreviewOptions

   ::_SetAllowEdit := GetFrProcAddress(::frManager:frSystHandle, "SetAllowEdit")
   ::_SetButtons := GetFrProcAddress(::frManager:frSystHandle, "SetButtons")
   ::_SetDoubleBuffered := GetFrProcAddress(::frManager:frSystHandle, "SetDoubleBuffered")
   ::_SetMaximized := GetFrProcAddress(::frManager:frSystHandle, "SetMaximized")
   ::_SetBounds := GetFrProcAddress(::frManager:frSystHandle, "SetBounds")
   ::_SetOutlineVisible := GetFrProcAddress(::frManager:frSystHandle, "SetOutlineVisible")
   ::_SetOutlineExpand := GetFrProcAddress(::frManager:frSystHandle, "SetOutlineExpand")
   ::_SetOutlineWidth := GetFrProcAddress(::frManager:frSystHandle, "SetOutlineWidth")
   ::_SetShowCaptions := GetFrProcAddress(::frManager:frSystHandle, "SetShowCaptions")
   ::_SetZoom := GetFrProcAddress(::frManager:frSystHandle, "SetZoom")
   ::_SetZoomMode := GetFrProcAddress(::frManager:frSystHandle, "SetZoomMode")
   ::_SetPictureCacheInFile := GetFrProcAddress(::frManager:frSystHandle,"SetPictureCacheInFile")
   ::_SetModal := GetFrProcAddress(::frManager:frSystHandle,"SetModal")
   ::_SetRemoveReportOnClose := GetFrProcAddress(::frManager:frSystHandle, "SetRemoveReportOnClose")

RETURN NIL


//////////////////////////////////////////////////////////////////////
// SetAllowEdit() - Enables or disables a finished report editing. 
//                  Default - True
//////////////////////////////////////////////////////////////////////

METHOD SetAllowEdit(lAllow) class frPreviewOptions
   Call_Proc_I(::_SetAllowEdit, IF(lAllow <> NIL, IF(lAllow, 1, 0) , 1))
RETURN self


/////////////////////////////////////////////////////////////////////////
// SetButtons() -   A set of buttons, which will be available in the 
//                  preview window. 
//                  nButtons - is sum of FR_PB_XXX values. See fastreph.ch
//                  Default - All buttons.
//////////////////////////////////////////////////////////////////////////

METHOD SetButtons(nButtons) class frPreviewOptions
   nButtons := IF(nButtons <> NIL, nButtons, 0) 
   Call_Proc_I(::_SetButtons, nButtons)
RETURN self


//////////////////////////////////////////////////////////////////////
// SetDoubleBuffered() - A double-buffer mode for the preview window. 
//                       If enabled (by default), the preview window 
//                       will not flicker during repainting, but the 
//                       process speed would be reduced. 
//////////////////////////////////////////////////////////////////////

METHOD SetDoubleBuffered(lDouble) class frPreviewOptions
   Call_Proc_I(::_SetDoubleBuffered, IF(lDouble <> NIL, IF(lDouble, 1, 0) , 1))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetMaximized() - Defines whether the preview window is maximized
////////////////////////////////////////////////////////////////////////

METHOD SetMaximized(lMax) class frPreviewOptions
   Call_Proc_I(::_SetMaximized, IF(lMax <> NIL, IF(lMax, 1, 0) , 1))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetBounds() - Defines position and size of the preview window
////////////////////////////////////////////////////////////////////////

METHOD SetBounds(nLeft, nTop, nWidth, nHeight) class frPreviewOptions
   Call_Proc_IIII(::_SetBounds, nLeft, nTop, nWidth, nHeight)
RETURN self


////////////////////////////////////////////////////////////////////////
// SetOutlineVisible() - Defines whether the panel with the report 
//                       outline is visible.
////////////////////////////////////////////////////////////////////////

METHOD SetOutlineVisible(lVis) class frPreviewOptions
   Call_Proc_I(::_SetOutlineVisible, IF(lVis <> NIL, IF(lVis, 1, 0) , 0))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetOutlineExpand() - Defines whether the tree of the report 
//                      outline is expand.
////////////////////////////////////////////////////////////////////////

METHOD SetOutlineExpand(lExpand) class frPreviewOptions
   Call_Proc_I(::_SetOutlineExpand, IF(lExpand <> NIL, IF(lExpand, 1, 0) , 1))
RETURN self


//////////////////////////////////////////////////////////////////////////
// SetOutlineWidth() - Defines width of the panel with the report outline.
//////////////////////////////////////////////////////////////////////////

METHOD SetOutlineWidth(nWidth) class frPreviewOptions
   Call_Proc_I(::_SetOutlineWidth, IF(nWidth <> NIL, nWidth , 120))
RETURN self


//////////////////////////////////////////////////////////////////////////
// SetShowCaptions() - Defines whether it is necessary to display button 
//                     captions. When enabling this property, you should 
//                     limit the number of the displayed buttons with 
//                     SetButtons() function, since all the buttons would not 
//                     find room on the screen. 
//////////////////////////////////////////////////////////////////////////

METHOD SetShowCaptions(lShow) class frPreviewOptions
   Call_Proc_I(::_SetShowCaptions, IF(lShow <> NIL, IF(lShow, 1, 0) , 0))
RETURN self


////////////////////////////////////////////////////////////////////////
// SetZoom()-Set default zooming, for example 1.4, Default - 1 
////////////////////////////////////////////////////////////////////////

METHOD SetZoom(nZoom)  class frPreviewOptions //->OldValue 
MEMVAR tmp_Param
PRIVATE tmp_Param := nZoom
   Call_Proc_I(::_SetZoom, IF(nZoom <> NIL, nZoom , 0))
RETURN tmp_Param


////////////////////////////////////////////////////////////////////////
// SetZoomMode()- Set default zooming mode. The following values are 
//                available: 
//                     FR_ZM_DEFAULT        0
//                     FR_ZM_WHOLEPAGE      1
//                     FR_ZM_PAGEWIDTH      2
//                     FR_ZM_MANYPAGES      3
//                       Default - FR_ZM_DEFAULT
////////////////////////////////////////////////////////////////////////

METHOD SetZoomMode(nZMode) class frPreviewOptions //->OldValue 
RETURN Call_Proc_I(::_SetZoomMode, IF(nZMode <> NIL, nZMode, -1))


////////////////////////////////////////////////////////////////////////
//
//  SetPictureCacheInFile() - Cache pictures or not, default - true. 
//
////////////////////////////////////////////////////////////////////////

METHOD SetPictureCacheInFile(lCache) class frPreviewOptions
   Call_Proc_I(::_SetPictureCacheInFile, IF(lCache <> NIL, IF(lCache, 1, 0) , 0))
RETURN self


////////////////////////////////////////////////////////////////////////
//
//  SetModal() - Set preview to modal or not modal mode 
//
////////////////////////////////////////////////////////////////////////


METHOD SetModal(lModal) class frPreviewOptions
   Call_Proc_I(::_SetModal, IF(lModal, 1, 0))
RETURN nil 

////////////////////////////////////////////////////////////////////////
//
//  SetRemoveReportOnClose() - Set to remove(free) or not report at
//                             preview closing. it does not work for 
//                             report with number 0.
//
////////////////////////////////////////////////////////////////////////


METHOD SetRemoveReportOnClose(lRemove) class frPreviewOptions
   Call_Proc_I(::_SetRemoveReportOnClose, IF(lRemove, 1, 0))
RETURN nil 




/////////////--end of frPreviewOptions class--//////////////////////////



//////////////////////////////////////////////////////////////////////
// frReportOptions - A set of properties, relating to the current 
//                     report 
//////////////////////////////////////////////////////////////////////

CLASS frReportOptions
   HIDDEN:
       VAR frManager, _SetAuthor, _SetCompressed, _SetCreateDate, _SetLastChange,;
           _SetDescription, _SetInitString, _SetName, _SetPassword, _SetVersion    

       METHOD PrepareCalls
   EXPORTED:
       METHOD Init
       METHOD SetAuthor
       METHOD SetCompressed
       METHOD SetCreateDate
       METHOD SetLastChange
       METHOD SetDescription
       METHOD SetInitString
       METHOD SetName
       METHOD SetPassword       
       METHOD SetVersion
ENDCLASS


////////////////////////////////////////////////////////////////////////
/////////////--start of frReportOptions class--/////////////////////////
////////////////////////////////////////////////////////////////////////
// Init()
////////////////////////////////////////////////////////////////////////

METHOD Init(oManager) class frReportOptions
   ::frManager := oManager
   ::PrepareCalls()
RETURN self


////////////////////////////////////////////////////////////////////////
// PrepareCalls()
////////////////////////////////////////////////////////////////////////

METHOD PrepareCalls() class frReportOptions

   ::_SetAuthor := GetFrProcAddress(::frManager:frSystHandle, "SetAuthor")
   ::_SetCompressed := GetFrProcAddress(::frManager:frSystHandle, "SetCompressed")
   ::_SetCreateDate := GetFrProcAddress(::frManager:frSystHandle, "SetCreateDate")
   ::_SetLastChange := GetFrProcAddress(::frManager:frSystHandle, "SetLastChange")
   ::_SetDescription := GetFrProcAddress(::frManager:frSystHandle, "SetDescription")
   ::_SetInitString := GetFrProcAddress(::frManager:frSystHandle, "SetInitString")
   ::_SetName := GetFrProcAddress(::frManager:frSystHandle, "SetName")
   ::_SetPassword := GetFrProcAddress(::frManager:frSystHandle, "SetPassword")
   ::_SetVersion := GetFrProcAddress(::frManager:frSystHandle, "SetVersion")

RETURN NIL



////////////////////////////////////////////////////////////////////////
// SetAuthor() - Set or get report author 
////////////////////////////////////////////////////////////////////////

METHOD SetAuthor(sAuthor) class frReportOptions  // ->OldValue 
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetAuthor, IF(sAuthor <> NIL, sAuthor, ""))
RETURN tmp_RetVal


////////////////////////////////////////////////////////////////////////
// SetCompressed() - Set or get report zip-compressed
////////////////////////////////////////////////////////////////////////

METHOD SetCompressed(lCompressed) class frReportOptions // ->OldValue
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_I_I(::_SetCompressed, IF(lCompressed <> NIL, IF(lCompressed, 1, 0) , -1))
RETURN tmp_RetVal


////////////////////////////////////////////////////////////////////////
// SetCreateDate() - Set or get report creation date. Parameter must use
//                the current locale's date/time format. In the US, this
//                is commonly MM/DD/YY HH:MM:SS format, in Russia this 
//                is DD.MM.YYYY HH:MM:SS. Specifying AM or PM as part of
//                the time is optional, as are the seconds. Use 24-hour 
//                time (7:45 PM is entered as 19:45, for example) if AM 
//                or PM is not specified. 
////////////////////////////////////////////////////////////////////////

METHOD SetCreateDate(sDateTime) class frReportOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetCreateDate, IF(sDateTime <> NIL, sDateTime, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////////
// SetLastChange() - Set or get last change date. Parameter is the same as
//                   in SetCreateDate()
//////////////////////////////////////////////////////////////////////////

METHOD SetLastChange(sDateTime) class frReportOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetLastChange, IF(sDateTime <> NIL, sDateTime, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////////
// SetDescription() - Set or get report description. 
//////////////////////////////////////////////////////////////////////////

METHOD SetDescription(sDescription) class frReportOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetDescription, IF(sDescription <> NIL, sDescription, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////////
// SetInitString() - Set or get report init string for dot-matrix reports
//////////////////////////////////////////////////////////////////////////

METHOD SetInitString(sInitString) class frReportOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetInitString, IF(sInitString <> NIL, sInitString, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////////
// SetName() - Set or get report name.
//////////////////////////////////////////////////////////////////////////

METHOD SetName(sName) class frReportOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetName, IF(sName<>NIL, sName, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////////
// SetPassword() - Set or get report password. If password is not blank, 
//                 a password is required when opening a report
//////////////////////////////////////////////////////////////////////////

METHOD SetPassword(sPassword) class frReportOptions // ->OldValue  
MEMVAR tmp_RetVal
PRIVATE tmp_RetVal
   Call_Func_C_I(::_SetPassword, IF(sPassword<>NIL, sPassword, ""))
RETURN tmp_RetVal


//////////////////////////////////////////////////////////////////////////
// SetVersion() - Set or get report version. version consist of :
//
//                 {sVersionMajor, 
//                  sVersionMinor, 
//                  sVersionRelease, 
//                  sVersionBuild} 
//
//////////////////////////////////////////////////////////////////////////

METHOD SetVersion(aVersion) class frReportOptions // ->OldValue  
MEMVAR tmp_Param
PRIVATE tmp_Param := aVersion
  IF (tmp_Param == NIL)
    tmp_Param := {NIL, NIL, NIL, NIL}
  ENDIF
  IF (Len(tmp_Param) < 4)
    ASize(tmp_Param, 4)
  ENDIF
  Call_Func__I(::_SetVersion)
RETURN tmp_Param


/////////////--end of frReportOptions class--////////////////////////////



//////////////////////////////////////////////////////////////////////
//
//  DELPHI.PRG
//
//  Copyright:
//       Spirin Sergey, Paritet Soft, (c) 1992-2008. All rights reserved.
//  
//  Contents:
//       Set of technical function.
//       
//       
//////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
// fnDBStruct - return DbStruct() in one delimited string
//////////////////////////////////////////////////////////////////////

FUNCTION fnDBStruct()
LOCAL Result := '', Arr, x, y
   IF frReportManager():bDbStruct == NIL  
     Arr := DbStruct()
   ELSE
     Arr := Eval(frReportManager():bDbStruct)
   ENDIF
   for x = 1 to Len(Arr)
      for y = 1 to Len(Arr[x]) 
         DO CASE                    
            CASE (y = 1)
              Result := Result + Arr[x,y] 
            CASE (y = 2)
              Result := Result + ',' + Arr[x,y] 
            CASE (y = 3).or.(y = 4)
              Result := Result + ',' + Alltrim(Str(Arr[x,y], 10, 0))
         ENDCASE
      next
      Result := Result + ';'  
   next
RETURN Result
