#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TTankes FROM TMANT

   DATA  oIva
   DATA  oDbfArt
   DATA  oNewImp

   DATA  cMru              INIT "Potion_Red_16"

   DATA  cBitmap           INIT clrTopArchivos

   DATA  oGetpVenta1
   DATA  oGetpVenta2
   DATA  oGetpVenta3
   DATA  oGetpVenta4
   DATA  oGetpVenta5
   DATA  oGetpVenta6

   DATA  oGetpVtaIva1
   DATA  oGetpVtaIva2
   DATA  oGetpVtaIva3
   DATA  oGetpVtaIva4
   DATA  oGetpVtaIva5
   DATA  oGetpVtaIva6

   DATA  oGetpVtaIva1
   DATA  oGetpVtaIva2
   DATA  oGetpVtaIva3
   DATA  oGetpVtaIva4
   DATA  oGetpVtaIva5
   DATA  oGetpVtaIva6

   DATA  oGetBenef1
   DATA  oGetBenef2
   DATA  oGetBenef3
   DATA  oGetBenef4
   DATA  oGetBenef5
   DATA  oGetBenef6

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD DefineFiles()

   METHod Resource( nMode )

   METHOD CalPre( lBnf, nBnf, oGetPrePts, oGetIvaPts )

   METHOD CalBnfIva( nPrePtsIva, oBnf, oGetBas )

   METHOD CalBnfPts( nPrePts, oBnf, oGetIvaPts )

   METHOD ChgImporteArticulo()

   METHOD lPreSave( oGet, oGet2, oDlg, nMode )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() )   FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat() )   FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::oNewImp            := TNewImp():Create( ::cPath )
   if !::oNewImp:OpenFiles()
      lOpen             := .f.
   end if

   ::lLoadDivisa()

   ::bOnPostEdit        := {|| ::ChgImporteArticulo() }

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de tanques de combustible" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oNewImp )
      ::oNewImp:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.
      
      ::CloseService()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de tanques de combustible" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   ::oDbf:End()

   ::oDbf               := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "Tankes.Dbf" CLASS "TANKES" ALIAS "TANKES" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tanques de combustible"

      FIELD NAME "CCODTNK"    TYPE "C" LEN  3  DEC 0                                COMMENT "Código"                             COLSIZE 100   OF ::oDbf
      FIELD NAME "CNOMTNK"    TYPE "C" LEN 35  DEC 0                                COMMENT "Nombre"                             COLSIZE 400   OF ::oDbf
      FIELD NAME "NLTRTNK"    TYPE "N" LEN 13  DEC 0 PICTURE "@EZ 999,999,999.999"  COMMENT "Capacidad"              ALIGN RIGHT COLSIZE 100   OF ::oDbf
      FIELD NAME "PCOSTO"     TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "TIPOIVA"    TYPE "C" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LIVAINC"    TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "CCODIMP"    TYPE "C" LEN  3  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LBNF1"      TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LBNF2"      TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LBNF3"      TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LBNF4"      TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LBNF5"      TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "LBNF6"      TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "BENEF1"     TYPE "N" LEN  6  DEC 2 PICTURE "@EZ 99.99"            COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "BENEF2"     TYPE "N" LEN  6  DEC 2 PICTURE "@EZ 99.99"            COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "BENEF3"     TYPE "N" LEN  6  DEC 2 PICTURE "@EZ 99.99"            COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "BENEF4"     TYPE "N" LEN  6  DEC 2 PICTURE "@EZ 99.99"            COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "BENEF5"     TYPE "N" LEN  6  DEC 2 PICTURE "@EZ 99.99"            COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "BENEF6"     TYPE "N" LEN  6  DEC 2 PICTURE "@EZ 99.99"            COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVENTA1"    TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVENTA2"    TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVENTA3"    TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVENTA4"    TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVENTA5"    TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVENTA6"    TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVTAIVA1"   TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVTAIVA2"   TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVTAIVA3"   TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVTAIVA4"   TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVTAIVA5"   TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf
      FIELD NAME "PVTAIVA6"   TYPE "N" LEN 15  DEC 6                                COMMENT ""                  HIDE                           OF ::oDbf

      INDEX TO "TANKES.CDX" TAG "CCODTNK" ON "CCODTNK" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "TANKES.CDX" TAG "CNOMTNK" ON "CNOMTNK" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

Method Resource( nMode )

	local oDlg
   local oGet
   local oGet2
   local oTipIva
   local oCodImp
   local oSayIva
   local cSayIva
   local oSayImp
   local cSayImp

   if nMode == APPD_MODE
      ::oDbf:TipoIva    := cDefIva()
      ::oDbf:Benef1     := nDefBnf( 1 )
      ::oDbf:Benef2     := nDefBnf( 2 )
      ::oDbf:Benef3     := nDefBnf( 3 )
      ::oDbf:Benef4     := nDefBnf( 4 )
      ::oDbf:Benef5     := nDefBnf( 5 )
      ::oDbf:Benef6     := nDefBnf( 6 )
   end if

   DEFINE DIALOG oDlg RESOURCE "Tankes" TITLE LblTitle( nMode ) + "tanques de combustibles"

      REDEFINE GET oGet VAR ::oDbf:CCODTNK;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR ::oDbf:cNomTnk;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:nLtrTnk;
         ID       120 ;
         PICTURE  ::oDbf:FieldByName( "NLTRTNK" ):cPict ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE CHECKBOX ::oDbf:lIvaInc ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oTipIva VAR ::oDbf:TipoIva ;
			ID 		140;
			COLOR 	CLR_GET ;
         PICTURE  "@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      oTipIva:bValid := {|| cTiva( oTipIva, ::oIva:cAlias, oSayIva ) }
      oTipIva:bHelp  := {|| BrwIva( oTipIva, ::oIva:cAlias, oSayIva ) }

      REDEFINE GET oSayIva VAR cSayIva ;
         WHEN     ( .f. );
			ID 		141 ;
			COLOR 	CLR_GET ;
         OF       oDlg

      REDEFINE GET oCodImp VAR ::oDbf:cCodImp ;
         ID       150;
			COLOR 	CLR_GET ;
         PICTURE  "@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      oCodImp:bValid  := {|| ::oNewImp:Existe( oCodImp, oSayImp, "cNomImp", .t., .t., "0" ) }
      oCodImp:bHelp   := {|| ::oNewImp:Buscar( oCodImp ) }

      REDEFINE GET oSayImp VAR cSayImp ;
         WHEN     ( .f. );
         ID       151 ;
			COLOR 	CLR_GET ;
         OF       oDlg

      /*
      Precio de compras________________________________________________________
      */

      REDEFINE GET ::oDbf:pCosto ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ::oGetBenef1:lValid() );
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET ;
         OF       oDlg

      /*
      Tarifa1 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX ::oDbf:lBnf1 ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBenef1 ;
         VAR      ::oDbf:Benef1 ;
         ID       171 ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         OF       oDlg
      ::oGetBenef1:bWhen      := {|| ::oDbf:lBnf1 .AND. nMode != ZOOM_MODE }
      ::oGetBenef1:bChange    := {|| ::CalPre( ::oDbf:lBnf1, ::oDbf:Benef1, ::oGetpVenta1, ::oGetpVtaIva1 ) }
      ::oGetBenef1:bValid     := {|| ::CalPre( ::oDbf:lBnf1, ::oDbf:Benef1, ::oGetpVenta1, ::oGetpVtaIva1 ) }

      REDEFINE GET ::oGetpVenta1 ;
         VAR      ::oDbf:pVenta1 ;
         ID       172 ;
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVenta1:bWhen     := {|| !::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVenta1:bValid    := {|| ::CalBnfPts( ::oDbf:pVenta1, ::oGetBenef1, ::oGetpVtaIva1 ) }

      REDEFINE GET ::oGetpVtaIva1 ;
         VAR      ::oDbf:pVtaIva1 ;
         ID       173 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVtaIva1:bWhen    := {|| ::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVtaIva1:bValid   := {|| ::CalBnfIva( ::oDbf:pVtaIva1, ::oGetBenef1, ::oGetpVenta1 ) }

      /*
      Tarifa2 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX ::oDbf:lBnf2 ;
         ID       180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBenef2 ;
         VAR      ::oDbf:Benef2 ;
         ID       181 ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         OF       oDlg
      ::oGetBenef2:bWhen      := {|| ::oDbf:lBnf2 .AND. nMode != ZOOM_MODE }
      ::oGetBenef2:bChange    := {|| ::CalPre( ::oDbf:lBnf2, ::oDbf:Benef2, ::oGetpVenta2, ::oGetpVtaIva2 ) }
      ::oGetBenef2:bValid     := {|| ::CalPre( ::oDbf:lBnf2, ::oDbf:Benef2, ::oGetpVenta2, ::oGetpVtaIva2 ) }

      REDEFINE GET ::oGetpVenta2 ;
         VAR      ::oDbf:pVenta2 ;
         ID       182 ;
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVenta2:bWhen     := {|| !::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVenta2:bValid    := {|| ::CalBnfPts( ::oDbf:pVenta2, ::oGetBenef2, ::oGetpVtaIva2 ) }

      REDEFINE GET ::oGetpVtaIva2 ;
         VAR      ::oDbf:pVtaIva2 ;
         ID       183 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVtaIva2:bWhen    := {|| ::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVtaIva2:bValid   := {|| ::CalBnfIva( ::oDbf:pVtaIva2, ::oGetBenef2, ::oGetpVenta2 ) }

      /*
      Tarifa3 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX ::oDbf:lBnf3 ;
         ID       190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBenef3 ;
         VAR      ::oDbf:Benef3 ;
         ID       191 ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         OF       oDlg
      ::oGetBenef3:bWhen      := {|| ::oDbf:lBnf3 .AND. nMode != ZOOM_MODE }
      ::oGetBenef3:bChange    := {|| ::CalPre( ::oDbf:lBnf3, ::oDbf:Benef3, ::oGetpVenta3, ::oGetpVtaIva3 ) }
      ::oGetBenef3:bValid     := {|| ::CalPre( ::oDbf:lBnf3, ::oDbf:Benef3, ::oGetpVenta3, ::oGetpVtaIva3 ) }

      REDEFINE GET ::oGetpVenta3 ;
         VAR      ::oDbf:pVenta3 ;
         ID       192 ;
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVenta3:bWhen     := {|| !::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVenta3:bValid    := {|| ::CalBnfPts( ::oDbf:pVenta3, ::oGetBenef3, ::oGetpVtaIva3 ) }

      REDEFINE GET ::oGetpVtaIva3 ;
         VAR      ::oDbf:pVtaIva3 ;
         ID       193 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVtaIva3:bWhen    := {|| ::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVtaIva3:bValid   := {|| ::CalBnfIva( ::oDbf:pVtaIva3, ::oGetBenef3, ::oGetpVenta3 ) }

      /*
      Tarifa4 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX ::oDbf:lBnf4 ;
         ID       200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBenef4 ;
         VAR      ::oDbf:Benef4 ;
         ID       201 ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         OF       oDlg
      ::oGetBenef4:bWhen      := {|| ::oDbf:lBnf4 .AND. nMode != ZOOM_MODE }
      ::oGetBenef4:bChange    := {|| ::CalPre( ::oDbf:lBnf4, ::oDbf:Benef4, ::oGetpVenta4, ::oGetpVtaIva4 ) }
      ::oGetBenef4:bValid     := {|| ::CalPre( ::oDbf:lBnf4, ::oDbf:Benef4, ::oGetpVenta4, ::oGetpVtaIva4 ) }

      REDEFINE GET ::oGetpVenta4 ;
         VAR      ::oDbf:pVenta4 ;
         ID       202 ;
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVenta4:bWhen     := {|| !::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVenta4:bValid    := {|| ::CalBnfPts( ::oDbf:pVenta4, ::oGetBenef4, ::oGetpVtaIva4 ) }

      REDEFINE GET ::oGetpVtaIva4 ;
         VAR      ::oDbf:pVtaIva4 ;
         ID       203 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVtaIva4:bWhen    := {|| ::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVtaIva4:bValid   := {|| ::CalBnfIva( ::oDbf:pVtaIva4, ::oGetBenef4, ::oGetpVenta4 ) }

      /*
      Tarifa5 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX ::oDbf:lBnf5 ;
         ID       210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBenef5 ;
         VAR      ::oDbf:Benef5 ;
         ID       211 ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         OF       oDlg
      ::oGetBenef5:bWhen      := {|| ::oDbf:lBnf5 .AND. nMode != ZOOM_MODE }
      ::oGetBenef5:bChange    := {|| ::CalPre( ::oDbf:lBnf5, ::oDbf:Benef5, ::oGetpVenta5, ::oGetpVtaIva5 ) }
      ::oGetBenef5:bValid     := {|| ::CalPre( ::oDbf:lBnf5, ::oDbf:Benef5, ::oGetpVenta5, ::oGetpVtaIva5 ) }

      REDEFINE GET ::oGetpVenta5 ;
         VAR      ::oDbf:pVenta5 ;
         ID       212 ;
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVenta5:bWhen     := {|| !::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVenta5:bValid    := {|| ::CalBnfPts( ::oDbf:pVenta5, ::oGetBenef5, ::oGetpVtaIva5 ) }

      REDEFINE GET ::oGetpVtaIva5 ;
         VAR      ::oDbf:pVtaIva5 ;
         ID       213 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVtaIva5:bWhen    := {|| ::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVtaIva5:bValid   := {|| ::CalBnfIva( ::oDbf:pVtaIva5, ::oGetBenef5, ::oGetpVenta5 ) }

      /*
      Tarifa6 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX ::oDbf:lBnf6 ;
         ID       220 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBenef6 ;
         VAR      ::oDbf:Benef6 ;
         ID       221 ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         OF       oDlg
      ::oGetBenef6:bWhen      := {|| ::oDbf:lBnf6 .AND. nMode != ZOOM_MODE }
      ::oGetBenef6:bChange    := {|| ::CalPre( ::oDbf:lBnf6, ::oDbf:Benef6, ::oGetpVenta6, ::oGetpVtaIva6 ) }
      ::oGetBenef6:bValid     := {|| ::CalPre( ::oDbf:lBnf6, ::oDbf:Benef6, ::oGetpVenta6, ::oGetpVtaIva6 ) }

      REDEFINE GET ::oGetpVenta6 ;
         VAR      ::oDbf:pVenta6 ;
         ID       222 ;
         PICTURE  ::cPouDiv ;
			COLOR 	CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVenta6:bWhen     := {|| !::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVenta6:bValid    := {|| ::CalBnfPts( ::oDbf:pVenta6, ::oGetBenef6, ::oGetpVtaIva6 ) }

      REDEFINE GET ::oGetpVtaIva6 ;
         VAR      ::oDbf:pVtaIva6 ;
         ID       223 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET, CLR_SHOW ;
         OF       oDlg
      ::oGetpVtaIva6:bWhen    := {|| ::oDbf:lIvaInc .and. nMode != ZOOM_MODE }
      ::oGetpVtaIva6:bValid   := {|| ::CalBnfIva( ::oDbf:pVtaIva6, ::oGetBenef6, ::oGetpVenta6 ) }

      /*
      Botones ___________________________________________________________________________
      */

      REDEFINE BUTTON;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Tanques_de_combustible" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oGet2, oDlg, nMode ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Tanques_de_combustible" ) } )

   oDlg:bStart := {|| oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oGet2, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:CCODTNK )
         MsgStop( "Código del tanke no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:CCODTNK, "CCODTNK" )
         MsgStop( "Código existente" )
         oGet:SetFocus()
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cNomTnk )
      MsgStop( "Nombre del tanke no puede estar vacío." )
      oGet2:SetFocus()
      Return .f.
   end if

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

METHOD CalPre( lBnf, nBnf, oGetPrePts, oGetIvaPts )

	local nIvaPct
	local nNewPre
   local nNewIva  := 0

   if lBnf .and. ::oDbf:pCosto != 0

      nIvaPct     := nIva( ::oIva:cAlias, ::oDbf:TipoIva )
      nNewPre     := Round( ( ::oDbf:pCosto * nBnf / 100 ) + ::oDbf:pCosto, ::nDouDiv )

      oGetPrePts:cText( nNewPre )

      /*
      Calculo del impuestos
      */

      nNewIva     := nNewPre

      /*
      Si tiene impuesto especial añadirlo
      */

      if !Empty( ::oDbf:cCodImp )
         nNewIva  += ::oNewImp:nValImp( ::oDbf:cCodImp, .t., nIvaPct )
      end if

      nNewIva     += Round( ( nNewIva * nIvaPct / 100 ), ::nDouDiv )

      if oGetIvaPts != NIL
			oGetIvaPts:cText( nNewIva )
      end if

   end if

RETURN .T.

//----------------------------------------------------------------------------//

/*
Esta funci¢n calcula el beneficio que se esta aplicando a un articulo sin impuestos
*/

Method CalBnfPts( nPrePts, oBnf, oGetIvaPts )

	local nNewBnf
   local nIvaPct
   local nNewIva  := nPrePts

   if ::oDbf:lIvaInc
      return .t.
   end

   nIvaPct        := nIva( ::oIva:cAlias, ::oDbf:TipoIva )
   nPrePts        := Round( nPrePts, ::nDouDiv )

   if ::oDbf:pCosto != 0

		/*
		Solo procedemos si el % de beneficio es != 0
		*/

      nNewBnf     := ( ( nPrePts / ::oDbf:pCosto ) - 1 ) * 100

		/*
		Proteccion contra limites
		*/

      if nNewBnf > 0 .AND. nNewBnf < 999
			oBnf:cText( nNewBnf )
      else
			oBnf:cText( 0 )
      end if

   end if

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( ::oDbf:cCodImp )
      nNewIva     += ::oNewImp:nValImp( ::oDbf:cCodImp, .t., nIvaPct )
   end if

	/*
   Calculo del impuestos
	*/

   nNewIva        += ( nNewIva * nIvaPct / 100 )

	IF oGetIvaPts != NIL
		oGetIvaPts:cText( nNewIva )
	END IF

RETURN .T.

//----------------------------------------------------------------------------//
/*
Esta funci¢n calcula el beneficio que se esta aplicando a un articulo con impuestos
*/

METHOD CalBnfIva( nPrePtsIva, oBnf, oGetBas )

	local nNewBnf
	local nNewPre
	local nIvaPct

   if ::oDbf:lIvaInc
      return .t.
   end if

   nIvaPct        := nIva( ::oIva:cAlias, ::oDbf:TipoIva )
   nPrePtsIva     := Round( nPrePtsIva, ::nDouDiv )

	/*
   Primero es quitar el impuestos
	*/

   nNewPre        := Round( nPrePtsIva / ( 1 + nIvaPct / 100 ), ::nDouDiv )

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( ::oDbf:cCodImp )
      nNewPre     -= ::oNewImp:nValImp( ::oDbf:cCodImp, ::oDbf:lIvaInc, nIvaPct )
   end if

	/*
	Actualizamos la base
	*/

   oGetBas:cText( nNewPre )

	/*
	Solo procedemos si el % de beneficio es != 0
	*/

   if ::oDbf:pCosto != 0

      nNewBnf     := ( ( nNewPre / ::oDbf:pCosto ) - 1 ) * 100

      if nNewBnf > 0 .AND. nNewBnf < 999
			oBnf:cText( nNewBnf )
      else
			oBnf:cText( 0 )
      end if

   end if

RETURN .T.

//----------------------------------------------------------------------------//

Method ChgImporteArticulo()

   if ApoloMsgNoYes( "¿ Desea actualizar los importes de los artículos relacionados ?", "Seleccione una opción" )

      CursorWait()

      if ::oDbfArt:Seek( ::oDbf:cCodTnk )

         while ::oDbf:cCodTnk == ::oDbfArt:cCodTnk .and. !::oDbfArt:Eof()

            ::oDbfArt:Load()
            ::oDbfArt:pCosto     := ::oDbf:pCosto
            ::oDbfArt:TipoIva    := ::oDbf:TipoIva
            ::oDbfArt:lIvaInc    := ::oDbf:lIvaInc
            ::oDbfArt:cCodImp    := ::oDbf:cCodImp
            ::oDbfArt:lBnf1      := ::oDbf:lBnf1
            ::oDbfArt:lBnf2      := ::oDbf:lBnf2
            ::oDbfArt:lBnf3      := ::oDbf:lBnf3
            ::oDbfArt:lBnf4      := ::oDbf:lBnf4
            ::oDbfArt:lBnf5      := ::oDbf:lBnf5
            ::oDbfArt:lBnf6      := ::oDbf:lBnf6
            ::oDbfArt:Benef1     := ::oDbf:Benef1
            ::oDbfArt:Benef2     := ::oDbf:Benef2
            ::oDbfArt:Benef3     := ::oDbf:Benef3
            ::oDbfArt:Benef4     := ::oDbf:Benef4
            ::oDbfArt:Benef5     := ::oDbf:Benef5
            ::oDbfArt:Benef6     := ::oDbf:Benef6
            ::oDbfArt:pVenta1    := ::oDbf:pVenta1
            ::oDbfArt:pVenta2    := ::oDbf:pVenta2
            ::oDbfArt:pVenta3    := ::oDbf:pVenta3
            ::oDbfArt:pVenta4    := ::oDbf:pVenta4
            ::oDbfArt:pVenta5    := ::oDbf:pVenta5
            ::oDbfArt:pVenta6    := ::oDbf:pVenta6
            ::oDbfArt:pVtaIva1   := ::oDbf:pVtaIva1
            ::oDbfArt:pVtaIva2   := ::oDbf:pVtaIva2
            ::oDbfArt:pVtaIva3   := ::oDbf:pVtaIva3
            ::oDbfArt:pVtaIva4   := ::oDbf:pVtaIva4
            ::oDbfArt:pVtaIva5   := ::oDbf:pVtaIva5
            ::oDbfArt:pVtaIva6   := ::oDbf:pVtaIva6
            ::oDbfArt:Save()

            ::oDbfArt:Skip()

         end while

      end if

      CursorWE()

   end if

Return .t.

//----------------------------------------------------------------------------//