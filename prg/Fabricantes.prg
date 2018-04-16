#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TFabricantes FROM TMant

   DATA  cText
   DATA  oSender
   DATA  lSelectSend
   DATA  lSelectRecive
   DATA  cIniFile
   DATA  lSuccesfullSend
   
   METHOD Create( cPath )                       CONSTRUCTOR
   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Initiate( cText, oSender )            CONSTRUCTOR

   METHOD Activate()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )

   METHOD Publicar()

   METHOD Envio()

   METHOD cCodigoWeb( cCodArt )

   METHOD lPreSave( oGet, oGet2, oDlg, nMode )

   METHOD CreateData()
   METHOD RestoreData()
   METHOD SendData()
   METHOD ReciveData()
   METHOD Process()

   METHOD nGetNumberToSend()
   METHOD Save()
   METHOD Load()

   METHOD Syncronize()

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath     := cPatEmp()

   ::cPath           := cPath
   ::oDbf            := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := Auth():Level( "01013" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::oDbf               := nil

   ::cMru               := "gc_bolt_16"

   ::cBitmap            := clrTopArchivos

   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Initiate( cText, oSender )

   ::cText              := cText
   ::oSender            := oSender
   ::cIniFile           := cIniEmpresa()
   ::lSuccesfullSend    := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "Lbl" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Envio() ) ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Publicar( .t. ) ) ;
         TOOLTIP  "(P)ublicar" ;
         HOTKEY   "P";
         LEVEL    ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir las bases de datos fabricantes" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Fabric.Dbf" CLASS "Fabric" ALIAS "Fabric" PATH ( cPath ) VIA ( cDriver ) COMMENT "Fabricantes o marcas"

      FIELD CALCULATE NAME "bSndDoc"            LEN  14  DEC 0 COMMENT { "Envio", "gc_mail2_16", 3 }     VAL {|| ::oDbf:lSndDoc }   BITMAPS "gc_mail2_12", "Nil16" COLSIZE 20 OF ::oDbf
      FIELD CALCULATE NAME "bPubInt"            LEN  14  DEC 0 COMMENT { "Publicar", "gc_earth_16", 3 }  VAL {|| ::oDbf:lPubInt}    BITMAPS "gc_earth_12", "Nil16" COLSIZE 20 OF ::oDbf
      FIELD NAME "cCodFab"             TYPE "C" LEN   3  DEC 0 COMMENT "Código"         PICTURE "@!"  COLSIZE 60   OF ::oDbf
      FIELD NAME "cNomFab"             TYPE "C" LEN  35  DEC 0 COMMENT "Nombre"                       COLSIZE 200  OF ::oDbf
      FIELD NAME "lPubInt"             TYPE "L" LEN   1  DEC 0 COMMENT "Publicar"                     HIDE         OF ::oDbf
      FIELD NAME "cImgLogo"            TYPE "C" LEN 254  DEC 0 COMMENT "Imagen logo"                  HIDE         OF ::oDbf
      FIELD NAME "cCodWeb"             TYPE "N" LEN  11  DEC 0 COMMENT "Código Web"                   HIDE         OF ::oDbf
      FIELD NAME "cUrlFab"             TYPE "C" LEN 250  DEC 0 COMMENT "Url"                          COLSIZE 200  OF ::oDbf
      FIELD NAME "lSndDoc"             TYPE "L" LEN   1  DEC 0 COMMENT "Envio"                        HIDE         OF ::oDbf
      FIELD NAME "uuid"                TYPE "C" LEN  40  DEC 0 COMMENT "uuid"                         HIDE         OF ::oDbf

      INDEX TO "Fabric.CDX"    TAG "cCodFab" ON "cCodFab"             COMMENT "Código"     NODELETED OF ::oDbf
      INDEX TO "Fabric.CDX"    TAG "cNomFab" ON "cNomFab"             COMMENT "Nombre"     NODELETED OF ::oDbf
      INDEX TO "Fabric.CDX"    TAG "cCodWeb" ON "Str( cCodWeb, 11 )"  COMMENT "Código web" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oGet2
   local oGetImg
   local bmpImage

   DEFINE DIALOG oDlg RESOURCE "Fabricante" TITLE LblTitle( nMode ) + "fabricantes"

      REDEFINE GET oGet VAR ::oDbf:cCodFab UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR ::oDbf:cNomFab UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oGetImg VAR ::oDbf:cImgLogo UPDATE;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( GetBmp( oGetImg, bmpImage ) ) ;
         ON CHANGE( ChgBmp( oGetImg, bmpImage ) ) ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR ::oDbf:cUrlFab UPDATE;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lPubInt ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( ::Publicar() ) ;
         OF       oDlg

      REDEFINE IMAGE bmpImage ;
         ID       500 ;
         OF       oDlg ;
         FILE     cFileBmpName( ::oDbf:cImgLogo )

      bmpImage:SetColor( , GetSysColor( 15 ) )
      bmpImage:bLClicked   := {|| ShowImage( bmpImage ) }
      bmpImage:bRClicked   := {|| ShowImage( bmpImage ) }

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Tipos_de_fabricantes" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oGet2, oDlg, nMode ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Tipos_de_fabricantes" ) } )

      oDlg:bStart := {|| oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oGet2, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodFab )
         MsgStop( "Código de tipo de fabricante no puede estar vacío." )
         oGet:SetFocus()
         RETURN .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodFab, "cCodFab" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodFab ) )
         RETURN nil
      end if

   end if

   if Empty( ::oDbf:cNomFab )
      MsgStop( "Nombre de tipo de fabricante no puede estar vacío." )
      oGet2:SetFocus()
      RETURN .f.
   end if

   ::oDbf:lSndDoc := .t.

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

METHOD lValid( oGet, oSay )

   local cCodArt

   if Empty( oGet:VarGet() )
      RETURN .t.
   end if

   cCodArt        := RJustObj( oGet, "0" )

   if ::oDbf:Seek( cCodArt )
      oGet:cText( cCodArt )
      if oSay != nil
         oSay:cText( ::oDbf:cNomFab )
      end if
   else
      msgStop( "Código no encontrado" )
      RETURN .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cNombre( cCodArt )

   local cNombre  := ""

   if ::oDbf:Seek( cCodArt )
      cNombre     := ::oDbf:cNomFab
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD cCodigoWeb( cCodArt )

   local cCodigoWeb  := ""

   if ::oDbf:Seek( cCodArt )
      cCodigoWeb     := ::oDbf:cCodWeb
   end if

RETURN ( cCodigoWeb )

//---------------------------------------------------------------------------//

METHOD Publicar( lLoad ) CLASS TFabricantes

   DEFAULT lLoad     := .f.

   if lLoad
      ::oDbf:Load()
      ::oDbf:lPubInt := !::oDbf:lPubInt
      ::oDbf:lSndDoc := ::oDbf:lPubInt
   end if

      ::oDbf:cCodWeb := 0

   if lLoad
      ::oDbf:Save()
      ::oWndBrw:Refresh()
   end if

   if !Empty( ::oWndBrw )
      ::oWndBrw:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Envio() CLASS TFabricantes

   ::oDbf:Load()
   ::oDbf:lSndDoc := !::oDbf:lSndDoc
   ::oDbf:Save()

   ::oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateData()

   local lSnd        := .t.
   local oFabricantes
   local oFabricantesTmp
   local cFileName

   if ::oSender:lServer
      cFileName      := "Fabricantes" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Fabricantes" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando movimientos de almacén" )

   oFabricantes      := ::DefineFiles( cPatEmp() )
   oFabricantes:Activate()

   oFabricantes:OrdSetFocus( "cCodFab" )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   oFabricantesTmp   := ::DefineFiles( cPatSnd() )
   oFabricantesTmp:Activate()

   oFabricantesTmp:OrdSetFocus( "cCodFab" )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   while !oFabricantes:eof()

      if oFabricantes:lSndDoc

         lSnd  := .t.

         dbPass( oFabricantes:nArea, oFabricantesTmp:nArea, .t. )

         ::oSender:SetText( oFabricantes:cCodFab )

      end if

      oFabricantes:Skip()

   end while

   /*
   Cerrar ficheros temporales--------------------------------------------------
   */

   oFabricantes:End()
   oFabricantesTmp:End()

   if lSnd

      /*
      Comprimir los archivos
      */

      ::oSender:SetText( "Comprimiendo fabricantes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos en " + Rtrim( cFileName ) )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay movimientos de almacén para enviar" )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD RestoreData()

   local oFabricantes

   if ::lSuccesfullSend

      oFabricantes   := ::DefineFiles( cPatEmp() )
      oFabricantes:Activate()

      oFabricantes:oDbf:GoTop()

      while !oFabricantes:oDbf:Eof()

         if oFabricantes:oDbf:lSelDoc
            oFabricantes:oDbf:FieldPutByName( "lSelDoc", .f. )
         end if

         oFabricantes:oDbf:Skip()

      end while

      oFabricantes:End()

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SendData()

   local cFileName

   if ::oSender:lServer
      cFileName      := "Fabricantes" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Fabricantes" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if file( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero no enviado" )
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt        := aRetDlgEmp()
   else
      aExt        := { "All" }
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo fabricantes" )

   for n := 1 to len( aExt )
      ::oSenderGetFiles( "Fabricantes*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Fabricantes recibidos" )

RETURN Self

//----------------------------------------------------------------------------//

METHOD Process()

   local m
   local oBlock
   local oError
   local oFabricantes
   local oFabricantesTmp
   local aFiles               := Directory( cPatIn() )

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Importando movimientos de almacén" )

   for m := 1 to len( aFiles )

      oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales---------------------------------------------------
         */

         ::oSender:SetText( "Procesando fichero " + cPatIn() + aFiles[ m, 1 ] )

         if file( cPatSnd() + "Fabric.Dbf" )

            oFabricantes      := ::DefineFiles( cPatEmp() )
            oFabricantes:Activate()

            oFabricantes:OrdSetFocus( "cCodFab" )

            /*
            Creamos todas las bases de datos relacionadas con Articulos
            */

            oFabricantesTmp   := ::DefineFiles( cPatSnd() )
            oFabricantesTmp:Activate()

            oFabricantesTmp:OrdSetFocus( "cCodFab" )

            /*
            Trasbase de turnos-------------------------------------------------------
            */

            while !( oFabricantesTmp:eof() )

               if oFabricantes:Seek( oFabricantesTmp:cCodFab )
                  if !::oSender:lServer
                     dbPass( oFabricantesTmp:cAlias, oFabricantes:cAlias )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( oFabricantes:cCodFab ) + "; " + AllTrim( oFabricantes:cNomFab ) )
                  else
                     ::oSender:SetText( "Desestimado : " + AllTrim( oFabricantes:cCodFab ) + "; " + AllTrim( oFabricantes:cNomFab ) )
                  end if
               else
                     dbPass( oFabricantesTmp:cAlias, oFabricantes:cAlias, .t. )
                     ::oSender:SetText( "Añadido : " + AllTrim( oFabricantes:cCodFab ) + "; " + AllTrim( oFabricantes:cNomFab ) )
               end if

               oFabricantesTmp:Skip() 

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( oFabricantesTmp:OrdKeyNo() ) 
               end if

               SysRefresh()

            end while

            /*
            Finalizando--------------------------------------------------------
            */

            oFabricantes:End()
            oFabricantesTmp:End()

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !File( cPatSnd() + "Fabric.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "Fabric.Dbf" )
            end if

         end if

      end if

       RECOVER USING oError

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

RETURN Self

//----------------------------------------------------------------------------//

METHOD nGetNumberToSend()

   ::nNumberSend     := GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile )

RETURN ( ::nNumberSend )

//----------------------------------------------------------------------------//

METHOD Save()

   WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile )
   WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load()

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio",     ::cText, cValToChar( ::lSelectSend ),   ::cIniFile ) ) == ".T." )
   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Syncronize()

   if ::OpenService()

      while !::oDbf:Eof()

         if empty( ::oDbf:uuid )
            ::oDbf:FieldPutByName( "uuid", win_uuidcreatestring() )
         end if

         ::oDbf:Skip()

      end while

      ::CloseService()

   end if

RETURN .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FabricantesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Fabric" )

   METHOD getUuid( cCodigoFabricante )

END CLASS

//---------------------------------------------------------------------------//

METHOD getUuid( cCodigoFabricante ) CLASS FabricantesModel

   local cStm
   local cSql  := "SELECT uuid "                                  + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodFab = " + quoted( cCodigoFabricante ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->uuid )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

