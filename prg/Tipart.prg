#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TTipArt FROM TMant

   DATA oClasificacionArticulo

   DATA  cText              
   DATA  oSender            
   DATA  cIniFile       

   DATA  nNumberSend                            INIT 0
   DATA  nNumberRecive                          INIT 0

   DATA  lSelectSend                            INIT .f.
   DATA  lSelectRecive                          INIT .f.

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Initiate( cText, oSender )            CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )            METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Activate()

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )
   METHOD nTipo( cCodArt )

   METHOD Resource( nMode )
   METHOD InitResource()
   METHOD SaveResource( oGet, oGet2, oDlg )

   METHOD PublicarWeb( lLoad )

   METHOD Enviar( lLoad )

   METHOD lSelect( lSel, oBrw )
   METHOD SelectAll( lSel, oBrw )

   // Envios-------------------------------------------------------------------

   METHOD CreateData()
   METHOD RestoreData()
   METHOD SendData()
   METHOD ReciveData()
   METHOD Process()

   METHOD nGetNumberToSend()                    INLINE ( GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile ) )
   Method setNumberToSend()                     INLINE ( WritePProString( "Numero", ::cText, cValToChar( ::nNumberSend ), ::cIniFile ) )
   Method incNumberToSend()                     INLINE ( WritePProString( "Numero", ::cText, cValToChar( ++::nNumberSend ), ::cIniFile ) )

   METHOD Save()                                INLINE ( WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile ),;
                                                         WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) )
   METHOD Load()                                INLINE ( ::lSelectSend     := ( Upper( GetPvProfString( "Envio",     ::cText, cValToChar( ::lSelectSend ),   ::cIniFile ) ) == ".T." ),;
                                                         ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatArt()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := GetWndFrame()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oWndParent         := oWndParent

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01013" )
   end if

   ::oDbf               := nil

   ::cMru               := "gc_objects_16"

   ::cBitmap            := clrTopArchivos
   
   ::cMessageNotFound   := "Tipo de artículo no encontrado."

   ::lAutoButtons       := .f.
   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Initiate( cText, oSender )

   ::cText              := cText
   ::oSender            := oSender
   ::cIniFile           := cIniEmpresa()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local oBlock
   local oError
   local lOpen          := .t.

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de tipos de artículos" )
      
      ::CloseFiles()
      
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "Tipart.Dbf" CLASS "Tipart" ALIAS "Tipart" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de artículos"

      FIELD CALCULATE NAME "bSndDoc"   LEN  14  DEC 0 COMMENT { "Enviar", "gc_mail2_16", 3 }       VAL {|| ::oDbf:FieldGetByName( "lSelect" ) } ;
            BITMAPS "gc_mail2_12", "Nil16" COLSIZE 20                                                             OF ::oDbf

      FIELD CALCULATE NAME "bPubInt"   LEN  14  DEC 0 COMMENT { "Publicar", "gc_earth_16", 3 }  VAL {|| ::oDbf:FieldGetByName( "lPubInt" ) } ;
            BITMAPS "gc_earth_12", "Nil16" COLSIZE 20                                                             OF ::oDbf

      FIELD NAME "cCodTip" TYPE "C"    LEN   4  DEC 0 COMMENT "Código"         PICTURE "@!"  COLSIZE 60     OF ::oDbf
      FIELD NAME "cNomTip" TYPE "C"    LEN 100  DEC 0 COMMENT "Nombre"                       COLSIZE 200    OF ::oDbf

      FIELD CALCULATE NAME "cTipArt"   LEN 100  DEC 0 COMMENT "Clasificación"                VAL {|| ClasificacionTipoArticulo():GetNombre( ::oDbf:FieldGetByName( "nTipArt" ) ) } ;
            COLSIZE 120                                                                                     OF ::oDbf

      FIELD NAME "nTipArt" TYPE "N"    LEN   1  DEC 0 COMMENT ""               HIDE          COLSIZE 0      OF ::oDbf              
      FIELD NAME "lSelect" TYPE "L"    LEN   1  DEC 0 COMMENT ""               HIDE          COLSIZE 0      OF ::oDbf
      FIELD NAME "lPubInt" TYPE "L"    LEN   1  DEC 0 COMMENT ""               HIDE          COLSIZE 0      OF ::oDbf
      FIELD NAME "cCodWeb" TYPE "N"    LEN  11  DEC 0 COMMENT "Código Web"     HIDE                         OF ::oDbf
      FIELD NAME "cImgTip" TYPE "C"    LEN 250  DEC 0 COMMENT "Imagen"         HIDE                         OF ::oDbf
      FIELD NAME "nPosInt" TYPE "N"    LEN   3  DEC 0 COMMENT "nPosInt"        HIDE                         OF ::oDbf
      FIELD NAME "cNomInt" TYPE "C"    LEN 100  DEC 0 COMMENT "Nombre comercio electrónico"                 OF ::oDbf

      INDEX TO "TipArt.CDX" TAG "cCodTip" ON "cCodTip"            COMMENT "Código"           NODELETED      OF ::oDbf
      INDEX TO "TipArt.CDX" TAG "cNomTip" ON "Upper( cNomTip )"   COMMENT "Nombre"           NODELETED      OF ::oDbf
      INDEX TO "TipArt.CDX" TAG "cCodWeb" ON "Str( cCodWeb, 11 )" COMMENT "Códigoweb"        NODELETED      OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

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

      DEFINE BTNSHELL RESOURCE "Lbl" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Enviar( .t. ) ) ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::PublicarWeb( .t. ) ) ;
         TOOLTIP  "(P)ublicar" ;
         HOTKEY   "P";
         LEVEL    ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oGetNombre
   local oGetNombreInt
   local oGetImagen
   local oBmpImagen

   if ( nMode == APPD_MODE )
      ::oDbf:nPosInt := 1
      ::oDbf:nTipArt := 1
   end if

   DEFINE DIALOG oDlg RESOURCE "TipArt" TITLE LblTitle( nMode ) + "tipos de artículos"

      REDEFINE GET oGet VAR ::oDbf:cCodTip UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

         oGet:bHelp           := {|| oGet:cText( NextKey( ::oDbf:cCodTip, ::oDbf, , 4 ) ) }
         oGet:cBmp            := "BOT"

      REDEFINE GET oGetNombre VAR ::oDbf:cNomTip UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oClasificacionArticulo   := ClasificacionTipoArticulo():New( 200, oDlg )
      ::oClasificacionArticulo:SetMode( nMode )

      REDEFINE GET oGetNombreInt VAR ::oDbf:cNomInt UPDATE;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lPubInt ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:nPosInt ;
         ID       180 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         VALID    ( ::oDbf:nPosInt >= 1 .and. ::oDbf:nPosInt <= 999 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGetImagen VAR ::oDbf:cImgTip UPDATE;
         BITMAP   "Folder" ;
         ON HELP  ( GetBmp( oGetImagen, oBmpImagen ) ) ;
         ON CHANGE( ChgBmp( oGetImagen, oBmpImagen ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       120 ;
         OF       oDlg

      REDEFINE IMAGE oBmpImagen ;
         ID       600 ;
         OF       oDlg ;
         FILE     cFileBmpName( ::oDbf:cImgTip )

      oBmpImagen:SetColor( , GetSysColor( 15 ) )
      oBmpImagen:bLClicked  := {|| ShowImage( oBmpImagen ) }
      oBmpImagen:bRClicked  := {|| ShowImage( oBmpImagen ) }

      REDEFINE GET ::oDbf:cCodWeb UPDATE;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99999" ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::SaveResource( oGet, oGetNombre, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Tipos_de_artículos" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::SaveResource( oGet, oGetNombre, oDlg ) } )
   end if

   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Tipos_de_artículos" ) } )

   oDlg:bStart    := {|| oGet:SetFocus() }

   oDlg:Activate( , , , .t., , , {|| ::InitResource() } )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD InitResource()
   
   ::oClasificacionArticulo:SetNumber( ::oDbf:nTipArt )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SaveResource( oGet, oGetNombre, oDlg )

   if ( ::nMode == APPD_MODE .or. ::nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodTip )
         MsgStop( "Código de tipo de artículo no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

      // ::oDbf:cCodTip := RJust( ::oDbf:cCodTip, "0" )

      if ::oDbf:SeekInOrd( ::oDbf:cCodTip, "cCodTip" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodTip ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNomTip )
      MsgStop( "Nombre de tipo de artículo no puede estar vacío." )
      oGetNombre:SetFocus()
      Return .f.
   end if

   ::oDbf:lSelect    := .t.
   ::oDbf:cCodWeb    := 0
   ::oDbf:nTipArt    := ::oClasificacionArticulo:GetNumber()

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Method lSelect( lSel, oBrw )

   ::oDbf:FieldPutByName( "lSelect", lSel )

   if oBrw != nil
      oBrw:Refresh()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelectAll( lSel, oBrw )

   DEFAULT lSel   := .f.

   ::oDbf:GetStatus()

   ::oDbf:GoTop()
   while !( ::oDbf:eof() )
      ::lSelect( lSel )
      ::oDbf:Skip()
   end while

   ::oDbf:SetStatus()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lValid( oGet, oSay )

   local cCodArt  := oGet:VarGet()

   if empty( cCodArt )
      return .t.
   end if

   if ::oDbf:SeekInOrd( cCodArt, "cCodTip" )

      oGet:cText( cCodArt )

      if oSay != nil
         oSay:cText( ::oDbf:cNomTip )
      end if

   else

      msgStop( "Código de tipo de artículo no encontrado" )

      return .f.

   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cNombre( cCodTip )

   local cNombre  := ""

   if ::oDbf:Seek( cCodTip )
      cNombre     := ::oDbf:cNomTip
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD nTipo( cCodTip )

   local nTipo  := 0

   if ::oDbf:Seek( cCodTip )
      nTipo     := ::oDbf:nTipArt
   end if

RETURN ( nTipo )

//---------------------------------------------------------------------------//

METHOD PublicarWeb()

   local nSelected
   local lPublicar   := !::oDbf:lPubInt

   ::oDbf:getStatus()

   for each nSelected in ( ::oWndBrw:oBrw:aSelected )
      ::oDbf:goTo( nSelected )
      ::oDbf:FieldPutByName( "lPubInt", lPublicar )
      ::oDbf:FieldPutByName( "lSelect", lPublicar )
      ::oDbf:FieldPutByName( "cCodWeb", 0 )
   next

   ::oDbf:setStatus()

   ::oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Enviar( lLoad )

   local nSelected

   ::oDbf:getStatus()

   for each nSelected in ( ::oWndBrw:oBrw:aSelected )
      ::oDbf:goTo( nSelected )
      ::oDbf:FieldPutByName( "lSelect", !::oDbf:lSelect )
      ::oDbf:FieldPutByName( "cCodWeb", 0 )
   next

   ::oDbf:setStatus()

   ::oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method CreateData()

   local lSnd           := .f.
   local oTipoArt
   local oTipoArtTmp
   local cFileName

   if ::oSender:lServer
      cFileName       := "TipArt" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName       := "TipArt" + StrZero( ::nGetNumberToSend(), 6 ) + "." + retSufEmp()
   end if

   MsgInfo( cFileName )

   oTipoArt             := TTipArt():Create( cPatEmp(), cDriver() )
   oTipoArt:OpenService()

   // Apertura de bases de dataos------------------------------------------------

   oTipoArtTmp          := TTipArt():Create( cPatSnd(), cLocalDriver() )
   oTipoArtTmp:OpenService( .t. )

   // Traspaso ----------------------------------------------------------------

   ::oSender:SetText( "Enviando tipos de artículos" )

   oTipoArt:oDbf:GoTop()
   while !oTipoArt:oDbf:eof()
      
      if oTipoArt:oDbf:lSelect
      
         lSnd           := .t.

         ::oSender:SetText( oTipoArt:oDbf:cCodTip + "; " + oTipoArt:oDbf:cNomTip )
      
         dbPass( oTipoArt:oDbf:cAlias, oTipoArtTmp:oDbf:cAlias, .t. )

      end if
      
      oTipoArt:oDbf:Skip()
      
      SysRefresh()
   
   end while

   // Cerrar ficheros----------------------------------------------------------

   oTipoArt:CloseService()
   oTipoArt:End()

   oTipoArtTmp:CloseService()
   oTipoArtTmp:End()

   // Comprimir los archivos---------------------------------------------------

   if lSnd

      ::oSender:SetText( "Comprimiendo tipos de artículos" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos en " + cFileName )
      else
         ::oSender:SetText( "¡ERROR! al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay tipos de artículos para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   ::cPath     := cPatEmp()

   if ::OpenService()

      while !::oDbf:eof()

         if ::oDbf:lSelect
            ::oDbf:FieldPutByName( "lSelect", .f. )
         end if

         ::oDbf:Skip()

      end while

      ::CloseService()

   end if


Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "TipArt" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "TipArt" + StrZero( ::nGetNumberToSend(), 6 ) + "." + retSufEmp()
   end if

   if file( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero " + lower( cPatOut() + cFileName ) + " enviado" )
      else
         ::oSender:SetText( "¡ERROR! fichero " + lower( cPatOut() + cFileName ) + " no enviado" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData()

   local cDelegacion
   local aDelegaciones

   if ::oSender:lServer
      aDelegaciones     := aRetDlgEmp()
   else
      aDelegaciones     := { "All" }
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo tipos de artículos" )

   for each cDelegacion in aDelegaciones
      ::oSender:GetFiles( "TipArt*." + cDelegacion, cPatIn() )
   next

   ::oSender:SetText( "Tipos de artículos recibidas" )

Return ( Self )

//----------------------------------------------------------------------------//

Method Process()

   local m
   local oBlock
   local oError
   local oTipArt
   local oTipArtTmp
   local aFiles      := Directory( cPatIn() )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         // Descomprimimos el fichero------------------------------------------

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            // Ficheros temporales---------------------------------------------

            if file( cPatSnd() + "TipArt.Dbf" )

               oTipArtTmp   := TTipArt():New( cPatSnd(), cLocalDriver() )
               oTipArtTmp:OpenService( .f. )

               oTipArt      := TTipArt():New( cPatEmp(), cDriver() )
               oTipArt:OpenService()

               // Trasbase de tipos de articulos-------------------------------

               oTipArtTmp:oDbf:GoTop()
               while !oTipArtTmp:oDbf:eof()

                  if oTipArt:oDbf:Seek( oTipArtTmp:oDbf:cCodTip )
                     
                     dbPass( oTipArtTmp:oDbf:cAlias, oTipArt:oDbf:cAlias, .f. )
                     
                     oTipArt:oDbf:Load()
                     oTipArt:oDbf:lSelect := .f.
                     oTipArt:oDbf:Save()

                     ::oSender:SetText( "Reemplazado : " + oTipArt:oDbf:cCodTip + "; " + oTipArt:oDbf:cNomTip )

                  else

                     dbPass( oTipArtTmp:oDbf:cAlias, oTipArt:oDbf:cAlias, .t. )

                     oTipArt:oDbf:Load()
                     oTipArt:oDbf:lSelect := .f.
                     oTipArt:oDbf:Save()

                     ::oSender:SetText( "Añadido : " + oTipArt:oDbf:cCodTip + "; " + oTipArt:oDbf:cNomTip )
                     
                  end if

                  oTipArtTmp:oDbf:Skip()

                  SysRefresh()

               end while

               /*
               Finalizando--------------------------------------------------------------
               */

               oTipArt:CloseService()
               oTipArt:End()

               oTipArtTmp:CloseService()
               oTipArtTmp:End()

            else 

               ::oSender:SetText( "No existe el fichero " + cPatSnd() + "TipArt.Dbf" )

            end if

         end if 

         ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      RECOVER USING oError

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return ( Self )

//----------------------------------------------------------------------------//

CLASS ClasificacionTipoArticulo
   
   DATA        oClasificacionArticulo
   DATA        cClasificacionArticulo

   CLASSDATA   aClasificacionArticulo     INIT { "Terminado", "Semiterminado", "Materia prima", "Desecho", "Otros" }
   
   METHOD New( nId, oDialog)

   METHOD Change()                        VIRTUAL

   METHOD GetText()                       INLINE ( ::oClasificacionArticulo:VarGet() )
   METHOD SetText( cText )                INLINE ( ::oClasificacionArticulo:Set( cText ) )

   METHOD GetNumber()                     INLINE ( ::oClasificacionArticulo:nAt )
   METHOD SetNumber( nNumber )            INLINE ( ::SetText( nNumber ) )

   METHOD SetMode( nMode )                INLINE ( ::oClasificacionArticulo:bWhen := {| nMode | nMode != APPD_MODE } )

   METHOD GetNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nId, oDialog ) CLASS ClasificacionTipoArticulo

   REDEFINE COMBOBOX ::oClasificacionArticulo ;
            VAR      ::cClasificacionArticulo ;
            ID       ( nId ) ;
            ITEMS    ::aClasificacionArticulo ;
            OF       oDialog

   ::oClasificacionArticulo:bChange := {|| ::Change( ::oClasificacionArticulo ) }
   
RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD GetNombre( nTipArt ) CLASS ClasificacionTipoArticulo

   local cNombre     := ""

   if nTipArt > 0
      cNombre        := ::aClasificacionArticulo[ ( Min( Max( nTipArt, 1 ), len( ::aClasificacionArticulo ) ) ) ] 
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//

Function GetNombreClasificacionTipoArticulo( nTipoArticulo ) 

Return ( ClasificacionTipoArticulo():GetNombre( nTipoArticulo ) )

//---------------------------------------------------------------------------//
