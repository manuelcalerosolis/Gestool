#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TSituaciones FROM TMant

   CLASSDATA oInstance

   CLASSDATA aSituaciones

   DATA  cMru                                   INIT "gc_document_attachment_16"
   DATA  oComercio
   DATA  lenguajePrestashop

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD Resource( nMode )
   METHOD lSaveResource()

   METHOD Activate()
   METHOD sincronizarSituacionesPrestashop()
   METHOD findState( statePrestashop )          INLINE ( ::oDbf:SeekInOrd( upper( statePrestashop ), "cSitua" ) )   
   METHOD processStatePrestashop()
   METHOD assignIdPrestashop( idStatePrestashop );
                                                INLINE ( ::oDbf:FieldPutByName( "idPs", idStatePrestashop ) )
   METHOD importStatePrestashop( oQuery )
   METHOD importState( oQuery )
   METHOD exportStateGestool( oQuery )
   METHOD exportState( oQuery )
   METHOD exportStateLang( oQuery )
   //METHOD idState()

   METHOD LoadSituaciones()
   METHOD LoadSituacionesFromFiles()            INLINE ( if( ::OpenFiles(), ( ::LoadSituaciones(), ::CloseFiles() ), ) )
   METHOD GetSituaciones()                      INLINE ( ::LoadSituacionesFromFiles(), ::aSituaciones ) 

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01096"

   ::Create( cPath )

   if Empty( ::nLevel )
      ::nLevel          := nLevelUsr( oMenuItem )
   end if

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatDat()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Situa.Dbf" CLASS "Situa" ALIAS "Situa" PATH ( cPath ) VIA ( cDriver ) COMMENT getConfigTraslation( "Situaciones" )

      FIELD NAME "cSitua"  TYPE "C"      LEN 140     DEC 0       COMMENT "Número de serie"               COLSIZE 200    OF ::oDbf
      FIELD NAME "idPs"    TYPE "N"      LEN 9       DEC 0       COMMENT "Codigo prestashop"   HIDE      COLSIZE 200    OF ::oDbf

      INDEX TO "Situa.Cdx" TAG "cSitua"   ON "Upper( cSitua )"    COMMENT "Situación"           NODELETED      OF ::oDbf
      INDEX TO "Situa.Cdx" TAG "idPs"     ON "idPs"               COMMENT "Id de Prestashop"    NODELETED      OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE LblTitle( nMode ) + getConfigTraslation( "situación" )

   REDEFINE GET   ::oDbf:cSitua ;
      ID          100 ;
      WHEN        ( nMode != ZOOM_MODE ) ; 
      OF          oDlg

   REDEFINE GET   ::oDbf:idPs ;
      ID          200 ;
      WHEN        ( .f. ) ; 
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      ACTION      ( ::lSaveResource( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( oDlg )

   if Empty( ::oDbf:cSitua )
      MsgStop( "Código de " + getConfigTraslation( "situación" ) + " no puede estar vacío" )
      ::oGetCodigo:SetFocus()
      Return nil
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD LoadSituaciones()

   ::aSituaciones := {}

   ::oDbf:GoTop()
   while !::oDbf:Eof()
      aAdd( ::aSituaciones, ::oDbf:cSitua )
      ::oDbf:Skip()
   end while

Return ( ::aSituaciones )

//---------------------------------------------------------------------------//

METHOD Activate() 

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" GROUP OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::sincronizarSituacionesPrestashop() ) ;
         TOOLTIP  "Sincronizar";
         HOTKEY   "N" ;
         LEVEL    ACC_IMPR

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( , , , , , , , , , , , , , , , , {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD sincronizarSituacionesPrestashop()

   ::oComercio             := TComercio():New()

   if !::oComercio:connect()
      msgStop( "No se ha podido conectar a la base de datos" )
      Return ( .f. )
   end if 

   ::lenguajePrestashop    := ::oComercio:GetLanguagePrestashop()

   ::processStatePrestashop()

   ::oComercio:disconnect()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processStatePrestashop()

   local oQuery   := TMSQuery():New( ::oComercio:oCon, "SELECT * FROM " + ::oComercio:cPrefixtable( "order_state_lang" ) + " WHERE id_lang = " + alltrim( str( ::lenguajePrestashop ) ) )

   if oQuery:Open() .and. ( oQuery:RecCount() > 0 )
      
      ::oDbf:getStatus()

      while !oQuery:Eof()

         ::importStatePrestashop( oQuery )         
         oQuery:Skip()

      end while

      ::exportStateGestool( oQuery )

      ::oDbf:setStatus()

   endif

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD importStatePrestashop( oQuery )

   if ::findState( oQuery:FieldGetByName( "name" ) )

            if empty( ::oDbf:idPs )
               ::assignIdPrestashop( oQuery:FieldGetByName( "id_order_state" ) )
            end if 

         else
            ::importState( oQuery )
         endif

Return( .t. ) 

//---------------------------------------------------------------------------//

METHOD importState( oQuery )
   
   ::oDbf:Append()
   ::oDbf:cSitua     := oQuery:FieldGetByName( "name" )
   ::oDbf:idPs       := oQuery:FieldGetByName( "id_order_state" )
   ::oDbf:Save()

Return ( .t. )

//---------------------------------------------------------------------------// 

METHOD exportStateGestool( oQuery )

   local insertState
   local insertStateLang
   local idPs

   ::oDbf:GoTop()

   while !::oDbf:eof()

      if empty( ::oDbf:idps )

         idPs         := ::exportState()  

         ::exportStateLang( idPs )
      
      endif

      ::oDbf:Skip()

   end while

Return( .t. )

//---------------------------------------------------------------------------// 

METHOD exportState()

   local insertState
   local idps
   
   insertState               :="INSERT INTO " + ::oComercio:cPrefixtable( "order_state" ) + " VALUES ( '', 0, 0, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0 )" 

   if TMSCommand():New( ::oComercio:oCon ):ExecDirect( insertState )
      idPs            := ::oComercio:oCon:GetInsertId()
   end if 

   if !empty( idPs )
      ::oDbf:fieldPutByName( "idPs", idPs )
   endif

         
Return( idps )

//---------------------------------------------------------------------------// 

METHOD exportStateLang( idPs )

   local insertStateLang

      insertStateLang           :="INSERT INTO " + ::oComercio:cPrefixtable( "order_state_lang" ) + " VALUES ( " + alltrim( str( idPs ) ) + ", " + alltrim( str( ::lenguajePrestashop ) ) + ", '" + alltrim( ::oDbf:cSitua ) + "', '' ) "

      if TMSCommand():New( ::oComercio:oCon ):ExecDirect( insertStateLang )

         if !empty( idPs )
            ::oDbf:fieldPutByName( "idPs", idPs )
         endif
   
      end if
   
Return( .t. )

//---------------------------------------------------------------------------// 

