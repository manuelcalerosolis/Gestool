#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Factu.ch" 

#define  _CCODALM    1
#define  _CNOMALM    2
#define  _CCODART    3
#define  _CNOMART    4
#define  _NENTART    5
#define  _NABNART    6
#define  _NCAJART    7
#define  _NEXTART    8

static nLevel
static dbfExtAgeT
static dbfExtAgeL
static dbfDepAgeT
static dbfDepAgeL
static dbfAlbCliT
static dbfAlbCliL
static dbfArticulo
static dbfAlmT
static dbfDiv
static dbfTVta
static dbfClient
static dbfIva
static dbfKit
static dbfTarPreL
static dbfTarPreS
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfCliAtp
static dbfCount
static cPicUnd
static cNewFil
static dbfNewFil
static aDbf     := { { "CCODALM", "C", 16, 0, "Código del almacen" },;
                     { "CNOMALM", "C", 20, 0, "Nombre del almacen" },;
                     { "CCODART", "C", 18, 0, "Código del artículo" },;
                     { "CNOMART", "C", 50, 0, "Nombre del artículo" },;
                     { "CCODFAM", "C", 16, 0, "Código de la família" },;
                     { "CTIPMOV", "C",  2, 0, "Tipo de movimiento" },;
                     { "NENTART", "N", 16, 6, "Unidades entregadas" },;
                     { "NABNART", "N", 16, 6, "Unidades vendidas" },;
                     { "NEXTART", "N", 16, 6, "Unidades en existencias" } }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
      lOpen       := .f.
   end if

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "EXTAGET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGET", @dbfExtAgeT ) )
   SET ADSINDEX TO ( cPatEmp() + "EXTAGET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "EXTAGEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGEL", @dbfExtAgeL ) )
   SET ADSINDEX TO ( cPatEmp() + "EXTAGEL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "DEPAGET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DEPAGET", @dbfDepAgeT ) )
   SET ADSINDEX TO ( cPatEmp() + "DEPAGET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "DEPAGEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DEPAGEL", @dbfDepAgeL ) )
   SET ADSINDEX TO ( cPatEmp() + "DEPAGEL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
   SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
   SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
   SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOT.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOL.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOC.CDX" ) ADDITIVE

   USE ( cPatCli() + "CliAtp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIATP", @dbfCliAtp ) )
   SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
   SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

   /*
   Fichero temporal____________________________________________________________
   */

   cNewFil  := cGetNewFileName( cPatTmp() + "LQDALM"  )
   dbCreate( cNewFil, aDbf, cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFil, cCheckArea( "LQDALM", @dbfNewFil ), .f. )
   if !( dbfNewFil )->( neterr() )
      ( dbfNewFil )->( ordCreate( cPatTmp() + "LQDALM.CDX", "CCODALM", "Field->CCODALM", {|| Field->CCODALM } ) )
      ( dbfNewFil )->( ordListAdd( cPatTmp() + "LQDALM.CDX" ) )
   end if

   cPicUnd     := MasUnd()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   /*
   Fichero temporal____________________________________________________________
   */

   if !Empty( dbfNewFil )
      ( dbfNewFil )->( dbCloseArea() )
   end if

   if File( cNewFil )
      fErase( cNewFil )
   end if

   if !Empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliT )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfExtAgeT )
      ( dbfExtAgeT )->( dbCloseArea() )
   end if

   if !Empty( dbfExtAgeL )
      ( dbfExtAgeL )->( dbCloseArea() )
   end if

   if !Empty( dbfExtAgeT )
      ( dbfDepAgeT )->( dbCloseArea() )
   end if

   if !Empty( dbfDepAgeL )
      ( dbfDepAgeL )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !Empty( dbfAlmT )
      ( dbfAlmT )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv )->( dbCloseArea() )
   end if

   if !Empty( dbfTVta )
      ( dbfTVta )->( dbCloseArea() )
   end if

   if !Empty( dbfClient )
      ( dbfClient )->( dbCloseArea() )
   end if

   if !Empty( dbfIva )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( dbfTarPreL )
      ( dbfTarPreL )->( dbCloseArea() )
   end if

   if !Empty( dbfTarPreS )
      ( dbfTarPreS )->( dbCloseArea() )
   end if

   if !Empty( dbfPromoT )
      ( dbfPromoT )->( dbCloseArea() )
   end if

   if !Empty( dbfPromoL )
      ( dbfPromoL )->( dbCloseArea() )
   end if

   if !Empty( dbfPromoC )
      ( dbfPromoC )->( dbCloseArea() )
   end if

   if !Empty( dbfCliAtp )
      ( dbfCliAtp )->( dbCloseArea() )
   end if

   if !Empty( dbfKit )
      ( dbfKit )->( dbCloseArea() )
   end if

   if !Empty( dbfCount )
      ( dbfCount )->( dbCloseArea() )
   end if

   dbfNewFil   := nil
   dbfAlbCliT  := nil
   dbfAlbCliL  := nil
   dbfExtAgeT  := nil
   dbfExtAgeL  := nil
   dbfDepAgeT  := nil
   dbfDepAgeL  := nil
   dbfArticulo := nil
   dbfAlmT     := nil
   dbfDiv      := nil
   dbfTVta     := nil
   dbfClient   := nil
   dbfIva      := nil
   dbfTarPreL  := nil
   dbfTarPreS  := nil
   dbfPromoT   := nil
   dbfPromoL   := nil
   dbfPromoC   := nil
   dbfCliAtp   := nil
   dbfKit      := nil
   dbfCount    := nil

Return .t.

//----------------------------------------------------------------------------//

FUNCTION LqdAlm( oMenuItem, oWnd )

   local oDlg
   local oFld
   local oTree
   local oBrwLqd
   local oGetAlmDes
   local oGetAlmHas
   local cGetAlmDes
   local cGetAlmHas
   local oSayAlmDes
   local oSayAlmHas
   local cSayAlmDes
   local cSayAlmHas
   local oMetMsg
   local oMetLqd
   local nMetMsg        := 0
   local nMetLqd        := 0
   local dIniFecLqd     := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   local dFinFecLqd     := Date()

   DEFAULT  oMenuItem   := "01052"
   DEFAULT  oWnd        := oWnd()

   /*
   Obtenemos el nivel de acceso
   */

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      return nil
   end if

   /*
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Liquidación de depositos", ProcName() )

   cGetAlmDes := dbFirst( dbfAlmT )
   cGetAlmHas := dbLast( dbfAlmT )

   /*
   Caja de dialogo_____________________________________________________________
   */

   DEFINE DIALOG oDlg RESOURCE "LQDALM" TITLE "Liquidación de depositos" OF oWnd()

      REDEFINE FOLDER oFld ;
         ID 200 ;
         OF oDlg ;
         PROMPT   "&Fecha", "Liquidación" ;
         DIALOGS  "LQDALM_1", "LQDALM_2"

      oFld:aEnable := { .t., .f. }

      /*
		Primera caja de dialogo_______________________________________________
		*/

      REDEFINE GET dIniFecLqd ;
			ID 		100 ;
			SPINNER ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET dFinFecLqd ;
         ID       110 ;
			SPINNER ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetAlmDes VAR cGetAlmDes;
         ID       120;
         VALID    cAlmacen( oGetAlmDes, dbfAlmT, oSayAlmDes ) ;
         BITMAP   "LUPA" ;
         ON HELP  BrwAlmacen( oGetAlmDes, oSayAlmDes ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlmDes VAR cSayAlmDes ;
         ID       121 ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetAlmHas VAR cGetAlmHas;
         ID       130;
         VALID    cAlmacen( oGetAlmHas, dbfAlmT, oSayAlmHas ) ;
         BITMAP   "LUPA" ;
         ON HELP  BrwAlmacen( oGetAlmHas, oSayAlmHas ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlmHas VAR cSayAlmHas ;
         ID       131 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

REDEFINE APOLOMETER oMetMsg VAR nMetMsg ;
         ID       140 ;
         NOPERCENTAGE ;
         OF       oFld:aDialogs[1]

		REDEFINE BUTTON ;
			ID 		519;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( mkLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, oBrwLqd, oTree, oMetMsg, oFld ) )

		REDEFINE BUTTON ;
			ID 		510;
			OF 		oFld:aDialogs[1] ;
         ACTION   (  oDlg:end() )

		/*
      Segunda caja de dialogo--------------------------------------------------
		*/

      oBrwLqd                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwLqd:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLqd:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLqd:cAlias          := dbfNewFil
      oBrwLqd:nMarqueeStyle   := 5
      oBrwLqd:cName           := "Linea de liquidación detalle"

      oBrwLqd:CreateFromResource( 100 )

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Alm. Almacén"
         :bEditValue          := {|| ( dbfNewFil )->cCodAlm }
         :nWidth              := 30
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Cod. artículo"
         :bEditValue          := {|| Rtrim( ( dbfNewFil )->cCodArt ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Nom. artículo"
         :bEditValue          := {|| ( dbfNewFil )->cNomArt }
         :nWidth              := 180
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Mov. tipo de movimiento"
         :bEditValue          := {|| ( dbfNewFil )->cTipMov }
         :nWidth              := 30
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Entradas"
         :bEditValue          := {|| nUnd2Caj( ( dbfNewFil )->nEntArt, ( dbfNewFil )->cCodArt, dbfArticulo, cPicUnd ) }
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Ventas"
         :bEditValue          := {|| nUnd2Caj( ( dbfNewFil )->nAbnArt, ( dbfNewFil )->cCodArt, dbfArticulo, cPicUnd ) }
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Existencias"
         :bEditValue          := {|| nUnd2Caj( ( dbfNewFil )->nExtArt, ( dbfNewFil )->cCodArt, dbfArticulo, cPicUnd ) }
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLqd:AddCol() )
         :cHeader             := "Saldo"
         :bEditValue          := {|| nUnd2Caj( ( dbfNewFil )->nEntArt - ( dbfNewFil )->nAbnArt - ( dbfNewFil )->nExtArt, ( dbfNewFil )->cCodArt, dbfArticulo, cPicUnd ) }
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

REDEFINE APOLOMETER oMetLqd VAR nMetLqd ;
         ID       150 ;
         NOPERCENTAGE ;
         OF       oFld:aDialogs[2]

      REDEFINE BUTTON ;
         ID       508;
         OF       oFld:aDialogs[2] ;
         ACTION   ( ImpLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, 1, dbfNewFil ) )

		REDEFINE BUTTON ;
         ID       505;
         OF       oFld:aDialogs[2] ;
         ACTION   ( ImpLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, 2, dbfNewFil ) )

      REDEFINE BUTTON ;
			ID 		519;
         OF       oFld:aDialogs[2] ;
         ACTION   ( genLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, oMetLqd ), oDlg:end() )

		REDEFINE BUTTON ;
			ID 		510;
         OF       oFld:aDialogs[2] ;
         ACTION   ( oDlg:end() )

      oDlg:bStart  := {|| oBrwLqd:Load() }

   ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT  ( oGetAlmDes:lValid(), oGetAlmHas:lValid() );
         VALID    ( CloseFiles() )

   /*
    Guardamos los datos del browse
   */

    oBrwLqd:CloseData()

RETURN ( NIL )

//----------------------------------------------------------------------------//

STATIC FUNCTION mkLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, oBrwLqd, oTree, oMetMsg, oFld )

   local n
   local nEntArt  := 0
   local nAbnArt  := 0
   local nExtArt  := 0

   oFld:aDialogs[1]:disable()

   /*
   Procesamos todos los almacenes______________________________________________
   */

   ( dbfAlmT )->( dbSeek( cGetAlmDes ) )

   WHILE ( dbfAlmT )->CCODALM <= cGetAlmHas .AND. !( dbfAlmT )->( eof() )

      oMetMsg:cText := rtrim( ( dbfAlmT )->CCODALM + " - " + ( dbfAlmT )->CNOMALM )
      n  := 1

      ( dbfArticulo )->( dbGoTop() )

      oMetMsg:setTotal( ( dbfArticulo )->( lastrec() + 1 ) )

      WHILE !( dbfArticulo )->( eof() )

         /*
         Unidades en los depositos
         */

         ( dbfTVta )->( dbGoTop() )

         while !( dbfTVta )->( eof() )

            nEntArt  := nEntArt( ( dbfAlmT )->CCODALM, ( dbfArticulo )->CODIGO, ( dbfTVta )->cCodMov, dIniFecLqd, dFinFecLqd )
            nAbnArt  := nAbnArt( ( dbfAlmT )->CCODALM, ( dbfArticulo )->CODIGO, ( dbfTVta )->cCodMov, dIniFecLqd, dFinFecLqd )
            nExtArt  := nExtArt( ( dbfAlmT )->CCODALM, ( dbfArticulo )->CODIGO, ( dbfTVta )->cCodMov, dIniFecLqd, dFinFecLqd )

            IF nEntArt != 0 .OR. nAbnArt != 0 .OR. nExtArt != 0

               ( dbfNewFil )->( dbAppend() )
               ( dbfNewFil )->CCODALM  := ( dbfAlmT )->CCODALM
               ( dbfNewFil )->CNOMALM  := ( dbfAlmT )->CNOMALM
               ( dbfNewFil )->CCODART  := ( dbfArticulo )->CODIGO
               ( dbfNewFil )->cCodFam  := ( dbfArticulo )->Familia
               ( dbfNewFil )->CNOMART  := ( dbfArticulo )->NOMBRE
               ( dbfNewFil )->cTipMov  := ( dbfTVta )->cCodMov
               ( dbfNewFil )->NENTART  := nEntArt
               ( dbfNewFil )->NABNART  := nAbnArt
               ( dbfNewFil )->NEXTART  := nExtArt
               ( dbfNewFil )->NEXTART  := nExtArt

            END IF

            ( dbfTVta )->( dbSkip() )

         end while

         ( dbfArticulo )->( dbSkip() )

         oMetMsg:set( n++ )

      END DO

      ( dbfAlmT )->( dbSkip() )

   END DO

   oFld:aDialogs[1]:enable()

   oFld:aEnable := { .f., .t. }
   oFld:SetOption( 2 )
   oBrwLqd:Refresh()

   /*
   Posicionamos el combobox en el primer almacen_______________________________
   */

   oBrwLqd:goTop()

RETURN NIL

//----------------------------------------------------------------------------//
/*
Devuelve las unidades que entran por los depositos
*/

STATIC FUNCTION nEntArt( cCodAlm, cCodArt, cTipMov, dFecIni, dFecFin )

   local nValRet  := 0

   /*
   Buscamos los articulos______________________________________________________
   */
   IF ( dbfDepAgeL )->( dbSeek( cCodArt ) )

      WHILE ( dbfDepAgeL )->CREF == cCodArt .AND. !( dbfDepAgeL )->( eof() )

         /*
         Posicionamiento en depositos de agentes_______________________________
         */

         IF ( dbfDepAgeT )->( dbSeek( ( dbfDepAgeL )->cSerDep + Str( ( dbfDepAgeL )->NNUMDEP ) + ( dbfDepAgeL )->cSufDep ) )

            /*
            Comprobamos si ya este liquidado este deposito_____________________
            */

            IF ( dbfDepAgeT )->cCodAlm == cCodAlm .AND. ;
               ( dbfDepAgeT )->dFecDep >= dFecIni .AND. ;
               ( dbfDepAgeT )->dFecDep <= dFecFin .AND. ;
               ( dbfDepAgeL )->cTipMov == cTipMov .AND. ;
               !(dbfDepAgeT )->lLiqDep

               /*
               Aplicando el tipo de movimeiento
               */

               nValRet  += nUnitEnt( dbfDepAgeL ) * nVtaUnd( ( dbfDepAgeL )->cTipMov, dbfTVta )

            END IF

         END IF

         ( dbfDepAgeL )->( dbSkip() )

      END DO

   END IF

RETURN ( nValRet )

//----------------------------------------------------------------------------//

/*
Devuelve las unidades que se abonan por los albaranes
*/

STATIC FUNCTION nAbnArt( cCodAlm, cCodArt, cTipMov, dFecIni, dFecFin )

   local nValRet  := 0

   /*
   Buscamos los articulos______________________________________________________
   */

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )

      while ( dbfAlbCliL )->cRef == cCodArt .AND. !( dbfAlbCliL )->( eof() )

         /*
         Posicionamiento en depositos de agentes_______________________________
         */

         if ( dbfAlbCliT )->( dbSeek( ( dbfAlbCliL )->CSERALB + Str( ( dbfAlbCliL )->NNUMALB ) + ( dbfAlbCliL )->CSUFALB ) )

            /*
            Comprobamos si ya este liquidado este deposito_____________________
            */

            if ( dbfAlbCliT )->cCodAlm == cCodAlm  .AND. ;
               ( dbfAlbCliT )->dFecAlb >= dFecIni  .AND. ;
               ( dbfAlbCliT )->dFecAlb <= dFecFin  .AND. ;
               ( dbfAlbCliL )->cTipMov == cTipMov  .AND. ;
               !(dbfAlbCliT )->lGenLqd             .AND. ;
               ( dbfAlbCliT )->lFacturado

               /*
               Comportamiento segun unidades___________________________________
               */

               nValRet  += nUnitEnt( dbfAlbCliL ) * nVtaUnd( ( dbfAlbCliL )->CTIPMOV, dbfTVta )

            END IF

         END IF

         ( dbfAlbCliL )->( dbSkip() )

      END DO

   END IF

RETURN ( nValRet )

//----------------------------------------------------------------------------//

/*
Devuelve las unidades que se introducen por las existencias
*/

STATIC FUNCTION nExtArt( cCodAlm, cCodArt, cTipMov, dFecIni, dFecFin )

   local nValRet  := 0

   /*
   Buscamos los articulos______________________________________________________
   */

   IF ( dbfExtAgeL )->( dbSeek( cCodArt ) )

      WHILE ( dbfExtAgeL )->cRef == cCodArt .AND. !( dbfExtAgeL )->( eof() )

         /*
         Posicionamiento en depositos de agentes_______________________________
         */

         IF ( dbfExtAgeT )->( dbSeek( ( dbfExtAgeL )->cSerExt + Str( ( dbfExtAgeL )->NNUMEXT ) + ( dbfExtAgeL )-> cSufExt ) )

            /*
            Comprobamos si ya este liquidado este deposito_____________________
            */

            IF ( dbfExtAgeT )->cCodAlm == cCodAlm .AND. ;
               ( dbfExtAgeT )->dFecExt >= dFecIni .AND. ;
               ( dbfExtAgeT )->dFecExt <= dFecFin .AND. ;
               ( dbfExtAgeL )->cTipMov == cTipMov .AND. ;
               !(dbfExtAgeT )->lLiqExt

               nValRet  += nUnitEnt( dbfExtAgeL )

            END IF

         END IF

         ( dbfExtAgeL )->( dbSkip() )

      END DO

   END IF

RETURN ( nValRet )

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfDepAgeT, oBrw, bWhen, bValid, nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "EDTEXT" TITLE lblTitle( nMode ) + "lineas de liquidación"

      REDEFINE GET aGet[_CCODALM] VAR aTmp[_CCODALM] ;
			ID 		100 ;
			WHEN  	( .F. ) ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET aGet[_CCODART] VAR aTmp[_CCODART] ;
         ID       110 ;
			WHEN  	( .F. ) ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET aGet[_CNOMART] VAR aTmp[_CNOMART] ;
         ID       120 ;
			WHEN  	( .F. ) ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET aGet[_NENTART] VAR aTmp[_NENTART] ;
         ID       130 ;
			WHEN  	( .F. ) ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET aGet[_NABNART] VAR aTmp[_NABNART] ;
         ID       140 ;
			WHEN  	( .F. ) ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET aGet[_NCAJART] VAR aTmp[_NCAJART] ;
         ID       150 ;
         SPINNER ;
         PICTURE  cPicUnd ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[_NEXTART] VAR aTmp[_NEXTART] ;
         ID       160 ;
         SPINNER ;
         PICTURE  CPICUND ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, aGet, dbfDepAgeT, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION GenLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, oMetMsg )

   local cCodCli
   local nDepAge
   local nTarifa  := 1
   local cSerAlb  := "A"
   local nUni     := 0
   local nMod     := 0
   local n        := 1
   local cAlmCur  := " "

   /*
   Ponemos todos los documentos como liquidados________________________________
   */

   oMetMsg:cText  := "Liquidando depositos..."
   oMetMsg:setTotal( ( dbfDepAgeT )->( lastrec() + 1 ) )

   ( dbfDepAgeT )->( dbGoTop() )

   WHILE !( dbfDepAgeT )->( eof() )

      IF !(dbfDepAgeT )->LLIQDEP                .AND. ;
         ( dbfDepAgeT )->DFECDEP >= dIniFecLqd  .AND. ;
         ( dbfDepAgeT )->DFECDEP <= dFinFecLqd

         ( dbfDepAgeT )->( dbRLock() )
         ( dbfDepAgeT )->LLIQDEP := .T.
         ( dbfDepAgeT )->( dbUnLock() )

      END IF

      ( dbfDepAgeT )->( dbSkip() )

      oMetMsg:set( n++ )

   END WHILE

   /*
   Ponemos todos los documentos como liquidados________________________________
   */

   n              := 1
   oMetMsg:cText  := "Liquidando existencias..."
   oMetMsg:setTotal( ( dbfExtAgeT )->( lastrec() + 1 ) )

   ( dbfExtAgeT )->( dbGoTop() )

   WHILE !( dbfExtAgeT )->( eof() )

      IF !( dbfExtAgeT )->LLIQEXT               .AND. ;
         ( dbfExtAgeT )->DFECEXT >= dIniFecLqd  .AND. ;
         ( dbfExtAgeT )->DFECEXT <= dFinFecLqd

         ( dbfExtAgeT )->( dbRLock() )
         ( dbfExtAgeT )->LLIQEXT := .T.
         ( dbfExtAgeT )->( dbUnLock() )

      END IF

      ( dbfExtAgeT )->( dbSkip() )
      oMetMsg:set( n++ )

   END WHILE

   /*
   Generación de los nuevos documentos_________________________________________
   */

   n              := 1
   oMetMsg:cText  := "Nuevos depositos..."
   oMetMsg:setTotal( ( dbfNewFil )->( lastrec() + 1 ) )

   ( dbfNewFil )->( dbGoTop() )

   WHILE !( dbfNewFil )->( eof() )

      IF cAlmCur != ( dbfNewFil )->CCODALM

         /*
         Cabecera de depositos_________________________________________________
         */

         nDepAge                 := nNewDoc( "A", dbfDepAgeT, "NDEPAGE", , dbfCount )

         ( dbfDepAgeT )->( dbAppend() )
         ( dbfDepAgeT )->CSERDEP := "A"
         ( dbfDepAgeT )->NNUMDEP := nDepAge
         ( dbfDepAgeT )->CSUFDEP := RetSufEmp()
         ( dbfDepAgeT )->DFECDEP := date()
         ( dbfDepAgeT )->CCODALM := ( dbfNewFil )->CCODALM
         ( dbfDepAgeT )->CNOMALM := ( dbfNewFil )->CNOMALM
         ( dbfDepAgeT )->CDIVDEP := cDivEmp()
         ( dbfDepAgeT )->NVDVDEP := nChgDiv( ( dbfDepAgeT )->CDIVDEP, dbfDiv )
         ( dbfDepAgeT )->CDIRALM := ""
         ( dbfDepAgeT )->CPOBALM := ""
         ( dbfDepAgeT )->CPRVALM := ""
         ( dbfDepAgeT )->CPOSALM := ""

         /*
         Cambio de almacen_____________________________________________________
         */

         cAlmCur  := ( dbfNewFil )->CCODALM

      END IF

      /*
      Lineas de detalle________________________________________________________
      */

      if ( dbfArticulo )->( dbSeek( ( dbfNewFil )->CCODART ) )                            .and.;
         ( dbfNewFil )->cTipMov <= "01"                                                   .and.;
         ( dbfNewFil )->NENTART - ( dbfNewFil )->NABNART - ( dbfNewFil )->NEXTART != 0

         nUni                    := ( dbfNewFil )->NEXTART
         nMod                    := Mod( nUni, ( dbfArticulo )->nUniCaja )

         if nMod == 0
            ( dbfDepAgeL )->( dbAppend())
            ( dbfDepAgeL )->CSERDEP    := "A"
            ( dbfDepAgeL )->NNUMDEP    := nDepAge
            ( dbfDepAgeL )->CSUFDEP    := RetSufEmp()
            ( dbfDepAgeL )->CREF       := ( dbfNewFil )->CCODART
            ( dbfDepAgeL )->CDETALLE   := ( dbfNewFil )->CNOMART
            ( dbfDepAgeL )->cTipMov    := ( dbfNewFil )->cTipMov
            ( dbfDepAgeL )->NCANENT    := nUni / ( dbfArticulo )->nUniCaja
            ( dbfDepAgeL )->NUNICAJA   := ( dbfArticulo )->nUniCaja
         else
            ( dbfDepAgeL )->( dbAppend())
            ( dbfDepAgeL )->CSERDEP    := "A"
            ( dbfDepAgeL )->NNUMDEP    := nDepAge
            ( dbfDepAgeL )->CSUFDEP    := RetSufEmp()
            ( dbfDepAgeL )->CREF       := ( dbfNewFil )->CCODART
            ( dbfDepAgeL )->CDETALLE   := ( dbfNewFil )->CNOMART
            ( dbfDepAgeL )->cTipMov    := ( dbfNewFil )->cTipMov
            ( dbfDepAgeL )->NCANENT    := if( nMod == 0, 1, nMod )
            ( dbfDepAgeL )->NUNICAJA   := ( dbfArticulo )->nUniCaja

            ( dbfDepAgeL )->( dbAppend())
            ( dbfDepAgeL )->CSERDEP    := "A"
            ( dbfDepAgeL )->NNUMDEP    := nDepAge
            ( dbfDepAgeL )->CSUFDEP    := RetSufEmp()
            ( dbfDepAgeL )->CREF       := ( dbfNewFil )->CCODART
            ( dbfDepAgeL )->CDETALLE   := ( dbfNewFil )->CNOMART
            ( dbfDepAgeL )->cTipMov    := ( dbfNewFil )->cTipMov
            ( dbfDepAgeL )->NCANENT    := 1
            ( dbfDepAgeL )->NUNICAJA   := nUni - ( nMod * ( dbfArticulo )->nUniCaja )
         end if

      end if

      ( dbfNewFil )->( dbSkip() )

      oMetMsg:set( n++ )

   end while

   /*
   Albaranes-------------------------------------------------------------------
   */

   cAlmCur        := " "
   n              := 1
   oMetMsg:cText  := "Nuevos albaranes..."
   oMetMsg:setTotal( ( dbfNewFil )->( lastrec() + 1 ) )

   ( dbfNewFil )->( dbGoTop() )

   WHILE !( dbfNewFil )->( eof() )

      IF cAlmCur != ( dbfNewFil )->CCODALM

         /*
         Cabecera de albaranes_________________________________________________
         */

         cCodCli                 := RetCliAlm( ( dbfNewFil )->CCODALM, dbfAlmT )

         if ( dbfClient )->( dbSeek( cCodCli ) )
            cSerAlb              := if( Empty( ( dbfClient )->SERIE ), "A", ( dbfClient )->SERIE )
            nTarifa              := ( dbfClient )->nTarifa
         end if
         nDepAge                 := nNewDoc( cSerAlb, dbfAlbCliT, "NALBCLI", , dbfCount )

         /*
         Cabecera______________________________________________________________
         */

         ( dbfAlbCliT )->( dbAppend() )

         ( dbfAlbCliT )->CSERALB := cSerAlb
         ( dbfAlbCliT )->NNUMALB := nDepAge
         ( dbfAlbCliT )->CSUFALB := RetSufEmp()
         ( dbfAlbCliT )->DFECALB := Date()
         ( dbfAlbCliT )->CCODALM := ( dbfNewFil )->CCODALM
         ( dbfAlbCliT )->CDIVALB := cDivEmp()
         ( dbfAlbCliT )->NVDVALB := nChgDiv( ( dbfDepAgeT )->CDIVDEP, dbfDiv )
         ( dbfAlbCliT )->lGenLqd := .t.

         /*
         Datos del cliente
         */

         ( dbfAlbCliT )->CCODCLI := cCodCli
         ( dbfAlbCliT )->nTarifa := nTarifa
         ( dbfAlbCliT )->CNOMCLI := ( dbfClient )->TITULO
         ( dbfAlbCliT )->CDIRCLI := ( dbfClient )->DOMICILIO
         ( dbfAlbCliT )->CPOBCLI := ( dbfClient )->POBLACION
         ( dbfAlbCliT )->CPRVCLI := ( dbfClient )->PROVINCIA
         ( dbfAlbCliT )->CPOSCLI := ( dbfClient )->CODPOSTAL
         ( dbfAlbCliT )->CDNICLI := ( dbfClient )->NIF
         ( dbfAlbCliT )->CCODTAR := ( dbfClient )->CCODTAR
         ( dbfAlbCliT )->CCODPAGO:= ( dbfClient )->CODPAGO
         ( dbfAlbCliT )->CCODRUT := ( dbfClient )->CCODRUT
         ( dbfAlbCliT )->CCODAGE := ( dbfClient )->CAGENTE
         ( dbfAlbCliT )->LMAYOR  := ( dbfClient )->LMAYORISTA
         ( dbfAlbCliT )->LRECARGO:= ( dbfClient )->LREQ
         ( dbfAlbCliT )->NDTOESP := ( dbfClient )->NDTOESP
         ( dbfAlbCliT )->NDPP    := ( dbfClient )->NDPP

         /*
         Cambio de almacen_____________________________________________________
         */

         cAlmCur                 := ( dbfNewFil )->CCODALM

      END IF

      /*
      Lineas de detalle________________________________________________________
      */


      if ( dbfArticulo )->( dbSeek( ( dbfNewFil )->CCODART ) )

         nUni                    := ( dbfNewFil )->NENTART - ( dbfNewFil )->NABNART - ( dbfNewFil )->NEXTART

         if nUni != 0

            nMod                 := Mod( nUni, ( dbfArticulo )->nUniCaja )

            if nMod == 0
               ( dbfAlbCliL )->( dbAppend())
               ( dbfAlbCliL )->CSERALB    := cSerAlb
               ( dbfAlbCliL )->NNUMALB    := nDepAge
               ( dbfAlbCliL )->CSUFALB    := RetSufEmp()
               ( dbfAlbCliL )->CREF       := ( dbfNewFil )->CCODART
               ( dbfAlbCliL )->CDETALLE   := ( dbfNewFil )->CNOMART
               ( dbfAlbCliL )->cTipMov    := ( dbfNewFil )->cTipMov
               ( dbfAlbCliL )->NCANENT    := nUni / ( dbfArticulo )->nUniCaja
               ( dbfAlbCliL )->NUNICAJA   := ( dbfArticulo )->nUniCaja

            else

               ( dbfAlbCliL )->( dbAppend())
               ( dbfAlbCliL )->CSERALB    := cSerAlb
               ( dbfAlbCliL )->NNUMALB    := nDepAge
               ( dbfAlbCliL )->CSUFALB    := RetSufEmp()
               ( dbfAlbCliL )->CREF       := ( dbfNewFil )->CCODART
               ( dbfAlbCliL )->CDETALLE   := ( dbfNewFil )->CNOMART
               ( dbfAlbCliL )->cTipMov    := ( dbfNewFil )->cTipMov
               ( dbfAlbCliL )->NCANENT    := if( nMod == 0, 1, nMod )
               ( dbfAlbCliL )->NUNICAJA   := ( dbfArticulo )->nUniCaja

               ( dbfAlbCliL )->( dbAppend())
               ( dbfAlbCliL )->CSERALB    := cSerAlb
               ( dbfAlbCliL )->NNUMALB    := nDepAge
               ( dbfAlbCliL )->CSUFALB    := RetSufEmp()
               ( dbfAlbCliL )->CREF       := ( dbfNewFil )->CCODART
               ( dbfAlbCliL )->CDETALLE   := ( dbfNewFil )->CNOMART
               ( dbfAlbCliL )->cTipMov    := ( dbfNewFil )->cTipMov
               ( dbfAlbCliL )->NCANENT    := 1
               ( dbfAlbCliL )->NUNICAJA   := nUni - ( nMod * ( dbfArticulo )->nUniCaja )

            end if

            /*
            Precio de articulo
            */

            ( dbfAlbCliL )->CDETALLE   := ( dbfArticulo )->NOMBRE
            ( dbfAlbCliL )->NPESOKG    := ( dbfArticulo )->NPESOKG
            ( dbfAlbCliL )->CUNIDAD    := ( dbfArticulo )->CUNIDAD
            ( dbfAlbCliL )->NIVA       := nIva( dbfIva, (dbfArticulo)->TIPOIVA )

            /*
            Chequeamos situaciones especiales y comprobamos las fechas
            */

            do case
            /*case lSeekAtpArt( cCodCli + ( dbfNewFil )->cCodArt, , , ( dbfAlbCliT )->dFecAlb, dbfCliAtp )

               ( dbfAlbCliL )->nPreUnit   := ( dbfCliAtp )->NPRCART
               ( dbfAlbCliL )->nDto       := ( dbfCliAtp )->NDTOART
               ( dbfAlbCliL )->nDtoPrm    := ( dbfCliAtp )->NDPRART
               ( dbfAlbCliL )->nComAge    := ( dbfCliAtp )->NCOMAGE*/

            case !Empty( ( dbfAlbCliT )->cCodTar ) .and. ( dbfAlbCliL )->nPreUnit == 0

               ( dbfAlbCliL )->nPreUnit   := RetPrcTar( ( dbfNewFil )->CCODART, ( dbfAlbCliT )->CCODTAR, Space( 5 ), Space( 5 ), Space( 5 ), Space( 5 ), dbfTarPreL, ( dbfAlbCliT )->nTarifa )
               ( dbfAlbCliL )->nDtoPrm    := RetPctTar( ( dbfNewFil )->CCODART, ( dbfNewFil )->cCodFam, ( dbfAlbCliT )->cCodTar, Space( 5 ), Space( 5 ), Space( 5 ), Space( 5 ), dbfTarPreL )
               ( dbfAlbCliL )->nComAge    := RetComTar( ( dbfNewFil )->CCODART, ( dbfNewFil )->cCodFam, ( dbfAlbCliT )->cCodTar, Space( 5 ), Space( 5 ), Space( 5 ), Space( 5 ), ( dbfAlbCliT )->CCODAGE, dbfTarPreL, dbfTarPreS )

               /*
               Si no obtenemos precio de las lecturas anteriores
               */

            case ( dbfAlbCliL )->nPreUnit == 0

               ( dbfAlbCliL )->nPreUnit   := nRetPreArt( ( dbfAlbCliT )->nTarifa, ( dbfAlbCliT )->cDivAlb, .f., dbfArticulo, dbfDiv, dbfKit, dbfIva )
               ( dbfAlbCliL )->nPntVer    := ( dbfArticulo )->nPntVer1 / ( dbfAlbCliT )->nVdvAlb

            end case

         end if

      end if

      ( dbfNewFil )->( dbSkip() )

      oMetMsg:set( n++ )

   END WHILE

RETURN NIL

//----------------------------------------------------------------------------//

static function ImpLqdAlm( dIniFecLqd, dFinFecLqd, cGetAlmDes, cGetAlmHas, nDevice, dbfNewFil )

   local oReport
   local nRec     := ( dbfNewFil )->( RecNo() )
   local oFont1   := TFont():New( "Courier New", 0, -10, .F., .T. )
   local oFont2   := TFont():New( "Courier New", 0, -10, .F., .F. )
   local oFont3   := TFont():New( "Courier New", 0, -10, .F., .F. )

   ( dbfNewFil )->( dbGoTop() )

   IF nDevice == 1

		REPORT oReport ;
         TITLE    "Informe de liquidación de almacenes", "" ;
         FONT     oFont1, oFont2, oFont3 ;
         HEADER   "Periodo : " + dToC( dIniFecLqd ) + " -> " + dToC( dFinFecLqd ),;
                  "Almacen : " + cGetAlmDes + " -> " + cGetAlmHas ,;
                  "Fecha   : " + dToC( Date() ) ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Liquidación de almacen";
			PREVIEW

	ELSE

      REPORT oReport ;
         TITLE    "Informe de liquidación de almacenes", "" ;
			FONT   	oFont1, oFont2, oFont3 ;
         HEADER   "Periodo : " + dToC( dIniFecLqd ) + " -> " + dToC( dFinFecLqd ),;
                  "Almacen : " + cGetAlmDes + " -> " + cGetAlmHas ,;
                  "Fecha   : " + dToC( Date() ) ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Liquidación de almacen";
         TO PRINTER

	END IF

   COLUMN TITLE   "Almacen" ;
         DATA     ( dbfNewFil )->CCODALM;
         SIZE     8 ;
         FONT     2

   COLUMN TITLE   "Artículo" ;
         DATA     Rtrim( ( dbfNewFil )->CCODART )+ " - " + ( dbfNewFil )->CNOMART;
         SIZE     45 ;
         FONT     2

   COLUMN TITLE   "Mov." ;
         DATA     ( dbfNewFil )->cTipMov ;
         SIZE     4 ;
         FONT     2

   COLUMN TITLE   "Entradas" ;
         DATA     nUnd2Caj( ( dbfNewFil )->NENTART, ( dbfNewFil )->CCODART, dbfArticulo );
         PICTURE  cPicUnd;
         TOTAL ;
         SIZE     9 ;
         FONT     2

   COLUMN TITLE   "Ventas" ;
         DATA     nUnd2Caj( ( dbfNewFil )->NABNART, ( dbfNewFil )->CCODART, dbfArticulo );
         PICTURE  cPicUnd;
         TOTAL ;
         SIZE     9 ;
         FONT     2

   COLUMN TITLE   "Existencias" ;
         DATA     nUnd2Caj( ( dbfNewFil )->NEXTART, ( dbfNewFil )->CCODART, dbfArticulo );
         PICTURE  cPicUnd;
         TOTAL ;
         SIZE     9 ;
         FONT     2

   COLUMN TITLE   "Saldo" ;
         DATA     nUnd2Caj( ( dbfNewFil )->NENTART - ( dbfNewFil )->NABNART - ( dbfNewFil )->NEXTART, ( dbfNewFil )->CCODART, dbfArticulo ) ;
         PICTURE  cPicUnd;
         TOTAL ;
         SIZE     9 ;
         FONT     2

   END REPORT

   IF !Empty( oReport ) .and. oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:bSkip     := {|| ( dbfNewFil )->( dbSkip() ) }
   END IF

   ACTIVATE REPORT oReport WHILE !( dbfNewFil )->( eof() )

	oFont1:end()
	oFont2:end()
	oFont3:end()

   ( dbfNewFil )->( dbGoTop( nRec ) )

return nil

//---------------------------------------------------------------------------//

static function nUnd2Caj( nUnd, cCodArt, dbfArt, cPicUnd )

   local nCaj  := 1

   if ( dbfArt )->( dbSeek( cCodArt ) )
      if ( dbfArt )->nUniCaja != 0
         nCaj  := nUnd / ( dbfArt )->nUniCaja
      end if
   end if

return ( if( cPicUnd != nil, Trans( nCaj, cPicUnd ), nCaj ) )

//---------------------------------------------------------------------------//