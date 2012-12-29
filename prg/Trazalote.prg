#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TTrazarLote

   DATA oDbfIva
   DATA oDbfArt
   DATA oDbfCli
   DATA oDbfPrv
   DATA oDbfTmp
   DATA oPedPrvT
   DATA oPedPrvL
   DATA oAlbPrvT
   DATA oAlbPrvL
   DATA oFacPrvT
   DATA oFacPrvL
   DATA oAlbCliT
   DATA oAlbCliL
   DATA oFacCliT
   DATA oFacCliL
   DATA oFacRecT
   DATA oFacRecL
   DATA oPreCliT
   DATA oPreCliL
   DATA oPedCliT
   DATA oPedCliL
   DATA oTikCliT
   DATA oTikCliL
   DATA oHisMov
   DATA oProducT
   DATA oProducL
   DATA oProducM

   DATA oMetMsg
   DATA nMetMsg   AS NUMERIC  INIT 0
   DATA cLote     INIT Space( 12 )

   DATA oBrw

   DATA aBmp

   DATA cCodArt   INIT Space( 18 )
   DATA cFiltro   INIT Space( 12 )
   DATA cBuscar   INIT Space( 7 )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Activate( oMenuItem, oWnd )

   METHOD Search()

   METHOD AddPedPrv()

   METHOD AddAlbPrv()

   METHOD AddFacPrv()

   METHOD AddPreCli()

   METHOD AddPedCli()

   METHOD AddAlbCli()

   METHOD AddFacCli()

   METHOD AddFacRec()

   METHOD AddHisMov()

   METHOD Zoom()

   METHOD Filtrar()

   METHOD Visualizar()

   METHOD Imprimir()

   METHOD AddProducido()

   METHOD AddConsumido()

   Method nTreeImagen()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oDbfPrv PATH ( cPatPrv() ) FILE "PROVEE.DBF" VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

      DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PedProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "PedProvT.Cdx"

      DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PedProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "PedProvL.Cdx"
      ::oPedPrvL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "AlbProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvT.Cdx"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "AlbProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvL.Cdx"
      ::oAlbPrvL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FacPrvT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvT.Cdx"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FacPrvL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvL.Cdx"
      ::oFacPrvL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oPreCliT PATH ( cPatEmp() ) FILE "PreCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "PreCliT.Cdx"

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PreCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "PreCliL.Cdx"
      ::oPreCliL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oPedCliT PATH ( cPatEmp() ) FILE "PedCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliT.Cdx"

      DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PedCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliL.Cdx"
      ::oPedCliL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oAlbCliT PATH ( cPatEmp() ) FILE "AlbCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliT.Cdx"

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliL.Cdx"
      ::oAlbCliL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oFacCliT PATH ( cPatEmp() ) FILE "FacCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliT.Cdx"

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FacCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliL.Cdx"
      ::oFacCliL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FacRecT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecT.Cdx"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FacRecL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecL.Cdx"
      ::oFacRecL:OrdSetFocus( "Lote" )

      DATABASE NEW ::oHisMov PATH ( cPatEmp() )  FILE "HISMOV.DBF" VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"
      ::oHisMov:OrdSetFocus( "cLote" )

      DATABASE NEW ::oProducT PATH ( cPatEmp() ) FILE "PROCAB.DBF" VIA ( cDriver() ) SHARED INDEX "PROCAB.CDX"

      DATABASE NEW ::oProducL PATH ( cPatEmp() ) FILE "PROLIN.DBF" VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"
      ::oProducL:OrdSetFocus( "cLote" )

      DATABASE NEW ::oProducM PATH ( cPatEmp() ) FILE "PROMAT.DBF" VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"
      ::oProducM:OrdSetFocus( "cLote" )

      ::oDbfTmp         := DbfServer( "TrazarLote", SubStr( Str( Seconds() ), -6 ) ):New( "TrazarLote", "TrazarLote", cLocalDriver(), , cPatTmp() )

      ::oDbfTmp:AddField( "cTipDoc",  "C", 40, 0 )
      ::oDbfTmp:AddField( "cNumDoc",  "C", 12, 0 )
      ::oDbfTmp:AddField( "cDoc",     "C", 12, 0 )
      ::oDbfTmp:AddField( "cCodArt",  "C", 18, 0 )
      ::oDbfTmp:AddField( "cNomArt",  "C",100, 0 )
      ::oDbfTmp:AddField( "nUnidades","N", 16, 6 )
      ::oDbfTmp:AddField( "dFecDoc",  "D",  8, 0 )
      ::oDbfTmp:AddField( "cCodCli",  "C", 12, 0 )
      ::oDbfTmp:AddField( "cCliPrv",  "C", 50, 0 )
      ::oDbfTmp:AddField( "cCodObr",  "C", 10, 0 )

      ::oDbfTmp:Create()
      ::oDbfTmp:Activate( .f., .f. )

      ::oDbfTmp:AddTmpIndex( "dFecDoc", "TrazarLote.Cdx", "Dtos( dFecDoc )" )
      ::oDbfTmp:AddTmpIndex( "cTipDoc", "TrazarLote.Cdx", "cTipDoc + Dtos( dFecDoc )" )
      ::oDbfTmp:AddTmpIndex( "cCodArt", "TrazarLote.Cdx", "cCodArt + Dtos( dFecDoc )" )
      ::oDbfTmp:AddTmpIndex( "cNomArt", "TrazarLote.Cdx", "cNomArt + Dtos( dFecDoc )" )
      ::oDbfTmp:AddTmpIndex( "cCliPrv", "TrazarLote.Cdx", "cCliPrv + Dtos( dFecDoc )" )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de trazabilidad" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if !Empty( ::oPedPrvT ) .and.::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if

   if !Empty( ::oPedPrvL ) .and.::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if !Empty( ::oAlbPrvT ) .and.::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and.::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT ) .and.::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and.::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oPreCliT ) .and.::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and.::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oPedCliT ) .and.::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and.::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oAlbCliT ) .and.::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and.::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFacCliT ) .and.::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and.::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacRecT ) .and.::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if !Empty( ::oFacRecL ) .and.::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oHisMov )  .and.::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oProducT ) .and.::oProducT:Used()
      ::oProducT:End()
   end if

   if !Empty( ::oProducL ) .and.::oProducL:Used()
      ::oProducL:End()
   end if

   if !Empty( ::oProducM ) .and.::oProducM:Used()
      ::oProducM:End()
   end if

   if !Empty( ::oDbfTmp )  .and.::oDbfTmp:Used()
      ::oDbfTmp:End()
   end if

   fErase( cPatTmp() + "TrazarLote.Dbf" )
   fErase( cPatTmp() + "TrazarLote.Cdx" )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( oMenuItem, oWnd )

   local oDlg
   local oBmp
   local oLote
   local nLevel
   local oBlock
   local oError
   local oCodArt
   local oSayArt
   local cSayArt
   local oFiltro
   local aFiltro
   local oBuscar
   local aBuscar
   local oBotonImprimir
   local oBotonVer
   local oBotonZoom
   local oBotonInforme
   local oBtnCancel
   local oBtnBuscar

   DEFAULT  oMenuItem   := "01022"
   DEFAULT  oWnd        := oWnd()

   // Nivel de usuario---------------------------------------------------------

   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   // Inicializa variables-----------------------------------------------------

   cSayArt              := ""
   aBuscar              := {  "Compras", "Almacén", "Ventas", "Producción", "Todos" }
   aFiltro              := {  "Todos",;
                              Space( 3 ) + "Compras",;
                              Space( 6 ) + "Pedidos a proveedores",;
                              Space( 6 ) + "Albaranes de proveedores",;
                              Space( 6 ) + "Facturas de proveedores",;
                              Space( 3 ) + "Ventas",;
                              Space( 6 ) + "Presupuestos de clientes",;
                              Space( 6 ) + "Pedidos de clientes",;
                              Space( 6 ) + "Albaranes de clientes",;
                              Space( 6 ) + "Facturas de clientes",;
                              Space( 6 ) + "Facturas rectificativas de clientes",;
                              Space( 3 ) + "Movimiento de almacén",;
                              Space( 3 ) + "Partes de producción",;
                              Space( 6 ) + "Material producido",;
                              Space( 6 ) + "Material consumido" }

   ::cFiltro            := "Todos"
   ::cBuscar            := "Todos"
   ::aBmp               := {  "Clipboard_empty_businessman_16",;
                              "Document_plain_businessman_16",;
                              "Document_businessman_16",;
                              "Notebook_user1_16",;
                              "Clipboard_empty_user1_16",;
                              "Document_plain_user1_16",;
                              "Document_user1_16",;
                              "Document_delete_16",;
                              "Package_book_red_16",;
                              "Worker2_Form_Red_16" }

   if !::OpenFiles()
      return( Self )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DEFINE DIALOG oDlg RESOURCE "TrazarLote" // OF oWnd()

   REDEFINE BITMAP oBmp;
      RESOURCE "Package_Alpha_48" ;
      ID       800 ;
      OF       oDlg

   REDEFINE GET oCodArt VAR ::cCodArt;
      ID       ( 100 ) ;
      VALID    cArticulo( oCodArt, ::oDbfArt:cAlias, oSayArt );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oCodArt, oSayArt );
      OF       oDlg

   REDEFINE GET oSayArt VAR cSayArt ;
      WHEN     .f.;
      ID       ( 110 ) ;
      OF       oDlg

   REDEFINE GET oLote VAR ::cLote;
      ID       ( 120 ) ;
      OF       oDlg

   REDEFINE COMBOBOX oFiltro VAR ::cFiltro ;
      ITEMS    aFiltro ;
      ID       130 ;
      ON CHANGE ( ::Filtrar() );
      OF       oDlg

   oFiltro:bChange   := {|| ::Filtrar() }

   REDEFINE COMBOBOX oBuscar VAR ::cBuscar ;
      ITEMS    aBuscar ;
      ID       140 ;
      OF       oDlg

   // Lisbox de resultados-----------------------------------------------------

   ::oBrw                  := TXBrowse():New( oDlg )

   ::oBrw:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrw:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrw:SetoDbf( ::oDbfTmp )

   ::oBrw:nMarqueeStyle    := 5

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Tipo de documento"
         :cSortOrder       := "cTipDoc"
         :bStrData         := {|| ::oDbfTmp:cTipDoc }
         :bBmpData         := {|| ::nTreeImagen() }
         :nWidth           := 120
         aEval( ::aBmp, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "cNumDoc"
         :bStrData         := {|| ::oDbfTmp:cNumDoc }
         :nWidth           := 70
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecDoc"
         :bStrData         := {|| Dtoc( ::oDbfTmp:dFecDoc ) }
         :nWidth           := 70
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Cliente/Proveedor"
         :cSortOrder       := "cCodCli"
         :bStrData         := {|| Rtrim( ::oDbfTmp:cCodCli ) + Space( 1 ) + Rtrim( ::oDbfTmp:cCliPrv ) }
         :nWidth           := 300
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Obra"
         :cSortOrder       := "cCodObr"
         :bStrData         := {|| ::oDbfTmp:cCodObr }
         :nWidth           := 60
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Unidades"
         :bEditValue       := {|| ::oDbfTmp:nUnidades }
         :cEditPicture     := MasUnd()
         :nWidth           := 100
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Artículo"
         :cSortOrder       := "cCodArt"
         :bStrData         := {|| ::oDbfTmp:cCodArt }
         :nWidth           := 140
      end with

      ::oBrw:bRClicked     := {| nRow, nCol, nFlags | ::oBrw:RButtonDown( nRow, nCol, nFlags ) }
      ::oBrw:bLDblClick    := {|| ::Zoom() }

      ::oBrw:CreateFromResource( 150 )

   REDEFINE METER ::oMetMsg ;
      VAR      ::nMetMsg ;
      ID       160 ;
      OF       oDlg

   REDEFINE BUTTON oBtnBuscar ;
      ID       200 ;
      OF       oDlg ;
      ACTION   ( if( ::Search( oLote, oBtnCancel, oBtnBuscar ), ( oBotonImprimir:Show(), oBotonVer:Show(), oBotonZoom:Show(), oFiltro:Show(), oBotonInforme:Enable() ), ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       210 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   REDEFINE BUTTON oBotonImprimir ;
      ID       220 ;
      OF       oDlg ;
      ACTION   ( ::Imprimir() )

   REDEFINE BUTTON oBotonVer;
      ID       240 ;
      OF       oDlg ;
      ACTION   ( ::Visualizar() )

   REDEFINE BUTTON oBotonZoom;
      ID       230 ;
      OF       oDlg ;
      ACTION   ( ::Zoom() )

   REDEFINE BUTTON oBotonInforme;
      ID       250 ;
      OF       oDlg ;
      ACTION   ( TInfTrazLot():New( "Informe detallado de trazas de un lotes", , , , , , { ::oDbfTmp, ::cLote } ):Play() )

   oDlg:AddFastKey( VK_F5, {|| if( ::Search( oLote, oBtnCancel, oBtnBuscar ), ( oBotonImprimir:Show(), oBotonVer:Show(), oBotonZoom:Show(), oFiltro:Show(), oBotonInforme:Enable() ), ) } )

   oDlg:bStart := {|| oCodArt:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBotonImprimir:Hide(), oBotonVer:Hide(), oBotonZoom:Hide(), oFiltro:Hide(), oBotonInforme:Disable() )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir dialogo" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::CloseFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Search( oLote, oBtnCancel, oBtnBuscar )

   if Empty( ::cLote )
      MsgStop( "Debe introducir un número de lote." )
      oLote:SetFocus()
      Return ( .f. )
   end if

   oBtnCancel:Disable()
   oBtnBuscar:Disable()

   CursorWait()

   ::oDbfTmp:Zap()

   if ::cBuscar == "Compras" .or. ::cBuscar == "Todos"

      // Pedidos de proveedor-----------------------------------------------------

      ::oMetMsg:SetTotal( ::oPedPrvL:LastRec() )

      ::oMetMsg:cText   := "Pedidos proveedor"

#ifdef __SQLLIB__
      if ::oPedPrvL:SqlSetFilter( 'cLote = ' + sr_cdbValue( ::cLote ) )
#else
      if ::oPedPrvL:Seek( ::cLote )
#endif

         while ::cLote == ::oPedPrvL:cLote .and. !::oPedPrvL:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oPedPrvL:cRef )
               ::AddPedPrv()
            end if

            ::oPedPrvL:Skip()

            ::oMetMsg:Set( ::oPedPrvL:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oPedPrvL:LastRec() )

      // Albaranes de proveedor---------------------------------------------------

      ::oMetMsg:SetTotal( ::oAlbPrvL:LastRec() )

      ::oMetMsg:cText   := "Albaranes proveedor"

      if ::oAlbPrvL:Seek( ::cLote )
         while ::cLote == ::oAlbPrvL:cLote .and. !::oAlbPrvL:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oAlbPrvL:cRef )
               ::AddAlbPrv()
            end if

            ::oAlbPrvL:Skip()

            ::oMetMsg:Set( ::oAlbPrvL:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oAlbPrvL:LastRec() )

      // Facturas de proveedor----------------------------------------------------

      ::oMetMsg:SetTotal( ::oFacPrvL:LastRec() )

      ::oMetMsg:cText   := "Facturas proveedor"

      if ::oFacPrvL:Seek( ::cLote )
         while ::cLote == ::oFacPrvL:cLote .and. !::oFacPrvL:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oFacPrvL:cRef )
               ::AddFacPrv()
            end if

            ::oFacPrvL:Skip()

            ::oMetMsg:Set( ::oFacPrvL:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oFacPrvL:LastRec() )

   end if

   if ::cBuscar == "Ventas" .or. ::cBuscar == "Todos"

   // Presupuestos de clientes-------------------------------------------------

   ::oMetMsg:SetTotal( ::oPreCliL:LastRec() )

   ::oMetMsg:cText   := "Presupuestos clientes"

   if ::oPreCliL:Seek( ::cLote )

      while ::cLote == ::oPreCliL:cLote .and. !::oPreCliL:Eof()

         if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oPreCliL:cRef )
            ::AddPreCli()
         end if

         ::oPreCliL:Skip()

         ::oMetMsg:Set( ::oPreCliL:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oPreCliL:LastRec() )

   // Pedidos de clientes------------------------------------------------------

   ::oMetMsg:SetTotal( ::oPedCliL:LastRec() )

   ::oMetMsg:cText   := "Pedidos clientes"

   if ::oPedCliL:Seek( ::cLote )

      while ::cLote == ::oPedCliL:cLote .and. !::oPedCliL:Eof()

         if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oPedCliL:cRef )
            ::AddPedCli()
         end if

         ::oPedCliL:Skip()

         ::oMetMsg:Set( ::oPedCliL:OrdKeyNo() )

      end while

   end if

   ::oMetMsg:Set( ::oPedCliL:LastRec() )

   // Albaranes de clientes----------------------------------------------------

   ::oMetMsg:SetTotal( ::oAlbCliL:LastRec() )

   ::oMetMsg:cText   := "Albaranes clientes"

   if ::oAlbCliL:Seek( ::cLote )

         while ::cLote == ::oAlbCliL:cLote .and. !::oAlbCliL:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oAlbCliL:cRef )
               ::AddAlbCli()
            end if

            ::oAlbCliL:Skip()

            ::oMetMsg:Set( ::oAlbCliL:OrdKeyNo() )

         end while

   end if

   ::oMetMsg:Set( ::oAlbCliL:LastRec() )

   // Facturas de clientes-----------------------------------------------------

   with object ( ::oFacCliL )

      ::oMetMsg:SetTotal( :LastRec() )

      ::oMetMsg:cText   := "Facturas clientes"

      if :Seek( ::cLote )

         while ::cLote == :cLote .and. !:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == :cRef )
               ::AddFacCli()
            end if

            :Skip()

            ::oMetMsg:Set( :OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( :LastRec() )

   end with

   // Facturas de rectificativas-----------------------------------------------

   with object ( ::oFacRecL )

      ::oMetMsg:SetTotal( :LastRec() )

      ::oMetMsg:cText   := "Facturas rectificativas clientes"

         if :Seek( ::cLote )

            while ::cLote == :cLote .and. !:Eof()

               if ( Empty( ::cCodArt ) .or. ::cCodArt == :cRef )
                  ::AddFacRec()
               end if

               :Skip()

               ::oMetMsg:Set( :OrdKeyNo() )

            end while

         end if

      ::oMetMsg:Set( :LastRec() )

   end with


   // Fin de la busquedas------------------------------------------------------

   end if

   //Buscamos por movimientos de almacen---------------------------------------

   if ::cBuscar == "Almacén" .or. ::cBuscar == "Todos"

      ::oMetMsg:SetTotal( ::oHisMov:LastRec() )

      ::oMetMsg:cText   := "Movimientos de almacén"

      if ::oHisMov:Seek( ::cLote )

         while ::oHisMov:cLote == ::cLote .and. !::oHisMov:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oHisMov:cRefMov )
               ::AddHisMov()
            end if

            ::oHisMov:Skip()

            ::oMetMsg:Set( ::oHisMov:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oHisMov:LastRec() )

   end if

   if ::cBuscar == "Producción" .or. ::cBuscar == "Todos"

      //Materiales producidos-----------------------------------------------------

      ::oMetMsg:SetTotal( ::oProducL:LastRec() )

      ::oMetMsg:cText   := "Materiales producidos"

      if ::oProducL:Seek( ::cLote )

         while ::cLote == ::oProducL:cLote .and. !::oProducL:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oProducL:cCodArt )
               ::AddProducido()
            end if

            ::oProducL:Skip()

            ::oMetMsg:Set( ::oProducL:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oProducL:LastRec() )

      //Materiales consumidos-----------------------------------------------------

      ::oMetMsg:SetTotal( ::oProducM:LastRec() )

      ::oMetMsg:cText   := "Materiales consumidos"

      if ::oProducM:Seek( ::cLote )

         while ::cLote == ::oProducM:cLote .and. !::oProducM:Eof()

            if ( Empty( ::cCodArt ) .or. ::cCodArt == ::oProducM:cCodArt )
               ::AddConsumido()
            end if

            ::oProducM:Skip()

            ::oMetMsg:Set( ::oProducM:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oProducM:LastRec() )

   end if

   ::oDbfTmp:GoTop()

   ::oBrw:Refresh( .t. )
   ::oBrw:Select()

   CursorWE()

   oBtnCancel:Enable()
   oBtnBuscar:Enable()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD AddPedPrv()

      if ::cLote == ::oPedPrvL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Pedido a proveedor"
         ::oDbfTmp:cNumDoc    := ::oPedPrvL:cSerPed + "/" + Ltrim( Str( ::oPedPrvL:nNumPed ) ) + "/" + ::oPedPrvL:cSufPed
         ::oDbfTmp:cDoc       := ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed
         ::oDbfTmp:cCodArt    := ::oPedPrvL:cRef
         ::oDbfTmp:cNomArt    := ::oPedPrvL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNPedPrv( ::oPedPrvL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT, "dFecPed" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT, "cCodPrv" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT, "cNomPrv" )
         ::oDbfTmp:cCodObr    := ""
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddAlbPrv()

      if ::cLote == ::oAlbPrvL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Albarán de proveedor"
         ::oDbfTmp:cNumDoc    := ::oAlbPrvL:cSerAlb + "/" + Ltrim( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + ::oAlbPrvL:cSufAlb
         ::oDbfTmp:cDoc       := ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb
         ::oDbfTmp:cCodArt    := ::oAlbPrvL:cRef
         ::oDbfTmp:cNomArt    := ::oAlbPrvL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNAlbPrv( ::oAlbPrvL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT, "dFecAlb" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT, "cCodPrv" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT, "cNomPrv" )
         ::oDbfTmp:cCodObr    := ""
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacPrv()

      if ::cLote == ::oFacPrvL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Factura de proveedor"
         ::oDbfTmp:cNumDoc    := ::oFacPrvL:cSerFac + "/" + Ltrim( Str( ::oFacPrvL:nNumFac ) ) + "/" + ::oFacPrvL:cSufFac
         ::oDbfTmp:cDoc       := ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac
         ::oDbfTmp:cCodArt    := ::oFacPrvL:cRef
         ::oDbfTmp:cNomArt    := ::oFacPrvL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNFacPrv( ::oFacPrvL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT, "dFecFac" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT, "cCodPrv" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT, "cNomPrv" )
         ::oDbfTmp:cCodObr    := ""
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddPreCli()

      if ::cLote == ::oPreCliL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Presupuesto de cliente"
         ::oDbfTmp:cNumDoc    := ::oPreCliL:cSerPre + "/" + Ltrim( Str( ::oPreCliL:nNumPre ) ) + "/" + ::oPreCliL:cSufPre
         ::oDbfTmp:cDoc       := ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre
         ::oDbfTmp:cCodArt    := ::oPreCliL:cRef
         ::oDbfTmp:cNomArt    := ::oPreCliL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNPreCli( ::oPreCliL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "dFecPre" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "cCodCli" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "cNomCli" )
         ::oDbfTmp:cCodObr    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "cCodObr" )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddPedCli()

      if ::cLote == ::oPedCliL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Pedido de cliente"
         ::oDbfTmp:cNumDoc    := ::oPedCliL:cSerPed + "/" + Ltrim( Str( ::oPedCliL:nNumPed ) ) + "/" + ::oPedCliL:cSufPed
         ::oDbfTmp:cDoc       := ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed
         ::oDbfTmp:cCodArt    := ::oPedCliL:cRef
         ::oDbfTmp:cNomArt    := ::oPedCliL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNPedCli( ::oPedCliL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "dFecPed" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "cCodCli" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "cNomCli" )
         ::oDbfTmp:cCodObr    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "cCodObr" )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddAlbCli()

      if ::cLote == ::oAlbCliL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Albarán de cliente"
         ::oDbfTmp:cNumDoc    := ::oAlbCliL:cSerAlb + "/" + Ltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb
         ::oDbfTmp:cDoc       := ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb
         ::oDbfTmp:cCodArt    := ::oAlbCliL:cRef
         ::oDbfTmp:cNomArt    := ::oAlbCliL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNAlbCli( ::oAlbCliL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "dFecAlb" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "cCodCli" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "cNomCli" )
         ::oDbfTmp:cCodObr    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "cCodObr" )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacCli()

      if ::cLote == ::oFacCliL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Factura de cliente"
         ::oDbfTmp:cNumDoc    := ::oFacCliL:cSerie + "/" + Ltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac
         ::oDbfTmp:cDoc       := ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac
         ::oDbfTmp:cCodArt    := ::oFacCliL:cRef
         ::oDbfTmp:cNomArt    := ::oFacCliL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNFacCli( ::oFacCliL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "dFecFac" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "cCodCli" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "cNomCli" )
         ::oDbfTmp:cCodObr    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "cCodObr" )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacRec()

      if ::cLote == ::oFacRecL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Factura rectificativa de cliente"
         ::oDbfTmp:cNumDoc    := ::oFacRecL:cSerie + "/" + Ltrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac
         ::oDbfTmp:cDoc       := ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac
         ::oDbfTmp:cCodArt    := ::oFacRecL:cRef
         ::oDbfTmp:cNomArt    := ::oFacRecL:cDetalle
         ::oDbfTmp:nUnidades  := nTotNFacRec( ::oFacRecL:cName )
         ::oDbfTmp:dFecDoc    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "dFecFac" )
         ::oDbfTmp:cCodCli    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "cCodCli" )
         ::oDbfTmp:cCliPrv    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "cNomCli" )
         ::oDbfTmp:cCodObr    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "cCodObr" )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddHisMov()

   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Movimiento de almacén"
   ::oDbfTmp:cNumDoc    := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
   ::oDbfTmp:cDoc       := Str( ::oHisMov:Recno() ) //Guardamos el recno
   ::oDbfTmp:cCodArt    := ::oHisMov:cRefMov
   ::oDbfTmp:cNomArt    := oRetFld( ::oHisMov:cRefMov, ::oDbfArt )
   ::oDbfTmp:nUnidades  := nTotNMovAlm( ::oHisMov:cAlias )
   ::oDbfTmp:dFecDoc    := ::oHisMov:dFecMov
   ::oDbfTmp:cCodCli    := Space(12)
   ::oDbfTmp:cCliPrv    := Space(50)
   ::oDbfTmp:cCodObr    := Space(10)
   ::oDbfTmp:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProducido()

      if ::cLote == ::oProducL:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Material producido"
         ::oDbfTmp:cNumDoc    := ::oProducL:cSerOrd + "/" + Ltrim( Str( ::oProducL:nNumOrd ) ) + "/" + ::oProducL:cSufOrd
         ::oDbfTmp:cDoc       := ::oProducL:cSerOrd + Str( ::oProducL:nNumOrd ) + ::oProducL:cSufOrd
         ::oDbfTmp:cCodArt    := ::oProducL:cCodArt
         ::oDbfTmp:cNomArt    := ::oProducL:cNomArt
         ::oDbfTmp:nUnidades  := NotCaja( ::oProducL:nCajOrd ) * ::oProducL:nUndOrd
         ::oDbfTmp:dFecDoc    := oRetFld( ::oProducL:cSerOrd + Str( ::oProducL:nNumOrd ) + ::oProducL:cSufOrd, ::oProducT, "dFecFin" )
         ::oDbfTmp:cCodCli    := Space( 12 )
         ::oDbfTmp:cCliPrv    := Space( 50 )
         ::oDbfTmp:cCodObr    := Space( 10 )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddConsumido()

      if ::cLote == ::oProducM:cLote

         ::oDbfTmp:Append()
         ::oDbfTmp:cTipDoc    := "Material consumido"
         ::oDbfTmp:cNumDoc    := ::oProducM:cSerOrd + "/" + Ltrim( Str( ::oProducM:nNumOrd ) ) + "/" + ::oProducM:cSufOrd
         ::oDbfTmp:cDoc       := ::oProducM:cSerOrd + Str( ::oProducM:nNumOrd ) + ::oProducM:cSufOrd
         ::oDbfTmp:cCodArt    := ::oProducM:cCodArt
         ::oDbfTmp:cNomArt    := ::oProducM:cNomArt
         ::oDbfTmp:nUnidades  := NotCaja( ::oProducM:nCajOrd ) * ::oProducM:nUndOrd
         ::oDbfTmp:dFecDoc    := oRetFld( ::oProducM:cSerOrd + Str( ::oProducM:nNumOrd ) + ::oProducM:cSufOrd, ::oProducT, "dFecFin" )
         ::oDbfTmp:cCodCli    := Space( 12 )
         ::oDbfTmp:cCliPrv    := Space( 50 )
         ::oDbfTmp:cCodObr    := Space( 10 )
         ::oDbfTmp:Save()

      end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Zoom()

    do case
      case AllTrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"
         ZooPedPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"
         ZooAlbPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"
         ZooFacPrv( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         ZooPedCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Presupuesto de cliente"
         ZooPreCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         ZooAlbCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         ZooFacCli( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         ZooFacRec( ::oDbfTmp:cDoc )

      case AllTrim( ::oDbfTmp:cTipDoc ) == "Movimiento de almacén"
         ZooMovAlm( Val( ::oDbfTmp:cDoc ) )  // El parametro es el recno

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         ZoomProduccion( ::oDbfTmp:cDoc, ::oBrw )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         ZoomProduccion( ::oDbfTmp:cDoc, ::oBrw )

   endcase

return( Self )

//---------------------------------------------------------------------------//

METHOD Filtrar()

   ::oDbfTmp:SetFilter()

   do case
      case Alltrim( ::cFiltro ) == "Todos"
         ::oDbfTmp:OrdSetFocus( "dFecDoc" )
         ::oDbfTmp:OrdClearScope()
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Compras"
         ::oDbfTmp:OrdSetFocus( "dFecDoc" )
         ::oDbfTmp:SetFilter( "'proveedor' $ cTipDoc" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Pedidos a proveedores"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Pedido a proveedor" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Albaranes de proveedores"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Albarán de proveedor" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Facturas de proveedores"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Factura de proveedor" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Ventas"
         ::oDbfTmp:OrdSetFocus( "dFecDoc" )
         ::oDbfTmp:SetFilter( "'cliente' $ cTipDoc" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Presupuestos de clientes"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Presupuesto de cliente" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Pedidos de clientes"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Pedido de cliente" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Albaranes de clientes"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Albarán de cliente" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Facturas de clientes"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Factura de cliente" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Facturas rectificativas de clientes"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Factura rectificativa de cliente" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Movimiento de almacén"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Movimiento de almacén" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Partes de producción"
         ::oDbfTmp:OrdSetFocus( "dFecDoc" )
         ::oDbfTmp:SetFilter( "'Material' $ cTipDoc" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Material producido"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Material producido" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

      case Alltrim( ::cFiltro ) == "Material consumido"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Material consumido" )
         ::oDbfTmp:GoTop()
         ::oBrw:Refresh()

   end case

return( nil )

//---------------------------------------------------------------------------//

METHOD Visualizar()

   do case

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"
         VisPedPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"
         VisAlbPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"
         VisFacPrv( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Presupuesto de cliente"
         VisPreCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         VisPedCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         VisAlbCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         VisFacCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         VisFacRec( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Movimiento de almacén"
         msgStop( "El documento no se puede visualizar","Información" )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         VisProduccion( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         VisProduccion( ::oDbfTmp:cDoc )

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

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Presupuesto de cliente"
         PrnPreCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         PrnPedCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         PrnAlbCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         PrnFacCli( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         PrnFacRec( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Movimiento de almacén"
         msgStop( "El documento no se puede imprimir","Información" )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         PrnProduccion( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         PrnProduccion( ::oDbfTmp:cDoc )

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

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Presupuesto de cliente"
         Return ( 4 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"
         Return ( 5 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"
         Return ( 6 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"
         Return ( 7 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"
         Return ( 8 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Movimiento de almacén"
         Return ( 9 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         Return ( 10 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         Return ( 10 )

   end case

Return ( 1 )

//---------------------------------------------------------------------------//