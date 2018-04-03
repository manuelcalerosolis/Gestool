#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TSeaNumSer

   DATA oDbfIva
   DATA oDbfArt
   DATA oDbfCli
   DATA oDbfPrv
   DATA oDbfAlm
   DATA oDbfTmp

   DATA oAlbPrvT
   DATA oAlbPrvL
   DATA oAlbPrvS

   DATA oFacPrvT
   DATA oFacPrvL
   DATA oFacPrvS

   DATA oRctPrvT
   DATA oRctPrvL
   DATA oRctPrvS

   DATA oSatCliT
   DATA oSatCliL
   DATA oSatCliS

   DATA oAlbCliT
   DATA oAlbCliL
   DATA oAlbCliS

   DATA oFacCliT
   DATA oFacCliL
   DATA oFacCliS

   DATA oFacRecT
   DATA oFacRecL
   DATA oFacRecS

   DATA oTikCliT
   DATA oTikCliL
   DATA oTikCliS

   DATA oProCabT
   DATA oProSerS
   DATA oMatSerS

   DATA oOperacion

   DATA oMetMsg
   DATA nMetMsg   AS NUMERIC  INIT 0

   DATA oSayCompras
   DATA nSayCompras           INIT 0

   DATA oSayVentas
   DATA nSayVentas            INIT 0

   DATA oSayProduccion
   DATA nSayProduccion        INIT 0

   DATA oSayTotal
   DATA nSayTotal             INIT 0

   DATA oBrw

   DATA cCodArt               INIT Space( 18 )
   DATA cNumSer               INIT Space( 100 )
   DATA cCodCli               INIT Space( 12 )
   DATA cCodPrv               INIT Space( 12 )
   DATA cCodAlm               INIT Space( 3 )

   DATA lBlocked              INIT .f.

   DATA oStock
   DATA dConsolidacion

   CLASSDATA aMovimiento      INIT { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Activate( oMenuItem, oWnd, lStart )

   METHOD Search( oNumSer )

   METHOD AddAlbPrv()
   METHOD AddFacPrv()
   METHOD AddRctPrv()

   METHOD AddSatCli()
   METHOD AddAlbCli()
   METHOD AddFacCli()
   METHOD AddFacRec()
   METHOD AddTikCli()

   METHOD AddProSer()
   METHOD AddMatSer()

   METHOD Zoom()

   METHOD Visualizar()

   METHOD Imprimir()

   Method nTreeImagen()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local oBlock
   local oError
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"

      DATABASE NEW ::oDbfArt PATH ( cPatEmp() )  FILE "Articulo.Dbf" VIA ( cDriver() ) SHARED INDEX "Articulo.Cdx"

      DATABASE NEW ::oDbfCli PATH ( cPatEmp() )  FILE "Client.Dbf" VIA ( cDriver() ) SHARED INDEX "Client.Cdx"

      DATABASE NEW ::oDbfPrv PATH ( cPatEmp() )  FILE "Provee.Dbf" VIA ( cDriver() ) SHARED INDEX "Provee.Cdx"

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "AlbProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvT.Cdx"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "AlbProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvL.Cdx"

      DATABASE NEW ::oAlbPrvS PATH ( cPatEmp() ) FILE "AlbPrvS.Dbf"  VIA ( cDriver() ) SHARED INDEX "AlbPrvS.Cdx"
      ::oAlbPrvS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FacPrvT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvT.Cdx"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FacPrvL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvL.Cdx"

      DATABASE NEW ::oFacPrvS PATH ( cPatEmp() ) FILE "FacPrvS.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvS.Cdx"
      ::oFacPrvS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oRctPrvT PATH ( cPatEmp() ) FILE "RctPrvT.Dbf" VIA ( cDriver() ) SHARED INDEX "RctPrvT.Cdx"

      DATABASE NEW ::oRctPrvL PATH ( cPatEmp() ) FILE "RctPrvL.Dbf" VIA ( cDriver() ) SHARED INDEX "RctPrvL.Cdx"

      DATABASE NEW ::oRctPrvS PATH ( cPatEmp() ) FILE "RctPrvS.Dbf" VIA ( cDriver() ) SHARED INDEX "RctPrvS.Cdx"
      ::oRctPrvS:OrdSetFocus( "cNumSer" )

      ::oAlbCliT := TDataCenter():oAlbCliT()

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliL.Cdx"

      DATABASE NEW ::oAlbCliS PATH ( cPatEmp() ) FILE "AlbCliS.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliS.Cdx"
      ::oAlbCliS:OrdSetFocus( "cNumSer" )

      ::oSatCliT := TDataCenter():oSatCliT() 

      DATABASE NEW ::oSatCliL PATH ( cPatEmp() ) FILE "SatCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "SatCliL.Cdx"

      DATABASE NEW ::oSatCliS PATH ( cPatEmp() ) FILE "SatCliS.Dbf" VIA ( cDriver() ) SHARED INDEX "SatCliS.Cdx"
      ::oSatCliS:OrdSetFocus( "cNumSer" )

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FacCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliL.Cdx"
      ::oFacCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacCliS PATH ( cPatEmp() ) FILE "FacCliS.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliS.Cdx"
      ::oFacCliS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FacRecT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecT.Cdx"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FacRecL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecL.Cdx"
      ::oFacRecL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacRecS PATH ( cPatEmp() ) FILE "FacRecS.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecS.Cdx"
      ::oFacRecS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TikeT.Dbf"  VIA ( cDriver() ) SHARED INDEX "TikeT.Cdx"

      DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TikeL.Dbf"  VIA ( cDriver() ) SHARED INDEX "TikeL.Cdx"
      ::oTikCliL:OrdSetFocus( "cCbaTil" )

      DATABASE NEW ::oTikCliS PATH ( cPatEmp() ) FILE "TikeS.Dbf"  VIA ( cDriver() ) SHARED INDEX "TikeS.Cdx"
      ::oTikCliS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oDbfAlm  PATH ( cPatEmp() ) FILE "Almacen.Dbf" VIA ( cDriver() ) SHARED INDEX "Almacen.Cdx"

      DATABASE NEW ::oProCabT PATH ( cPatEmp() ) FILE "ProCab.Dbf"  VIA ( cDriver() ) SHARED INDEX "ProCab.Cdx"

      DATABASE NEW ::oProSerS PATH ( cPatEmp() ) FILE "ProSer.Dbf"  VIA ( cDriver() ) SHARED INDEX "ProSer.Cdx"
      ::oProSerS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oMatSerS PATH ( cPatEmp() ) FILE "MatSer.Dbf"  VIA ( cDriver() ) SHARED INDEX "MatSer.Cdx"
      ::oMatSerS:OrdSetFocus( "cNumSer" )

      DATABASE NEW ::oOperacion PATH ( cPatEmp() ) FILE "Operacio.Dbf"  VIA ( cDriver() ) SHARED INDEX "Operacio.Cdx"

      ::oDbfTmp         := DbfServer( "SeaNum", SubStr( Str( Seconds() ), -6 ) ):New( "SeaNum", "SeaNum", cLocalDriver(), , cPatTmp() )

      ::oDbfTmp:AddField( "cTipDoc", "C", 40, 0 )
      ::oDbfTmp:AddField( "cNumDoc", "C", 12, 0 )
      ::oDbfTmp:AddField( "cDoc",    "C", 12, 0 )
      ::oDbfTmp:AddField( "cCodArt", "C", 18, 0 )
      ::oDbfTmp:AddField( "dFecDoc", "D",  8, 0 )
      ::oDbfTmp:AddField( "cCodCli", "C", 12, 0 )
      ::oDbfTmp:AddField( "cCliPrv", "C", 50, 0 )
      ::oDbfTmp:AddField( "cCodObr", "C", 10, 0 )
      ::oDbfTmp:AddField( "cCodAlm", "C", 16, 0 )
      ::oDbfTmp:AddField( "nNumLin", "N",  4, 0 )

      ::oDbfTmp:Create()
      ::oDbfTmp:Activate( .f., .f. )

      ::oDbfTmp:AddTmpIndex( "cTipDoc" , "SeaNum" , "cTipdoc" )
      ::oDbfTmp:AddTmpIndex( "cNumDoc" , "SeaNum" , "cNumDoc" )
      ::oDbfTmp:AddTmpIndex( "cDoc"    , "SeaNum" , "cDoc"    )
      ::oDbfTmp:AddTmpIndex( "cCodArt" , "SeaNum" , "cCodArt" )
      ::oDbfTmp:AddTmpIndex( "cCodCli" , "SeaNum" , "cCodCli" )
      ::oDbfTmp:AddTmpIndex( "cCliPrv" , "SeaNum" , "cCliPrv" )
      ::oDbfTmp:AddTmpIndex( "cCodObr" , "SeaNum" , "cCodObr" )
      ::oDbfTmp:AddTmpIndex( "cCodAlm" , "SeaNum" , "cCodAlm" )
      ::oDbfTmp:AddTmpIndex( "nNumLin" , "SeaNum" , "nNumLin" )
      ::oDbfTmp:AddTmpIndex( "dFecDoc" , "SeaNum" , "dFecDoc" )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de números de serie" )

      ::CloseFiles()

      lOpenFiles     := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenfiles )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfIva )
      ::oDbfIva:End()
   end if

   if !Empty( ::oDbfArt )
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfCli )
      ::oDbfCli:End()
   end if

   if !Empty( ::oDbfPrv )
      ::oDbfPrv:End()
   end if

   if !Empty( ::oAlbPrvT )
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL )
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oAlbPrvS )
      ::oAlbPrvS:End()
   end if

   if !Empty( ::oFacPrvT )
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL )
      ::oFacPrvL:End()
   end if

   if !Empty( ::oFacPrvS )
      ::oFacPrvS:End()
   end if

   if !Empty( ::oRctPrvT )
      ::oRctPrvT:End()
   end if

   if !Empty( ::oRctPrvL )
      ::oRctPrvL:End()
   end if

   if !Empty( ::oRctPrvS )
      ::oRctPrvS:End()
   end if

   if !Empty( ::oAlbCliT )
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL )
      ::oAlbCliL:End()
   end if

   if !Empty( ::oAlbCliS )
      ::oAlbCliS:End()
   end if

   if !Empty( ::oSatCliT )
      ::oSatCliT:End()
   end if

   if !Empty( ::oSatCliL )
      ::oSatCliL:End()
   end if

   if !Empty( ::oSatCliS )
      ::oSatCliS:End()
   end if

   if !Empty( ::oFacCliT )
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL )
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacCliS )
      ::oFacCliS:End()
   end if

   if !Empty( ::oFacRecT )
      ::oFacRecT:End()
   end if

   if !Empty( ::oFacRecL )
      ::oFacRecL:End()
   end if

   if !Empty( ::oFacRecS )
      ::oFacRecS:End()
   end if

   if !Empty( ::oTikCliT )
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL )
      ::oTikCliL:End()
   end if

   if !Empty( ::oTikCliS )
      ::oTikCliS:End()
   end if

   if !Empty( ::oDbfAlm )
      ::oDbfAlm:End()
   end if

   if !Empty( ::oDbfTmp )
      ::oDbfTmp:End()
   end if

   if !Empty( ::oProCabT )
      ::oProCabT:End()
   end if

   if !Empty( ::oProSerS )
      ::oProSerS:End()
   end if

   if !Empty( ::oMatSerS )
      ::oMatSerS:End()
   end if

   if !Empty( ::oOperacion )
      ::oOperacion:End()
   end if

   fErase( cPatTmp() + "SeaNum.Dbf" )
   fErase( cPatTmp() + "SeaNum.Cdx" )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( oMenuItem, oWnd, lStart )

   local oDlg
   local oBmp
   local nLevel
   local oCodArt
   local oCodAlm
   local oSayArt
   local cSayArt        := ""
   local oNumSer
   local oCodCli
   local oSayCli
   local cSayCli        := ""
   local oCodPrv
   local oSayPrv
   local cSayPrv        := ""
   local oBotonImprimir
   local oBotonVer
   local oBotonZoom
   local oBotonInforme
   local oBtnCancel
   local oBtnBuscar

   DEFAULT  oMenuItem   := "01022"

   // Nivel de usuario---------------------------------------------------------

   nLevel            := Auth():Level( oMenuItem )

   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !::OpenFiles()
      return nil
    end if

   DEFINE DIALOG oDlg RESOURCE "SeaNumSer" OF oWnd()

   REDEFINE BITMAP oBmp;
      RESOURCE "gc_package_48" ;
      TRANSPARENT ;
      ID       800 ;
      OF       oDlg

   REDEFINE GET oCodArt VAR ::cCodArt;
      ID       ( 100 ) ;
      WHEN     ( !::lBlocked ) ;
      VALID    cArticulo( oCodArt, ::oDbfArt:cAlias, oSayArt );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oCodArt, oSayArt );
      OF       oDlg

   REDEFINE GET oSayArt VAR cSayArt ;
      WHEN     .f.;
      ID       ( 101 ) ;
      OF       oDlg

   REDEFINE GET oNumSer VAR ::cNumSer;
      WHEN     ( !::lBlocked ) ;
      ID       ( 110 ) ;
      OF       oDlg

   REDEFINE GET oCodCli VAR ::cCodCli;
      ID       ( 120 ) ;
      WHEN     ( !::lBlocked ) ;
      VALID    cClient( oCodCli, ::oDbfCli:cAlias, oSayCli );
      BITMAP   "LUPA" ;
      ON HELP  BrwClient( oCodCli, oSayCli );
      OF       oDlg

   REDEFINE GET oSayCli VAR cSayCli ;
      WHEN     .f.;
      ID       ( 121 ) ;
      OF       oDlg

   REDEFINE GET oCodPrv VAR ::cCodPrv;
      ID       ( 130 ) ;
      WHEN     ( !::lBlocked ) ;
      VALID    cProvee( oCodPrv, ::oDbfPrv:cAlias, oSayPrv );
      BITMAP   "LUPA" ;
      ON HELP  BrwProvee( oCodPrv, oSayPrv );
      OF       oDlg

   REDEFINE GET oSayPrv VAR cSayPrv ;
      WHEN     .f.;
      ID       ( 131 ) ;
      OF       oDlg

   REDEFINE GET oCodAlm VAR ::cCodAlm ;
      WHEN     ( !::lBlocked ) ;
      VALID    ( cAlmacen( oCodAlm, ::oDbfAlm:cAlias, oCodAlm:oHelpText ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAlmacen( oCodAlm, oCodAlm:oHelpText ) ) ;
      ID       ( 160 );
      IDTEXT   ( 161 );
      OF       oDlg

   REDEFINE SAY ::oSayCompras VAR ::nSayCompras ;
      ID       ( 200 );
      PICTURE  MasUnd() ;
      OF       oDlg

   REDEFINE SAY ::oSayVentas VAR ::nSayVentas ;
      ID       ( 201 );
      PICTURE  MasUnd() ;
      OF       oDlg

   REDEFINE SAY ::oSayProduccion VAR ::nSayProduccion ;
      ID       ( 202 ) ;
      PICTURE  MasUnd() ;
      OF       oDlg

   REDEFINE SAY ::oSayTotal VAR ::nSayTotal ;
      ID       ( 203 );
      PICTURE  MasUnd() ;
      OF       oDlg

   // Lisbox de resultados-----------------------------------------------------

   ::oBrw               := IXBrowse():New( oDlg )

   ::oBrw:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrw:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrw:nMarqueeStyle := 5

   ::oDbfTmp:SetBrowse( ::oBrw )

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Tipo de documento"
      :cSortOrder       := "cTipDoc"
      :bStrData         := {|| ::oDbfTmp:cTipDoc }
      :bBmpData         := {|| ::nTreeImagen() }
      :nWidth           := 120
      :AddResource( "gc_clipboard_empty_businessman_16"  )  // Pedido proveedor
      :AddResource( "gc_document_empty_businessman_16"   )  // Albarán proveedor
      :AddResource( "gc_document_text_businessman_16"         )  // Factura proveedor
      :AddResource( "gc_document_text_delete2_16"      )  // Rectificativa proveedor
      :AddResource( "gc_document_text_delete2_16"              )  // Facturas rectificativas
      :AddResource( "gc_clipboard_empty_user_16"      )  // Pedido cliente
      :AddResource( "gc_document_empty_16"            )  // Albarán cliente
      :AddResource( "gc_document_text_businessman_16"               )  // Factura cliente
      :AddResource( "gc_cash_register_user_16"        )  // Tiket cliente
      :AddResource( "gc_document_text_worker_16"             )  // Parte de produccion
      :AddResource( "gc_pencil_package_16"               )  // Mov de almancen
      :AddResource( "gc_power_drill_sat_user_16"            )  // SAT
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Número"
      :cSortOrder       := "cNumDoc"
      :bStrData         := {|| Alltrim( ::oDbfTmp:cNumDoc ) }
      :nWidth           := 80
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Artículo"
      :cSortOrder       := "cCodArt"
      :bStrData         := {|| ::oDbfTmp:cCodArt }
      :nWidth           := 80
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Fecha"
      :cSortOrder       := "dFecDoc"
      :bStrData         := {|| Dtoc( ::oDbfTmp:dFecDoc ) }
      :nWidth           := 80
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Cliente/Proveedor"
      :cSortOrder       := "cCodCli"
      :bStrData         := {|| Rtrim( ::oDbfTmp:cCodCli ) + Space( 1 ) + Rtrim( ::oDbfTmp:cCliPrv ) }
      :nWidth           := 200
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Dirección"
      :cSortOrder       := "cCodObr"
      :lHide            := .t.
      :bStrData         := {|| ::oDbfTmp:cCodObr }
      :nWidth           := 60
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Almacen"
      :cSortOrder       := "cCodAlm"
      :bStrData         := {|| ::oDbfTmp:cCodAlm }
      :nWidth           := 60
   end with

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Num."
      :bEditValue       := {|| Trans( ::oDbfTmp:nNumLin, "9999" ) }
      :nWidth           := 35
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   ::oBrw:bRClicked     := {| nRow, nCol, nFlags | ::oBrw:RButtonDown( nRow, nCol, nFlags ) }
   ::oBrw:bLDblClick    := {|| ::Zoom() }

   ::oBrw:CreateFromResource( 140 )

 REDEFINE APOLOMETER ::oMetMsg VAR ::nMetMsg ;
      ID       150 ;
      OF       oDlg

   REDEFINE BUTTON oBtnBuscar;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( !::lBlocked ) ;
      ACTION   ( if( ::Search( oNumSer, oBtnCancel, oBtnBuscar ), ( oBotonImprimir:Show(), oBotonVer:Show(), oBotonZoom:Show(), oBotonInforme:Enable() ), ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       510 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   REDEFINE BUTTON oBotonImprimir ;
      ID       540 ;
      OF       oDlg ;
      ACTION   ( ::Imprimir() )

   REDEFINE BUTTON oBotonVer;
      ID       530 ;
      OF       oDlg ;
      ACTION   ( ::Visualizar() )

   REDEFINE BUTTON oBotonZoom;
      ID       520 ;
      OF       oDlg ;
      ACTION   ( ::Zoom() )

   REDEFINE BUTTON oBotonInforme;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( TInfSeaNum():New( "Informe detallado de series", , , , , , ::oDbfTmp ):Play() )

   if IsTrue( lStart )
      oDlg:bStart := {|| if( ::Search( oNumSer, oBtnCancel, oBtnBuscar ), ( oBotonImprimir:Show(), oBotonVer:Show(), oBotonZoom:Show(), oBotonInforme:Enable() ), ) }
   end if

   oDlg:AddFastKey( VK_F5, {|| oBtnBuscar:Click() } )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBotonImprimir:Hide(), oBotonVer:Hide(), oBotonZoom:Hide(), oBotonInforme:Disable() )

   ::CloseFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Search( oNumSer, oBtnCancel, oBtnBuscar )

   if Empty( ::cNumSer )
      MsgStop( "Debe introducir un número de serie" )
      oNumSer:SetFocus()
      Return ( .f. )
   end if

   oBtnCancel:Disable()
   oBtnBuscar:Disable()

   CursorWait()

   ::oDbfTmp:Zap()

   ::nSayCompras        := 0
   ::nSayVentas         := 0
   ::nSayProduccion     := 0
   ::nSayTotal          := 0

   // Fecha de consolidación---------------------------------------------------

   if !Empty( ::oStock )
      ::dConsolidacion  := ::oStock:GetConsolidacion( ::cCodArt )
   end if

   // Albaranes de proveedor---------------------------------------------------

   ::oMetMsg:cText   := "Albaranes proveedor"

   ::oMetMsg:SetTotal( ::oAlbPrvS:LastRec() )

   if ::oAlbPrvS:Seek( ::cNumSer )

      while ( Rtrim( ::oAlbPrvS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oAlbPrvS:Eof()

         ::AddAlbPrv()

         ::oAlbPrvS:Skip()

         ::oMetMsg:Set( ::oAlbPrvS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oAlbPrvS:LastRec() )

   // Facturas de proveedor----------------------------------------------------

   ::oMetMsg:cText   := "Facturas proveedor"

   ::oMetMsg:SetTotal( ::oFacPrvS:LastRec() )

   if ::oFacPrvS:Seek( ::cNumSer )

      while ( Rtrim( ::oFacPrvS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oFacPrvS:Eof()

         ::AddFacPrv()

         ::oFacPrvS:Skip()

         ::oMetMsg:Set( ::oFacPrvS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oFacPrvS:LastRec() )

   // Rectificativas de proveedor----------------------------------------------------

   ::oMetMsg:cText   := "Facturas rectificativas de proveedor"

   ::oMetMsg:SetTotal( ::oRctPrvS:LastRec() )

   if ::oRctPrvS:Seek( ::cNumSer )

      while ( Rtrim( ::oRctPrvS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oRctPrvS:Eof()

         ::AddRctPrv()

         ::oRctPrvS:Skip()

         ::oMetMsg:Set( ::oRctPrvS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oRctPrvS:LastRec() )

   // Sataranes de clientes----------------------------------------------------

   ::oMetMsg:cText   := "S.A.T. de cliente"

   ::oMetMsg:SetTotal( ::oSatCliS:LastRec() )

   if ::oSatCliS:Seek( ::cNumSer )

      while ( Rtrim( ::oSatCliS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oSatCliS:Eof()

         ::AddSatCli()

         ::oSatCliS:Skip()

         ::oMetMsg:Set( ::oSatCliS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oSatCliS:LastRec() )

   // Albaranes de clientes----------------------------------------------------

   ::oMetMsg:cText   := "Albaranes de clientes"

   ::oMetMsg:SetTotal( ::oAlbCliS:LastRec() )

   if ::oAlbCliS:Seek( ::cNumSer )

      while ( Rtrim( ::oAlbCliS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oAlbCliS:Eof()

         ::AddAlbCli()

         ::oAlbCliS:Skip()

         ::oMetMsg:Set( ::oAlbCliS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oAlbCliS:LastRec() )

   // Facturas de clientes-----------------------------------------------------

   ::oMetMsg:cText   := "Facturas clientes"

   ::oMetMsg:SetTotal( ::oFacCliL:LastRec() )

   if ::oFacCliS:Seek( ::cNumSer )

      while ( Rtrim( ::oFacCliS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oFacCliS:Eof()

         ::AddFacCli()

         ::oFacCliS:Skip()

         ::oMetMsg:Set( ::oFacCliS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oFacCliL:LastRec() )

   // Facturas rectificativas----------------------------------------------------

   ::oMetMsg:cText   := "Facturas rectificativas de clientes"

   ::oMetMsg:SetTotal( ::oFacRecL:LastRec() )

   if ::oFacRecS:Seek( ::cNumSer )

      while ( Rtrim( ::oFacRecS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oFacRecS:Eof()

         ::AddFacRec()

         ::oFacRecS:Skip()

         ::oMetMsg:Set( ::oFacRecS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oFacRecL:LastRec() )

   // Tikets de clientes-----------------------------------------------------

   ::oMetMsg:cText   := "Tikets de cliente"

   ::oMetMsg:SetTotal( ::oTikCliS:LastRec() )

   if ::oTikCliS:Seek( ::cNumSer )

      while ( Rtrim( ::oTikCliS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oTikCliS:Eof()

         ::AddTikCli()

         ::oTikCliS:Skip()

         ::oMetMsg:Set( ::oTikCliS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oTikCliS:LastRec() )

   // Materiales producidos----------------------------------------------------

   ::oMetMsg:cText   := "Materiales producidos"

   ::oMetMsg:SetTotal( ::oProSerS:LastRec() )

   if ::oProSerS:Seek( ::cNumSer )

      while ( Rtrim( ::oProSerS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oProSerS:Eof()

         ::AddProSer()

         ::oProSerS:Skip()

         ::oMetMsg:Set( ::oProSerS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oProSerS:LastRec() )

   // Materias primas----------------------------------------------------------

   ::oMetMsg:cText   := "Materiales consumidos"

   ::oMetMsg:SetTotal( ::oMatSerS:LastRec() )

   if ::oMatSerS:Seek( ::cNumSer )

      while ( Rtrim( ::oMatSerS:cNumSer ) == Rtrim( ::cNumSer ) ) .and. !::oMatSerS:Eof()

         ::AddMatSer()

         ::oMatSerS:Skip()

         ::oMetMsg:Set( ::oMatSerS:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oMatSerS:LastRec() )

   // Fin de la busquedas------------------------------------------------------

   ::oDbfTmp:GoTop()

   ::oMetMsg:cText   := "Proceso finalizado"

   ::oMetMsg:Set( 0 )
   ::oMetMsg:Refresh( .f. )

   // Refrescos en pantalla----------------------------------------------------

   ::oSayCompras:Refresh()
   ::oSayVentas:Refresh()
   ::oSayProduccion:Refresh()

   ::oSayTotal:SetText( ::nSayCompras - ::nSayVentas + ::nSayProduccion )

   ::oBrw:Refresh( .t. )

   CursorWE()

   oBtnCancel:Enable()

   if !::lBlocked
      oBtnBuscar:Enable()
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD AddAlbPrv()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oAlbPrvS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oAlbPrvS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oAlbPrvS:dFecAlb >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodPrv ) .or. ( Rtrim( ::cCodPrv ) == Rtrim( oRetFld( ::oAlbPrvS:cSerAlb + Str( ::oAlbPrvS:nNumAlb ) + ::oAlbPrvS:cSufAlb, ::oAlbPrvT, "cCodPrv" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Albarán de proveedor"
      ::oDbfTmp:cNumDoc := ::oAlbPrvS:cSerAlb + "/" + Ltrim( Str( ::oAlbPrvS:nNumAlb ) ) + "/" + ::oAlbPrvS:cSufAlb
      ::oDbfTmp:cDoc    := ::oAlbPrvS:cSerAlb + Str( ::oAlbPrvS:nNumAlb ) + ::oAlbPrvS:cSufAlb
      ::oDbfTmp:cCodArt := ::oAlbPrvS:cRef
      ::oDbfTmp:nNumLin := ::oAlbPrvS:nNumLin
      ::oDbfTmp:cCodAlm := ::oAlbPrvS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oAlbPrvS:cSerAlb + Str( ::oAlbPrvS:nNumAlb ) + ::oAlbPrvS:cSufAlb, ::oAlbPrvT, "dFecAlb" )
      ::oDbfTmp:cCodCli := oRetFld( ::oAlbPrvS:cSerAlb + Str( ::oAlbPrvS:nNumAlb ) + ::oAlbPrvS:cSufAlb, ::oAlbPrvT, "cCodPrv" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oAlbPrvS:cSerAlb + Str( ::oAlbPrvS:nNumAlb ) + ::oAlbPrvS:cSufAlb, ::oAlbPrvT, "cNomPrv" )
      ::oDbfTmp:Save()

      if ::oAlbPrvS:lUndNeg
         ::nSayCompras--
      else
         ::nSayCompras++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacPrv()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oFacPrvS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oFacPrvS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oFacPrvS:dFecFac >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodPrv ) .or. ( Rtrim( ::cCodPrv ) == Rtrim( oRetFld( ::oFacPrvS:cSerFac + Str( ::oFacPrvS:nNumFac ) + ::oFacPrvS:cSufFac, ::oFacPrvT, "cCodPrv" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Factura de proveedor"
      ::oDbfTmp:cNumDoc := ::oFacPrvS:cSerFac + "/" + Ltrim( Str( ::oFacPrvS:nNumFac ) ) + "/" + ::oFacPrvS:cSufFac
      ::oDbfTmp:cDoc    := ::oFacPrvS:cSerFac + Str( ::oFacPrvS:nNumFac ) + ::oFacPrvS:cSufFac
      ::oDbfTmp:cCodArt := ::oFacPrvS:cRef
      ::oDbfTmp:nNumLin := ::oFacPrvS:nNumLin
      ::oDbfTmp:cCodAlm := ::oFacPrvS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oFacPrvS:cSerFac + Str( ::oFacPrvS:nNumFac ) + ::oFacPrvS:cSufFac, ::oFacPrvT, "dFecFac" )
      ::oDbfTmp:cCodCli := oRetFld( ::oFacPrvS:cSerFac + Str( ::oFacPrvS:nNumFac ) + ::oFacPrvS:cSufFac, ::oFacPrvT, "cCodPrv" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oFacPrvS:cSerFac + Str( ::oFacPrvS:nNumFac ) + ::oFacPrvS:cSufFac, ::oFacPrvT, "cNomPrv" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oFacPrvS:lUndNeg
         ::nSayCompras--
      else
         ::nSayCompras++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddRctPrv()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oRctPrvS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oRctPrvS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oRctPrvS:dFecFac >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodPrv ) .or. ( Rtrim( ::cCodPrv ) == Rtrim( oRetFld( ::oRctPrvS:cSerFac + Str( ::oRctPrvS:nNumFac ) + ::oRctPrvS:cSufFac, ::oRctPrvT, "cCodPrv" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Factura rectificativa de proveedor"
      ::oDbfTmp:cNumDoc := ::oRctPrvS:cSerFac + "/" + Ltrim( Str( ::oRctPrvS:nNumFac ) ) + "/" + ::oRctPrvS:cSufFac
      ::oDbfTmp:cDoc    := ::oRctPrvS:cSerFac + Str( ::oRctPrvS:nNumFac ) + ::oRctPrvS:cSufFac
      ::oDbfTmp:cCodArt := ::oRctPrvS:cRef
      ::oDbfTmp:nNumLin := ::oRctPrvS:nNumLin
      ::oDbfTmp:cCodAlm := ::oRctPrvS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oRctPrvS:cSerFac + Str( ::oRctPrvS:nNumFac ) + ::oRctPrvS:cSufFac, ::oRctPrvT, "dFecFac" )
      ::oDbfTmp:cCodCli := oRetFld( ::oRctPrvS:cSerFac + Str( ::oRctPrvS:nNumFac ) + ::oRctPrvS:cSufFac, ::oRctPrvT, "cCodPrv" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oRctPrvS:cSerFac + Str( ::oRctPrvS:nNumFac ) + ::oRctPrvS:cSufFac, ::oRctPrvT, "cNomPrv" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oRctPrvS:lUndNeg
         ::nSayCompras--
      else
         ::nSayCompras++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddAlbCli()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oAlbCliS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oAlbCliS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oAlbCliS:dFecAlb >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodCli ) .or. ( Rtrim( ::cCodCli ) == Rtrim( oRetFld( ::oAlbCliS:cSerAlb + Str( ::oAlbCliS:nNumAlb ) + ::oAlbCliS:cSufAlb, ::oAlbCliT, "cCodCli" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Albarán de cliente"
      ::oDbfTmp:cNumDoc := ::oAlbCliS:cSerAlb + "/" + Ltrim( Str( ::oAlbCliS:nNumAlb ) ) + "/" + ::oAlbCliS:cSufAlb
      ::oDbfTmp:cDoc    := ::oAlbCliS:cSerAlb + Str( ::oAlbCliS:nNumAlb ) + ::oAlbCliS:cSufAlb
      ::oDbfTmp:cCodArt := ::oAlbCliS:cRef
      ::oDbfTmp:nNumLin := ::oAlbCliS:nNumLin
      ::oDbfTmp:cCodAlm := ::oAlbCliS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oAlbCliS:cSerAlb + Str( ::oAlbCliS:nNumAlb ) + ::oAlbCliS:cSufAlb, ::oAlbCliT, "dFecAlb" )
      ::oDbfTmp:cCodCli := oRetFld( ::oAlbCliS:cSerAlb + Str( ::oAlbCliS:nNumAlb ) + ::oAlbCliS:cSufAlb, ::oAlbCliT, "cCodCli" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oAlbCliS:cSerAlb + Str( ::oAlbCliS:nNumAlb ) + ::oAlbCliS:cSufAlb, ::oAlbCliT, "cNomCli" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oAlbCliS:lUndNeg
         ::nSayVentas--
      else
         ::nSayVentas++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddSatCli()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oSatCliS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oSatCliS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oSatCliS:dFecSat >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodCli ) .or. ( Rtrim( ::cCodCli ) == Rtrim( oRetFld( ::oSatCliS:cSerSat + Str( ::oSatCliS:nNumSat ) + ::oSatCliS:cSufSat, ::oSatCliT, "cCodCli" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "S.A.T. de cliente"
      ::oDbfTmp:cNumDoc := ::oSatCliS:cSerSat + "/" + Ltrim( Str( ::oSatCliS:nNumSat ) ) + "/" + ::oSatCliS:cSufSat
      ::oDbfTmp:cDoc    := ::oSatCliS:cSerSat + Str( ::oSatCliS:nNumSat ) + ::oSatCliS:cSufSat
      ::oDbfTmp:cCodArt := ::oSatCliS:cRef
      ::oDbfTmp:nNumLin := ::oSatCliS:nNumLin
      ::oDbfTmp:cCodAlm := ::oSatCliS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oSatCliS:cSerSat + Str( ::oSatCliS:nNumSat ) + ::oSatCliS:cSufSat, ::oSatCliT, "dFecSat" )
      ::oDbfTmp:cCodCli := oRetFld( ::oSatCliS:cSerSat + Str( ::oSatCliS:nNumSat ) + ::oSatCliS:cSufSat, ::oSatCliT, "cCodCli" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oSatCliS:cSerSat + Str( ::oSatCliS:nNumSat ) + ::oSatCliS:cSufSat, ::oSatCliT, "cNomCli" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oSatCliS:lUndNeg
         ::nSayVentas--
      else
         ::nSayVentas++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacCli()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oFacCliS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oFacCliS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oFacCliS:dFecFac >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodCli ) .or. ( Rtrim( ::cCodCli ) == Rtrim( oRetFld( ::oFacCliS:cSerFac + Str( ::oFacCliS:nNumFac ) + ::oFacCliS:cSufFac, ::oFacCliT, "cCodCli" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Factura de cliente"
      ::oDbfTmp:cNumDoc := ::oFacCliS:cSerFac + "/" + Ltrim( Str( ::oFacCliS:nNumFac ) ) + "/" + ::oFacCliS:cSufFac
      ::oDbfTmp:cDoc    := ::oFacCliS:cSerFac + Str( ::oFacCliS:nNumFac ) + ::oFacCliS:cSufFac
      ::oDbfTmp:cCodArt := ::oFacCliS:cRef
      ::oDbfTmp:nNumLin := ::oFacCliS:nNumLin
      ::oDbfTmp:cCodAlm := ::oFacCliS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oFacCliS:cSerFac + Str( ::oFacCliS:nNumFac ) + ::oFacCliS:cSufFac, ::oFacCliT, "dFecFac" )
      ::oDbfTmp:cCodCli := oRetFld( ::oFacCliS:cSerFac + Str( ::oFacCliS:nNumFac ) + ::oFacCliS:cSufFac, ::oFacCliT, "cCodCli" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oFacCliS:cSerFac + Str( ::oFacCliS:nNumFac ) + ::oFacCliS:cSufFac, ::oFacCliT, "cNomCli" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oFacPrvS:lUndNeg
         ::nSayVentas--
      else
         ::nSayVentas++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacRec()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oFacRecS:cRef ) ) )      .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oFacRecS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oFacRecS:dFecFac >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodCli ) .or. ( Rtrim( ::cCodCli ) == Rtrim( oRetFld( ::oFacRecS:cSerFac + Str( ::oFacRecS:nNumFac ) + ::oFacRecS:cSufFac, ::oFacRecT, "cCodCli" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Factura rectificativa de cliente"
      ::oDbfTmp:cNumDoc := ::oFacRecS:cSerFac + "/" + Ltrim( Str( ::oFacRecS:nNumFac ) ) + "/" + ::oFacRecS:cSufFac
      ::oDbfTmp:cDoc    := ::oFacRecS:cSerFac + Str( ::oFacRecS:nNumFac ) + ::oFacRecS:cSufFac
      ::oDbfTmp:cCodArt := ::oFacRecS:cRef
      ::oDbfTmp:nNumLin := ::oFacRecS:nNumLin
      ::oDbfTmp:cCodAlm := ::oFacRecS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oFacRecS:cSerFac + Str( ::oFacRecS:nNumFac ) + ::oFacRecS:cSufFac, ::oFacRecT, "dFecFac" )
      ::oDbfTmp:cCodCli := oRetFld( ::oFacRecS:cSerFac + Str( ::oFacRecS:nNumFac ) + ::oFacRecS:cSufFac, ::oFacRecT, "cCodCli" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oFacRecS:cSerFac + Str( ::oFacRecS:nNumFac ) + ::oFacRecS:cSufFac, ::oFacRecT, "cNomCli" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oFacRecS:lUndNeg
         ::nSayVentas--
      else
         ::nSayVentas++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddTikCli()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oTikCliS:cCbaTil ) ) )   .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oTikCliS:cAlmLin ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oTikCliS:dFecTik >= ::dConsolidacion ) )       .and.;
      ( Empty( ::cCodCli ) .or. ( Rtrim( ::cCodCli ) == Rtrim( oRetFld( ::oTikCliS:cSerTik + ::oTikCliS:cNumTik + ::oTikCliS:cSufTik, ::oTikCliT, "cCliTik" ) ) ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Tiket de cliente"
      ::oDbfTmp:cNumDoc := ::oTikCliS:cSerTik + "/" + Ltrim( ::oTikCliS:cNumTik ) + "/" + ::oTikCliS:cSufTik
      ::oDbfTmp:cDoc    := ::oTikCliS:cSerTik + ::oTikCliS:cNumTik + ::oTikCliS:cSufTik
      ::oDbfTmp:cCodArt := ::oTikCliS:cCbaTil
      ::oDbfTmp:nNumLin := ::oTikCliS:nNumLin
      ::oDbfTmp:cCodAlm := ::oTikCliS:cAlmLin
      ::oDbfTmp:dFecDoc := oRetFld( ::oTikCliS:cSerTik + ::oTikCliS:cNumTik + ::oTikCliS:cSufTik, ::oTikCliT, "dFecTik" )
      ::oDbfTmp:cCodCli := oRetFld( ::oTikCliS:cSerTik + ::oTikCliS:cNumTik + ::oTikCliS:cSufTik, ::oTikCliT, "cCodCli" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oTikCliS:cSerTik + ::oTikCliS:cNumTik + ::oTikCliS:cSufTik, ::oTikCliT, "cNomCli" )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oTikCliS:lUndNeg
         ::nSayVentas--
      else
         ::nSayVentas++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddProSer()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oProSerS:cCodArt ) ) )   .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oProSerS:cAlmOrd ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oProSerS:dFecOrd >= ::dConsolidacion ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Materiales producidos"
      ::oDbfTmp:cNumDoc := ::oProSerS:cSerOrd + "/" + Ltrim( Str( ::oProSerS:nNumOrd ) ) + "/" + ::oProSerS:cSufOrd
      ::oDbfTmp:cDoc    := ::oProSerS:cSerOrd + Str( ::oProSerS:nNumOrd ) + ::oProSerS:cSufOrd
      ::oDbfTmp:cCodArt := ::oProSerS:cCodArt
      ::oDbfTmp:nNumLin := ::oProSerS:nNumLin
      ::oDbfTmp:cCodAlm := ::oProSerS:cAlmOrd
      ::oDbfTmp:dFecDoc := oRetFld( ::oProSerS:cSerOrd + Str( ::oProSerS:nNumOrd ) + ::oProSerS:cSufOrd, ::oProCabT, "dFecOrd" )
      ::oDbfTmp:cCodCli := oRetFld( ::oProSerS:cSerOrd + Str( ::oProSerS:nNumOrd ) + ::oProSerS:cSufOrd, ::oProCabT, "cCodOpe" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oDbfTmp:cCodCli, ::oOperacion )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oProSerS:lUndNeg
         ::nSayProduccion--
      else
         ::nSayProduccion++
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddMatSer()

   if ( Empty( ::cCodArt ) .or. ( Rtrim( ::cCodArt ) == Rtrim( ::oMatSerS:cCodArt ) ) )   .and.;
      ( Empty( ::cCodAlm ) .or. ( Rtrim( ::cCodAlm ) == Rtrim( ::oMatSerS:cAlmOrd ) ) )   .and.;
      ( Empty( ::dConsolidacion ) .or. ( ::oMatSerS:dFecOrd >= ::dConsolidacion ) )

      ::oDbfTmp:Append()
      ::oDbfTmp:cTipDoc := "Materiales consumidos"
      ::oDbfTmp:cNumDoc := ::oMatSerS:cSerOrd + "/" + Ltrim( Str( ::oMatSerS:nNumOrd ) ) + "/" + ::oMatSerS:cSufOrd
      ::oDbfTmp:cDoc    := ::oMatSerS:cSerOrd + Str( ::oMatSerS:nNumOrd ) + ::oMatSerS:cSufOrd
      ::oDbfTmp:cCodArt := ::oMatSerS:cCodArt
      ::oDbfTmp:nNumLin := ::oMatSerS:nNumLin
      ::oDbfTmp:cCodAlm := ::oMatSerS:cAlmOrd
      ::oDbfTmp:dFecDoc := oRetFld( ::oMatSerS:cSerOrd + Str( ::oMatSerS:nNumOrd ) + ::oMatSerS:cSufOrd, ::oProCabT, "dFecOrd" )
      ::oDbfTmp:cCodCli := oRetFld( ::oMatSerS:cSerOrd + Str( ::oMatSerS:nNumOrd ) + ::oMatSerS:cSufOrd, ::oProCabT, "cCodOpe" )
      ::oDbfTmp:cCliPrv := oRetFld( ::oDbfTmp:cCodCli, ::oOperacion )
      ::oDbfTmp:cCodObr := ""
      ::oDbfTmp:Save()

      if ::oMatSerS:lUndNeg
         ::nSayProduccion++
      else
         ::nSayProduccion--
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Zoom()

    do case
      case AllTrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"
         ZooPedPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"
         ZooAlbPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"
         ZooFacPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de proveedor"
         ZooRctPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         ZooPedCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         ZooAlbCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         ZooFacCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         ZooFacRec( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Tiket de cliente"
         ZooTikCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "S.A.T. de cliente"
         ZooSatCli( ::oDbfTmp:cDoc )

   endcase

return( Self )

//---------------------------------------------------------------------------//

METHOD Visualizar()

   do case
      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"
         VisPedPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"
         VisAlbPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"
         VisFacPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de proveedor"
         VisRctPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         VisPedCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         VisAlbCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         VisFacCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Tiket de cliente"
         VisTikCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         VisFacRec( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "S.A.T. de cliente"
         VisSatCli( ::oDbfTmp:cDoc )

   endcase

return( nil )

//---------------------------------------------------------------------------//

METHOD Imprimir()

   do case
      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"
         PrnPedPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"
         PrnAlbPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"
         PrnFacPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de proveedor"
         PrnRctPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         PrnPedCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         PrnAlbCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         PrnFacCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Tiket de cliente"
         PrnTikCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         PrnFacRec( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "S.A.T. de cliente"
         PrnSatCli( ::oDbfTmp:cDoc )

   endcase

return( nil )

//---------------------------------------------------------------------------//

Method nTreeImagen()

   do case
      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"
         Return ( 1 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"
         Return ( 2 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"
         Return ( 3 )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de proveedor"
         Return ( 4 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         Return ( 5 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         Return ( 6 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         Return ( 7 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         Return ( 8 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Tiket de cliente"
         Return ( 9 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Materiales producidos" .or. Alltrim( ::oDbfTmp:cTipDoc ) == "Materiales consumidos"
         Return ( 10 )

      case aScan( ::aMovimiento, Alltrim( ::oDbfTmp:cTipDoc ) ) != 0
         Return ( 11 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "S.A.T. de cliente"
         Return ( 12 )

   end case

Return ( 1 )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TNumerosSerie

   DATA  oDlg

   DATA  cCodArt
   DATA  cCodAlm
   DATA  nNumLin

   DATA  oBrwSer
   DATA  aNumSer
   DATA  aValSer
   DATA  cPreFix              INIT Space( 18 )
   DATA  oSerIni
   DATA  nSerIni              INIT 0
   DATA  oSerFin
   DATA  nSerFin              INIT 0
   DATA  oNumGen
   DATA  nNumGen              INIT 0

   DATA  uTmpSer

   DATA  aTmp
   DATA  nMode

   DATA  oStock

   DATA  nTotalUnidades

   DATA  lAutoSerializacion   INIT .f.

   DATA  lCompras             INIT .f.
   DATA  lTicket              INIT .f.

   DATA  lAvisar              INIT .f.

   METHOD Resource()

   METHOD GenerarSeries()

   METHOD lChequearSeries()

   METHOD lValidarSeries()

   METHOD SalvarSeries()

   METHOD lChequearSalvarSeries()      INLINE ( if( ::lChequearSeries(), ::SalvarSeries(), ) )

   METHOD EliminarSeries()

   METHOD lStockSeries()               INLINE ( !::lUnidadesNegativas() .and. !::lCompras )

   METHOD InfoSeries()

   METHOD AutoSerializa()

   METHOD lUnidadesNegativas()         INLINE   ( ::nTotalUnidades < 0 )

   METHOD nAbsUnidades()               INLINE   ( Abs( ::nTotalUnidades ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TNumerosSerie

   local n
   local oBmpNumSer

   if ::nAbsUnidades() == 0
      MsgStop( "No hay unidades para asignar números de serie." )
      Return ( Self )
   end if

   n                       := 1
   ::aNumSer               := Afill( Array( ::nAbsUnidades() ), Space( 30 ) )
   ::aValSer               := Afill( Array( ::nAbsUnidades() ), .f. )

   if !Empty( ::oStock )
      ::lAvisar            := ::oStock:lAvisarSerieSinStock( ::cCodArt )
   end if 
   
   do case
   case IsChar( ::uTmpSer )

      if ::lTicket

         if ( ::uTmpSer )->( dbSeek( Str( ::nNumLin, 4 ) + ::cCodArt ) )
            while ( Str( ( ::uTmpSer )->nNumLin, 4 ) + ( ::uTmpSer )->cCbaTil == Str( ::nNumLin, 4 ) + ::cCodArt ) .and. !( ::uTmpSer )->( Eof() )
               if ( n <= ::nAbsUnidades() )
                  ::aNumSer[ n ] := ( ::uTmpSer )->cNumSer
               end if
               ( ::uTmpSer )->( dbSkip() )
               n++
            end while
         end if

      else

         if ( ::uTmpSer )->( dbSeek( Str( ::nNumLin, 4 ) + ::cCodArt ) )
            while ( Str( ( ::uTmpSer )->nNumLin, 4 ) + ( ::uTmpSer )->cRef == Str( ::nNumLin, 4 ) + ::cCodArt ) .and. !( ::uTmpSer )->( Eof() )
               if ( n <= ::nAbsUnidades() )
                  ::aNumSer[ n ] := ( ::uTmpSer )->cNumSer
               end if
               ( ::uTmpSer )->( dbSkip() )
               n++
            end while
         end if

      end if

   case IsObject( ::uTmpSer )

      if ::uTmpSer:Seek( Str( ::nNumLin, 4 ) + ::cCodArt )

         while ( Str( ::uTmpSer:nNumLin, 4 ) + ::uTmpSer:cCodArt == Str( ::nNumLin, 4 ) + ::cCodArt ) .and. ! ::uTmpSer:Eof()

            if ( n <= ::nAbsUnidades() )
               ::aNumSer[ n ] := ::uTmpSer:cNumSer
            end if
            ::uTmpSer:Skip()
            n++
         end while
      end if

   end case

   DEFINE DIALOG ::oDlg RESOURCE "VtaNumSer"

      REDEFINE BITMAP oBmpNumSer ;
         ID       800 ;
         RESOURCE "gc_odometer_48" ;
         TRANSPARENT ;
         OF       ::oDlg

      REDEFINE GET ::nTotalUnidades ;
         ID       100 ;
         PICTURE  MasUnd() ;
         WHEN     .f. ;
         OF       ::oDlg

      REDEFINE GET ::cPreFix ;
         ID       110 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oDlg

      REDEFINE GET ::oSerIni VAR ::nSerIni ;
         ID       120 ;
         PICTURE  "99999999999999999999" ;
         SPINNER ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         VALID    ( ::oSerFin:cText( ::nSerIni + ::nAbsUnidades() ), .t. ) ;
         OF       ::oDlg

      REDEFINE GET ::oSerFin VAR ::nSerFin ;
         ID       130 ;
         PICTURE  "99999999999999999999" ;
         WHEN     .f. ;
         OF       ::oDlg

      REDEFINE GET ::oNumGen VAR ::nNumGen ;
         ID       140 ;
         SPINNER ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         PICTURE  "99999999999999999999" ;
         OF       ::oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::GenerarSeries() )

      ::oBrwSer                  := IXBrowse():New( ::oDlg )

      ::oBrwSer:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwSer:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwSer:lHScroll         := .f.
      ::oBrwSer:lRecordSelector  := .t.
      ::oBrwSer:lFastEdit        := .t.

      ::oBrwSer:nMarqueeStyle    := MARQSTYLE_HIGHLCELL

      ::oBrwSer:SetArray( ::aNumSer, , , .f. )

      ::oBrwSer:nColSel          := 2

      with object ( ::oBrwSer:addCol() )
         :cHeader             := "N."
         :bStrData            := {|| Trans( ::oBrwSer:nArrayAt, "999999" ) }
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwSer:addCol() )
         :cHeader             := "Serie"
         :bEditValue          := {|| ::aNumSer[ ::oBrwSer:nArrayAt ] }

         if ::lStockSeries()
            :nWidth           :=  220
            :bOnPostEdit      := {|o,x| ::aNumSer[ ::oBrwSer:nArrayAt ] := x, ::aValSer[ ::oBrwSer:nArrayAt ] := ::oStock:lValidNumeroSerie( ::cCodArt, ::cCodAlm, x ) }
         else
            :nWidth           :=  240
            :bOnPostEdit      := {|o,x| ::aNumSer[ ::oBrwSer:nArrayAt ] := x }
         end if

         if ::nMode != ZOOM_MODE
            :nEditType        := 1
         end if
      end whit

      if ::lStockSeries()

         with object ( ::oBrwSer:addCol() )
            :cHeader          := "Es."
            :nHeadBmpNo       := 4
            :bStrData         := {|| "" }
            :bBmpData         := {|| if( ::aValSer[ ::oBrwSer:nArrayAt ], 3, 1 ) }
            :nWidth           := 20
            :bLDClickData     := {|| ::InfoSeries( ::aNumSer[ ::oBrwSer:nArrayAt ], ::oStock ) }
            :AddResource( "gc_delete_12" )
            :AddResource( "gc_shape_square_12" )
            :AddResource( "gc_check_12" )
            :AddResource( "gc_document_information_16" )
         end with

      end if

      ::oBrwSer:CreateFromResource( 150 )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       ::oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::lChequearSalvarSeries() )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      ::oDlg:bStart  := {|| ::lValidarSeries() }

      ::oDlg:AddFastKey( VK_F5, {|| ::lChequearSalvarSeries() } )

   ACTIVATE DIALOG ::oDlg CENTER

   if !Empty( oBmpNumSer )
      oBmpNumSer:End()
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD GenerarSeries() CLASS TNumerosSerie

   local n
   local nChg  := 1

   CursorWait()

   ::oDlg:Disable()

   if Empty( ::nNumGen )
      aEval( ::aNumSer, {| a, n | ::aNumSer[ n ] := Padr( Rtrim( ::cPreFix ) + Ltrim( Str( ::nSerIni + n - 1 ) ), 30 ) } )
   else
      for n := 1 to len( ::aNumSer )
         if Empty( ::aNumSer[ n ] )
            ::aNumSer[ n ]    := Padr( Rtrim( ::cPreFix ) + Ltrim( Str( ::nSerIni + nChg - 1 ) ), 30 )
            nChg++
         end if
         if nChg == ::nNumGen
            exit
         end if
      next
   end if

   ::oBrwSer:Refresh()

   ::lValidarSeries()

   ::oDlg:Enable()

   CursorWE()

Return ( self )

//---------------------------------------------------------------------------//

METHOD lChequearSeries() CLASS TNumerosSerie

   local l
   local n
   local lValid            := .t.

   if !::lStockSeries()
      Return ( lValid )
   end if

   CursorWait()

   for each l in ::aValSer

      if IsFalse( l )

         lValid            := .f.
         n                 := hb_EnumIndex()
         exit

      end if

   next

   if !lValid

      if uFieldEmpresa( "lSerNoCom" )
         msgStop( "Hay números de serie sin stock para su venta." )
      else
         if ::lAvisar
            lValid         := ApoloMsgNoYes( "Hay números de serie sin stock para su venta.", "¿Desea continuar con la venta?" )
         else
            lValid         := .t.
         end if 
      end if

      if !Empty( ::oBrwSer ) .and. IsNum( n )
         ::oBrwSer:nArrayAt  := n
         ::oBrwSer:Refresh()
      end if

   end if

   CursorWE()

Return ( lValid )

//---------------------------------------------------------------------------//

METHOD lValidarSeries() CLASS TNumerosSerie

   local n
   local lValid         := .t.

   if ::lStockSeries()

      CursorWait()

      // ::oDlg:Disable()

      for n := 1 to ::nAbsUnidades()

         if !Empty( ::aNumSer[ n ] )

            ::aValSer[ n ] := ::oStock:lValidNumeroSerie( ::cCodArt, ::cCodAlm, ::aNumSer[ n ] )

            if !::aValSer[ n ]
               lValid      := .f.
            end if

         else

            lValid         := .f.

         end if

      next

      if !Empty( ::oBrwSer )
         ::oBrwSer:Refresh()
      end if

      // ::oDlg:Enable()

      if !Empty( ::oBrwSer )
         ::oBrwSer:SetFocus()
      end if

      CursorWE()

   end if

Return ( lValid )

//---------------------------------------------------------------------------//

METHOD SalvarSeries() CLASS TNumerosSerie

   local cNumSer
   local nTotUnd              := len( ::aNumSer )

   ::oDlg:Disable()

   ::EliminarSeries()

   for each cNumSer in ::aNumSer

      do case
      case IsChar( ::uTmpSer )

         ( ::uTmpSer )->( dbAppend() )
         if ::lTicket
         ( ::uTmpSer )->cCbaTil  := ::cCodArt
         else
         ( ::uTmpSer )->cRef     := ::cCodArt
         end if
         ( ::uTmpSer )->cAlmLin  := ::cCodAlm
         ( ::uTmpSer )->nNumLin  := ::nNumLin
         ( ::uTmpSer )->cNumSer  := cNumSer
         ( ::uTmpSer )->lUndNeg  := ::lUnidadesNegativas()

      case IsObject( ::uTmpSer )

         ::uTmpSer:Append()
         ::uTmpSer:cCodArt       := ::cCodArt
         ::uTmpSer:cAlmOrd       := ::cCodAlm
         ::uTmpSer:nNumLin       := ::nNumLin
         ::uTmpSer:cNumSer       := cNumSer
         ::uTmpSer:lUndNeg       := ::lUnidadesNegativas()
         ::uTmpSer:Save()

      end case

   next

   ::oDlg:Enable()
   ::oDlg:End()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD EliminarSeries() CLASS TNumerosSerie

   do case
   case IsChar( ::uTmpSer )

      while ( ( ::uTmpSer )->( dbSeek( Str( ::nNumLin, 4 ) + ::cCodArt ) ) ) .and. !( ::uTmpSer )->( Eof() )
         ( ::uTmpSer )->( dbDelete() )
      end while

   case IsObject( ::uTmpSer )

      while ( ::uTmpSer:Seek( Str( ::nNumLin, 4 ) + ::cCodArt ) ) .and. ! ::uTmpSer:Eof()
         ::uTmpSer:Delete(.f.)
      end while

   end case

Return ( nil )

//----------------------------------------------------------------------------//

METHOD InfoSeries( cNumSer, oStock ) CLASS TNumerosSerie

   if Empty( cNumSer )
      MsgStop( "Número de serie esta vacio." )
      Return ( Self )
   end if

   with object ( TSeaNumSer() )
      :lBlocked   := .t.
      :cCodArt    := ::cCodArt
      :cCodAlm    := ::cCodAlm
      :cNumSer    := cNumSer
      :oStock     := oStock
      :Activate( , , .t. )
   end with

Return ( Self )

//----------------------------------------------------------------------------//

METHOD AutoSerializa() CLASS TNumerosSerie

   local cNumSer
   local nNumSer

   if ::nAbsUnidades() == 0
      MsgStop( "No hay unidades para asignar números de serie." )
      Return ( Self )
   end if

   nNumSer                 := uFieldEmpresa( "nAutSer" )

   ::aNumSer               := Afill( Array( ::nAbsUnidades() ), Space( 30 ) )
   ::aValSer               := Afill( Array( ::nAbsUnidades() ), .f. )

   for each cNumSer in ::aNumSer

      do case
      case IsChar( ::uTmpSer )

         ( ::uTmpSer )->( dbAppend() )
         ( ::uTmpSer )->cNumSer  := Alltrim( Str( nNumSer ) )
         ( ::uTmpSer )->cRef     := ::cCodArt
         ( ::uTmpSer )->cAlmLin  := ::cCodAlm
         ( ::uTmpSer )->nNumLin  := ::nNumLin
         ( ::uTmpSer )->lUndNeg  := ::lUnidadesNegativas()

      case IsObject( ::uTmpSer )

         ::uTmpSer:Append()
         ::uTmpSer:cNumSer       := Alltrim( Str( nNumSer ) )
         ::uTmpSer:cCodArt       := ::cCodArt
         ::uTmpSer:cAlmOrd       := ::cCodAlm
         ::uTmpSer:nNumLin       := ::nNumLin
         ::uTmpSer:lUndNeg       := ::lUnidadesNegativas()
         ::uTmpSer:Save()

      end case

      ++nNumSer

   next

   SetFieldEmpresa( nNumSer, "nAutSer" )

Return ( Self )

//----------------------------------------------------------------------------//