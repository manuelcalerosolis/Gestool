#include "FiveWin.ch"
#include "Cmbtll12.ch"

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------

CLASS ListLabel

   DATA  oWnd
   DATA  oActivex
   DATA  hDll
   DATA  hJob

   DATA  cFile
   DATA  cTmpPath
   DATA  lPreview
   DATA  cTitle
   DATA  hWndParent
   DATA  nProject


   Var   lError
   Var   lScreen

   Var   nCicli
   Var   nParz
   VAR   nAddEnd

   Method New           CONSTRUCTOR
   Method JobOpen
   Method JobClose      INLINE ( LlJobClose( ::hJob ) )

   Method OpenReport
   Method DelPreview    VIRTUAL
   Method InsVariable   VIRTUAL
   Method IniField      VIRTUAL
   Method ModiLabel     VIRTUAL
   Method AddRecord     VIRTUAL
   Method EndAppend     VIRTUAL
   Method Preview       VIRTUAL

ENDCLASS

//-----------------------------------------------------------------------------

Method New( nLanguage )

   // ::hDll   := LoadLibrary( "cmll12.dll" )

   ::cFile        := "Article"
   ::cTmpPath     := cPatTmp()
   ::lPreview     := .t.
   ::cTitle       := "Titulo"
   ::hWndParent   := oWnd():hWnd
   ::nProject     := LL_PROJECT_LIST

   ::JobOpen( 1 )

   // LlSetOptionString( ::hJob, LL_OPTIONSTR_LICENSINGINFO, "1W4iOw" )

   LlDefineVariableStart( ::hJob )

   LlDefineVariableExt( ::hJob, "Clientes.Nombre",    "Nombre del cliente",      LL_TEXT, "" )
   LlDefineVariableExt( ::hJob, "Clientes.dirección", "dirección del cliente",   LL_TEXT, "" )

   LlDefineVariableExt( ::hJob, "Agente.Nombre",      "Nombre del agente",       LL_TEXT, "" )
   LlDefineVariableExt( ::hJob, "Agente.dirección",   "dirección del agente",    LL_TEXT, "" )

   LlDefineFieldExt( ::hJob, "Field 1", "Valor del field 1", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Valor del field 2", LL_TEXT, "" )

   LlDefineLayout( ::hJob, ::hWndParent, ::cTitle, ::nProject, ::cFile )

   ::JobClose()

   /*
   Tiramos el informe
   */

   ::JobOpen( 1 )

   LlDefineVariableExt( ::hJob, "Clientes.Nombre",    "Manuel Calero Solís",     LL_TEXT, "" )
   LlDefineVariableExt( ::hJob, "Clientes.dirección", "Cl. Real, 58",            LL_TEXT, "" )

   LlDefineVariableExt( ::hJob, "Agente.Nombre",      "James Bond",              LL_TEXT, "" )
   LlDefineVariableExt( ::hJob, "Agente.dirección",   "Cl. Octopusi, 10",        LL_TEXT, "" )

   LlDefineFieldExt( ::hJob, "Field 1", "Valor del field 1", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Valor del field 2", LL_TEXT, "" )

   LlDefineFieldExt( ::hJob, "Field 1", "Titulo... Valor del field 1.1", nOr( LL_TABLE_HEADERFIELD, LL_TEXT ), "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Titulo... Valor del field 2.1", nOr( LL_TABLE_HEADERFIELD, LL_TEXT ), "" )

   ::OpenReport()

   LlPrint( ::hJob )

   LlDefineFieldExt( ::hJob, "Field 1", "Reporting... Valor del field 1.1", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Reporting... Valor del field 2.1", LL_TEXT, "" )

   llPrintFields( ::hJob )

   LlDefineFieldExt( ::hJob, "Field 1", "Reporting... Valor del field 1.2", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Reporting... Valor del field 2.2", LL_TEXT, "" )

   llPrintFields( ::hJob )

   LlDefineVariableExt( ::hJob, "Variable 1", "Reporting... de la variable 1", LL_TEXT, "" )
   LlDefineVariableExt( ::hJob, "Variable 2", "Reporting... de la variable 2", LL_TEXT, "" )

   LlDefineFieldExt( ::hJob, "Field 1", "Reporting... Valor del field 1.1", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Reporting... Valor del field 2.1", LL_TEXT, "" )

   llPrintFields( ::hJob )

   LlDefineFieldExt( ::hJob, "Field 1", "Reporting... Valor del field 1.2", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Reporting... Valor del field 2.2", LL_TEXT, "" )

   llPrintFields( ::hJob )

   LlDefineFieldExt( ::hJob, "Field 1", "Reporting... Valor del field 1.3", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Reporting... Valor del field 2.3", LL_TEXT, "" )

   llPrintFields( ::hJob )

   LlDefineFieldExt( ::hJob, "Field 1", "Reporting... Valor del field 1.4", LL_TEXT, "" )
   LlDefineFieldExt( ::hJob, "Field 2", "Reporting... Valor del field 2.4", LL_TEXT, "" )

   llPrintFields( ::hJob )

   LlPrint( ::hJob )

   LLPrintEnd( ::hJob, 0 )

   LlPreviewDisplay( ::hJob, ::cFile, ::cTmpPath, ::hWndParent )
   LlPreviewDeleteFiles( ::hJob, ::cFile, ::cTmpPath )

   ::JobClose()

   // FreeLibrary( ::hDll )

   /*
   local hJob        := 1

   DEFINE WINDOW ::oWnd TITLE "FiveWin ActiveX Support"

      ::oActiveX     := TActiveX():New( ::oWnd, "L12.List-Label12_Ctrl_32.1" )

      ::oActiveX:Do( "LlSetOption", LL_OPTION_MULTIPLETABLELINES, 1 )

      ::oActiveX:Do( "LlDefineFieldStart" )

      ::oActiveX:Do( "LlSetPrinterDefaultsDir", hJob, "C:\Windows\Temp" )

      ::oActiveX:Do( "LlDefineLayout", ::oWnd:hWnd, "Designer", LL_PROJECT_LIST, "article.lst" )

      ::InsVariable( "Empresa", "Nombre de la empresa", "TEXT" )

      ::oWnd:oClient := ::oActiveX

   ACTIVATE WINDOW ::oWnd
   */

Return Self

//-----------------------------------------------------------------------------

Method JobOpen( nJob )

   DEFAULT nJob   := 1

   ::hJob         := LlJobOpen( nJob )

Return ( ::hJob )

//-----------------------------------------------------------------------------

Method OpenReport()

   local nError

   if  ::lPreview
      nError   := LlPrintWithBoxStart( ::hJob, ::nProject, ::cFile, LL_PRINT_PREVIEW, LL_BOXTYPE_BRIDGEMETER, ::hWndParent, ::cTitle )
      nError   := LlPreviewSetTempPath( ::hJob, ::cTmpPath )
   else
      nError   := LlPrintWithBoxStart( ::hJob, ::nProject, ::cFile, LL_PRINT_NORMAL, LL_BOXTYPE_BRIDGEMETER, ::cTitle )
   endif

   nError      := LlPrintSetOption( ::hJob, LL_OPTION_COPIES, LL_COPIES_HIDE )
   nError      := LlPrintOptionsDialog( ::hJob, ::hWndParent, ::cTitle )

   if nError < 0
      msginfo( "Tenemos errores" + Str( nError ) )
   endif

Return Self

//-----------------------------------------------------------------------------

#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"

#include "cmbtll12.h"

HB_FUNC( LLJOBOPEN )
{
   hb_retni( LlJobOpen( hb_parni( 1 ) ) );
}

HB_FUNC( LLJOBCLOSE )
{
   LlJobClose( hb_parni( 1 ) );
}

HB_FUNC( LLPRINT )
{
   hb_retni( LlPrint( hb_parni( 1 ) ) );
}

HB_FUNC( LLPRINTFIELDS )
{
   hb_retni( LlPrintFields( hb_parni( 1 ) ) );
}

HB_FUNC( LLPRINTFIELDSEND )
{
   hb_retni( LlPrintFieldsEnd( hb_parni( 1 ) ) );
}

HB_FUNC( LLPRINTEND )
{
   hb_retni( LlPrintEnd( hb_parni( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( LLDEFINEVARIABLESTART )
{
   LlDefineVariableStart( ( HLLJOB ) hb_parni( 1 ) );
}

HB_FUNC( LLDEFINELAYOUT )
{
   hb_retni( LlDefineLayout( hb_parni( 1 ), ( HWND ) hb_parni( 2 ), hb_parc( 3 ), hb_parni( 4 ), hb_parc( 5 ) ) );
}

HB_FUNC( LLDEFINEVARIABLE )
{
   hb_retni( LlDefineVariable( hb_parni( 1 ), hb_parc( 2 ), hb_parc( 3 ) ) );
}

HB_FUNC( LLDEFINEVARIABLEEXT )
{
   hb_retni( LlDefineVariableExt( hb_parni( 1 ), hb_parc( 2 ), hb_parc( 3 ), hb_parni( 4 ), hb_parc( 5 ) ) );
}

HB_FUNC( LLDEFINEFIELD )
{
   hb_retni( LlDefineField( hb_parni( 1 ), hb_parc( 2 ), hb_parc( 3 ) ) );
}

HB_FUNC( LLDEFINEFIELDEXT )
{
   hb_retni( LlDefineFieldExt( hb_parni( 1 ), hb_parc( 2 ), hb_parc( 3 ), hb_parni( 4 ), hb_parc( 5 ) ) );
}

HB_FUNC( LLSETOPTIONSTRING )
{
   hb_retni( LlSetOptionString( hb_parni( 1 ), hb_parni( 2 ), hb_parc( 3 ) ) );
}

HB_FUNC( LLPRINTWITHBOXSTART )
{
   hb_retni( LlPrintWithBoxStart( hb_parni( 1 ), hb_parni( 2 ), hb_parc( 3 ), hb_parni( 4 ), hb_parni( 5 ), ( HWND ) hb_parni( 6 ), hb_parc( 7 ) ) );
}

HB_FUNC( LLPREVIEWSETTEMPPATH )
{
   hb_retni( LlPreviewSetTempPath( hb_parni( 1 ), hb_parc( 2 ) ) );
}

HB_FUNC( LLPRINTSETOPTION )
{
   hb_retni( LlPrintSetOption( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
}

HB_FUNC( LLPRINTOPTIONSDIALOG )
{
   hb_retni( LlPrintOptionsDialog( hb_parni( 1 ), ( HWND ) hb_parni( 2 ), hb_parc( 3 ) ) );
}

HB_FUNC( LLPREVIEWDISPLAY )
{
   hb_retni( LlPreviewDisplay( hb_parni( 1 ), hb_parc( 2 ), hb_parc( 3 ), ( HWND ) hb_parni( 4 ) ) );
}

HB_FUNC( LLPREVIEWDELETEFILES )
{
   hb_retni( LlPreviewDeleteFiles( hb_parni( 1 ), hb_parc( 2 ), hb_parc( 3 ) ) );
}

#pragma ENDDUMP

//-----------------------------------------------------------------------------