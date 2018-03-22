#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TTrazaDocumento

   DATA oDbfIva
   DATA oDbfArt
   DATA oDbfCli
   DATA oDbfPrv
   DATA oDbfDiv
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
   DATA oPreCliT
   DATA oPreCliL
   DATA oPedCliT
   DATA oPedCliL
   DATA oTikCliT
   DATA oTikCliL

   DATA oBrw

   DATA cFileName

   DATA cPicUnd
   DATA cPicImp
   DATA cPicDiv
   DATA nDecDiv
   DATA nRecDiv

   DATA oMetMsg
   DATA nMetMsg   AS NUMERIC  INIT 0

   DATA oTree
   DATA oBack
   DATA oImgLst

   DATA oCodigo
   DATA cCodigo               INIT ""

   DATA oNombre
   DATA cNombre               INIT ""

   DATA aAlbaranes            INIT {}
   DATA aFacturas             INIT {}
   DATA aTickets              INIT {}
   DATA aAlbProveedor         INIT {}

   DATA bEdit                 INIT {|| MsgInfo( "Edit" ) }
   DATA bZoom                 INIT {|| MsgInfo( "Zoom" ) }
   DATA bDelete               INIT {|| MsgInfo( "Delete" ) }
   DATA bVisual               INIT {|| MsgInfo( "Visualizar" ) }
   DATA bPrint                INIT {|| MsgInfo( "Imprimir" ) }

   Method OpenFiles()

   Method CloseFiles()

   Method Activate( cNumDoc )

   Method ChangeDocument()

   Method TrazaDocumento( cTypeDocument, cNumDoc )

   Method TrazaPedidoProveedor( cNumDoc )

   Method TrazaAlbaranProveedor( cNumDoc )

   Method TrazaFacturaProveedor( cNumDoc )

   Method TrazaPresupuestoCliente( cNumDoc )

   Method TrazaPedidoCliente( cNumDoc )

   Method TrazaAlbaranCliente( cNumDoc )

   Method TrazaFacturaCliente( cNumDoc )

   Method TrazaTicketCliente( cNumDoc )

   Method AddPedidoProveedor( lMainDocument, oTree )     
   
   Method AddAlbaranProveedor( lMainDocument, oTree )    
   
   Method AddFacturaProveedor( lMainDocument, oTree )    
   
   Method AddPresupuestoCliente( lMainDocument, oTree )  
   
   Method AddPedidoCliente( lMainDocument, oTree )       
   
   Method AddAlbaranCliente( lMainDocument, oTree )      
   
   Method AddAlbaranClienteLinea( lMainDocument, oTree )

   Method AddFacturaCliente( lMainDocument, oTree )

   Method AddTicketCliente( lMainDocument, oTree )

   Method AddAlbaranProveedorLinea( lMainDocument, oTree )

   Method CargaPedidoProveedor( cNumDoc )

   Method CargaAlbaranProveedor( cNumDoc )

   Method CargaFacturaProveedor( cNumDoc )

   Method CargaPresupuestoCliente( cNumDoc )

   Method CargaPedidoCliente( cNumDoc )

   Method CargaAlbaranCliente( cNumDoc )

   Method CargaFacturaCliente( cNumDoc )

   Method CargaTicketCliente( cNumDoc )

   Method EditDocument()

   Method ZoomDocument()

   Method DeleteDocument()

   Method VisualizaDocument()

   Method ImprimirDocument()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   CursorWait()

   ::cFileName    := cGetNewFileName( cPatTmp() + "LinDoc" + Auth():Codigo(), "Dbf", .t. )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "Divisas.Dbf" VIA ( cDriver() ) SHARED INDEX "Divisas.Cdx"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "Articulo.Dbf" VIA ( cDriver() ) SHARED INDEX "Articulo.Cdx"

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "Client.Cdx"

   DATABASE NEW ::oDbfPrv PATH ( cPatPrv() ) FILE "Provee.Dbf" VIA ( cDriver() ) SHARED INDEX "Provee.Cdx"

   DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PedProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "PedProvT.Cdx"

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PedProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "PedProvL.Cdx"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "AlbProvT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvT.Cdx"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "AlbProvL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbProvL.Cdx"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FacPrvT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvT.Cdx"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FacPrvL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvL.Cdx"

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PreCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "PreCliL.Cdx"

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PedCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliL.Cdx"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliL.Cdx"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FacCliL.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliL.Cdx"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TikeT.Dbf"   VIA ( cDriver() ) SHARED INDEX "TikeT.Cdx"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TikeL.Dbf"   VIA ( cDriver() ) SHARED INDEX "TikeL.Cdx"

   ::oDbfTmp      := dbfServer( "Lineas", SubStr( Str( Seconds() ), -6 ) ):New( ::cFileName, "Lineas", cLocalDriver(), , cPatTmp() )

   ::oDbfTmp:AddField( "nNumLin", "N",  4, 0 )
   ::oDbfTmp:AddField( "cRef",    "C", 18, 0 )
   ::oDbfTmp:AddField( "cDetalle","C",100, 0 )
   ::oDbfTmp:AddField( "nIva",    "N",  6, 2 )
   ::oDbfTmp:AddField( "nReq",    "N", 16, 6 )
   ::oDbfTmp:AddField( "nTotUnd", "N", 16, 6 )
   ::oDbfTmp:AddField( "nPreDiv", "N", 16, 6 )
   ::oDbfTmp:AddField( "cUnidad", "C",  2, 0 )
   ::oDbfTmp:AddField( "mLngDes", "M", 10, 0 )
   ::oDbfTmp:AddField( "nDtoLin", "N",  6, 2 )
   ::oDbfTmp:AddField( "nDtoPrm", "N",  6, 2 )
   ::oDbfTmp:AddField( "nTotLin", "N", 16, 6 )
   ::oDbfTmp:AddField( "nLote",   "N",  9, 0 )
   ::oDbfTmp:AddField( "cLote",   "C", 14, 0 )
   ::oDbfTmp:AddField( "cValPr1", "C", 20, 0 )
   ::oDbfTmp:AddField( "cValPr2", "C", 20, 0 )
   ::oDbfTmp:AddField( "cAlmLin" ,"C",  3, 0 )

   ::oDbfTmp:Activate( .f., .f. )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos.", "Atención" )
      msgStop( ErrorMessage( oError ) )

      lOpen       := .f.

      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

RETURN( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if( ::oDbfIva != nil, ::oDbfIva:End(), )

   if( ::oDbfArt != nil, ::oDbfArt:End(), )

   if( ::oDbfCli != nil, ::oDbfCli:End(), )

   if( ::oDbfPrv != nil, ::oDbfPrv:End(), )

   if( ::oPedPrvT != nil, ::oPedPrvT:End(), )

   if( ::oPedPrvL != nil, ::oPedPrvL:End(), )

   if( ::oAlbPrvT != nil, ::oAlbPrvT:End(), )

   if( ::oAlbPrvL != nil, ::oAlbPrvL:End(), )

   if( ::oFacPrvT != nil, ::oFacPrvT:End(), )

   if( ::oFacPrvL != nil, ::oFacPrvL:End(), )

   if( ::oPreCliT != nil, ::oPreCliT:End(), )

   if( ::oPreCliL != nil, ::oPreCliL:End(), )

   if( ::oPedCliT != nil, ::oPedCliT:End(), )

   if( ::oPedCliL != nil, ::oPedCliL:End(), )

   if( ::oAlbCliT != nil, ::oAlbCliT:End(), )

   if( ::oAlbCliL != nil, ::oAlbCliL:End(), )

   if( ::oFacCliT != nil, ::oFacCliT:End(), )

   if( ::oFacCliL != nil, ::oFacCliL:End(), )

   if( ::oTikCliT != nil, ::oTikCliT:End(), )

   if( ::oTikCliL != nil, ::oTikCliL:End(), )

   if( ::oDbfDiv != nil, ::oDbfDiv:End(), )

   if( ::oDbfTmp != nil, ::oDbfTmp:End(), )

   if File( ::cFileName )
      fErase( ::cFileName )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( cTypeDoc, cNumDoc )

   local oDlg

   ::aAlbaranes         := {}
   ::aFacturas          := {}
   ::aAlbProveedor      := {}

   if ::OpenFiles()

      CursorWait()

      if ::oDbfDiv:Seek( cDivEmp() )

         ::cPicUnd      := MasUnd()

         if cTypeDoc <= FAC_PRV
            ::cPicImp   := RetPic( ::oDbfDiv:nNinDiv, ::oDbfDiv:nDinDiv )
            ::cPicDiv   := RetPic( ::oDbfDiv:nNinDiv, ::oDbfDiv:nRinDiv )
            ::nDecDiv   := ::oDbfDiv:nDinDiv
            ::nRecDiv   := ::oDbfDiv:nRinDiv
         else
            ::cPicImp   := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nDouDiv )
            ::cPicDiv   := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nRouDiv )
            ::nDecDiv   := ::oDbfDiv:nDouDiv
            ::nRecDiv   := ::oDbfDiv:nRouDiv
         end if

      end if

      oDlg              := TDialog():New( , , , , , "BiTrazaDocumentos" )

      ::oTree           := TTreeView():Redefine( 100, oDlg )
      ::oTree:bChanged  := {|| ::ChangeDocument( ::oTree ) }

      ::oBack           := TTreeView():Redefine( 101, oDlg )
      ::oBack:bChanged  := {|| ::ChangeDocument( ::oBack ) }

      ::oImgLst         := TImageList():New()
      ::oImgLst:AddMasked( TBitmap():Define( "gc_document_text_16", , oDlg ), Rgb( 255, 0, 255 ) )
      ::oImgLst:AddMasked( TBitmap():Define( "gc_document_text_plus2_16", , oDlg ), Rgb( 255, 0, 255 ) )

      REDEFINE GET ::oCodigo VAR ::cCodigo ID 110 WHEN ( .f. ) OF oDlg

      REDEFINE GET ::oNombre VAR ::cNombre ID 111 WHEN ( .f. ) OF oDlg

      REDEFINE BUTTON ID 301 OF oDlg ACTION ( ::EditDocument() )

      REDEFINE BUTTON ID 302 OF oDlg ACTION ( ::ZoomDocument() )

      REDEFINE BUTTON ID 303 OF oDlg ACTION ( ::DeleteDocument() )

      REDEFINE BUTTON ID 304 OF oDlg ACTION ( ::VisualizaDocument() )

      REDEFINE BUTTON ID 305 OF oDlg ACTION ( ::ImprimirDocument() )

      ::oBrw               := IXBrowse():New( oDlg )

      ::oBrw:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDbfTmp:SetBrowse( ::oBrw )

      ::oBrw:nMarqueeStyle := 5

      ::oBrw:cName         := "Busquedas.Numeros de serie"

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Código"
            :cSortOrder       := "cRef"
            :bStrData         := {|| ::oDbfTmp:cRef }
            :nWidth           := 120
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Lote"
            :cSortOrder       := "cLote"
            :bStrData         := {|| ::oDbfTmp:cLote }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Descripción"
            :bStrData         := {|| If( Empty( ::oDbfTmp:cRef ) .and. !Empty( ::oDbfTmp:mLngDes ), ::oDbfTmp:mLngDes, ::oDbfTmp:cDetalle ) }
            :nWidth           := 160
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Prp. 1"
            :bStrData         := {|| ::oDbfTmp:cValPr1 }
            :nWidth           := 40
            :lHide            := .t.
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Prp. 2"
            :bStrData         := {|| ::oDbfTmp:cValPr2 }
            :nWidth           := 40
            :lHide            := .t.
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Unidades"
            :bEditValue       := {|| ::oDbfTmp:nTotUnd }
            :cEditPicture     := ::cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Almacén"
            :bStrData         := {|| ::oDbfTmp:cAlmLin }
            :nWidth           := 30
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| ::oDbfTmp:nPreDiv }
            :cEditPicture     := ::cPicDiv
            :nWidth           := 70
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "%Dto."
            :bEditValue       := {|| ::oDbfTmp:nDtoLin }
            :cEditPicture     := "@E 99.99"
            :nWidth           := 30
            :nDataStrAlign    := AL_RIGHT
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "%Prm."
            :bEditValue       := {|| ::oDbfTmp:nDtoPrm }
            :cEditPicture     := "@E 99.99"
            :nWidth           := 30
            :nDataStrAlign    := AL_RIGHT
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "Total"
            :bEditValue       := {|| ::oDbfTmp:nTotLin }
            :cEditPicture     := ::cPicDiv
            :nWidth           := 70
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         with object ( ::oBrw:AddCol() )
            :cHeader          := "%IVA"
            :bEditValue       := {|| ::oDbfTmp:nIva }
            :cEditPicture     := "@E 99.99"
            :nWidth           := 30
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         ::oBrw:bRClicked     := {| nRow, nCol, nFlags | ::oBrw:RButtonDown( nRow, nCol, nFlags ) }
         ::oBrw:bLDblClick    := {|| ::ZoomDocument() }

         ::oBrw:CreateFromResource( 140 )

      TButton():ReDefine( IDCANCEL, {|| oDlg:end() }, oDlg, , , .f., , , , .f. )

      CursorWE()

      oDlg:AddFastKey( VK_F3, {|| ::EditDocument() } )
      oDlg:AddFastKey( VK_F4, {|| ::DeleteDocument() } )

      oDlg:bStart             := {|| ::oTree:ExpandAll(), ::oBack:ExpandAll(), ::oBrw:Load() }

      oDlg:Activate( , , , .t., , , {|| ::TrazaDocumento( cTypeDoc, cNumDoc ) } )

      ::CloseFiles()

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method TrazaDocumento( cTypeDocument, cNumDoc )

   CursorWait()

   ::oTree:SetImageList( ::oImgLst )
   ::oBack:SetImageList( ::oImgLst )

   do case
      case cTypeDocument == PED_PRV

         ::TrazaPedidoProveedor( cNumDoc )

      case cTypeDocument == ALB_PRV

         ::TrazaAlbaranProveedor( cNumDoc )

      case cTypeDocument == FAC_PRV

         ::TrazaFacturaProveedor( cNumDoc )

      case cTypeDocument == PRE_CLI

         ::TrazaPresupuestoCliente( cNumDoc )

      case cTypeDocument == PED_CLI

         ::TrazaPedidoCliente( cNumDoc )

      case cTypeDocument == ALB_CLI

         ::TrazaAlbaranCliente( cNumDoc )

      case cTypeDocument == FAC_CLI

         ::TrazaFacturaCliente( cNumDoc )

      case cTypeDocument == TIK_CLI

         ::TrazaTicketCliente( cNumDoc )

   end case

   CursorWE()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method ChangeDocument( oTree )

   local oItemTree   := oTree:GetSelected()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:Cargo )

      do case
         case oItemTree:Cargo[ 1 ] == PED_PRV
            
            ::CargaPedidoProveedor( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == ALB_PRV
            
            ::CargaAlbaranProveedor( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == FAC_PRV
            
            ::CargaFacturaProveedor( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == PRE_CLI
            
            ::CargaPresupuestoCliente( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == PED_CLI
            
            ::CargaPedidoCliente( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == ALB_CLI
            
            ::CargaAlbaranCliente( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == FAC_CLI
            
            ::CargaFacturaCliente( oItemTree:Cargo[ 2 ] )

         case oItemTree:Cargo[ 1 ] == TIK_CLI
            
            ::CargaTicketCliente( oItemTree:Cargo[ 2 ] )

      end case

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method EditDocument()

   if ::bEdit != nil
      Eval( ::bEdit )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ZoomDocument()

   if ::bZoom != nil
      Eval( ::bZoom )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method DeleteDocument()

   if ::bDelete != nil
      Eval( ::bDelete )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method VisualizaDocument()

   if ::bVisual != nil
      Eval( ::bVisual )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ImprimirDocument()

   if ::bPrint != nil
      Eval( ::bPrint )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaPedidoProveedor( cNumDoc )

   local oItm1
   local oItm2
   local aNumeroFactura    := {}

   ::oAlbPrvL:GetStatus()
   ::oAlbPrvL:OrdSetFocus( 'cCodPed' )

   if ::oPedPrvT:Seek( cNumDoc )

      oItm1                := ::AddPedidoProveedor( .t., ::oTree )

      if ::oAlbPrvL:Seek( cNumDoc )

         while ::oAlbPrvL:cCodPed == cNumDoc .and. !::oAlbPrvL:eof()

            oItm2          := ::AddAlbaranProveedorLinea( .f., oItm1 )

            if ::oAlbPrvT:SeekInOrd( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, "NNUMALB" )

               if aScan( aNumeroFactura, ::oAlbPrvT:cNumFac ) == 0

                  if ::oFacPrvT:Seek( ::oAlbPrvT:cNumFac )

                     while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oAlbPrvT:cNumFac .and. !::oFacPrvT:eof()

                        ::AddFacturaProveedor( .f., oItm2 )

                        ::oFacPrvT:Skip()

                     end while

                  end if

                  aAdd( aNumeroFactura, ::oAlbPrvT:cNumFac )

               end if

            end if

            ::oAlbPrvL:Skip()

         end while

      end if

   end if

   ::oAlbPrvL:SetStatus()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaAlbaranProveedor( cNumDoc )

   local oItm1
   local oItm2
   local cDocumento
   local aNumeroPedido  := {}
   local aNumeroFactura := {}

   if ::oAlbPrvT:Seek( cNumDoc )

      if ::oAlbPrvL:Seek( cNumDoc )

         while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == cNumDoc .and. !::oAlbPrvL:Eof()

            if aScan( aNumeroPedido, ::oAlbPrvL:cCodPed ) == 0
               aAdd( aNumeroPedido, ::oAlbPrvL:cCodPed )
            end if

            if aScan( aNumeroFactura, ::oAlbPrvL:cNumFac ) == 0
               aAdd( aNumeroFactura, ::oAlbPrvL:cNumFac )
            end if

            ::oAlbPrvL:Skip()

         end while

      end if

      for each cDocumento in aNumeroPedido 
         if ::oPedPrvT:SeekInOrd( cDocumento, 'nNumPed' )
            oItm1 := ::AddPedidoProveedor( .f., ::oTree )
         end if
      next

      oItm2 := ::AddAlbaranProveedor( .t., if( !Empty( oItm1 ), oItm1, ::oTree ) )

      for each cDocumento in aNumeroFactura
         if ::oFacPrvT:SeekInOrd( cDocumento, 'nNumFac' )
            ::AddFacturaProveedor( .f., oItm2 )
         end if 
      next

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaFacturaProveedor( cNumDoc )

   local n
   local oItm1
   local oItm2
   local cOrdAnterior   := ::oAlbPrvT:OrdSetFocus( "cNumFac" )
   local aNumeroPedido  := {}

   if ::oFacPrvT:Seek( cNumDoc )

      if ::oAlbPrvT:Seek( cNumDoc )

         while ::oAlbPrvT:cNumFac == cNumDoc .and. !::oAlbPrvT:eof()

            if ::oAlbPrvL:Seek( cNumDoc )

               while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == cNumDoc .and. !::oAlbPrvL:Eof()

                  if aScan( aNumeroPedido, ::oAlbPrvL:cCodPed ) == 0
                     aAdd( aNumeroPedido, ::oAlbPrvL:cCodPed )
                  end if

                  ::oAlbPrvL:Skip()

               end while

            end if

            for n := 1 to len( aNumeroPedido )

               if ::oPedPrvT:SeekInOrd( aNumeroPedido[ n ], 'nNumPed' )

                  oItm1 := ::AddPedidoProveedor( .f., ::oTree )

               end if

            next

            oItm2 := ::AddAlbaranProveedor( .f., if( !Empty( oItm1 ), oItm1, ::oTree ) )

            ::oAlbPrvT:Skip()

         end while

      end if

      if !Empty( oItm2 )
         ::AddFacturaProveedor( .t., oItm2 )
      else
         ::AddFacturaProveedor( .t., ::oTree )
      end if

   end if

   ::oAlbPrvT:OrdSetFocus( cOrdAnterior )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaPresupuestoCliente( cNumDoc )

   local oItm1
   local oItm2
   local oItm3

   ::oPreCliT:GetStatus()

   ::oPedCliT:GetStatus()
   ::oPedCliT:OrdSetFocus( "cNumPre" )

   ::oAlbCliL:GetStatus()
   ::oAlbCliL:OrdSetFocus( 'cNumPed' )

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "cNumPre" )

   if ::oPreCliT:Seek( cNumDoc )

      oItm1 := ::AddPresupuestoCliente( .t., ::oTree )

      // Buscamos en pedidos de clientes, albaranes y facturas-----------------

      if ::oPedCliT:Seek( cNumDoc )

         while ::oPedCliT:cNumPre == cNumDoc .and. !::oPedCliT:eof()

            oItm2 := ::AddPedidoCliente( .f., oItm1 )

            if ::oAlbCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

               while ::oAlbCliL:cNumPed == ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed .and. !::oAlbCliL:eof()

                  oItm3 := ::AddAlbaranClienteLinea( .f., oItm2 )

                  if !Empty( oItm3 )

                     if ::oFacCliT:SeekInOrd( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, 'cNumAlb' )

                        ::AddFacturaCliente( .f., oItm3 )

                     else

                        if ::oFacCliL:SeekInOrd( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, 'cCodAlb' )

                           if ::oFacCliT:SeekInOrd( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, 'nNumFac' )

                              ::AddFacturaCliente( .f., oItm3 )

                           end if

                        end if

                     end if

                  end if

                  ::oAlbCliL:Skip()

               end while

            end if

            ::oPedCliT:Skip()

         end while

      end if

      // Buscamos en facturas de clientes--------------------------------------

      if ::oFacCliT:SeekInOrd( cNumDoc, 'cNumPre' )

         while ::oFacCliT:cNumPre == cNumDoc .and. !::oFacCliT:Eof()

            ::AddFacturaCliente( .f., oItm1 )

            ::oFacCliT:Skip()

         end while

      end if

   end if

   ::oPreCliT:SetStatus()

   ::oPedCliT:SetStatus()

   ::oAlbCliL:SetStatus()

   ::oFacCliT:SetStatus()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaPedidoCliente( cNumDoc )

   local oItm1
   local oItm2
   local oItm3

   if ::oPedCliT:Seek( cNumDoc )

      /*
      Hacia atras miramos los presupuestos-------------------------------------
      */

      if ::oPreCliT:SeekInOrd( ::oPedCliT:cNumPre, 'nNumPre' )

         oItm1 := ::AddPresupuestoCliente( .f., ::oTree )

      end if

      /*
      Añadimos el pedido de cliente--------------------------------------------
      */

      oItm2    := ::AddPedidoCliente( .t., if( !Empty( oItm1 ), oItm1, ::oTree ) )

      /*
      Hacia delante los albaranes y facturas-----------------------------------
      */

      ::oAlbCliL:GetStatus()
      ::oAlbCliL:OrdSetFocus( 'cNumPed' )

      if ::oAlbCliL:Seek( cNumDoc )

         while ::oAlbCliL:cNumPed == cNumDoc .and. !::oAlbCliL:eof()

            oItm3 := ::AddAlbaranClienteLinea( .f., if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) )

            if !Empty( oItm3 )

               if ::oFacCliT:SeekInOrd( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, 'cNumAlb' )
                  ::AddFacturaCliente( .f., oItm3 )
               else
                  if ::oFacCliL:SeekInOrd( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, 'cCodAlb' )
                     if ::oFacCliT:SeekInOrd( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, 'nNumFac' )
                        ::AddFacturaCliente( .f., oItm3 )
                     end if
                  end if
               end if

            end if

            ::oAlbCliL:Skip()

         end while

      end if

      ::oAlbCliL:SetStatus()

      /*
      Hacia delante facturas---------------------------------------------------
      */

      ::oFacCliT:GetStatus()
      ::oFacCliT:OrdSetFocus( 'cNumPed' )

      if ::oFacCliT:Seek( cNumDoc )

         while ::oFacCliT:cNumPed == cNumDoc .and. !::oFacCliT:eof()

            ::AddFacturaCliente( .f., if( !Empty( oItm3 ), oItm3, if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) ) )

            ::oFacCliT:Skip()

         end while

      end if

      ::oFacCliT:SetStatus()

   end if

   /*
   Hacia atras miramos los pedidos a proveedores-------------------------------
   */

   ::oPedPrvT:GetStatus()
   ::oPedPrvT:OrdSetFocus( "cPedCli" )

   ::oAlbPrvT:GetStatus()
   ::oAlbPrvT:OrdSetFocus( 'cNumPed' )

   if ::oPedPrvT:Seek( cNumDoc )

      while ::oPedPrvT:cNumPedCli == cNumDoc .and. !::oPedPrvT:eof()

         oItm1 := ::AddPedidoProveedor( .f., ::oBack )

         if ::oAlbPrvT:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while ::oAlbPrvT:cNumPed == ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed .and. !::oAlbPrvT:eof()

               oItm2 := ::AddAlbaranProveedor( .f., oItm1 )

               if ::oFacPrvT:Seek( ::oAlbPrvT:cNumFac )

                  while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oAlbPrvT:cNumFac .and. !::oFacPrvT:eof()

                     ::AddFacturaProveedor( .f., oItm2 )

                     ::oFacPrvT:Skip()

                  end while

               end if

               ::oAlbPrvT:Skip()

            end while

         end if

         ::oPedPrvT:Skip()

      end while

   end if

   ::oPedPrvT:SetStatus()
   ::oAlbPrvT:SetStatus()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaAlbaranCliente( cNumDoc )

   local n
   local oItm1
   local oItm2
   local oItm3
   local aNumeroPedido  := {}

   if ::oAlbCliT:Seek( cNumDoc )

      if ::oAlbCliL:Seek( cNumDoc )

         while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == cNumDoc .and. !::oAlbCliL:Eof()

            if aScan( aNumeroPedido, ::oAlbCliL:cNumPed ) == 0
               aAdd( aNumeroPedido, ::oAlbCliL:cNumPed )
            end if

            ::oAlbCliL:Skip()

         end while

      end if

      for n := 1 to len( aNumeroPedido )

         if ::oPedCliT:SeekInOrd( aNumeroPedido[ n ], 'nNumPed' )

            /*
            Hacia atras miramos los presupuestos-------------------------------
            */

            if ::oPreCliT:SeekInOrd( ::oPedCliT:cNumPre, 'nNumPre' )

               oItm1    := ::AddPresupuestoCliente( .f., ::oTree )

            end if

            oItm2       := ::AddPedidoCliente( .f., if( !Empty( oItm1 ), oItm1, ::oTree ), aNumeroPedido[ n ] )

         end if

      next

      oItm3             := ::AddAlbaranCliente( .t., if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) )

      /*
      Hacia delante en facturas de clientes------------------------------------
      */

      if ::oFacCliT:SeekInOrd( cNumDoc, 'cNumAlb' )
         ::AddFacturaCliente( .f., oItm3 )
      else
         if ::oFacCliL:SeekInOrd( cNumDoc, 'cCodAlb' )
            if ::oFacCliT:SeekInOrd( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, 'nNumFac' )
               ::AddFacturaCliente( .f., oItm3 )
            end if
         end if
      end if

      /*
      Buscamos si se ha pasado a tiket
      */

      if ::oTikCliT:SeekInOrd( ::oAlbCliT:cNumTik, 'cNumTik' )
         ::AddTicketCliente( .f., oItm3)
      end if

   end if

   ::oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD TrazaFacturaCliente( cNumDoc )

   local n
   local oItm1
   local oItm2
   local oItm3
   local aNumeroPedido  := {}

   if ::oFacCliT:Seek( cNumDoc )

      ::oAlbCliT:GetStatus()
      ::oAlbCliT:OrdSetFocus( 'cNumFac' )

      if ::oAlbCliT:Seek( cNumDoc )

         while ::oAlbCliT:cNumFac == cNumDoc .and. !::oAlbCliT:eof()

            if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:Eof()

                  if aScan( aNumeroPedido, ::oAlbCliL:cNumPed ) == 0
                     aAdd( aNumeroPedido, ::oAlbCliL:cNumPed )
                  end if

                  ::oAlbCliL:Skip()

               end while

            end if

            for n := 1 to len( aNumeroPedido )

               if ::oPedCliT:SeekInOrd( aNumeroPedido[ n ], 'nNumPed' )

                  // Hacia atras miramos los presupuestos-------------------------------

                  if ::oPreCliT:SeekInOrd( ::oPedCliT:cNumPre, 'nNumPre' )

                     oItm1 := ::AddPresupuestoCliente( .f., ::oTree )

                  end if

                  oItm2    := ::AddPedidoCliente( .f., if( !Empty( oItm1 ), oItm1, ::oTree ), aNumeroPedido[ n ] )

               end if

            next

            oItm3          := ::AddAlbaranCliente( .f., if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) )

            ::oAlbCliT:Skip()

            aNumeroPedido  := {}

         end while

      end if

      if !Empty( ::oFacCliT:cNumPre )

         ::oPreCliT:GetStatus()
         ::oPreCliT:OrdSetFocus( 'nNumPre' )

         oItm1 := ::AddPresupuestoCliente( .f., ::oTree )

         ::oPreCliT:SetStatus()

      end if

      if !Empty( ::oFacCliT:cNumPed )

         ::oPedCliT:GetStatus()
         ::oPedCliT:OrdSetFocus( 'nNumPed' )

         oItm1 := ::AddPedidoCliente( .f., ::oTree )

         ::oPedCliT:SetStatus()

      end if

      ::AddFacturaCliente( .t., if( !Empty( oItm3 ), oItm3, if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) ) )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD TrazaTicketCliente( cNumDoc, lVale )

   local n
   local cDoc
   local oItm1
   local oItm2
   local oItm3

   DEFAULT lVale     := .f.

   if ::oTikCliT:Seek( cNumDoc )

      if ( ::oTikCliT:cTipTik == SAVVAL )
         RETURN ( ::TrazaTicketCliente( ::oTikCliT:cTikVal, .t. ) )
      end if

      /*
      Buscamos si un albaran se a pasado a tiket      
      */

      if ::oAlbCliT:SeekInOrd( cNumDoc, "CNUMTIK" )

         oItm1 := ::AddAlbaranCliente( .f., if( !Empty( oItm3 ), oItm3, if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) ) )

      end if   

      // if ::oTikCliT:Seek( cNumDoc )

      oItm1          := ::AddTicketCliente( !lVale, if( !Empty( oItm3 ), oItm3, if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) ) )

      ::oTikCliT:OrdSetFocus( "cValTik" )
      if ::oTikCliT:Seek( cNumDoc )

         oItm2       := ::AddTicketCliente( lVale, if( !Empty( oItm3 ), oItm3, if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) ) )

         if ::oTikCliT:lLiqTik

            cDoc     := ::oTikCliT:cValDoc

            ::oTikCliT:OrdSetFocus( "cNumTik" )
            if ::oTikCliT:Seek( cDoc )

               oItm3 := ::AddTicketCliente( .f., if( !Empty( oItm3 ), oItm3, if( !Empty( oItm2 ), oItm2, if( !Empty( oItm1 ), oItm1, ::oTree ) ) ) )

            end if

         end if

         ::oTikCliT:OrdSetFocus( "cNumTik" )

      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaPedidoProveedor( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oPedPrvT:Seek( cNumDoc )
      ::oCodigo:cText( ::oPedPrvT:cCodPrv )
      ::oNombre:cText( ::oPedPrvT:cNomPrv )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oPedPrvL:Seek( cNumDoc )

      while ( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed == cNumDoc ) .and. ( !::oPedPrvL:Eof() )

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oPedPrvL:nNumLin
            ::oDbfTmp:cRef       := ::oPedPrvL:cRef
            ::oDbfTmp:cDetalle   := ::oPedPrvL:cDetalle
            ::oDbfTmp:nIva       := ::oPedPrvL:nIva
            ::oDbfTmp:nReq       := ::oPedPrvL:nReq
            ::oDbfTmp:cUnidad    := ::oPedPrvL:cUnidad
            ::oDbfTmp:mLngDes    := ::oPedPrvL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oPedPrvL:nDtoLin
            ::oDbfTmp:nDtoPrm    := ::oPedPrvL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oPedPrvL:cValPr1
            ::oDbfTmp:cValPr2    := ::oPedPrvL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oPedPrvL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNPedPrv( ::oPedPrvL )
            ::oDbfTmp:nPreDiv    := nTotUPedPrv( ::oPedPrvL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLPedPrv( ::oPedPrvL, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oPedPrvL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtPedPrv( cNumDoc ) }
   ::bZoom     := {|| ZooPedPrv( cNumDoc ) }
   ::bDelete   := {|| DelPedPrv( cNumDoc ) }
   ::bVisual   := {|| VisPedPrv( cNumDoc ) }
   ::bPrint    := {|| PrnPedPrv( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaAlbaranProveedor( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oAlbPrvT:Seek( cNumDoc )
      ::oCodigo:cText( ::oAlbPrvT:cCodPrv )
      ::oNombre:cText( ::oAlbPrvT:cNomPrv )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oAlbPrvL:Seek( cNumDoc )

      while ( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == cNumDoc ) .and. ( !::oAlbPrvL:Eof() )

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oAlbPrvL:nNumLin
            ::oDbfTmp:cRef       := ::oAlbPrvL:cRef
            ::oDbfTmp:cDetalle   := ::oAlbPrvL:cDetalle
            ::oDbfTmp:nIva       := ::oAlbPrvL:nIva
            ::oDbfTmp:nReq       := ::oAlbPrvL:nReq
            ::oDbfTmp:cUnidad    := ::oAlbPrvL:cUnidad
            ::oDbfTmp:mLngDes    := ::oAlbPrvL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oAlbPrvL:nDtoLin
            ::oDbfTmp:nDtoPrm    := ::oAlbPrvL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oAlbPrvL:cValPr1
            ::oDbfTmp:cValPr2    := ::oAlbPrvL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oAlbPrvL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNAlbPrv( ::oAlbPrvL )
            ::oDbfTmp:nPreDiv    := nTotUAlbPrv( ::oAlbPrvL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLAlbPrv( ::oAlbPrvL, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oAlbPrvL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtAlbPrv( cNumDoc ) }
   ::bZoom     := {|| ZooAlbPrv( cNumDoc ) }
   ::bDelete   := {|| DelAlbPrv( cNumDoc ) }
   ::bVisual   := {|| VisAlbPrv( cNumDoc ) }
   ::bPrint    := {|| PrnAlbPrv( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaFacturaProveedor( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oFacPrvT:Seek( cNumDoc )
      ::oCodigo:cText( ::oFacPrvT:cCodPrv )
      ::oNombre:cText( ::oFacPrvT:cNomPrv )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oFacPrvL:Seek( cNumDoc )

      while ( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac == cNumDoc ) .and. ( !::oFacPrvL:Eof() )

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oFacPrvL:nNumLin
            ::oDbfTmp:cRef       := ::oFacPrvL:cRef
            ::oDbfTmp:cDetalle   := ::oFacPrvL:cDetalle
            ::oDbfTmp:nIva       := ::oFacPrvL:nIva
            ::oDbfTmp:nReq       := ::oFacPrvL:nReq
            ::oDbfTmp:cUnidad    := ::oFacPrvL:cUnidad
            ::oDbfTmp:mLngDes    := ::oFacPrvL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oFacPrvL:nDtoLin
            ::oDbfTmp:nDtoPrm    := ::oFacPrvL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oFacPrvL:cValPr1
            ::oDbfTmp:cValPr2    := ::oFacPrvL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oFacPrvL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNFacPrv( ::oFacPrvL )
            ::oDbfTmp:nPreDiv    := nTotUFacPrv( ::oFacPrvL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLFacPrv( ::oFacPrvL, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oFacPrvL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtFacPrv( cNumDoc ) }
   ::bZoom     := {|| ZooFacPrv( cNumDoc ) }
   ::bDelete   := {|| DelFacPrv( cNumDoc ) }
   ::bVisual   := {|| VisFacPrv( cNumDoc ) }
   ::bPrint    := {|| PrnFacPrv( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaPresupuestoCliente( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oPreCliT:Seek( cNumDoc )
      ::oCodigo:cText( ::oPreCliT:cCodCli )
      ::oNombre:cText( ::oPreCliT:cNomCli )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oPreCliL:Seek( cNumDoc )

      while ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre == cNumDoc .and. !::oPreCliL:Eof()

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oPreCliL:nNumLin
            ::oDbfTmp:cRef       := ::oPreCliL:cRef
            ::oDbfTmp:cDetalle   := ::oPreCliL:cDetalle
            ::oDbfTmp:nIva       := ::oPreCliL:nIva
            ::oDbfTmp:nReq       := ::oPreCliL:nReq
            ::oDbfTmp:cUnidad    := ::oPreCliL:cUnidad
            ::oDbfTmp:mLngDes    := ::oPreCliL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oPreCliL:nDto
            ::oDbfTmp:nDtoPrm    := ::oPreCliL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oPreCliL:cValPr1
            ::oDbfTmp:cValPr2    := ::oPreCliL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oPreCliL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNPreCli( ::oPreCliL )
            ::oDbfTmp:nPreDiv    := nTotUPreCli( ::oPreCliL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLPreCli( ::oPreCliL:cAlias, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oPreCliL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtPreCli( cNumDoc ) }
   ::bZoom     := {|| ZooPreCli( cNumDoc ) }
   ::bDelete   := {|| DelPreCli( cNumDoc ) }
   ::bVisual   := {|| VisPreCli( cNumDoc ) }
   ::bPrint    := {|| PrnPreCli( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaPedidoCliente( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oPedCliT:Seek( cNumDoc )
      ::oCodigo:cText( ::oPedCliT:cCodCli )
      ::oNombre:cText( ::oPedCliT:cNomCli )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oPedCliL:Seek( cNumDoc )

      while ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed == cNumDoc .and. !::oPedCliL:Eof()

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oPedCliL:nNumLin
            ::oDbfTmp:cRef       := ::oPedCliL:cRef
            ::oDbfTmp:cDetalle   := ::oPedCliL:cDetalle
            ::oDbfTmp:nIva       := ::oPedCliL:nIva
            ::oDbfTmp:nReq       := ::oPedCliL:nReq
            ::oDbfTmp:cUnidad    := ::oPedCliL:cUnidad
            ::oDbfTmp:mLngDes    := ::oPedCliL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oPedCliL:nDto
            ::oDbfTmp:nDtoPrm    := ::oPedCliL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oPedCliL:cValPr1
            ::oDbfTmp:cValPr2    := ::oPedCliL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oPedCliL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNPedCli( ::oPedCliL )
            ::oDbfTmp:nPreDiv    := nTotUPedCli( ::oPedCliL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLPedCli( ::oPedCliL:cAlias, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oPedCliL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtPedCli( cNumDoc ) }
   ::bZoom     := {|| ZooPedCli( cNumDoc ) }
   ::bDelete   := {|| DelPedCli( cNumDoc ) }
   ::bVisual   := {|| VisPedCli( cNumDoc ) }
   ::bPrint    := {|| PrnPedCli( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaAlbaranCliente( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oAlbCliT:Seek( cNumDoc )
      ::oCodigo:cText( ::oAlbCliT:cCodCli )
      ::oNombre:cText( ::oAlbCliT:cNomCli )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oAlbCliL:Seek( cNumDoc )

      while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == cNumDoc .and. !::oAlbCliL:Eof()

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oAlbCliL:nNumLin
            ::oDbfTmp:cRef       := ::oAlbCliL:cRef
            ::oDbfTmp:cDetalle   := ::oAlbCliL:cDetalle
            ::oDbfTmp:nIva       := ::oAlbCliL:nIva
            ::oDbfTmp:nReq       := ::oAlbCliL:nReq
            ::oDbfTmp:cUnidad    := ::oAlbCliL:cUnidad
            ::oDbfTmp:mLngDes    := ::oAlbCliL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oAlbCliL:nDto
            ::oDbfTmp:nDtoPrm    := ::oAlbCliL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oAlbCliL:cValPr1
            ::oDbfTmp:cValPr2    := ::oAlbCliL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oAlbCliL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNAlbCli( ::oAlbCliL )
            ::oDbfTmp:nPreDiv    := nTotUAlbCli( ::oAlbCliL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oAlbCliL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtAlbCli( cNumDoc ) }
   ::bZoom     := {|| ZooAlbCli( cNumDoc ) }
   ::bDelete   := {|| DelAlbCli( cNumDoc ) }
   ::bVisual   := {|| VisAlbCli( cNumDoc ) }
   ::bPrint    := {|| PrnAlbCli( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaFacturaCliente( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oFacCliT:Seek( cNumDoc )
      ::oCodigo:cText( ::oFacCliT:cCodCli )
      ::oNombre:cText( ::oFacCliT:cNomCli )
   end if

   /*
   Lineas----------------------------------------------------------------------
   */

   if ::oFacCliL:Seek( cNumDoc )

      while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == cNumDoc .and. !::oFacCliL:Eof()

         if ::oDbfTmp:Append()
            ::oDbfTmp:nNumLin    := ::oFacCliL:nNumLin
            ::oDbfTmp:cRef       := ::oFacCliL:cRef
            ::oDbfTmp:cDetalle   := ::oFacCliL:cDetalle
            ::oDbfTmp:nIva       := ::oFacCliL:nIva
            ::oDbfTmp:nReq       := ::oFacCliL:nReq
            ::oDbfTmp:cUnidad    := ::oFacCliL:cUnidad
            ::oDbfTmp:mLngDes    := ::oFacCliL:mLngDes
            ::oDbfTmp:nDtoLin    := ::oFacCliL:nDto
            ::oDbfTmp:nDtoPrm    := ::oFacCliL:nDtoPrm
            ::oDbfTmp:cValPr1    := ::oFacCliL:cValPr1
            ::oDbfTmp:cValPr2    := ::oFacCliL:cValPr2
            ::oDbfTmp:cAlmLin    := ::oFacCliL:cAlmLin
            ::oDbfTmp:nTotUnd    := nTotNFacCli( ::oFacCliL )
            ::oDbfTmp:nPreDiv    := nTotUFacCli( ::oFacCliL, ::nDecDiv )
            ::oDbfTmp:nTotLin    := nTotLFacCli( ::oFacCliL:cAlias, ::nDecDiv, ::nRecDiv )
            ::oDbfTmp:Save()
         end if

         ::oFacCliL:Skip()

      end while

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtFacCli( cNumDoc ) }
   ::bZoom     := {|| ZooFacCli( cNumDoc ) }
   ::bDelete   := {|| DelFacCli( cNumDoc ) }
   ::bVisual   := {|| VisFacCli( cNumDoc ) }
   ::bPrint    := {|| PrnFacCli( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method CargaTicketCliente( cNumDoc )

   ::oDbfTmp:Zap()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if ::oTikCliT:Seek( cNumDoc )

      ::oCodigo:cText( ::oTikCliT:cCliTik )
      ::oNombre:cText( ::oTikCliT:cNomTik )

      /*
      Lineas----------------------------------------------------------------------
      */

      if ::oTikCliL:Seek( cNumDoc )

         while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == cNumDoc .and. !::oTikCliL:Eof()

            if ::oDbfTmp:Append()
               ::oDbfTmp:nNumLin    := ::oTikCliL:nNumLin
               ::oDbfTmp:cRef       := ::oTikCliL:cCbaTil
               ::oDbfTmp:cDetalle   := ::oTikCliL:cNomTil
               ::oDbfTmp:nIva       := ::oTikCliL:nIvaTil
               ::oDbfTmp:nReq       := 0
               ::oDbfTmp:cUnidad    := ::oTikCliL:cUnidad
               ::oDbfTmp:mLngDes    := ""
               ::oDbfTmp:nDtoLin    := ::oTikCliL:nDtoLin
               ::oDbfTmp:nDtoPrm    := 0
               ::oDbfTmp:cValPr1    := ::oTikCliL:cValPr1
               ::oDbfTmp:cValPr2    := ::oTikCliL:cValPr2
               ::oDbfTmp:cAlmLin    := ::oTikCliL:cAlmLin
               ::oDbfTmp:nTotUnd    := if( ::oTikCliT:cTipTik == "4", - ::oTikCliL:nUntTil, ::oTikCliL:nUntTil )
               ::oDbfTmp:nPreDiv    := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecDiv )
               ::oDbfTmp:nTotLin    := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecDiv, ::nRecDiv )
               ::oDbfTmp:Save()
            end if

            ::oTikCliL:Skip()

         end while

      end if

   end if

   ::oDbfTmp:GoTop()

   ::bEdit     := {|| EdtTikCli( cNumDoc ) }
   ::bZoom     := {|| ZooTikCli( cNumDoc ) }
   ::bDelete   := {|| DelTikCli( cNumDoc ) }
   ::bVisual   := {|| VisTikCli( cNumDoc ) }
   ::bPrint    := {|| PrnTikCli( cNumDoc ) }

   ::oBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method AddPedidoProveedor( lMainDocument, oTree )
   
   local oNode := oTree:Add(  "Pedido proveedor"                                                                                 + " - " +;
                              ::oPedPrvT:cSerPed + "/" + Ltrim( Str( ::oPedPrvT:nNumPed ) ) + "/" + Rtrim( ::oPedPrvT:cSufPed )  + " - " +;
                              Dtoc( ::oPedPrvT:dFecPed ),;
                              if( lMainDocument, 1, 0 ) )
   oNode:Cargo := { PED_PRV, ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed } 

Return ( oNode )

//----------------------------------------------------------------------------//

Method AddAlbaranProveedor( lMainDocument, oTree )

   local oNode := oTree:Add(  "Albarán proveedor"                                                                                 + " - " +;
                              ::oAlbPrvT:cSerAlb + "/" + Ltrim( Str( ::oAlbPrvT:nNumAlb ) ) + "/" + Rtrim( ::oAlbPrvT:cSufAlb )   + " - " +;
                              Dtoc( ::oAlbPrvT:dFecAlb ),;
                              if( lMainDocument, 1, 0 ) )
   oNode:Cargo := { ALB_PRV, ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb }

Return ( oNode )

//----------------------------------------------------------------------------//

Method AddFacturaProveedor( lMainDocument, oTree )    

   local oNode := oTree:Add("Factura proveedor"                                                                                + " - " +;
                              ::oFacPrvT:cSerFac + "/" + Ltrim( Str( ::oFacPrvT:nNumFac ) ) + "/" + Rtrim( ::oFacPrvT:cSufFac )  + " - " +;
                              Dtoc( ::oFacPrvT:dFecFac ),;
                              if( lMainDocument, 1, 0 ) )
   oNode:Cargo := { FAC_PRV, ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac }

Return ( oNode )

//----------------------------------------------------------------------------//

Method AddPresupuestoCliente( lMainDocument, oTree )  

   local oNode := oTree:Add(  "Presupuesto cliente"                                                                              + " - " +;
                              ::oPreCliT:cSerPre + "/" + Ltrim( Str( ::oPreCliT:nNumPre ) ) + "/" + Rtrim( ::oPreCliT:cSufPre )  + " - " +;
                              Dtoc( ::oPreCliT:dFecPre ),;
                              if( lMainDocument, 1, 0 ) )
   oNode:Cargo := { PRE_CLI, ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre }

Return ( oNode )

//----------------------------------------------------------------------------//

Method AddPedidoCliente( lMainDocument, oTree )       

   local oNode := oTree:Add(  "Pedido cliente"                                                                                   + " - " +;
                              ::oPedCliT:cSerPed + "/" + Ltrim( Str( ::oPedCliT:nNumPed ) ) + "/" + Rtrim( ::oPedCliT:cSufPed )  + " - " +;
                              Dtoc( ::oPedCliT:dFecPed ),;
                              if( lMainDocument, 1, 0 ) )
   oNode:Cargo := { PED_CLI, ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed } 

Return ( oNode )

//----------------------------------------------------------------------------//

Method AddAlbaranCliente( lMainDocument, oTree )      

   local oNode := oTree:Add(  "Albarán cliente"                                                                                  + " - " +;
                              ::oAlbCliT:cSerAlb + "/" + Ltrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + Rtrim( ::oAlbCliT:cSufAlb )  + " - " +;
                              Dtoc( ::oAlbCliT:dFecAlb ),;
                              if( lMainDocument, 1, 0 ) )
   oNode:Cargo := { ALB_CLI, ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb } 

Return ( oNode )

//----------------------------------------------------------------------------//

Method AddAlbaranProveedorLinea( lMainDocument, oTree )

   local oNode
   local cDocNum  := ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb

   if aScan( ::aAlbProveedor, cDocNum ) == 0

      aAdd( ::aAlbProveedor, cDocNum )

      oNode       := oTree:Add(  "Albarán proveedor" + " - " +;
                                 ::oAlbPrvL:cSerAlb + "/" + Ltrim( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + Rtrim( ::oAlbPrvL:cSufAlb )  + " - " +;
                                 Dtoc( dFecAlbPrv( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT:cAlias ) ),;
                                 if( lMainDocument, 1, 0 ) )
      oNode:Cargo := { ALB_PRV, cDocNum }  

      Return ( oNode )

   end if

Return ( oTree )

//---------------------------------------------------------------------------//

Method AddAlbaranClienteLinea( lMainDocument, oTree )

   local oNode
   local cDocNum  := ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb

   if aScan( ::aAlbaranes, cDocNum ) == 0

      aAdd( ::aAlbaranes, cDocNum )

      oNode       := oTree:Add(  "Albarán cliente" + " - " +;
                                 ::oAlbCliL:cSerAlb + "/" + Ltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + Rtrim( ::oAlbCliL:cSufAlb )  + " - " +;
                                 Dtoc( dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) ),;
                                 if( lMainDocument, 1, 0 ) )
      oNode:Cargo := { ALB_CLI, cDocNum }  

      Return ( oNode )

   end if

Return ( oTree )

//----------------------------------------------------------------------------//

Method AddFacturaCliente( lMainDocument, oTree )

   local oNode
   local cDocNum  := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac

   if aScan( ::aFacturas, cDocNum ) == 0

      aAdd( ::aFacturas, cDocNum )

      oNode       := oTree:Add(  "Factura cliente"                                                                                  + " - " +;
                                 ::oFacCliT:cSerie + "/" + Ltrim( Str( ::oFacCliT:nNumFac ) ) + "/" + Rtrim( ::oFacCliT:cSufFac )   + " - " +;
                                 Dtoc( ::oFacCliT:dFecFac ),;
                                 if( lMainDocument, 1, 0 ) )

      oNode:Cargo := { FAC_CLI, ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac }  

      Return ( oNode ) 

   end if

Return ( oTree )

//----------------------------------------------------------------------------//

Method AddTicketCliente( lMainDocument, oTree )

   local oNode
   local cDocNum  := ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik

   if aScan( ::aTickets, cDocNum ) == 0

      aAdd( ::aTickets, cDocNum )

      oNode       := oTree:Add(  aTipTik( ::oTikCliT )                                                                        + " - " +;
                                 ::oTikCliT:cSerTik + "/" + Ltrim( ::oTikCliT:cNumTik ) + "/" + Rtrim( ::oTikCliT:cSufTik )   + " - " +;
                                 Dtoc( ::oTikCliT:dFecTik ),;
                                 if( lMainDocument, 1, 0 ) )
      oNode:Cargo := { TIK_CLI, ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik }  

      Return ( oNode )

   end if

Return ( oTree )

//----------------------------------------------------------------------------//