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
   DATA oProducT
   DATA oProducL
   DATA oProducM 

   DATA oMetMsg
   DATA nMetMsg         AS NUMERIC  INIT 0

   DATA oBrw

   DATA aBmp

   DATA cCodigo         INIT Space( 18 )
   DATA cLote           INIT Space( 14 )

   DATA cCodigoLote

   DATA cFileTrazaLote
   
   DATA cFiltro         INIT Space( 12 )
   DATA cBuscar         INIT Space( 7 )

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

   METHOD AddTikCli()

   METHOD Zoom()

   METHOD Filtrar()

   METHOD Visualizar()

   METHOD Imprimir()

   METHOD AddProducido()

   METHOD AddConsumido()

   Method nTreeImagen()

   METHOD InformeLote()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock      

   ::cFileTrazaLote  := "TrazarLote" + Auth():Codigo()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )   
   BEGIN SEQUENCE

      DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oDbfPrv PATH ( cPatPrv() ) FILE "PROVEE.DBF" VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

      DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PedProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "PedProvT.Cdx"

      DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PedProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "PedProvL.Cdx"
      ::oPedPrvL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "AlbProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvT.Cdx"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "AlbProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvL.Cdx"
      ::oAlbPrvL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FacPrvT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvT.Cdx"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FacPrvL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvL.Cdx"
      ::oFacPrvL:OrdSetFocus( "cRef" )

      ::oPreCliT  := TDataCenter():oPreCliT()

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PreCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "PreCliL.Cdx"
      ::oPreCliL:OrdSetFocus( "cRef" )

      ::oPedCliT := TDataCenter():oPedCliT()

      DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PedCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliL.Cdx"
      ::oPedCliL:OrdSetFocus( "cRef" )

      ::oAlbCliT := TDataCenter():oAlbCliT()

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliL.Cdx"
      ::oAlbCliL:OrdSetFocus( "cRef" )

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FacCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliL.Cdx"
      ::oFacCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FacRecT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecT.Cdx"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FacRecL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacRecL.Cdx"
      ::oFacRecL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oProducT PATH ( cPatEmp() ) FILE "ProCab.Dbf" VIA ( cDriver() ) SHARED INDEX "ProCab.Cdx"

      DATABASE NEW ::oProducL PATH ( cPatEmp() ) FILE "ProLin.Dbf" VIA ( cDriver() ) SHARED INDEX "ProLin.Cdx"
      ::oProducL:OrdSetFocus( "cCodArt" )

      DATABASE NEW ::oProducM PATH ( cPatEmp() ) FILE "PROMAT.DBF" VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"
      ::oProducM:OrdSetFocus( "cCodArt" )

      DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"
      
      DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.Dbf" VIA ( cDriver() ) SHARED INDEX "TIKEL.Cdx"
      ::oTikCliL:OrdSetFocus( "cCbaTil" )


      DEFINE TABLE ::oDbfTmp FILE ( ::cFileTrazaLote ) CLASS ( ::cFileTrazaLote ) ALIAS ( ::cFileTrazaLote ) PATH ( cPatTmp() ) VIA ( cLocalDriver() )

         FIELD NAME "cTipDoc"    TYPE "C" LEN  40 DEC 0 OF ::oDbfTmp
         FIELD NAME "cNumDoc"    TYPE "C" LEN  20 DEC 0 OF ::oDbfTmp
         FIELD NAME "cDoc"       TYPE "C" LEN  13 DEC 0 OF ::oDbfTmp
         FIELD NAME "cCodigo"    TYPE "C" LEN  18 DEC 0 OF ::oDbfTmp
         FIELD NAME "cNomArt"    TYPE "C" LEN 100 DEC 0 OF ::oDbfTmp
         FIELD NAME "nUnidades"  TYPE "N" LEN  16 DEC 6 OF ::oDbfTmp
         FIELD NAME "dFecDoc"    TYPE "D" LEN   8 DEC 0 OF ::oDbfTmp
         FIELD NAME "cCodCli"    TYPE "C" LEN  12 DEC 0 OF ::oDbfTmp
         FIELD NAME "cNomCli"    TYPE "C" LEN  50 DEC 0 OF ::oDbfTmp
         FIELD NAME "cCodObr"    TYPE "C" LEN  10 DEC 0 OF ::oDbfTmp
         FIELD NAME "cLote"      TYPE "C" LEN  14 DEC 0 OF ::oDbfTmp  
         FIELD NAME "dFecCad"    TYPE "D" LEN   8 DEC 0 OF ::oDbfTmp

         INDEX TO ( ::cFileTrazaLote ) TAG "cLote"     ON "cLote"                       NODELETED OF ::oDbfTmp
         INDEX TO ( ::cFileTrazaLote ) TAG "dFecDoc"   ON "Dtos( dFecDoc )"             NODELETED OF ::oDbfTmp
         INDEX TO ( ::cFileTrazaLote ) TAG "cTipDoc"   ON "cTipDoc + Dtos( dFecDoc )"   NODELETED OF ::oDbfTmp
         INDEX TO ( ::cFileTrazaLote ) TAG "cCodigo"   ON "cCodigo + Dtos( dFecDoc )"   NODELETED OF ::oDbfTmp
         INDEX TO ( ::cFileTrazaLote ) TAG "cNomArt"   ON "cNomArt + Dtos( dFecDoc )"   NODELETED OF ::oDbfTmp
         INDEX TO ( ::cFileTrazaLote ) TAG "cNomCli"   ON "cNomCli + Dtos( dFecDoc )"   NODELETED OF ::oDbfTmp
         INDEX TO ( ::cFileTrazaLote ) TAG "dFecCad"   ON "Dtos( dFecCad )"             NODELETED OF ::oDbfTmp

      END DATABASE ::oDbfTmp

      ::oDbfTmp:Activate( .f., .f. )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de trazabilidad" )

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

   if !Empty( ::oTikCliT ) .and.::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and.::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   dbfErase( cPatTmp() + ::cFileTrazaLote )

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

   DEFAULT  oMenuItem   := "01023"
   DEFAULT  oWnd        := oWnd()

   // Nivel de usuario---------------------------------------------------------

   nLevel               := Auth():Level( oMenuItem )

   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   // Inicializa variables-----------------------------------------------------

   cSayArt              := ""
   aBuscar              := {  "Compras", "Ventas", "Producción", "Todos" }
   aFiltro              := {  "Todos",;
                              Space( 3 ) + "Compras",;
                              Space( 6 ) + "Pedidos a proveedores",;
                              Space( 6 ) + "Albaranes de proveedores",;
                              Space( 6 ) + "Facturas de proveedores",;
                              Space( 3 ) + "Ventas",;
                              Space( 6 ) + "Presupuestos de clientes",;
                              Space( 6 ) + getConfigTraslation("Pedidos de clientes"),;
                              Space( 6 ) + "Albaranes de clientes",;
                              Space( 6 ) + "Facturas de clientes",;
                              Space( 6 ) + "Facturas rectificativas de clientes",;
                              Space( 6 ) + "Tickets de clientes",;
                              Space( 3 ) + "Partes de producción",;
                              Space( 6 ) + "Material producido",;
                              Space( 6 ) + "Material consumido" }

   ::cFiltro            := "Todos"
   ::cBuscar            := "Todos"
   ::aBmp               := {  "gc_clipboard_empty_businessman_16",;
                              "gc_document_empty_businessman_16",;
                              "gc_document_text_businessman_16",;
                              "gc_notebook_user_16",;
                              "gc_clipboard_empty_user_16",;
                              "gc_document_empty_16",;
                              "gc_document_text_businessman_16",;
                              "gc_document_text_delete2_16",;
                              "gc_document_text_pencil_16",;
                              "gc_document_text_worker_16",;
                              "gc_cash_register_user_16" }

   if !::OpenFiles()
      return( Self )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DEFINE DIALOG oDlg RESOURCE "TrazarLote" // OF oWnd()

   REDEFINE BITMAP oBmp;
      RESOURCE "gc_package_48" ;
      TRANSPARENT ;
      ID       800 ;
      OF       oDlg

   REDEFINE GET oCodArt VAR ::cCodigo;
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

   ::oBrw                  := IXBrowse():New( oDlg )

   ::oBrw:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrw:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   ::oBrw:nMarqueeStyle    := 5

   ::oBrw:CreateFromResource( 150 )

   ::oDbfTmp:SetBrowse( ::oBrw )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Lote"
         :cSortOrder       := "cLote"
         :bStrData         := {|| ::oDbfTmp:cLote }
         :nWidth           := 120
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Caducidad"
         :cSortOrder       := "dFecCad"
         :bStrData         := {|| Dtoc( ::oDbfTmp:dFecCad ) }
         :nWidth           := 70
      end with

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
         :bStrData         := {|| Rtrim( ::oDbfTmp:cCodCli ) + Space( 1 ) + Rtrim( ::oDbfTmp:cNomCli ) }
         :nWidth           := 240
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bStrData         := {|| ::oDbfTmp:cCodObr }
         :nWidth           := 60
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Unidades"
         :bEditValue       := {|| ::oDbfTmp:nUnidades }
         :cEditPicture     := MasUnd()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Artículo"
         :cSortOrder       := "cCodigo"
         :bStrData         := {|| ::oDbfTmp:cCodigo }
         :nWidth           := 120
      end with

      ::oBrw:bRClicked     := {| nRow, nCol, nFlags | ::oBrw:RButtonDown( nRow, nCol, nFlags ) }
      ::oBrw:bLDblClick    := {|| ::Zoom() }
      ::oBrw:bChange       := {|| ::oBrw:Refresh() }

 REDEFINE APOLOMETER ::oMetMsg ;
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
      ACTION   ( ::InformeLote( oDlg ) )

   oDlg:AddFastKey( VK_F5, {|| if( ::Search( oLote, oBtnCancel, oBtnBuscar ), ( oBotonImprimir:Show(), oBotonVer:Show(), oBotonZoom:Show(), oFiltro:Show(), oBotonInforme:Enable() ), ) } )

   oDlg:bStart := {|| oCodArt:SetFocus() }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT ( oBotonImprimir:Hide(), oBotonVer:Hide(), oBotonZoom:Hide(), oFiltro:Hide(), oBotonInforme:Disable() )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir dialogo" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::CloseFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Search( oLote, oBtnCancel, oBtnBuscar )

   if Empty( ::cCodigo )
      MsgStop( "Debe introducir un código de artículo." )
      Return ( .f. )
   end if

   oBtnCancel:Disable()
   oBtnBuscar:Disable()

   CursorWait()

   ::cCodigoLote        := Padr( ::cCodigo, 18 ) + Alltrim( ::cLote )

   ::oDbfTmp:Zap()

   if ::cBuscar == "Compras" .or. ::cBuscar == "Todos"

      // Pedidos de proveedor-----------------------------------------------------

      ::oMetMsg:cText   := "Pedidos proveedor"

      ::oMetMsg:SetTotal( ::oPedPrvL:OrdKeyCount() )

      if ::oPedPrvL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oPedPrvL:cRef ) .and. !( ::oPedPrvL:Eof() )

            if ( ::cLote == ::oPedPrvL:cLote .or. Empty( ::cLote ) ) 
               ::AddPedPrv()
            end if 

            ::oPedPrvL:Skip()

            ::oMetMsg:Set( ::oPedPrvL:OrdKeyNo() )

         end while

      end if

      ::oMetMsg:Set( ::oPedPrvL:LastRec() )

      // Albaranes de proveedor---------------------------------------------------


      ::oMetMsg:cText   := "Albaranes proveedor"

      ::oMetMsg:SetTotal( ::oAlbPrvL:OrdKeyCount() )

      if ::oAlbPrvL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oAlbPrvL:cRef ) .and. !( ::oAlbPrvL:Eof() )

            if ( ::cLote == ::oAlbPrvL:cLote .or. Empty( ::cLote ) )
               ::AddAlbPrv()
            end if 

            ::oAlbPrvL:Skip()

            ::oMetMsg:Set( ::oAlbPrvL:OrdKeyNo() )

         end while

      end if

      // Facturas de proveedor----------------------------------------------------

      ::oMetMsg:cText   := "Facturas proveedor"

      ::oMetMsg:SetTotal( ::oFacPrvL:OrdKeyCount() )

      if ::oFacPrvL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oFacPrvL:cRef ) .and. !( ::oFacPrvL:Eof() )

            if ( ::cLote == ::oFacPrvL:cLote .or. Empty( ::cLote ) )
               ::AddFacPrv()
            end if 

            ::oFacPrvL:Skip()

            ::oMetMsg:Set( ::oFacPrvL:OrdKeyNo() )

         end while

      end if

   end if

   if ::cBuscar == "Ventas" .or. ::cBuscar == "Todos"

      // Presupuestos de clientes-------------------------------------------------

      ::oMetMsg:cText   := "Presupuestos clientes"

      ::oMetMsg:SetTotal( ::oPreCliL:OrdKeyCount() )

      if ::oPreCliL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oPreCliL:cRef ) .and. !( ::oPreCliL:Eof() )

            if ( ::cLote == ::oPreCliL:cLote .or. Empty( ::cLote ) )
               ::AddPreCli()
            end if 

            ::oPreCliL:Skip()

            ::oMetMsg:Set( ::oPreCliL:OrdKeyNo() )

         end while

      end if

      // Pedidos de clientes------------------------------------------------------

      ::oMetMsg:cText   := "Pedidos clientes"

      ::oMetMsg:SetTotal( ::oPedCliL:OrdKeyCount() )

      if ::oPedCliL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oPedCliL:cRef ) .and. !( ::oPedCliL:Eof() )

            if ( ::cLote == ::oPedCliL:cLote .or. Empty( ::cLote ) )
               ::AddPedCli()
            end if 

            ::oPedCliL:Skip()

            ::oMetMsg:Set( ::oPedCliL:OrdKeyNo() )

         end while

      end if

      // Albaranes de clientes----------------------------------------------------

      ::oMetMsg:cText   := "Albaranes clientes"

      ::oMetMsg:SetTotal( ::oAlbCliL:OrdKeyCount() )

      if ::oAlbCliL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oAlbCliL:cRef ) .and. !( ::oAlbCliL:Eof() )

            if ( ::cLote == ::oAlbCliL:cLote .or. Empty( ::cLote ) )
               ::AddAlbCli()
            end if 

            ::oAlbCliL:Skip()

            ::oMetMsg:Set( ::oAlbCliL:OrdKeyNo() )

         end while

      end if

   // Facturas de clientes-----------------------------------------------------

      ::oMetMsg:cText   := "Facturas clientes"

      ::oMetMsg:SetTotal( ::oFacCliL:OrdKeyCount() )

      if ::oFacCliL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oFacCliL:cRef ) .and. !( ::oFacCliL:Eof() )

            if ( ::cLote == ::oFacCliL:cLote .or. Empty( ::cLote ) )
               ::AddFacCli()
            end if 

            ::oFacCliL:Skip()

            ::oMetMsg:Set( ::oFacCliL:OrdKeyNo() )

         end while

      end if

   // Facturas de rectificativas-----------------------------------------------

      ::oMetMsg:cText   := "Facturas rectificativas clientes"

      ::oMetMsg:SetTotal( ::oFacRecL:OrdKeyCount() )

      if ::oFacRecL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oFacRecL:cRef ) .and. !( ::oFacRecL:Eof() )

            if ( ::cLote == ::oFacRecL:cLote .or. Empty( ::cLote ) )
               ::AddFacRec()
            end if 

            ::oFacRecL:Skip()

            ::oMetMsg:Set( ::oFacRecL:OrdKeyNo() )

         end while

      end if

      // Tickets-----------------------------------------------

      ::oMetMsg:cText   := "Tickets clientes"

      ::oMetMsg:SetTotal( ::oTikCliL:OrdKeyCount() )

      if ::oTikCliL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oTikCliL:cCbaTil ) .and. !( ::oTikCliL:Eof() )

            if ( ::cLote == ::oTikCliL:cLote .or. Empty( ::cLote ) )
               ::AddTikCli()
            end if 

            ::oTikCliL:Skip()

            ::oMetMsg:Set( ::oTikCliL:OrdKeyNo() )

         end while

      end if

   // Fin de la busquedas------------------------------------------------------

   end if

   if ::cBuscar == "Producción" .or. ::cBuscar == "Todos"

      //Materiales producidos-----------------------------------------------------

      ::oMetMsg:cText   := "Materiales producidos"

      ::oMetMsg:SetTotal( ::oProducL:OrdKeyCount() )

      if ::oProducL:Seek( ::cCodigo )

         while ( ::cCodigo == ::oProducL:cCodArt ) .and. !( ::oProducL:Eof() )

            if ( ::cLote == ::oProducL:cLote .or. Empty( ::cLote ) )
               ::AddProducido()
            end if

            ::oProducL:Skip()

            ::oMetMsg:Set( ::oProducL:OrdKeyNo() )

         end while

      end if

      // Materiales consumidos-------------------------------------------------

      ::oMetMsg:cText   := "Materiales consumidos"

      ::oMetMsg:SetTotal( ::oProducM:OrdKeyCount() )

      if ::oProducM:Seek( ::cCodigo )

         while ( ::cCodigo == ::oProducM:cCodArt ) .and. !( ::oProducM:Eof() )

            if ( ::cLote == ::oProducM:cLote .or. Empty( ::cLote ) )
               ::AddConsumido()
            end if

            ::oProducM:Skip()

            ::oMetMsg:Set( ::oProducM:OrdKeyNo() )

         end while

      end if

   end if

   ::oDbfTmp:GoTop()

   // Fin del proceso

   ::oMetMsg:cText   := "Proceso finalizado"
   ::oMetMsg:SetTotal( 0 )

   // Refrescos de pantalla

   ::oBrw:Refresh( .t. )
   ::oBrw:Select()

   CursorWE()

   oBtnCancel:Enable()
   oBtnBuscar:Enable()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD AddPedPrv()


   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Pedido a proveedor"
   ::oDbfTmp:cNumDoc    := ::oPedPrvL:cSerPed + "/" + Ltrim( Str( ::oPedPrvL:nNumPed ) ) + "/" + ::oPedPrvL:cSufPed
   ::oDbfTmp:cDoc       := ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed
   ::oDbfTmp:cCodigo    := ::oPedPrvL:cRef
   ::oDbfTmp:cLote      := ::oPedPrvL:cLote
   ::oDbfTmp:cNomArt    := ::oPedPrvL:cDetalle
   ::oDbfTmp:nUnidades  := nTotNPedPrv( ::oPedPrvL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT, "dFecPed" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT, "cCodPrv" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT, "cNomPrv" )
   ::oDbfTmp:cCodObr    := ""
   ::oDbfTmp:dFecCad    := ctod("")
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddAlbPrv()

   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Albarán de proveedor"
   ::oDbfTmp:cNumDoc    := ::oAlbPrvL:cSerAlb + "/" + Ltrim( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + ::oAlbPrvL:cSufAlb
   ::oDbfTmp:cDoc       := ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb
   ::oDbfTmp:cCodigo    := ::oAlbPrvL:cRef
   ::oDbfTmp:cNomArt    := ::oAlbPrvL:cDetalle
   ::oDbfTmp:cLote      := ::oAlbPrvL:cLote
   ::oDbfTmp:nUnidades  := nTotNAlbPrv( ::oAlbPrvL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT, "dFecAlb" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT, "cCodPrv" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT, "cNomPrv" )
   ::oDbfTmp:dFecCad    := ::oAlbPrvL:dFecCad
   ::oDbfTmp:cCodObr    := ""
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacPrv()


   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Factura de proveedor"
   ::oDbfTmp:cNumDoc    := ::oFacPrvL:cSerFac + "/" + Ltrim( Str( ::oFacPrvL:nNumFac ) ) + "/" + ::oFacPrvL:cSufFac
   ::oDbfTmp:cDoc       := ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac
   ::oDbfTmp:cCodigo    := ::oFacPrvL:cRef
   ::oDbfTmp:cNomArt    := ::oFacPrvL:cDetalle
   ::oDbfTmp:cLote      := ::oFacPrvL:cLote
   ::oDbfTmp:nUnidades  := nTotNFacPrv( ::oFacPrvL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT, "dFecFac" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT, "cCodPrv" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT, "cNomPrv" )
   ::oDbfTmp:dFecCad    := ::oFacPrvL:dFecCad
   ::oDbfTmp:cCodObr    := ""
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddPreCli()


   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Presupuesto de cliente"
   ::oDbfTmp:cNumDoc    := ::oPreCliL:cSerPre + "/" + Ltrim( Str( ::oPreCliL:nNumPre ) ) + "/" + ::oPreCliL:cSufPre
   ::oDbfTmp:cDoc       := ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre
   ::oDbfTmp:cCodigo    := ::oPreCliL:cRef
   ::oDbfTmp:cNomArt    := ::oPreCliL:cDetalle
   ::oDbfTmp:cLote      := ::oPreCliL:cLote
   ::oDbfTmp:nUnidades  := nTotNPreCli( ::oPreCliL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "dFecPre" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "cCodCli" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "cNomCli" )
   ::oDbfTmp:cCodObr    := oRetFld( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT, "cCodObr" )
   ::oDbfTmp:dFecCad    := ctod("")
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddPedCli()


   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Pedido de cliente"
   ::oDbfTmp:cNumDoc    := ::oPedCliL:cSerPed + "/" + Ltrim( Str( ::oPedCliL:nNumPed ) ) + "/" + ::oPedCliL:cSufPed
   ::oDbfTmp:cDoc       := ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed
   ::oDbfTmp:cCodigo    := ::oPedCliL:cRef
   ::oDbfTmp:cNomArt    := ::oPedCliL:cDetalle
   ::oDbfTmp:cLote      := ::oPedCliL:cLote
   ::oDbfTmp:nUnidades  := nTotNPedCli( ::oPedCliL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "dFecPed" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "cCodCli" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "cNomCli" )
   ::oDbfTmp:cCodObr    := oRetFld( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT, "cCodObr" )
   ::oDbfTmp:dFecCad    := ctod("")
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddAlbCli()


   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Albarán de cliente"
   ::oDbfTmp:cNumDoc    := ::oAlbCliL:cSerAlb + "/" + Ltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb
   ::oDbfTmp:cDoc       := ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb
   ::oDbfTmp:cCodigo    := ::oAlbCliL:cRef
   ::oDbfTmp:cNomArt    := ::oAlbCliL:cDetalle
   ::oDbfTmp:cLote      := ::oAlbCliL:cLote
   ::oDbfTmp:nUnidades  := nTotNAlbCli( ::oAlbCliL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "dFecAlb" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "cCodCli" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "cNomCli" )
   ::oDbfTmp:cCodObr    := oRetFld( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT, "cCodObr" )
   ::oDbfTmp:dFecCad    := ::oAlbCliL:dFecCad
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacCli()

   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Factura de cliente"
   ::oDbfTmp:cNumDoc    := ::oFacCliL:cSerie + "/" + Ltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac
   ::oDbfTmp:cDoc       := ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac
   ::oDbfTmp:cCodigo    := ::oFacCliL:cRef
   ::oDbfTmp:cNomArt    := ::oFacCliL:cDetalle
   ::oDbfTmp:cLote      := ::oFacCliL:cLote
   ::oDbfTmp:nUnidades  := nTotNFacCli( ::oFacCliL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "dFecFac" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "cCodCli" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "cNomCli" )
   ::oDbfTmp:cCodObr    := oRetFld( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT, "cCodObr" )
   ::oDbfTmp:dFecCad    := ::oFacCliL:dFecCad
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddFacRec()


   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Factura rectificativa de cliente"
   ::oDbfTmp:cNumDoc    := ::oFacRecL:cSerie + "/" + Ltrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac
   ::oDbfTmp:cDoc       := ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac
   ::oDbfTmp:cCodigo    := ::oFacRecL:cRef
   ::oDbfTmp:cNomArt    := ::oFacRecL:cDetalle
   ::oDbfTmp:cLote      := ::oFacRecL:cLote
   ::oDbfTmp:nUnidades  := nTotNFacRec( ::oFacRecL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "dFecFac" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "cCodCli" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "cNomCli" )
   ::oDbfTmp:cCodObr    := oRetFld( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT, "cCodObr" )
   ::oDbfTmp:dFecCad    := ::oFacRecL:dFecCad
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddTikCli()

   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Ticket de cliente"
   ::oDbfTmp:cNumDoc    := ::oTikCliL:cSerTil + "/" + Ltrim( ::oTikCliL:cNumTil ) + "/" + ::oTikCliL:cSufTil
   ::oDbfTmp:cDoc       := ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil
   ::oDbfTmp:cCodigo    := ::oTikCliL:cCbaTil
   ::oDbfTmp:cNomArt    := ::oTikCliL:cNomTil
   ::oDbfTmp:cLote      := ::oTikCliL:cLote
   ::oDbfTmp:nUnidades  := nTotNTpv( ::oTikCliL:cAlias )
   ::oDbfTmp:dFecDoc    := oRetFld( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT, "dFecTik" )
   ::oDbfTmp:cCodCli    := oRetFld( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT, "cCliTik" )
   ::oDbfTmp:cNomCli    := oRetFld( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT, "cNomTik" )
   ::oDbfTmp:cCodObr    := oRetFld( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT, "cCodObr" )
   ::oDbfTmp:dFecCad    := ::oTikCliL:dFecCad
   ::oDbfTmp:Save()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddProducido()

   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Material producido"
   ::oDbfTmp:cNumDoc    := ::oProducL:cSerOrd + "/" + Ltrim( Str( ::oProducL:nNumOrd ) ) + "/" + ::oProducL:cSufOrd
   ::oDbfTmp:cDoc       := ::oProducL:cSerOrd + Str( ::oProducL:nNumOrd ) + ::oProducL:cSufOrd
   ::oDbfTmp:cCodigo    := ::oProducL:cCodArt
   ::oDbfTmp:cNomArt    := ::oProducL:cNomArt
   ::oDbfTmp:cLote      := ::oProducL:cLote
   ::oDbfTmp:nUnidades  := NotCaja( ::oProducL:nCajOrd ) * ::oProducL:nUndOrd
   ::oDbfTmp:dFecDoc    := oRetFld( ::oProducL:cSerOrd + Str( ::oProducL:nNumOrd ) + ::oProducL:cSufOrd, ::oProducT, "dFecFin" )
   ::oDbfTmp:cCodCli    := Space( 12 )
   ::oDbfTmp:cNomCli    := Space( 50 )
   ::oDbfTmp:cCodObr    := Space( 10 )
   ::oDbfTmp:dFecCad    := ctod("")

   ::oDbfTmp:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddConsumido()

   ::oDbfTmp:Append()
   ::oDbfTmp:cTipDoc    := "Material consumido"
   ::oDbfTmp:cNumDoc    := ::oProducM:cSerOrd + "/" + Ltrim( Str( ::oProducM:nNumOrd ) ) + "/" + ::oProducM:cSufOrd
   ::oDbfTmp:cDoc       := ::oProducM:cSerOrd + Str( ::oProducM:nNumOrd ) + ::oProducM:cSufOrd
   ::oDbfTmp:cCodigo    := ::oProducM:cCodArt
   ::oDbfTmp:cNomArt    := ::oProducM:cNomArt
   ::oDbfTmp:cLote      := ::oProducM:cLote
   ::oDbfTmp:nUnidades  := NotCaja( ::oProducM:nCajOrd ) * ::oProducM:nUndOrd
   ::oDbfTmp:dFecDoc    := oRetFld( ::oProducM:cSerOrd + Str( ::oProducM:nNumOrd ) + ::oProducM:cSufOrd, ::oProducT, "dFecFin" )
   ::oDbfTmp:cCodCli    := Space( 12 )
   ::oDbfTmp:cNomCli    := Space( 50 )
   ::oDbfTmp:cCodObr    := Space( 10 )
   ::oDbfTmp:dFecCad    := ctod("")
   ::oDbfTmp:Save()

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

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         ZoomProduccion( ::oDbfTmp:cDoc, ::oBrw )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         ZoomProduccion( ::oDbfTmp:cDoc, ::oBrw )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Ticket de cliente"
         ZooTikCli( ::oDbfTmp:cDoc )   

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

      case Alltrim( ::cFiltro ) == getConfigTraslation("Pedidos de clientes")
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

      case Alltrim( ::cFiltro ) == "Tickets de clientes"
         ::oDbfTmp:OrdSetFocus( "cTipDoc" )
         ::oDbfTmp:OrdScope( "Ticket de cliente" )
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

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         VisProduccion( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         VisProduccion( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Ticket de cliente"
         msgStop( "El documento no se puede visualizar","Información" )

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

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         PrnProduccion( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         PrnProduccion( ::oDbfTmp:cDoc )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Ticket de cliente"
         msgStop( "El documento no se puede imprimir","Información" )

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

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material producido"
         Return ( 10 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Material consumido"
         Return ( 10 )

      case Alltrim( ::oDbfTmp:cTipDoc ) == "Ticket de cliente"
         Return ( 11 )   

   end case

Return ( 1 )

//---------------------------------------------------------------------------//

METHOD InformeLote( oDlg )

   local oReport
   local oBlock
   local oError

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )   
   BEGIN SEQUENCE

      oDlg:Disable()

      oReport           := TInfTrazLot():New( "Informe detallado de trazas de un lotes" )
      oReport:cLote     := ::cLote
      oReport:dbfTmp    := ::oDbfTmp:cAlias
      oReport:Play() 

      oDlg:Enable()

   RECOVER USING oError
      
      msgStop( ErrorMessage( oError ), "Imposible ejecutar informe de trazabilidad" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return (  Self )   

//---------------------------------------------------------------------------//
