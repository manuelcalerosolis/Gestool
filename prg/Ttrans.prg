#ifndef __PDA__
#include "FiveWin.Ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "MesDbf.ch"
#include "Factu.ch" 

static dbfTranspor

//---------------------------------------------------------------------------//

CLASS TTrans FROM TMANT

   DATA  cPouDiv

   DATA  cMru                          INIT "gc_small_truck_16"

   DATA  cBitmap                       INIT clrTopArchivos

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode )

   METHOD cBrwose( oGet )

   METHOD cNombre( cCodTrn )

   METHOD lPreSave( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath     := cPatCli()

   ::cPath           := cPath
   ::oDbf            := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatCli()
   DEFAULT oWndParent   := oWnd()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::cPouDiv            := cPouDiv( cDivEmp() )

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

  RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de transportistas" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Transpor.Dbf" CLASS "Transpor" ALIAS "Transpor" PATH ( cPath ) VIA ( cDriver ) COMMENT "Transportistas"

      FIELD NAME "cCodTrn" TYPE "C" LEN  9  DEC 0 COMMENT "Código"               COLSIZE 60                                OF ::oDbf
      FIELD NAME "cNomTrn" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre"               COLSIZE 200                               OF ::oDbf
      FIELD NAME "cDirTrn" TYPE "C" LEN 50  DEC 0 COMMENT "Domicilio"            COLSIZE 180                               OF ::oDbf
      FIELD NAME "cLocTrn" TYPE "C" LEN 40  DEC 0 COMMENT "Localidad"            COLSIZE 180                               OF ::oDbf
      FIELD NAME "cCdpTrn" TYPE "C" LEN  5  DEC 0 COMMENT "Código postal"        COLSIZE 60                                OF ::oDbf
      FIELD NAME "cPrvTrn" TYPE "C" LEN 24  DEC 0 COMMENT "Provincia"            COLSIZE 80                                OF ::oDbf
      FIELD NAME "cTlfTrn" TYPE "C" LEN 12  DEC 0 COMMENT "Teléfono"             COLSIZE 60                                OF ::oDbf
      FIELD NAME "cMovTrn" TYPE "C" LEN 12  DEC 0 COMMENT "Móvil"                COLSIZE 60                                OF ::oDbf
      FIELD NAME "cFaxTrn" TYPE "C" LEN 12  DEC 0 COMMENT "Fax"                  COLSIZE 60                                OF ::oDbf
      FIELD NAME "nKgsTrn" TYPE "N" LEN 16  DEC 6 COMMENT "Tara"                 PICTURE MasUnd() ALIGN RIGHT COLSIZE 100  OF ::oDbf
      FIELD NAME "cMatTrn" TYPE "C" LEN 20  DEC 0 COMMENT "Matrícula"            HIDE                                      OF ::oDbf
      FIELD NAME "cDniTrn" TYPE "C" LEN 15  DEC 0 COMMENT "DNI Transportista"    HIDE                                      OF ::oDbf

      INDEX TO "Transpor.Cdx" TAG "cCodTrn" ON "cCodTrn"          COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "Transpor.Cdx" TAG "cNomTrn" ON "Upper( cNomTrn )" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "TRANSP" TITLE LblTitle( nMode ) + "transportistas"

      REDEFINE GET oGet VAR ::oDbf:cCodTrn UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomTrn UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDniTrn UPDATE;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cDirTrn UPDATE;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cLocTrn UPDATE ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPrvTrn UPDATE ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCdpTrn UPDATE ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cTlfTrn UPDATE ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cMovTrn UPDATE ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cFaxTrn UPDATE ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:nKgsTrn UPDATE ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cMatTrn UPDATE ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Transportistas" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Transportistas" ) } )

   oDlg:bStart := { || oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if Empty( ::oDbf:cCodTrn )
      MsgStop( "El código del transportista no puede estar vacío." )
      Return .f.
   end if

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. ::oDbf:SeekInOrd( ::oDbf:cCodTrn, "CCODTRN" )
      MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodTrn ) )
      Return .f.
   end if

   if Empty( ::oDbf:cNomTrn )
      MsgStop( "El nombre del transportista no puede estar vacío." )
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD cBrwose( oGet )

   local n
   local cCaption
   local cAlias
   local cField
   local uOrden   := "cNomTrn"
   local aSizes   := {}
   local aOrd     := {}
   local aCampos  := {}
   local aTitulos := {}
   local bAlta    := {|| ::Append() }
   local bEdit    := {|| ::Edit()   }
   local bZoom    := {|| ::Zoom()   }

   cCaption       := ::oDbf:cComment
   cAlias         := ::oDbf:cAlias
   cField         := "cCodTrn"

   for n := 1 to ::oDbf:FCount()

      if !::oDbf:aTField[ n ]:lHide

         aAdd( aCampos, FieldWBlock( ::oDbf:aTField[ n ]:cName, ::oDbf:nArea ) )
         aAdd( aTitulos, ::oDbf:aTField[ n ]:cComment )
         aAdd( aSizes, ::oDbf:aTField[ n ]:nColSize )

      endif

   next

   for n := 1 to len( ::oDbf:aTIndex )
      aAdd( aOrd, ::oDbf:aTIndex[ n ]:cComment )
   next

   ::oBuscar      := TBuscar():New( cCaption, cAlias, uOrden, cField, aOrd,;
                                    aCampos, aTitulos, aSizes, bAlta, bEdit,;
                                    bZoom )

   ::oBuscar:Activate()

   if oGet != nil
      oGet:cText( ::oBuscar:Getfield() )
      oGet:lValid()
   end if

RETURN nil

//----------------------------------------------------------------------------//

METHOD cNombre( cCodTrn )

   local cNomTrn  := ""

   ::oDbf:GetStatus()
   ::oDbf:OrdSetFocus( "cCodTrn" )

   if ::oDbf:Seek( cCodtrn )
      cNomTrn     := ::oDbf:cNomTrn
   end if

   ::oDbf:SetStatus()

RETURN ( cNomTrn )

//----------------------------------------------------------------------------//

/*
FUNCTION Transportistas( uMenuItem, oWnd )

   local oTrans

   DEFAULT  uMenuItem   := "01045"
   DEFAULT  oWnd        := oWnd()

   oTrans               := TTrans():New( cPatEmp(), oWnd, uMenuItem )
   oTrans:Activate()

RETURN oTrans
*/

//----------------------------------------------------------------------------//
/*
Funcion para editar un almacén desde cualquier parte del programa
*/

FUNCTION EdtTrans( cCodTrans )

   local nLevel         := Auth():Level( "01045" )
   local oTrans

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   oTrans            := TTrans():Create( cPatCli() )

   if oTrans:OpenFiles()

      if oTrans:oDbf:SeekInOrd( cCodTrans, "cCodTrn" )

         oTrans:Edit()

      end if

      oTrans:CloseFiles()

   end if

   oTrans:End()

RETURN .t.

//---------------------------------------------------------------------------//

CLASS pdaTransSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaTransSenderReciver

   local pdaTranspor
   local pcTranspor
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatCli() + "Transpor.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Transpor", @pdaTranspor ) )
   SET ADSINDEX TO ( cPatCli() + "Transpor.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "Transpor.Dbf", cCheckArea( "Transpor", @pcTranspor ), .t. )
   ( pcTranspor )->( ordListAdd( cPatPc + "Transpor.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pcTranspor )->( OrdKeyCount() ) )
   end if

   ( pcTranspor )->( dbGoTop() )
   while !( pcTranspor )->( eof() )

      if ( pdaTranspor )->( dbSeek( ( pcTranspor )->cCodTrn ) )
         dbPass( pcTranspor, pdaTranspor, .f. )
      else
         dbPass( pcTranspor, pdaTranspor, .t. )
      end if

      ( pcTranspor )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando transportistas " + Alltrim( Str( ( pcTranspor )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( pcTranspor )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pcTranspor )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( pcTranspor )
   CLOSE ( pdaTranspor )

Return ( Self )

//---------------------------------------------------------------------------//

#ifdef __PDA__

//---------------------------------------------------------------------------//

Function IsTranspor()

   local oError
   local oBlock

   if !lExistTable( cPatCli() + "Transpor.Dbf" )
      mkTranspor( cPatCli() )
   end if

   if !lExistIndex( cPatCli() + "Transpor.Cdx" )
      rxTranspor( cPatCli() )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatCli() + "Transpor.Dbf" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "Transpor", @dbfTranspor ) )
      SET ADSINDEX TO ( cPatCli() + "Transpor.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfTranspor )

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkTranspor( cPath, lAppend, cPathOld, oMeter )

   local dbfTranspor

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatCli()

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
	END IF

   dbCreate( cPath + "Transpor.Dbf", aSqlStruct( aItmTra() ), cDriver() )

   if lAppend .and. lIsDir( cPathOld ) .and. lExistTable( cPathOld + "Transpor.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "Transpor.Dbf", cCheckArea( "Transpor", @dbfTranspor ), .f. )
      ( dbfTranspor )->( __dbApp( cPathOld + "Transpor.Dbf" ) )
      ( dbfTranspor )->( dbCloseArea() )

   end if

   rxTranspor( cPath, oMeter )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxTranspor( cPath, oMeter )

   local dbfTranspor

   DEFAULT cPath := cPatCli()

   if !lExistTable( cPath + "Transpor.DBF" )
      dbCreate( cPath + "Transpor.DBF", aSqlStrucT( aItmCfg() ), cDriver() )
   end if

   fEraseIndex( cPath + "Transpor.CDX" )

   dbUseArea( .t., cDriver(), cPath + "Transpor.DBF", cCheckArea( "Transpor", @dbfTranspor ), .f. )
   if !( dbfTranspor )->( neterr() )
      ( dbfTranspor )->( __dbPack() )

      ( dbfTranspor )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTranspor )->( ordCreate( cPath + "Transpor.CDX", "CCODTRN", "CCODTRN", {|| Field->CCODTRN }, ) )

      ( dbfTranspor )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTranspor )->( ordCreate( cPath + "Transpor.CDX", "CNOMTRN", "CNOMTRN", {|| Field->CNOMTRN }, ) )

      ( dbfTranspor )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de Transportistas" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

function aItmTra()

local aBase := {  {"cCodTrn",   "C",  9, 0, "Código"              ,  "",  "", "( cDbfTranspor )" },;
                  {"cNomTrn",   "C", 50, 0, "Nombre"              ,  "",  "", "( cDbfTranspor )" },;
                  {"cDirTrn",   "C", 50, 0, "Domicilio"           ,  "",  "", "( cDbfTranspor )" },;
                  {"cLocTrn",   "C", 40, 0, "Localidad"           ,  "",  "", "( cDbfTranspor )" },;
                  {"cCdpTrn",   "C",  5, 0, "Código postal"       ,  "",  "", "( cDbfTranspor )" },;
                  {"cPrvTrn",   "C", 24, 0, "Provincia"           ,  "",  "", "( cDbfTranspor )" },;
                  {"cTlfTrn",   "C", 12, 0, "Teléfono"            ,  "",  "", "( cDbfTranspor )" },;
                  {"cMovTrn",   "C", 12, 0, "Móvil"               ,  "",  "", "( cDbfTranspor )" },;
                  {"cFaxTrn",   "C", 12, 0, "Fax"                 ,  "",  "", "( cDbfTranspor )" },;
                  {"nKgsTrn",   "N", 16, 6, "Tara"                ,  "",  "", "( cDbfTranspor )" },;
                  {"cMatTrn",   "C", 20, 0, "Matrícula"           ,  "",  "", "( cDbfTranspor )" },;
                  {"cDniTrn",   "C", 15, 0, "DNI Transportista"   ,  "",  "", "( cDbfTranspor )" } }

return ( aBase )

//--------------------------------------------------------------------------//

#endif