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
  
   DATA TipoDocumento         INIT ""

   DATA aCamposExtra          INIT {}

   DATA lOpenFiles            INIT .f.

   DATA oCamposExtra  

   DATA hFormatoColumnas      INIT  {}

   DATA bId

   Method New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   Method DefineFiles()

   Method OpenFiles( lExclusive )
   Method CloseFiles()

   Method OpenService( lExclusive )
   Method CloseService()

   Method SetTipoDocumento( cValor )   INLINE ( ::TipoDocumento  := cValor )

   Method Reindexa( oMeter )

   Method Play()

   Method Resource( nMode )

   Method CargaValores( cClave )

   Method RollBackValores( cClave )

   Method GuardaValores( cClave )

   Method ChangeBrowse()

   Method setColType( uValue )         INLINE ( ::oCol:nEditType := uValue )
   Method setColPicture( uValue )      INLINE ( ::oCol:cEditPicture := uValue )
   Method setColListTxt( aValue )      INLINE ( ::oCol:aEditListTxt := aValue )

   Method setbId( bValue )             INLINE ( ::bId := bValue )

   Method cFormat2Char( uValor )
   Method cChar2Format( uValor, nFormat )

   Method lPreSave()

   METHOD lExisteCamposExtra()         INLINE ( len( ::aCamposExtra ) < 1 )

   METHOD addCamposExtra( oBrw )

   METHOD nAlignData( campoExtra )     INLINE ( if( campoExtra[ "tipo" ] == 2, AL_RIGHT, AL_LEFT ) )

   METHOD cPictData( campoExtra )

   METHOD cFormatValue( campoExtra )

   METHOD editColCampoExtra( oCol, uNewValue, nKey )

   METHOD aExtraFields()                 INLINE ( ::oCamposExtra:aCamposExtra( ::TipoDocumento ) )

   METHOD valueExtraField()

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

   ::hFormatoColumnas      := {  "1" => {||  ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "" ) } ,;
                                 "2" => {||  ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( NumPict( hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "longitud" ) + hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "decimales" ) - 1, hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "decimales" ), , .t. ) ) } ,;
                                 "3" => {||  ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "" ) } ,;
                                 "4" => {||  ::setColType( EDIT_LISTBOX ),;
                                             ::setColListTxt( { "si", "no" } ),;
                                             ::setColPicture( "" ) } ,;
                                 "5" => {||  ::setColType( EDIT_LISTBOX ) ,;
                                             ::setColListTxt( hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valores" ) ) ,;
                                             ::setColPicture( "" ) } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TDetCamposExtra

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "DETCEXTRA.DBF" CLASS "DETCEXTRA" ALIAS "DETCEXTRA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Detalle campos extra"
      
      FIELD NAME "cTipDoc"       TYPE "C" LEN   2  DEC 0 COMMENT "Tipo documento"         HIDE           OF ::oDbf
      FIELD NAME "cCodTipo"      TYPE "C" LEN   3  DEC 0 COMMENT "Código"                 HIDE           OF ::oDbf
      FIELD NAME "cClave"        TYPE "C" LEN  20  DEC 0 COMMENT "Clave principal"        HIDE           OF ::oDbf
      FIELD NAME "cValor"        TYPE "C" LEN 250  DEC 0 COMMENT "Valor del campo"        HIDE           OF ::oDbf

      INDEX TO "DETCEXTRA.Cdx" TAG "cTipDoc"      ON "cTipDoc"                        COMMENT "cTipDoc"                      NODELETED OF ::oDbf
      INDEX TO "DETCEXTRA.Cdx" TAG "cCodTipo"     ON "cCodTipo"                       COMMENT "cCodTipo"                     NODELETED OF ::oDbf
      INDEX TO "DETCEXTRA.Cdx" TAG "cClave"       ON "cClave"                         COMMENT "cClave"                       NODELETED OF ::oDbf
      INDEX TO "DETCEXTRA.Cdx" TAG "cTipoClave"   ON "cCodTipo + cClave"              COMMENT "cCodTipo + cClave"            NODELETED OF ::oDbf
      INDEX TO "DETCEXTRA.Cdx" TAG "cTotClave"    ON "cTipDoc + cCodTipo + cClave"    COMMENT "cTipDoc + cCodTipo + cClave"  NODELETED OF ::oDbf

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
      ::oCamposExtra:CloseFiles()
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

   ::CloseService()

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

Method Play( cClave, lResource )

   DEFAULT lResource    := .t.

   if Empty( ::TipoDocumento )
      MsgStop( "No existen campos extra para este tipo de documento." )
      Return .f.
   end if

   if !Empty( ::TipoDocumento )
      ::aCamposExtra    := ::oCamposExtra:aCamposExtra( ::TipoDocumento )
   end if

   if len( ::aCamposExtra ) < 1
      MsgStop( "No existen campos extra para este tipo de documento." )
      Return .f.
   end if  

   ::CargaValores( cClave ) 

   if lResource

      if ::Resource()
         ::RollBackValores( cClave )
         ::GuardaValores( cClave )
      end if

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD cFormat2Char( uValor, ldtos ) CLASS TDetCamposExtra

   DEFAULT ldtos     := .f.

   do case 
      case Valtype( uValor ) == "C"
         Return ( Padr( uValor, 250 ) )

      case Valtype( uValor  ) == "D"
         Return ( Padr( if( lDtos, dtos( uValor ), dtoc( uValor ) ), 250 ) )

      case Valtype( uValor ) == "N"
         Return ( Padr( Str( uValor ), 250 ) )

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD cChar2Format( uValor, nFormat ) CLASS TDetCamposExtra

   do case 
      case nFormat == 2
         Return ( Val( AllTrim( uValor ) ) )

      case nFormat == 3
         Return ( ctod( AllTrim( uValor ) ) )

   end case

Return ( uValor )

//---------------------------------------------------------------------------//

METHOD CargaValores( cClave ) CLASS TDetCamposExtra

   local nRec              := ::oDbf:Recno()
   local nOrdAnt           := ::oDbf:OrdSetFocus( "cTotClave" )
   local hCampos
   local cClavePrincipal

   for each hCampos in ::aCamposExtra

      cClavePrincipal      := hGet( DOCUMENTOS_ITEMS, ::TipoDocumento ) + hGet( hCampos, "código" ) + Padr( cClave, 20 )

      if ::oDbf:Seek( cClavePrincipal )

         hSet( hCampos, "valor", ::cChar2Format( ::oDbf:cValor, hGet( hCampos, "tipo" ) ) )

      end if

   next

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TDetCamposExtra

   local oBmp
   local oBtnAceptar
   
   DEFINE DIALOG ::oDlg RESOURCE "EXTRADET" TITLE "Campos extra"

   REDEFINE BITMAP oBmp ;
      ID          600 ;
      RESOURCE    "form_green_add_48_alpha" ;
      TRANSPARENT ;
      OF          ::oDlg

      ::oBrw                        := IXBrowse():New( ::oDlg )

      ::oBrw:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      msgalert( hb_valtoexp( ::aCamposExtra ), "aCamposExtra" )
      msgalert( valtype( ::aCamposExtra ), "hOptions" ) 

      ::oBrw:SetArray( ::aCamposExtra, , , .f. )

      ::oBrw:nMarqueeStyle          := MARQSTYLE_HIGHLCELL
      ::oBrw:lRecordSelector        := .f.
      ::oBrw:lHScroll               := .f.
      ::oBrw:lFastEdit              := .t.

      ::oBrw:bChange                := {|| ::ChangeBrowse() }

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Campo"
         :bStrData         := {|| AllTrim( hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "descripción" ) ) + if( hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "lrequerido" ), " *", "" ) }
         :nWidth           := 250
      end with

      with object ( ::oCol := ::oBrw:AddCol() )
         :cHeader          := "Valor"
         :bEditValue       := {|| hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valor" ) }
         :bStrData         := {|| hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valor" ) }
         :nWidth           := 300
      end with

   REDEFINE BUTTON oBtnAceptar ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( if( ::lPresave(), ::oDlg:End( IDOK ), ) )

   REDEFINE BUTTON  ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      CANCEL ;
      ACTION      ( ::oDlg:End( IDCANCEL ) )

      ::oDlg:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

      ::oDlg:bStart        := {|| ::ChangeBrowse() }

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave() CLASS TDetCamposExtra

   local cError   := ""
   local hCampo

   for each hCampo in ::aCamposExtra

      if hGet( hCampo, "lrequerido" ) .and. empty( ::cFormat2Char( hGet( hCampo, "valor" ), .t. ) )
         cError   += Space( 3 ) + "* " + AllTrim( hGet( hCampo, "descripción" ) ) + CRLF
      end if

   next

   if !Empty( cError )
      MsgStop( "Campos obligatorios que no están rellenos: " + CRLF + cError )
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS TDetCamposExtra

   Eval( hGet( ::hFormatoColumnas, AllTrim( Str( hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "tipo" ) ) ) ) )

   ::oCol:bOnPostEdit            := {|o,x,n| hSet( ::aCamposExtra[ ::oBrw:nArrayAt ], "valor", x ) }

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RollBackValores( cClave ) CLASS TDetCamposExtra

   local nRec     := ::oDbf:Recno()
   local nOrdAnt  := ::oDbf:OrdSetFocus( "cTotClave" )
   local hCampos
   local cClavePrincipal

   for each hCampos in ::aCamposExtra

      cClavePrincipal    := hGet( DOCUMENTOS_ITEMS, ::TipoDocumento ) + hGet( hCampos, "código" ) + Padr( cClave, 20 )

      while ::oDbf:Seek( cClavePrincipal )
         ::oDbf:Delete()
      end while

   next

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaValores( cClave ) CLASS TDetCamposExtra

   local hCampos

   for each hCampos in ::aCamposExtra

      ::oDbf:Append()

      ::oDbf:cTipDoc    := hGet( DOCUMENTOS_ITEMS, ::TipoDocumento )
      ::oDbf:cCodTipo   := hGet( hCampos, "código" )
      ::oDbf:cClave     := padr( cClave, 20 )
      ::oDbf:cValor     := ::cFormat2Char( hGet( hCampos, "valor" ) )

      ::oDbf:Save()

   next

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD addCamposExtra( oBrw ) CLASS TDetCamposExtra

   local campoExtra

   if empty( oBrw )
      Return .f.
   end if

   if empty( ::bId )
      Return .f.
   end if

   if empty( ::TipoDocumento )
      Return .f.
   end if

   ::aCamposExtra          := ::oCamposExtra:aCamposExtra( ::TipoDocumento )

   if ::lExisteCamposExtra()
      Return .f.
   end if

   for each campoExtra in ::aCamposExtra

      with object ( oBrw:AddCol() )
         :cHeader          := Capitalize( AllTrim( campoExtra[ "descripción" ] ) )
         :bStrData         := {|| ::cFormatValue( campoExtra ) }
         :nDataStrAlign    := ::nAlignData( campoExtra )
         :nHeadStrAlign    := ::nAlignData( campoExtra )
         :nWidth           := 100
         :lHide            := .t.
         :nEditType        := 1
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::editColCampoExtra( oCol, uNewValue, campoExtra, oBrw ) }
      end with

   next

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD editColCampoExtra( oCol, uNewValue, campoExtra, oBrw ) CLASS TDetCamposExtra

   local nRec        := ::oDbf:Recno()
   local nOrdAnt     := ::oDbf:OrdSetFocus( "cTotClave" )

   if ::oDbf:Seek( hGet( DOCUMENTOS_ITEMS, ::TipoDocumento ) + campoExtra[ "código" ] + eval( ::bId ) )

      ::oDbf:Load()
      ::oDbf:cValor    := ::cFormat2Char( uNewValue )
      ::oDbf:Save()

   else

      ::oDbf:Append()
      ::oDbf:cTipDoc    := hGet( DOCUMENTOS_ITEMS, ::TipoDocumento )
      ::oDbf:cCodTipo   := campoExtra[ "código" ]
      ::oDbf:cClave     := eval( ::bId )
      ::oDbf:cValor     := ::cFormat2Char( uNewValue )
      ::oDbf:Save()      

   end if

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD cFormatValue( campoExtra ) CLASS TDetCamposExtra

   local uValue

   if campoExtra[ "tipo" ] == 2   
      uValue   := Trans( Val( oRetFld( hGet( DOCUMENTOS_ITEMS, ::TipoDocumento ) + campoExtra[ "código" ] + eval( ::bId ), ::oDbf, "cValor", "cTotClave" ) ), ::cPictData( campoExtra ) )
   else
      uValue   := oRetFld( hGet( DOCUMENTOS_ITEMS, ::TipoDocumento ) + campoExtra[ "código" ] + eval( ::bId ), ::oDbf, "cValor", "cTotClave" )
   end if

Return uValue

//---------------------------------------------------------------------------//

METHOD cPictData( campoExtra ) CLASS TDetCamposExtra

   local cPict    := ""

   if campoExtra[ "tipo" ] == 2
      cPict       := NumPict( ( campoExtra[ "longitud" ] + campoExtra[ "decimales" ] ) -1, campoExtra[ "decimales" ] )
   else 
      cPict       := ""
   end if

Return ( cPict )

//---------------------------------------------------------------------------//

METHOD valueExtraField( cCampo, cClave, cField ) CLASS TDetCamposExtra

   local nRec              := ::oDbf:Recno()
   local nOrdAnt           := ::oDbf:OrdSetFocus( "cTotClave" )
   local cClavePrincipal   := ""
   local valueExtraField

   cClavePrincipal         := hGet( DOCUMENTOS_ITEMS, ::TipoDocumento ) + cCampo + Padr( cClave, 20 )

   if ::oDbf:Seek( cClavePrincipal )

      if cField[ "tipo" ] == 2
         valueExtraField      := Val( ::oDbf:cValor )
      else
         valueExtraField      := ::oDbf:cValor
      end if

   end if

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

Return ( valueExtraField )

//---------------------------------------------------------------------------//