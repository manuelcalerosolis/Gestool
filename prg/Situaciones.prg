#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TSituaciones FROM TMant

   CLASSDATA oInstance

   CLASSDATA aSituaciones

   DATA  cMru                                   INIT "Document_Attachment_16"

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD Resource( nMode )
   METHOD   lSaveResource()

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

   DEFINE DATABASE ::oDbf FILE "Situa.Dbf" CLASS "Situa" ALIAS "Situa" PATH ( cPath ) VIA ( cDriver ) COMMENT GetTraslation( "Situaciones" )

      FIELD NAME "cSitua"  TYPE "C" LEN 30  DEC 0  COMMENT "Número de serie"        COLSIZE 200    OF ::oDbf

      INDEX TO "Situa.Cdx" TAG "cSitua" ON "Upper( cSitua )"   COMMENT "Situación"  NODELETED      OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE LblTitle( nMode ) + GetTraslation( "situación" )

   REDEFINE GET   ::oDbf:cSitua ;
      ID          100 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
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
      MsgStop( "Código de " + GetTraslation( "situación" ) + " no puede estar vacío" )
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

