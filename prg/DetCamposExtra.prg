#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TDetCamposExtra FROM TMant

   DATA oDbf
   DATA oDlg
   
   DATA oBrw
   DATA oCol

   DATA TipoDocumento      INIT ""

   DATA aCamposExtra       INIT {}

   DATA lOpenFiles         INIT .f.

   DATA oCamposExtra      

   Method New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   Method DefineFiles()

   Method OpenFiles( lExclusive )
   Method CloseFiles()

   Method OpenService( lExclusive )
   Method CloseService()

   Method Reindexa( oMeter )

   Method Play()

   Method Resource( nMode )

   Method SetTipoDocumento( cValor )

   Method CargaValores( cClave )

   Method GuardaValores()              INLINE ( MsgInfo( "Guardamos valores", "provisional" ) )

   Method ChangeBrowse()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TDetCamposExtra

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "01124"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TDetCamposExtra

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "DETCAMPOEXTRA.DBF" CLASS "DETCAMPOEXTRA" ALIAS "DETCAMPOEXTRA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Detalle campos extra"
      
      FIELD NAME "nTipDoc"       TYPE "N" LEN   2  DEC 0 COMMENT "Tipo documento"         HIDE           OF ::oDbf
      FIELD NAME "cCodTipo"      TYPE "C" LEN   3  DEC 0 COMMENT "Código"                 HIDE           OF ::oDbf
      FIELD NAME "cClave"        TYPE "C" LEN  20  DEC 0 COMMENT "Clave principal"        HIDE           OF ::oDbf
      FIELD NAME "cValor"        TYPE "C" LEN 250  DEC 0 COMMENT "Valor del campo"        HIDE           OF ::oDbf

      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "nTipDoc"      ON "nTipDoc"            COMMENT "nTipDoc"             NODELETED OF ::oDbf
      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "cCodTipo"     ON "cCodTipo"           COMMENT "cCodTipo"            NODELETED OF ::oDbf
      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "cClave"       ON "cClave"             COMMENT "cClave"              NODELETED OF ::oDbf
      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "cTipoClave"   ON "cCodTipo + cClave"  COMMENT "cCodTipo + cClave"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetCamposExtra

   local oError
   local oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive         := .f.

   BEGIN SEQUENCE

   if !::lOpenFiles

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::lLoadDivisa()

      ::lOpenFiles         := .t.

      ::oCamposExtra       := TCamposExtra():New()
      ::lOpenFiles         := ::oCamposExtra:OpenFiles()

   end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetCamposExtra

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oCamposExtra != nil
      ::oCamposExtra:End()
   end if

   ::oDbf         := nil
   ::oCamposExtra := nil

   ::lOpenFiles   := .f.

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TDetCamposExtra

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::CloseFiles()

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TDetCamposExtra

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TDetCamposExtra

   if Empty( ::oDbf )
      ::oDbf      := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD SetTipoDocumento( cValor ) CLASS TDetCamposExtra

   ::TipoDocumento  := cValor

   if !Empty( ::TipoDocumento )
      ::aCamposExtra    := ::oCamposExtra:aCamposExtra( ::TipoDocumento )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method Play( cClave )

   if Empty( ::TipoDocumento )
      MsgStop( "No existen campos extra para este tipo de documento." )
      Return .f.
   end if

   if len( ::aCamposExtra ) < 1
      MsgStop( "No existen campos extra para este tipo de documento." )
      Return .f.
   end if  

   ::CargaValores( cClave ) 

   if ::Resource()
      ::GuardaValores( cClave )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CargaValores( cClave ) CLASS TDetCamposExtra

   local nRec     := ::oDbf:Recno()
   local nOrdAnt  := ::oDbf:OrdSetFocus( "cTipoClave" )
   local hCampos

   for each hCampos in ::aCamposExtra

      if ::oDbf:Seek( hGet( hCampos, "código" ) + Padr( cClave, 20 ) )
         hSet( hCampos, "valor", ::oDbf:cValor )
      end if

   next

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TDetCamposExtra

   local oBmp
   
   DEFINE DIALOG ::oDlg RESOURCE "EXTRADET" TITLE "Campos extra"

   REDEFINE BITMAP oBmp ;
      ID          600 ;
      RESOURCE    "form_green_add_48_alpha" ;
      TRANSPARENT ;
      OF          ::oDlg

      ::oBrw                        := IXBrowse():New( ::oDlg )

      ::oBrw:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:SetArray( ::aCamposExtra, , , .f. )

      ::oBrw:nMarqueeStyle          := 6
      ::oBrw:lRecordSelector        := .f.
      ::oBrw:lHScroll               := .f.
      ::oBrw:bChange                := {|| ::ChangeBrowse() }

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Descripción"
         :bStrData         := {|| hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "descripción" ) }
         :nWidth           := 200
      end with

      with object ( ::oCol := ::oBrw:AddCol() )
         :cHeader          := "Valor"
         :bEditValue       := {|| hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valor" ) }
         :nWidth           := 400
      end with

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End( IDOK ) )

   REDEFINE BUTTON  ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      CANCEL ;
      ACTION      ( ::oDlg:End( IDCANCEL ) )

      ::oDlg:bStart        := {|| ::ChangeBrowse() }

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS TDetCamposExtra

   do case 
      case hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "tipo" ) < 4
         ::oCol:nEditType        := EDIT_GET

      case hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "tipo" ) == 4
         ::oCol:nEditType        := EDIT_LISTBOX
         ::oCol:aEditListTxt     := { "si", "no" }

      case hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "tipo" ) == 5
         ::oCol:nEditType        := EDIT_LISTBOX
         ::oCol:aEditListTxt     := hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valores" )

   end case

   ::oCol:bOnPostEdit            := {|o,x,n| hSet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valor", x ) }

Return ( Self )

//---------------------------------------------------------------------------//