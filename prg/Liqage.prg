#include "FiveWin.Ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "TDbfVirt.ch"

//---------------------------------------------------------------------------//

CLASS TLiquidar FROM TMASDET

   DATA  oCtaRem
   DATA  oDivisas
   DATA  oRecibos
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oDbfIva
   DATA  oClientes
   DATA  oAgentes
   DATA  oBandera
   DATA  cPorDiv
   DATA  cPatExp
   DATA  dFecIni
   DATA  dFecFin
   DATA  oMeter
   DATA  nMeter      AS NUMERIC  INIT 0
   DATA  aMsg        AS ARRAY    INIT {}
   DATA  oSer                    INIT Array( 26 )
   DATA  aSer                    INIT Afill( Array( 26 ), .t. )
   DATA  cCodAge
   DATA  lFacLiq
   DATA  lFacCom
   DATA  lFacCob
   DATA  oBmp
   DATA  aDbfVir     AS ARRAY    INIT { { .f., "", 0, "", Ctod( "" ), "", "",  "", 0, 0 } }
   DATA  oBrwDet

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD DefineFiles( cPath, cDriver )

   METHOD OpenFiles()
   METHOD CloseFiles()
   METHOD Resource( nMode )
   METHOD Activate()
   METHOD lSave()
   METHOD cValidLiq()

   METHOD GetRecAge( oGet, oSay, nMode )
   METHOD LoaFacLiq( oBrwDet )
   METHOD LiqSelIni( oSay, oBrwDet )
   METHOD EdtLiqAge( nMode )
   METHOD DelLiqAge( oBrwDet )

   METHOD Del()

   METHOD nTotFac( lPic )
   METHOD nTotLiq( lPic )
   METHOD nTotLiqAge( cNumLiq, lPic )

   METHOD cNumRem()        INLINE   ::oDbf:cNumRem
   METHOD cBmp()           INLINE   ::oDbf:cBmpDiv

   METHOD SyncAllDbf()     INLINE   lCheckDbf( ::oDbf )

   METHOD Report()
   METHOD PrnReport( aNumDes, aNumHas, cTitulo, cSubTitulo, nDevice )

   METHOD Cancelar()

   METHOD OpenError()

   METHOD MarkFacCli( cNumFac, nMark )

   METHOD browseFacturasClientes( oGet )

   METHOD IntBtnPrv( oPag, oDlg )
   METHOD IntBtnNxt( oPag, oDlg )

   METHOD LoaFacAge( oBrwDet )
   METHOD dFecLiqAge( cNumLiq )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil
   ::oDbfDet            := nil


   ::cCodAge         := Space( 5 )
   ::dFecIni         := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFecFin         := Date()
   ::lFacLiq         := .f.
   ::lFacCom         := .f.
   ::lFacCob         := .f.
   ::oBmp            := LoadBitmap( 0, 32760 )

   ::cNumDocKey      := "cNumLiq"
   ::cSufDocKey      := "cSufLiq"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath           := ::cPath
   DEFAULT cDriver         := cDriver()

   DEFINE DATABASE ::oDbf FILE "LIQAGENP.DBF" CLASS "LIQAGENP" ALIAS "LIQAGENP" PATH ( cPath ) VIA ( cDriver ) COMMENT "Liquidación de agentes"

   FIELD NAME "NNUMLIQ"    TYPE "N" LEN   9 DEC  0 PICTURE "999999999" COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD NAME "CSUFLIQ"    TYPE "C" LEN   2 DEC  0 PICTURE "@!"        COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD CALCULATE NAME "cNumLiq"   LEN  12 DEC  0                     COMMENT "Número"  VAL ( str( ::oDbf:nNumLiq ) + "/" + ::oDbf:cSufLiq )                        COLSIZE  80      OF ::oDbf
   FIELD NAME "DFECLIQ"    TYPE "D" LEN   8 DEC  0                     COMMENT "Fecha"                                                                               COLSIZE  80      OF ::oDbf
   FIELD NAME "CCODAGE"    TYPE "C" LEN   3 DEC  0                     COMMENT "Cod."                                                                                COLSIZE  40      OF ::oDbf
   FIELD CALCULATE NAME "cNomLiq"   LEN  50 DEC  0                     COMMENT "Agente"  VAL cNbrAgent( ::oDbf:cCodAge, ::oAgentes:cAlias )                          COLSIZE 350      OF ::oDbf
   FIELD NAME "DPERDES"    TYPE "D" LEN   8 DEC  0                     COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD NAME "DPERHAS"    TYPE "D" LEN   8 DEC  0                     COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD NAME "CCODDIV"    TYPE "C" LEN   3 DEC  0                     COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD NAME "NVDVDIV"    TYPE "N" LEN  10 DEC  6                     COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD CALCULATE NAME "nTotLiq"   LEN  16 DEC  6                     COMMENT "Importe" VAL ::nTotLiqAge( Str( ::oDbf:nNumLiq ) + ::oDbf:cSufLiq, .t. ) ALIGN RIGHT COLSIZE 100      OF ::oDbf
   FIELD NAME "LIMPEUR"    TYPE "L" LEN   1 DEC  0                     COMMENT ""                                                                                                HIDE OF ::oDbf

   INDEX TO "LiqAgenP.Cdx" TAG "nNumLiq"  ON "Str( nNumLiq ) + cSufLiq" COMMENT "Número"  NODELETED OF ::oDbf
   INDEX TO "LiqAgenP.Cdx" TAG "cCodAge"  ON "cCodAge"                  COMMENT "Agente"  NODELETED OF ::oDbf
   INDEX TO "LiqAgenP.Cdx" TAG "dFecLiq"  ON "dFecLiq"                  COMMENT "Fecha"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::CreateShell( ::nLevel )

   ::oWndBrw:GralButtons( Self )
   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD OpenFiles( cPath )

   local lOpen    := .t.
   local oBlock

   DEFAULT cPath  := cPatEmp()

   oBlock         := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

   //::oFacCliT := TDataCenter():oFacCliT()
   //::oFacCliT:OrdSetFocus( "CCODAGE" )

   DATABASE NEW ::oFacCliT FILE "FACCLIT.DBF" PATH ( cPath )      VIA ( cDriver() ) SHARED INDEX  "FACCLIT.CDX"
   ::oFacCliT:OrdSetFocus( "CCODAGE" )

   DATABASE NEW ::oFacCliL FILE "FACCLIL.DBF" PATH ( cPath )      VIA ( cDriver() ) SHARED INDEX  "FACCLIL.CDX"

   DATABASE NEW ::oIva     FILE "TIVA.DBF"    PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDivisas FILE "DIVISAS.DBF" PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oClientes ;
         FILE  "CLIENT.DBF" ;
         PATH  ( cPath ) ;
         VIA   cDriver() ;
         SHARED ;
         INDEX "CLIENT.CDX"

   DATABASE NEW ::oAgentes ;
         FILE  "AGENTES.DBF" ;
         PATH  ( cPatEmp() ) ;
         VIA   cDriver() ;
         SHARED ;
         INDEX "AGENTES.CDX"

   ::cPorDiv   := cPorDiv( cDivEmp(), ::oDivisas:cAlias ) // Picture de la divisa redondeada
   ::oBandera  := TBandera():New

   /*
   Definicion del master-------------------------------------------------------
   */

   ACTIVATE DATABASE ::oDbf NORECYCLE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()
 
   ?"1  "    
   if !Empty( ::oDivisas )
   ::oDivisas:End()
   end if
   ?"2"
   if !Empty( ::oClientes )
   ::oClientes:End()
   end if
   ?"3"
   if !Empty( ::oAgentes )
   ::oAgentes:End()
   end if
   ?"4"
   if !Empty( ::oFacCliT )
   ::oFacCliT:End()
   end if
   ?"5"
   if !Empty( ::oFacCliL )
   ::oFacCliL:End()
   end if
   ?"6"
   if !Empty( ::oDbfIva )
   ::oDbfIva:End()
   end if
   ?"7"
   if !Empty( ::oDbf )
   ::oDbf:End()
   end if
   ?"8"

   ::oDivisas     := nil
   ::oClientes    := nil
   ::oAgentes     := nil
   ::oFacCliT     := nil
   ::oFacCliL     := nil
   ::oDbfIva      := nil
   ::oDbf         := nil

   DeleteObject( ::oBmp )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet     := Array( 3 )
   local oSay
   local This     := Self
   local cSay     := ""
   local oBmpDiv

   /*
   Esto lo he puesto aqui ya que cuando se termina la edición hay que destruir ::oDbfDet para que no se sumen
   al array datos de otro albarán que se añada o se modifique en este momento. Al final, cuendo se sale del
   diálogo hace un ::oDbf:Destroy()
   */

   DBVIRTUAL ::oDbfDet NAME "DETLIQ"
      VFIELD "CSERIE"  TYPE  "C" LEN  1 DEC 0 OF ::oDbfDet
      VFIELD "NNUMFAC" TYPE  "N" LEN  9 DEC 0 OF ::oDbfDet
      VFIELD "CSUFFAC" TYPE  "C" LEN  2 DEC 0 OF ::oDbfDet
      VFIELD "DFECFAC" TYPE  "D" LEN  8 DEC 0 OF ::oDbfDet
      VFIELD "CCODCLI" TYPE  "C" LEN 12 DEC 0 OF ::oDbfDet
      VFIELD "CNOMCLI" TYPE  "C" LEN 50 DEC 0 OF ::oDbfDet
      VFIELD "NIMPFAC" TYPE  "N" LEN 19 DEC 6 OF ::oDbfDet
      VFIELD "NIMPCOM" TYPE  "N" LEN 19 DEC 6 OF ::oDbfDet
   ACTIVATE DBVIRTUAL ::oDbfDet

   if nMode == APPD_MODE
      ::oDbf:cCodDiv := cDivEmp()
      ::oDbf:nVdvDiv := nChgDiv( cDivEmp(), ::oDivisas )
      ::oDbf:dFecLiq := Date()
      ::oDbf:cSufLiq := RetSufEmp()
   end if

   DEFINE DIALOG oDlg RESOURCE "LiqAge" TITLE LblTitle( nMode ) + "liquidación de agentes"

      REDEFINE GET ::oDbf:nNumLiq ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumLiq" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSufLiq ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufLiq" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecLiq ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode == APPD_MODE ) ;
			OF 		oDlg

      REDEFINE GET oGet[1] VAR ::oDbf:cCodAge UPDATE ;
         ID       130 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( This:GetRecAge( oGet[ 1 ], oSay, nMode ), .t. );
         PICTURE  ::oDbf:FieldByName( "cCodAge" ):cPict ;
         ON HELP  ( BrwAgentes( oGet[ 1 ], oSay ), .t. );
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET oSay VAR cSay UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGet[2] VAR ::oDbf:cCodDiv UPDATE ;
         WHEN     ( nMode == APPD_MODE .AND. ::oDbf:LastRec() == 0 ) ;
         VALID    ( cDivOut( oGet[2], oBmpDiv, oGet[3], nil, nil, nil, nil, nil, nil, nil, This:oDivisas:cAlias, This:oBandera ) );
         PICTURE  "@!";
         ID       140 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( oGet[2], oBmpDiv, oGet[3], This:oDivisas:cAlias, This:oBandera ) ;
         OF       oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       141;
         OF       oDlg

      REDEFINE GET oGet[3] VAR ::oDbf:nVdvDiv ;
			WHEN		( .F. ) ;
         ID       142 ;
         VALID    ( ::oDbf:nVdvDiv > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
         OF       oDlg

      REDEFINE GET ::dFecIni UPDATE ;
         ID       121 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::dFecFin UPDATE ;
         ID       122 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

       /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::EdtLiqAge( APPD_MODE ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::EdtLiqAge( EDIT_MODE ) )

      REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DelLiqAge() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         ACTION   ( ::EdtLiqAge( ZOOM_MODE ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::LiqSelIni( oSay ) )

      REDEFINE IBROWSE ::oBrwDet ;
			FIELDS ;
                  ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac ,;
                  DtoC( ::oDbfDet:dFecFac ),;
                  ::oDbfDet:cCodCli + Space( 1 ) + ::oDbfDet:cNomCli,;
                  Trans( ::oDbfDet:nImpFac, ::cPorDiv ),;
                  Trans( ::oDbfDet:nImpCom, ::cPorDiv ) ;
         FIELDSIZES ;
                  100,;
                  70,;
                  350,;
                  90,;
                  90 ;
         HEAD ;
                  "Número",;
                  "Fecha",;
                  "Cliente",;
                  "Importe",;
                  "Comisión" ;
         JUSTIFY  .f., .f., .f., .t., .t. ;
         ID       150 ;
         OF       oDlg

         ::oDbfDet:SetBrowse( ::oBrwDet )

         ::oBrwDet:bLDblClick    := {|| ::EdtLiqAge( EDIT_MODE ) }
         ::oBrwDet:aFooters      := {||{ "", "", "" ,::nTotFac( .t. ) ,::nTotLiq( .t. ) } }
         ::oBrwDet:lDrawFooters  := .t.
         ::oBrwDet:cWndName      := "Linea de liquidación de agente detalle"

         ::oBrwDet:Load()

         if nMode != ZOOM_MODE
            ::oBrwDet:bAdd       := {|| ::EdtLiqAge( APPD_MODE ) }
            ::oBrwDet:bDel       := {|| ::DelLiqAge() }
         end if

REDEFINE APOLOMETER ::oMeter VAR ::nMeter ;
         ID       160 ;
         NOPERCENTAGE ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lSave( nMode ), oDlg:End( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( ::Cancelar(), oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( HtmlHelp( "Liquidación agentes" ) )

   oDlg:bStart := {|| ::LoaFacLiq( nMode ) }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult != IDOK
      ::Cancelar()
   end if

   /*
   Hay que destruir el ::oDbfDet por que se queda cargado con los datos anteriores y falla.
   */

   ::oDbfDet:Destroy()

   oBmpDiv:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD Cancelar()

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "nNumFac" )

   ::oDbfDet:GoTop()
   while !::oDbfDet:Eof()
      if ::oFacCliT:Seek( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac )
         if ::oFacCliT:nNumLiq == -1
            ::MarkFacCli( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac, 0 )
         end if
      end if
      ::oDbfDet:Skip()
   end while

   ::oFacCliT:SetStatus()

return ( self )

//---------------------------------------------------------------------------//

METHOD lSave( nMode )

   if Empty( ::oDbf:cCodAge )
      MsgStop( "Debe seleccionar un agente", "Liquidaciones" )
      return .f.
   end if

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "NNUMFAC" )

   if nMode == APPD_MODE
      ::oDbf:nNumLiq          := ::cValidLiq()
   end if

   ::oDbfDet:GoTop()
   while !::oDbfDet:Eof()
      if ::oFacCliT:Seek( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac )
         ::oFacCliT:Load()
         ::oFacCliT:nNumLiq   := ::oDbf:nNumLiq
         ::oFacCliT:cSufLiq   := ::oDbf:cSufLiq
         ::oFacCliT:nImpLiq   := ::oDbfDet:nImpCom
         ::oFacCliT:dFecLiq   := ::oDbf:dFecLiq
         ::oFacCliT:Save()
      end if
      ::oDbfDet:Skip()
   end while

   ::oFacCliT:SetStatus()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD GetRecAge( oGet, oSay, nMode )

   local aFac  := {}

   if Empty( ::oDbf:cCodAge )
      return .t.
   end if

   ::oFacCliT:GetStatus()

   if cAgentes( oGet, ::oAgentes:cAlias, oSay )
      if !::LiqSelIni( oSay:cText )
         return .f.
      end if
   else
      return .f.
   end if

   ::oFacCliT:OrdSetFocus( "cAgeFec" )

   ::oFacCliT:Seek( ::oDbf:cCodAge + DtoS( ::dFecIni ), .t. )

   while ::oFacCliT:cCodAge == ::oDbf:cCodAge .and. !::oFacCliT:Eof()

      aFac  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDivisas:cAlias )

      if ::oFacCliT:dFecFac >= ::dFecIni              .and. ;
         ::oFacCliT:dFecFac <= ::dFecFin              .and. ;
         Empty( ::oFacCliT:nNumLiq )                  .and. ;
         ( !::lFacCob .and. !::oFacCliT:lLiquidada )  .and. ;
         ( !::lFacCom .and. aFac[ 7 ] != 0 )          .and. ;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         ::oDbfDet:Append()
         ::oDbfDet:cSerie    := ::oFacCliT:cSerie
         ::oDbfDet:nNumFac   := ::oFacCliT:nNumFac
         ::oDbfDet:cSufFac   := ::oFacCliT:cSufFac
         ::oDbfDet:dFecFac   := ::oFacCliT:dFecFac
         ::oDbfDet:cCodCli   := ::oFacCliT:cCodCli
         ::oDbfDet:cNomCli   := RetClient( ::oFacCliT:cCodCli, ::oClientes:cAlias )
         ::oDbfDet:nImpFac   := aFac[ 4 ]
         ::oDbfDet:nImpCom   := aFac[ 6 ]
         ::oDbfDet:Save()

      end if

      ::oFacCliT:Skip()

   end while

   ::oFacCliT:SetStatus()

   ::oDbfDet:GoTop()

   ::oBrwDet:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nTotLiq( lPic )

   local nTot     := 0
   local nPos     := ::oDbfDet:Recno()

   DEFAULT lPic   := .f.

   ::oDbfDet:GoTop()
   while !::oDbfDet:Eof()
      nTot  += ::oDbfDet:nImpCom
      ::oDbfDet:Skip()
   end while

   ::oDbfDet:GoTo( nPos )

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotFac( lPic )

   local nTot     := 0
   local nPos     := ::oDbfDet:Recno()

   DEFAULT lPic   := .f.

   ::oDbfDet:GoTop()
   WHILE !::oDbfDet:Eof()
         nTot  += ::oDbfDet:nImpFac
         ::oDbfDet:Skip()
   END WHILE

   ::oDbfDet:GoTo( nPos )

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotLiqAge( cNumLiq, lPic )

   local nTot     := 0

   DEFAULT lPic   := .f.

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "nNumLiq" )

   ::oFacCliT:Seek( cNumLiq )
   WHILE Str( ::oFacCliT:nNumLiq ) + ::oFacCliT:cSufLiq == cNumLiq .and. !::oFacCliT:Eof()
      nTot  += ::oFacCliT:nImpLiq
      ::oFacCliT:Skip()
   END WHILE

   ::oFacCliT:SetStatus()

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD EdtLiqAge( nMode )

   local oDlg
   local aGet     := Array( 8  )
   local This     := Self
   local cNumFac

   ::oDbfDet:GetStatus()

   if nMode == APPD_MODE
      ::oDbfDet:Append()
   end if

   cNumFac        := ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac

   DEFINE DIALOG oDlg RESOURCE "LLIQAGE"

   REDEFINE GET aGet[ 2 ] VAR cNumFac ;
      ID       120 ;
      WHEN     ( nMode == APPD_MODE ) ;
      VALID    ( CheckFac( aGet[ 2 ], This:oFacCliT:cAlias(), This, oDlg ) );
      BITMAP   "LUPA" ;
      ON HELP  ( This:browseFacturasClientes( aGet[ 2 ] ), oDlg:Update() );
      OF       oDlg

   REDEFINE GET aGet[ 4 ] VAR ::oDbfDet:dFecFac ;
      ID       140 ;
      SPINNER ;
      ON HELP  aGet[ 4 ]:cText( Calendario( ::oDbfDet:dFecFac ) ) ;
      WHEN     ( nMode == APPD_MODE ) ;
      UPDATE ;
      OF       oDlg

   REDEFINE GET aGet[ 5 ] VAR ::oDbfDet:cCodCli ;
      ID       150 ;
      WHEN     ( .F. ) ;
      UPDATE ;
      OF       oDlg

   REDEFINE GET aGet[ 6 ] VAR ::oDbfDet:cNomCli ;
      ID       151 ;
      WHEN     ( .F. ) ;
      UPDATE ;
      OF       oDLg

   REDEFINE GET aGet[ 7 ] VAR ::oDbfDet:nImpFac ;
      ID       160 ;
      PICTURE  ::cPorDiv ;
      WHEN     ( .F. ) ;
      UPDATE ;
      OF       oDlg

   REDEFINE GET aGet[ 8 ] VAR ::oDbfDet:nImpCom ;
      ID       170 ;
      PICTURE  ::cPorDiv ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      UPDATE ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       180 ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( ::oDbfDet:Save(), ::MarkFacCli( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac ), ::oBrwDet:Refresh(), oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       190 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() ) ;
      CANCEL

   REDEFINE BUTTON ;
      ID       200 ;
      OF       oDlg ;
      ACTION   ( MsgStop( "" ) )

   ACTIVATE DIALOG oDlg CENTER

   ::oDbfDet:SetStatus()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD Del()

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes("¿Desea eliminar el registro en curso?", "Confirme supresión" )

      ::oFacCliT:GetStatus()
      ::oFacCliT:OrdSetFocus( "NNUMLIQ" )
      ::oFacCliT:OrdScope( Str( ::oDbf:nNumLiq ) + ::oDbf:cSufLiq, Str( ::oDbf:nNumLiq ) + ::oDbf:cSufLiq )
      ::oFacCliT:GoTop()

      while !( ::oFacCliT:Eof() )
         ::oFacCliT:Load()
         ::oFacCliT:nNumLiq   := 0
         ::oFacCliT:cSufLiq   := ""
         ::oFacCliT:dFecLiq   := Ctod( "" )
         ::oFacCliT:nImpLiq   := 0
         ::oFacCliT:Save()
      end while
      ::oFacCliT:ClearScope()

      ::oDbf:Delete()

   end if
   ::oFacCliT:SetStatus()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelLiqAge()

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" )

      ::oFacCliT:GetStatus()
      ::oFacCliT:OrdSetFocus( "nNumFac" )

      if ::oFacCliT:Seek( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac )

         ::oFacCliT:Load()
         ::oFacCliT:nNumLiq   := 0
         ::oFacCliT:cSufLiq   := ""
         ::oFacCliT:nImpLiq   := 0
         ::oFacCliT:dFecLiq   := Ctod( "" )
         ::oFacCliT:Save()

      end if

      ::oFacCliT:SetStatus()

      ::oDbfDet:Delete()

      ::oBrwDet:Refresh()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Report()

	local oDlg
   local dFecDes     := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   local dFecHas     := Date()
   local oAgeDes
   local oAgeHas
   local cAgeDes     := dbFirst( ::oAgentes:cAlias )
   local cAgeHas     := dbLast(  ::oAgentes:cAlias )
   local oSayDes
   local oSayHas
   local cSayDes     := dbFirst( ::oAgentes:cAlias, 2 )
   local cSayHas     := dbLast(  ::oAgentes:cAlias, 2 )
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )
   local cSubTitulo  := Padr( "Listado de liquidaciones", 50 )
   local This        := Self

   ::oDbf:GetStatus()

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "REP_LIQAGE"

      REDEFINE GET dFecDes ;
         ID       100 ;
         SPINNER ;
			OF 		oDlg

      REDEFINE GET dFecHas ;
         ID       110 ;
         SPINNER ;
			OF 		oDlg

      REDEFINE GET oAgeDes VAR cAgeDes ;
         ID       120 ;
         VALID    ( cAgentes( oAgeDes, This:oAgentes:cAlias, oSayDes ) );
         ON HELP  ( BrwAgentes( oAgeDes, oSayDes ) );
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET oSayDes VAR cSayDes ;
         ID       121 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oAgeHas VAR cAgeHas ;
         ID       130 ;
         VALID    ( cAgentes( oAgeHas, This:oAgentes:cAlias, oSayHas ) );
         ON HELP  ( BrwAgentes( oAgeHas, oSayHas ) );
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET oSayHas VAR cSayHas ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET cTitulo ;
         ID       140 ;
         OF       oDlg

      REDEFINE GET cSubTitulo ;
         ID       150 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       508;
         OF       oDlg ;
         ACTION   ::PrnReport( dFecDes, dFecHas, cAgeDes, cAgeHas, cTitulo, cSubTitulo, 1 )

      REDEFINE BUTTON ;
         ID       505;
         OF       oDlg ;
         ACTION   ::PrnReport( dFecDes, dFecHas, cAgeDes, cAgeHas, cTitulo, cSubTitulo, 2 )

      REDEFINE BUTTON ;
         ID       510;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oAgeDes:lValid(), oAgeHas:lValid() )


   ::oDbf:SetStatus()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD PrnReport( dFecDes, dFecHas, cAgeDes, cAgeHas, cTitulo, cSubTitulo, nDevice )

   local oFont1
   local oFont2
   local oReport

   /*
	Cambiamos los indices
	*/

   ::oFacCliT:GetStatus()

   ::oFacCliT:OrdSetFocus( "NNUMLIQ" )
   ::oFacCliT:GoTop()

   oFont1   := TFont():New( "Arial", 0, - 8, .f., .t. )
   oFont2   := TFont():New( "Arial", 0, - 8, .f. )

		IF nDevice == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
                     Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
            HEADER   "Fecha : " + dtoc(date())  ;
				FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listado de liquidaciones";
				PREVIEW

		ELSE

         REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
                     Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
            HEADER   "Fecha : " + dtoc(date())  ;
				FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listado de liquidaciones";
            TO PRINTER

		END IF

      COLUMN TITLE   "Número" ;
            DATA     ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:nNumFac ) + "/" + ::oFacCliT:cSufFac ;
            SIZE     12 ;
            FONT     2

      COLUMN TITLE   "Fecha" ;
            DATA     DtoC( ::oFacCliT:dFecFac ) ;
            SIZE     8 ;
            FONT     2

      COLUMN TITLE   "Cliente" ;
            DATA     ::oFacCliT:cCodCli + Space( 1 ) + ::oFacCliT:cNomCli ;
            SIZE     35 ;
            FONT     2

      COLUMN TITLE   "Total" ;
            DATA     nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDivisas:cAlias ) ;
            PICTURE  ::cPorDiv ;
				RIGHT ;
            TOTAL ;
            SIZE     10 ;
            FONT     2

      COLUMN TITLE   "Liquidación" ;
            DATA     ::oFacCliT:nImpLiq ;
            PICTURE  ::cPorDiv ;
				RIGHT ;
            TOTAL ;
            SIZE     10 ;
            FONT     2

      GROUP ON    Str( ::oFacCliT:nNumLiq ) + ::oFacCliT:cSufLiq ;
         HEADER   "Remesa : " + Str( ::oFacCliT:nNumLiq ) + "/" + ::oFacCliT:cSufLiq ;
         FONT 2

         //FOOTER   "Total remesa " + Str( ::oFacCliT:nNumLiq ) + "/" + ::oFacCliT:cSufLiq + " : " + Trans( ;

		END REPORT

      IF !Empty( oReport ) .and. oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
         oReport:bSkip  := {|| ::oFacCliT:Skip( 1 ) }
		END IF

      ACTIVATE REPORT oReport ;
         ON STARTGROUP oReport:NewLine() ;
         FOR   ::dFecLiqAge( Str( ::oFacCliT:nNumLiq ) + ::oFacCliT:cSufLiq ) >= dFecDes   .AND. ;
               ::dFecLiqAge( Str( ::oFacCliT:nNumLiq ) + ::oFacCliT:cSufLiq ) <= dFecHas   .AND. ;
               ::oFacCliT:cCodAge >= cAgeDes                                               .AND. ;
               ::oFacCliT:cCodAge <= cAgeHas                                               .AND. ;
               ::oFacCliT:nNumLiq != 0                                                           ;
         WHILE !::oFacCliT:Eof()

	oFont1:end()
	oFont2:end()

   oReport:end()

   ::oFacCliT:SetStatus()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD LiqSelIni() CLASS TLiquidar

   local oDlg
   local oBrw
   local oPag
   local oBtnPrv
   local oBtnNxt

   if Empty( ::oDbf:cCodAge )
      return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "ASS_LIQAGE"

   REDEFINE PAGES oPag ID 110 OF oDlg DIALOGS "LIQAGE_1", "LIQAGE_2"

   REDEFINE GET ::dFecIni ;
      ID       150 ;
      SPINNER ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET ::dFecFin ;
      ID       160 ;
      SPINNER ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacCom ;
      ID       180 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacCob ;
      ID       190 ;
      OF       oPag:aDialogs[ 1 ]

   TWebBtn():Redefine(1170,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .T. ), o:refresh() } ) ) }, oPag:aDialogs[ 1 ],,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ),,,, "Seleccionar todas las series",,,, )

   TWebBtn():Redefine(1180,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .F. ), o:refresh() } ) ) }, oPag:aDialogs[ 1 ],,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ),,,, "Deseleccionar todas las series",,,, )

   REDEFINE CHECKBOX ::oSer[  1 ] VAR ::aSer[  1 ] ID 1190 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  2 ] VAR ::aSer[  2 ] ID 1200 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  3 ] VAR ::aSer[  3 ] ID 1210 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  4 ] VAR ::aSer[  4 ] ID 1220 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  5 ] VAR ::aSer[  5 ] ID 1230 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  6 ] VAR ::aSer[  6 ] ID 1240 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  7 ] VAR ::aSer[  7 ] ID 1250 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  8 ] VAR ::aSer[  8 ] ID 1260 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  9 ] VAR ::aSer[  9 ] ID 1270 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 10 ] VAR ::aSer[ 10 ] ID 1280 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 11 ] VAR ::aSer[ 11 ] ID 1290 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 12 ] VAR ::aSer[ 12 ] ID 1300 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 13 ] VAR ::aSer[ 13 ] ID 1310 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 14 ] VAR ::aSer[ 14 ] ID 1320 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 15 ] VAR ::aSer[ 15 ] ID 1330 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 16 ] VAR ::aSer[ 16 ] ID 1340 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 17 ] VAR ::aSer[ 17 ] ID 1350 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 18 ] VAR ::aSer[ 18 ] ID 1360 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 19 ] VAR ::aSer[ 19 ] ID 1370 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 20 ] VAR ::aSer[ 20 ] ID 1380 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 21 ] VAR ::aSer[ 21 ] ID 1390 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 22 ] VAR ::aSer[ 22 ] ID 1400 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 23 ] VAR ::aSer[ 23 ] ID 1410 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 24 ] VAR ::aSer[ 24 ] ID 1420 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 25 ] VAR ::aSer[ 25 ] ID 1430 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 26 ] VAR ::aSer[ 26 ] ID 1440 OF oPag:aDialogs[ 1 ]

   /*
   Segunda caja de dialogo-----------------------------------------------------
   */

   REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  if( ::aDbfVir[ oBrw:nAt, 1 ], ::oBmp, "" ),;
                  ::aDbfVir[ oBrw:nAt, 2 ] + "/" + Str( ::aDbfVir[ oBrw:nAt, 3 ] ) + "/" + ::aDbfVir[ oBrw:nAt, 4 ] ,;
                  DtoC( ::aDbfVir[ oBrw:nAt, 5 ] ),;
                  ::aDbfVir[ oBrw:nAt, 6 ] + Space( 1 ) + ::aDbfVir[ oBrw:nAt, 7 ],;
                  Trans( ::aDbfVir[ oBrw:nAt, 8 ], ::cPorDiv ),;
                  Trans( ::aDbfVir[ oBrw:nAt, 9 ], ::cPorDiv ) ;
         FIELDSIZES ;
                  14,;
                  80,;
                  70,;
                  230,;
                  80,;
                  80 ;
         HEAD ;
                  "S",;
                  "Número",;
                  "Fecha",;
                  "Cliente",;
                  "Importe",;
                  "Comisión" ;
         ID       110 ;
         OF       oPag:aDialogs[ 2 ]

         oBrw:SetArray( ::aDbfVir )
         oBrw:aJustify        := { .f., .f., .f., .f., .t., .t. }

   REDEFINE BUTTON ;
         ID       501 ;
         OF       oPag:aDialogs[ 2 ] ;
         ACTION   ( ::aDbfVir[ oBrw:nAt, 1 ] := !::aDbfVir[ oBrw:nAt, 1 ], oBrw:Refresh() )

   REDEFINE BUTTON ;
         ID       502 ;
         OF       oPag:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aDbfVir, { |aItem| aItem[1] := .t. } ), oBrw:refresh() )

   REDEFINE BUTTON ;
         ID       503 ;
         OF       oPag:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aDbfVir, { |aItem| aItem[1] := .f. } ), oBrw:refresh() )

   /*
   Botones caja de dialogo-----------------------------------------------------
   */

   REDEFINE BUTTON oBtnPrv ;                          // Boton de Anterior
         ID       401 ;
         OF       oDlg ;
         ACTION   ( ::IntBtnPrv( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw ) )

   REDEFINE BUTTON oBtnNxt ;                          // Boton de Siguiente
         ID       402 ;
         OF       oDlg ;
         ACTION   ( ::IntBtnNxt( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw ) )

   REDEFINE BUTTON ;                                  // Boton de salida
         ID       403 ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:Hide() )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD cValidLiq()

   /*
   local nCurLiq  := nCurLiq() + 1

   ::oDbf:GetStatus()

   ::oDbf:OrdSetFocus( "nNumLiq" )
   while ::oDbf:Seek( Str( nCurLiq ) + RetSufEmp() )
      ++nCurLiq
   end while

   if nCurLiq != nCurLiq()
      SetFieldEmpresa( nCurLiq, "nNumLiq" )
   end if

   ::oDbf:SetStatus()
   */


RETURN ( nil ) // nCurLiq
//--------------------------------------------------------------------------//

FUNCTION LiqAge( oMenuItem, oWnd )

   local nLevel
   local oLiqAge

   DEFAULT  oMenuItem   := "01038"
   DEFAULT  oWnd        := oWnd()

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Liquidación de agentes", ProcName() )

   oLiqAge  := TLiquidar():New( cPatEmp() )
   oLiqAge:Activate( nLevel )

RETURN NIL

//--------------------------------------------------------------------------//

METHOD browseFacturasClientes( oGet )

	local oDlg
   local oBrw
   local oFlt
   local oGet1
   local cGet1
   local nOrd        := GetBrwOpt( "BrwFacCli" )
   local oCbxOrd
   local aCbxOrd     := { "Número", "Fecha", "Cliente", "Nombre" }
   local cCbxOrd
   local aFac        := {}

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "CCODAGE" )
   ::oFacCliT:OrdScope( ::oDbf:cCodAge, ::oDbf:cCodAge )

   oFlt := TFilter():New( ::oFacCliT, "Filter", {|| ::oFacCliT:nNumLiq == 0 }, "::oFacCliT:nNumLiq == 0" )

   ::oFacCliT:SetFilter( oFlt )
   ::oFacCliT:GoTop()

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Facturas de clientes"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, ::oFacCliT:cAlias ) );
         VALID    ( OrdClearScope( oBrw, ::oFacCliT:cAlias ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ::oFacCliT:OrdSetFocus( oCbxOrd:nAt ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      REDEFINE LISTBOX oBrw ;
          FIELDS;
                  ::oFacCliT:cSerie + "/" + Rtrim( Str( ::oFacCliT:nNumFac ) ) + "/" + ::oFacCliT:cSufFac,;
                  Dtoc( ::oFacCliT:dFecFac ),;
                  Rtrim( ::oFacCliT:cCodCli ),;
                  Rtrim( ::oFacCliT:cNomCli ),;
                  ::oFacCliT:cCodAge ;
         HEAD;
                  "Número",;
                  "Fecha",;
                  "Cliente",;
                  "Nombre",;
                  "Agente" ;
         FIELDSIZES;
                  80 ,;
                  80 ,;
                  60,;
                  180,;
                  80  ;
         ID       105 ;
			OF 		oDlg

      ::oFacCliT:SetBrowse( oBrw )

      oBrw:aActions     := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, ::oFacCliT:cAlias ) }
      oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		.F.

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		.F.

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      aFac  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDivisas:cAlias )

      oGet:cText( ::oFacCliT:CSERIE + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC )

      ::oDbfDet:cSerie   := ::oFacCliT:cSerie
      ::oDbfDet:nNumFac  := ::oFacCliT:nNumFac
      ::oDbfDet:cSufFac  := ::oFacCliT:cSufFac
      ::oDBfDet:dFecFac  := ::oFacCliT:dFecFac
      ::oDbfDet:cCodCli  := ::oFacCliT:cCodCli
      ::oDbfDet:cNomCli  := RetClient( ::oFacCliT:cCodCli, ::oClientes:cAlias )
      ::oDbfDet:nImpFac  := aFac[ 4 ]
      ::oDbfDet:nImpCom  := aFac[ 7 ]

   end if

   DestroyFastFilter( ::oFacCliT:cAlias )

   SetBrwOpt( "BrwFacCli", ::oFacCliT:OrdNumber() )

   ::oFacCliT:OrdScope()
   ::oFacCliT:KillFilter()
   ::oFacCliT:SetStatus()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

FUNCTION CheckFac( oGet, dbfFacCliT, oLiq, oDlgAnt )

   local nRecAnt     := ( dbfFacCliT )->( RecNo() )
   local aFac        := {}
   local lResult     := .T.
   local cBuscar

   oLiq:oDbfDet:CSERIE     := Substr( oGet:cText, 1, 1 )
   oLiq:oDbfDet:NNUMFAC    := Val( Substr( oGet:cText, 3, 9 ) )
   oLiq:oDbfDet:CSUFFAC    := Substr( oGet:cText, 13, 2 )

   cBuscar                 := oLiq:oDbfDet:CSERIE + Str( oLiq:oDbfDet:NNUMFAC ) + oLiq:oDbfDet:CSUFFAC

   ( dbfFacCliT )->( OrdSetFocus( "nNumFac" ) )
   if ( dbfFacCliT )->( DBSeek( cBuscar ) )

      if ( dbfFacCliT )->nNumLiq != 0
          MsgStop( "Factura ya liquidada", "Añadir facturas" )
          return .f.
       end if

      if ( dbfFacCliT )->cCodAge != oLiq:oDbf:cCodAge
          MsgStop( "Factura de otro agente", "Añadir facturas" )
          return .f.
       end if

      aFac  := aTotFacCli( oLiq:oFacCliT:cSerie + Str( oLiq:oFacCliT:nNumFac ) + oLiq:oFacCliT:cSufFac, ;
                           oLiq:oFacCliT:cAlias, ;
                           oLiq:oFacCliL:cAlias, ;
                           oLiq:oDbfIva:cAlias, ;
                           oLiq:oDivisas:cAlias )

      oGet:cText( ( dbfFacCliT )->CSERIE + "/" + Str( ( dbfFacCliT )->NNUMFAC ) + "/" + ( dbfFacCliT )->CSUFFAC )
      oLiq:oDbfDet:cSerie   := ( dbfFacCliT )->CSERIE
      oLiq:oDbfDet:nNumFac  := ( dbfFacCliT )->NNUMFAC
      oLiq:oDbfDet:cSufFac  := ( dbfFacCliT )->CSUFFAC
      oLiq:oDBfDet:dFecFac  := ( dbfFacCliT )->dFecFac
      oLiq:oDbfDet:cCodCli  := ( dbfFacCliT )->cCodCli
      oLiq:oDbfDet:cNomCli  := RetClient( oLiq:oFacCliT:cCodCli, oLiq:oClientes:cAlias )
      oLiq:oDbfDet:nImpFac  := aFac[ 4 ]
      oLiq:oDbfDet:nImpCom  := aFac[ 7 ]
      oDlgAnt:Update()
      lResult  := .t.
   else
      MsgStop( "Nº de factura incorrecto", "Añadir facturas" )
      lResult  := .f.
   end if

   ( dbfFacCliT )->( dbGoTo( nRecAnt ) )

RETURN ( LResult )

//--------------------------------------------------------------------------//

METHOD OpenError()

   MsgStop( "Proceso en uso por otro usuario", "Abrir fichero" )
   ::lOpenError := .T.

RETURN .F.

//--------------------------------------------------------------------------//

METHOD MarkFacCli( cNumFac, nMark )

   DEFAULT nMark           := -1

   ::oFacCliT:GetStatus()
   ::oFacClit:OrdSetFocus( "nNumFac" )

   if ::oFacCliT:Seek( cNumFac )

      ::oFacCliT:Load()
      ::oFacCliT:nNumLiq   := nMark
      ::oFacCliT:Save()

   end if

   ::oFacCliT:SetStatus()

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Carga las facturas de una liquidacion
//

METHOD LoaFacLiq( nMode, oBrw )

   local aFac  := {}

   if nMode == APPD_MODE
      return .f.
   end if

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "nNumLiq" )

   if ::oFacCliT:Seek( Str( ::oDbf:nNumLiq ) + ::oDbf:cSufLiq )

      while Str( ::oFacCliT:nNumLiq ) + ::oFacCliT:cSufLiq == Str( ::oDbf:nNumLiq ) + ::oDbf:cSufLiq  .AND. ;
            !::oFacCliT:eof()

         aFac                := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDivisas:cAlias )

         ::oDbfDet:Append()
         ::oDbfDet:cSerie    := ::oFacCliT:cSerie
         ::oDbfDet:nNumFac   := ::oFacCliT:nNumFac
         ::oDbfDet:cSufFac   := ::oFacCliT:cSufFac
         ::oDbfDet:dFecFac   := ::oFacCliT:dFecFac
         ::oDbfDet:cCodCli   := ::oFacCliT:cCodCli
         ::oDbfDet:cNomCli   := RetClient( ::oFacCliT:cCodCli, ::oClientes:cAlias )
         ::oDbfDet:nImpFac   := aFac[ 4 ]
         ::oDbfDet:nImpCom   := ::oFacCliT:nImpLiq
         ::oDbfDet:Save()

         ::oFacCliT:Skip()

      end while

   end if

   ::oDbfDet:Gotop()
   ::oFacCliT:SetStatus()

   ::oBrwDet:Refresh()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD IntBtnPrv( oPag, oBtnPrv, oBtnNxt, oDlg )

   oPag:GoPrev()
   oBtnPrv:Hide()
   SetWindowText( oBtnNxt:hWnd, "Siguien&te" )

return ( SELF )

//---------------------------------------------------------------------------//

METHOD IntBtnNxt( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw )

   local n

   do case
      case oPag:nOption == 1
         ::LoaFacAge( oBrw )
         oPag:GoNext()
         oBtnPrv:Show()
         SetWindowText( oBtnNxt:hWnd, "&Importar" )
      case oPag:nOption == 2

         for n := 1 to len( ::aDbfVir )
            if ::aDbfVir[ n, 1 ]
               ::oDbfDet:Append()
               ::oDbfDet:cSerie  := ::aDbfVir[ n, 2 ]
               ::oDbfDet:nNumFac := ::aDbfVir[ n, 3 ]
               ::oDbfDet:cSufFac := ::aDbfVir[ n, 4 ]
               ::oDbfDet:dFecFac := ::aDbfVir[ n, 5 ]
               ::oDbfDet:cCodCli := ::aDbfVir[ n, 6 ]
               ::oDbfDet:cNomCli := ::aDbfVir[ n, 7 ]
               ::oDbfDet:nImpFac := ::aDbfVir[ n, 8 ]
               ::oDbfDet:nImpCom := ::aDbfVir[ n, 9 ]
               ::oDbfDet:Save()
               ::MarkFacCli( ::aDbfVir[ n, 2 ] + Str( ::aDbfVir[ n, 3 ] ) + ::aDbfVir[ n, 4 ] )
            end if
         next

         ::oBrwDet:Refresh()

         oDlg:End()
   end case

return nil

//---------------------------------------------------------------------------//

METHOD LoaFacAge( oBrw )

   local aTotFac

   ::aDbfVir  := {}

   if ::oFacCliT:Seek( ::oDbf:cCodAge )
      while ::oFacCliT:cCodAge == ::oDbf:cCodAge .and. !::oFacCliT:eof()

         aTotFac  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDivisas:cAlias )

         if ::oFacCliT:nNumLiq == 0                                              .and.;
            ::oFacCliT:dFecFac >= ::dFecIni                                      .and.;
            ::oFacCliT:dFecFac <= ::dFecFin                                      .and.;
            lChkSer( ::oFacCliT:cSerie, ::aSer )                                 .and.;
            if( ::lFacCob, ::oFacCliT:lLiquidada, .t. )                          .and.;
            if( ::lFacCom, aTotFac[ 7 ] != 0, .t. )

            aAdd( ::aDbfVir, { .t., ::oFacCliT:cSerie, ::oFacCliT:nNumFac, ::oFacCliT:cSufFac, ::oFacCliT:dFecFac, ::oFacCliT:cCodCli, ::oFacCliT:cNomCli, aTotFac[ 4 ], aTotFac[ 6 ] } )

         end if

         ::oFacCliT:Skip()

      end while

   end if

   if Empty( ::aDbfVir )
      ::aDbfVir  := { { .f., "", 0, "", Ctod( "" ), "", "", "", 0, 0 } }
   end if

   oBrw:SetArray( ::aDbfVir )
   oBrw:Refresh()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD dFecLiqAge( cNumLiq )

   local dFecLiq  := Ctod( "" )

   ::oDbf:GetStatus()

   ::oDbf:OrdSetFocus( "nNumLiq" )

   if ::oDbf:Seek( cNumLiq )
      dFecLiq  := ::oDbf:dFecLiq
   end if

   ::oDbf:SetStatus()

return ( dFecLiq )

//---------------------------------------------------------------------------//

