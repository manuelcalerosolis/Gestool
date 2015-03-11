#include "FiveWin.Ch" 
#include "Folder.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"
#include "Factu.ch" 

CLASS GeneraFacturasClientes FROM DialogBuilder
 
   DATA oDlg
   DATA oPag

   DATA nView

   DATA oBmp
   DATA oBtnPrv
   DATA oBtnNxt
   DATA oMetMsg
   DATA nMetMsg         INIT 0

   DATA oPeriodo
   DATA oClientes
   DATA oGruposClientes
   DATA oSeries
   DATA oAgruparCliente
   DATA oAgruparDireccion
   DATA oEntregados
   DATA oUnificarPago
   DATA oTotalizar

   DATA oBrwAlbaranes
   DATA oTreeTotales

   DATA lNodoActivo     INIT .f.
   DATA cClaveAnterior  INIT ""

   DATA oSerieFactura
   DATA cSerieFactura
   DATA nTipoSerie      INIT 1

   DATA cSerie
   DATA nNumero
   DATA cSufijo

   METHOD New()

   METHOD lOpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD NextPage()
   METHOD PrevPage()

   METHOD LoadAlbaranes()
   METHOD CreaFacturas()
   METHOD TestCreateTree()

   METHOD CreateTree()
   METHOD GetItemTree()
   METHOD GetImporteTree()
   METHOD GetItemCheck()

   METHOD SetTreeBrowse()
   METHOD SetTotalesDocumentos()

   METHOD ChangeBrowse()

   METHOD SetValueCheck()

   METHOD UpdatePadre()

   METHOD lIsFacturable()
   METHOD lValidaNodo()
   METHOD CreaNodo()
   METHOD AbreNodo()                   INLINE ( TreeBegin(), ::lNodoActivo   := .t. )
   METHOD CierraNodo()
   METHOD cClaveActual()
   METHOD AgregaNodo()

   METHOD InitClaves()
   METHOD setClaveAnterior( cValor )   INLINE ( ::cClaveAnterior := cValor )

   METHOD AppendFactura( oItem )
   METHOD AppendFacturaCabecera( oItem )
   METHOD AppendFacturaLineas( oItem )

   METHOD cTextoNodoPadre()

   METHOD cSerieFactura()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS GeneraFacturasClientes

   if ::lOpenFiles()

      ::oPeriodo           := GetPeriodo():Build( {            "idCombo" => 110,;
                                                               "idFechaInicio" => 120,;
                                                               "idFechaFin" => 130,;
                                                               "oContainer" => Self } )
   
      ::oGruposClientes    := GetRangoGrupoCliente():Build( {  "idAll" => 140,;
                                                               "idGetInicio" => 150,;
                                                               "idSayInicio" => 151,;
                                                               "idTextInicio" => 152,;
                                                               "idGetFin" => 160,;
                                                               "idSayFin" => 161,;
                                                               "idTextFin" => 162,;
                                                               "oContainer" => Self } )

      ::oClientes          := GetRangoCliente():Build( {       "idAll" => 170,;
                                                               "idGetInicio" => 180,;
                                                               "idSayInicio" => 181,;
                                                               "idTextInicio" => 182,;
                                                               "idGetFin" => 190,;
                                                               "idSayFin" => 191,;
                                                               "idTextFin" => 192,;
                                                               "oContainer" => Self } )

      ::oSeries            := GetRangoSeries():Build( {        "idTodas" => 310,;
                                                               "idNinguna" => 320,;
                                                               "idInicio" => 370,;
                                                               "oContainer" => Self } )

      ::oAgruparCliente    := ComponentCheck():New( 270, .t., Self )

      ::oAgruparDireccion  := ComponentCheck():New( 280, .f., Self )
      ::oAgruparDireccion:bWhen  := {|| ::oAgruparCliente:Value() }

      ::oEntregados        := ComponentCheck():New( 290, .f., Self )

      ::oUnificarPago      := ComponentCheck():New( 291, .f., Self )

      ::oTotalizar         := ComponentCheck():New( 292, .f., Self )

      ::Resource()

      ::CloseFiles()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD lOpenFiles() CLASS GeneraFacturasClientes

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::nView        := D():CreateView()

   D():Clientes( ::nView )

   D():GruposClientes( ::nView )

   D():Contadores( ::nView )

   D():AlbaranesClientes( ::nView )

   D():AlbaranesClientesLineas( ::nView )

   D():FacturasClientes( ::nView )

   D():FacturasClientesLineas( ::nView )

   D():Divisas( ::nView )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS GeneraFacturasClientes

   D():DeleteView( ::nView )

RETURN ( Self )

//---------------------------------------------------------------------------//  

METHOD Resource() CLASS GeneraFacturasClientes

   local nRadFec           := 1
   local dFecFac           := GetSysDate()

   ::cSerieFactura         := cNewSer( "nFacCli", D():Contadores( ::nView ) )
   
   DEFINE DIALOG ::oDlg RESOURCE "GENERARFACTURA"

   REDEFINE PAGES ::oPag ;
      ID       110 ;
      OF       ::oDlg ;
      DIALOGS  "GENFAC_03",;
               "GENFAC_04"

   REDEFINE BITMAP ::oBmp ;
      ID       600 ;
      RESOURCE "plantillas_automaticas_48_alpha" ;
      TRANSPARENT ;
      OF       ::oDlg 

   ::oPeriodo:Resource( ::oPag:aDialogs[1] )

   ::oGruposClientes:Resource( ::oPag:aDialogs[1] )

   ::oClientes:Resource( ::oPag:aDialogs[1] )

   ::oSeries:Resource( ::oPag:aDialogs[ 1 ] )

   REDEFINE RADIO nRadFec ;
      ID       210, 220 ;
      OF       ::oPag:aDialogs[ 1 ]

   REDEFINE GET dFecFac;
      WHEN     ( nRadFec == 1 ) ;
      SPINNER ;
      ID       230 ;
      OF       ::oPag:aDialogs[ 1 ]

   REDEFINE RADIO ::nTipoSerie ;
      ID       240, 241, 250 ;
      OF       ::oPag:aDialogs[ 1 ]

   REDEFINE GET ::oSerieFactura VAR ::cSerieFactura;
      ID       260 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( ::oSerieFactura ) );
      ON DOWN  ( DwSerie( ::oSerieFactura ) );
      VALID    ( ::cSerieFactura >= "A" .and. ::cSerieFactura <= "Z"  );
      OF       ::oPag:aDialogs[ 1 ]      

      ::oSerieFactura:bWhen := {|| ( ::nTipoSerie == 3 ) }

   ::oAgruparCliente:Resource( ::oPag:aDialogs[ 1 ] )

   ::oAgruparDireccion:Resource( ::oPag:aDialogs[ 1 ] )

   ::oEntregados:Resource( ::oPag:aDialogs[ 1 ] )

   ::oUnificarPago:Resource( ::oPag:aDialogs[ 1 ] )

   ::oTotalizar:Resource( ::oPag:aDialogs[ 1 ] )

   ::oMetMsg      := TApoloMeter():ReDefine( 120, { | u | if( pCount() == 0, ::nMetMsg, ::nMetMsg := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )          

   /*
   Segunda caja de diálogo-----------------------------------------------------
   */

   ::oBrwAlbaranes                  := IXBrowse():New( ::oPag:aDialogs[ 2 ] )

   ::oBrwAlbaranes:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwAlbaranes:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwAlbaranes:lVScroll         := .t.
   ::oBrwAlbaranes:lHScroll         := .t.
   ::oBrwAlbaranes:nMarqueeStyle    := 5

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := ""
      :bStrData                     := {|| "" }
      :bEditValue                   := {|| ::GetItemCheck() }
      :nWidth                       := 20
      :SetCheck( { "check2_16_2", "Nil16" } )
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := ""
      :nWidth                       := 480
      :bStrData                     := {|| ::GetItemTree() }
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Importes"
      :nWidth                       := 80
      :bStrData                     := {|| ::GetImporteTree() }
      :lHide                        := .f.
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :nFootStrAlign                := 1
   end with

   ::oBrwAlbaranes:bLDblClick       := {|| ::ChangeBrowse() }

   ::oBrwAlbaranes:CreateFromResource( 100 )

   REDEFINE BUTTON ::oBtnPrv ;
      ID       500;
      OF       ::oDlg ;
      ACTION   ( ::PrevPage() )

   REDEFINE BUTTON ::oBtnNxt ;
      ID       501;
      OF       ::oDlg ;
      ACTION   ( ::NextPage() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      CANCEL ;
      ACTION   ( ::oDlg:End() )

      ::oDlg:bStart  := {|| ::oBtnPrv:Hide() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::oBmp:End()

Return ( self )

//---------------------------------------------------------------------------//

METHOD NextPage()  CLASS GeneraFacturasClientes

   do case
   case ::oPag:nOption == 1

      ::LoadAlbaranes()

      if ::oTreeTotales:nCount() == 0
         MsgStop( "No existen registros en las condiciones solicitadas." )
         Return .f.
      end if

      ::oBtnPrv:Show()
   
      SetWindowText( ::oBtnNxt:hWnd, "&Terminar" )
   
      ::oPag:GoNext()

   case ::oPag:nOption == 2

      ::CreaFacturas()

      MsgInfo( "Proceso terminado con éxito." )

      ::oDlg:End()

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD PrevPage() CLASS GeneraFacturasClientes

   if ::oPag:nOption == 2
      SetWindowText( ::oBtnNxt:hWnd, "&Siguiente >" )
      ::oBtnPrv:Hide()
      ::oPag:GoPrev()
   end

Return ( self )

//---------------------------------------------------------------------------//

METHOD LoadAlbaranes() CLASS GeneraFacturasClientes

   ::CreateTree()

   if ::oTreeTotales:nCount() > 0

      ::SetTreeBrowse()
      ::SetTotalesDocumentos()

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetTreeBrowse() CLASS GeneraFacturasClientes

   if Empty( ::oBrwAlbaranes:oTree )

      ::oBrwAlbaranes:SetTree( ::oTreeTotales, { "Navigate_Minus_16", "Navigate_Plus_16", "Nil16" } ) 

      if len( ::oBrwAlbaranes:aCols ) > 1
         ::oBrwAlbaranes:aCols[ 1 ]:cHeader    := ""
         ::oBrwAlbaranes:aCols[ 1 ]:nWidth     := 20
      end if

   else

      ::oBrwAlbaranes:oTree     := ::oTreeTotales
      ::oBrwAlbaranes:oTreeItem := ::oTreeTotales:oFirst

   end if
      
   ::oBrwAlbaranes:Refresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetTotalesDocumentos() CLASS GeneraFacturasClientes

   local oItem
   local nCount   := 0
   local nTotAlb  := 0

   if !Empty( ::oBrwAlbaranes:oTree )

      oItem := ::oBrwAlbaranes:oTree:oFirst

      while oItem != nil
         
         if !Empty( oItem:oTree ) .and. oItem:Cargo[ 4 ]

            oItem:oTree:Eval( { | o | if( o:nLevel >= oItem:nLevel, nCount++, ), if( o:nLevel >= oItem:nLevel, ( nTotAlb := nTotAlb + o:Cargo[3] ), ) } )
            oItem:Cargo[2] := oItem:Cargo[2] + " [" + AllTrim( Str( nCount ) ) + if( nCount == 1, " doc.]", " docs.]" )
            oItem:Cargo[3] := nTotAlb

         end if   

         oItem = oItem:GetNext()
         nCount   := 0
         nTotAlb  := 0

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreateTree() CLASS GeneraFacturasClientes

   local nRec     := ( D():AlbaranesClientes( ::nView ) )->( Recno() )
   local nOrdAnt  := ( D():AlbaranesClientes( ::nView ) )->( OrdSetFocus( "LCLIOBR" ) )

   TreeInit()

   ::oTreeTotales                := TreeBegin( "Navigate_Minus_16", "Navigate_Plus_16" )

   ::InitClaves()

   ::oMetMsg:SetTotal( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyCount() ) )

   ( D():AlbaranesClientes( ::nView ) )->( dbGoTop() )

   while !( D():AlbaranesClientes( ::nView ) )->( Eof() )

      if ::lIsFacturable()

         if !::lValidaNodo()
            ::CierraNodo()
            ::CreaNodo()
            ::AbreNodo()
         end if

         ::AgregaNodo()

      end if

      ( D():AlbaranesClientes( ::nView ) )->( dbSkip() )

      ::oMetMsg:Set( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyNo() ) )

   end while

   ::CierraNodo()

   ::oMetMsg:Set( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyCount() ) )
   
   ( D():AlbaranesClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():AlbaranesClientes( ::nView ) )->( dbGoTo( nRec ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetItemTree() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem       := ::oBrwAlbaranes:oTreeItem:Cargo[ 2 ]
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetItemCheck() CLASS GeneraFacturasClientes

   local cItem    := .f.

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem       := ::oBrwAlbaranes:oTreeItem:Cargo[ 4 ]
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetImporteTree() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( ::oBrwAlbaranes:oTreeItem:Cargo[ 3 ], cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS GeneraFacturasClientes

   local nLevel

   if !Empty( ::oBrwAlbaranes:oTreeItem )

      if Empty( ::oBrwAlbaranes:oTreeItem:oTree )

         /*
         Es un nodo hijo-------------------------------------------------------
         */

         ::SetValueCheck( ::oBrwAlbaranes:oTreeItem, !::oBrwAlbaranes:oTreeItem:Cargo[ 4 ] )

         ::UpdatePadre( ::oBrwAlbaranes:oTreeItem )

      else

         /*
         Es un nodo padre------------------------------------------------------
         */

         nLevel := ::oBrwAlbaranes:oTreeItem:oTree:oFirst:nLevel

         ::oBrwAlbaranes:oTreeItem:oTree:Eval( { | oItem | If( oItem:nLevel >= nLevel, ::SetValueCheck( oItem, !::oBrwAlbaranes:oTreeItem:Cargo[ 4 ] ), ) } )

         ::SetValueCheck( ::oBrwAlbaranes:oTreeItem, !::oBrwAlbaranes:oTreeItem:Cargo[ 4 ] )

      end if

   end if 

   ::oBrwAlbaranes:Refresh()  
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD SetValueCheck( oItem, lValue ) CLASS GeneraFacturasClientes

   oItem:Cargo[ 4 ] := lValue

Return ( self )

//---------------------------------------------------------------------------//

METHOD UpdatePadre( oHijo ) CLASS GeneraFacturasClientes

   local lSel     := .f.
   local oParent  := oHijo:Parent( oHijo:nLevel )

   oParent:oTree:Eval( { | oItem | If( oItem:nLevel >= oParent:nLevel, iif( oItem:Cargo[ 4 ], lSel := .t., ), ) } )

   ::SetValueCheck( oParent, lSel )

Return ( self )

//---------------------------------------------------------------------------//

METHOD lIsFacturable() CLASS GeneraFacturasClientes

   if !::oPeriodo:InRange( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
      Return ( .f. )
   end if

   if !::oGruposClientes:InRange( ( D():AlbaranesClientes( ::nView ) )->cCodGrp )
      Return ( .f. )
   end if

   if !::oClientes:InRange( ( D():AlbaranesClientes( ::nView ) )->cCodCli )
      Return ( .f. )
   end if

   if !::oSeries:InRange( ( D():AlbaranesClientes( ::nView ) )->cSerAlb )
      Return ( .f. )
   end if

   if ::oEntregados:Value()
      if !( D():AlbaranesClientes( ::nView ) )->lEntregado
         Return ( .f. )
      end if   
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD InitClaves() CLASS GeneraFacturasClientes

   ::lNodoActivo     := .f.
   ::cClaveAnterior  := ""

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidaNodo() CLASS GeneraFacturasClientes

   local lValid         := .t.
   local cClaveActual   := ::cClaveActual()

   if ::cClaveAnterior != cClaveActual
      lValid            := .f.
   else
      if !::lNodoActivo
         lValid         := .f.
      end if   
   end if

   ::setClaveAnterior( cClaveActual )

Return ( lValid )

//---------------------------------------------------------------------------//

METHOD cClaveActual() CLASS GeneraFacturasClientes

   local cClave   := ""

   if !::oAgruparCliente:Value()
      cClave      := ( D():AlbaranesClientes( ::nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) + ( D():AlbaranesClientes( ::nView ) )->cSufAlb
      Return ( cClave )
   end if

   if ::oAgruparDireccion:Value()
      cClave   := ( D():AlbaranesClientes( ::nView ) )->cCodCli + ( D():AlbaranesClientes( ::nView ) )->cCodObr
   else
      cClave   := ( D():AlbaranesClientes( ::nView ) )->cCodCli
   end if

   if ::nTipoSerie == 1
      cClave   += ( D():AlbaranesClientes( ::nView ) )->cSerAlb
   end if 

Return ( cClave )

//---------------------------------------------------------------------------//

METHOD cTextoNodoPadre() CLASS GeneraFacturasClientes

   local cClave   := ""

   if !::oAgruparCliente:Value()
      cClave      := "Albarán: " + D():AlbaranesClientesIdTextShort( ::nView ) + " Cliente: " + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) + " - " + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cNomCli )
      Return ( cClave )
   end if

   if ::oAgruparDireccion:Value()
      cClave   := "Cliente: " + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) + " - " + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cNomCli ) + if( Empty( ( D():AlbaranesClientes( ::nView ) )->cCodObr ), "   Sin dirección", "   Dirección: " ) + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cCodObr )
   else
      cClave   := "Cliente: " + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) + " - " + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cNomCli )
   end if

Return ( cClave )

//---------------------------------------------------------------------------//

METHOD CreaNodo() CLASS GeneraFacturasClientes

   TreeAddItem( ::cClaveActual() ):Cargo := { ::cClaveActual(), ::cTextoNodoPadre() , "", .t. }

Return ( self )

//---------------------------------------------------------------------------//

METHOD CierraNodo() CLASS GeneraFacturasClientes

   if ::lNodoActivo
      TreeEnd()
      ::lNodoActivo := .f.
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD AgregaNodo() CLASS GeneraFacturasClientes

   local aDatos   := {  D():AlbaranesClientesId( ::nView ),; 
                        "Albarán: " + D():AlbaranesClientesIdTextShort( ::nView ) + " Fecha: " + dToc( ( D():AlbaranesClientes( ::nView ) )->dFecAlb ),;
                        ( D():AlbaranesClientes( ::nView ) )->nTotAlb,;
                        .t. }

   TreeAddItem( D():AlbaranesClientesId( ::nView ), "Detalles", , , , .f. ):Cargo := aDatos

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreaFacturas() CLASS GeneraFacturasClientes

   local oItem

   ::oDlg:Disable()

   if !Empty( ::oBrwAlbaranes:oTree )

      oItem := ::oBrwAlbaranes:oTree:oFirst

      while oItem != nil
         
         if !Empty( oItem:oTree ) .and. oItem:Cargo[ 4 ]

            ::AppendFactura( oItem )

         end if   

         oItem = oItem:GetNext()

      end while

   end if

   ::oDlg:Enable()

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFactura( oItem ) CLASS GeneraFacturasClientes

   ::AppendFacturaCabecera( oItem )

   oItem:oTree:Eval( { | o | If( o:nLevel >= oItem:nLevel, iif( o:Cargo[ 4 ], ::AppendFacturaLineas( o ), ), ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFacturaCabecera( oItem ) CLASS GeneraFacturasClientes

   MsgInfo( "Añado cabecera facturas para " + oItem:Cargo[ 1 ] )

   ::cSerie    := ::cSerieFactura()
   ::nNumero   := nNewDoc( ::cSerie, D():FacturasClientes( ::nView ), "NFACCLI", , D():Contadores( ::nView ) )
   ::cSufijo   := RetSufEmp()

            /*if nTipoSerie <= 1
               cSerAlb                 := ( dbfAlbCliT )->cSerAlb
            else
               cSerAlb                 := cSerieFactura
            end if

            nNewFac                    := nNewDoc( cSerAlb, dbfFacCliT, "NFACCLI", , dbfCount )
            nNumLin                    := 0
            cLinObr                    := Space( 1 )
            cCodCaj                    := oUser():cCaja()

            ( dbfFacCliT )->( dbAppend() )
            ( dbfFacCliT )->cSerie     := cSerAlb
            ( dbfFacCliT )->nNumFac    := nNewFac
            ( dbfFacCliT )->cSufFac    := cSufEmp
            ( dbfFacCliT )->cCodCaj    := cCodCaj
            ( dbfFacCliT )->cTurFac    := cCurSesion()
            ( dbfFacCliT )->cCodUsr    := cCurUsr()
            ( dbfFacCliT )->dFecCre    := Date()
            ( dbfFacCliT )->cTimCre    := Time()
            ( dbfFacCliT )->lImpAlb    := .t.
            ( dbfFacCliT )->cCodDlg    := RetFld( cCurUsr(), dbfUsr, "cCodDlg" )
            ( dbfFacCliT )->cCodAlm    := ( dbfAlbCliT )->cCodAlm

            if nRadFec == 1
               ( dbfFacCliT )->dFecFac := dFecFac
            else
               ( dbfFacCliT )->dFecFac := ( dbfAlbCliT )->dFecAlb
               dFecFac                 := ( dbfAlbCliT )->dFecAlb
            end if

            // Si no estamos agrupando por clientes anotamos el numero del albaran en la factura

            if !lGrpCli
               ( dbfFacCliT )->cNumAlb    := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
            end if

            // Asignando datos del cliente----------------------------------------

            cCodCli                       := ( dbfAlbCliT )->cCodCli
            cNomCli                       := ( dbfClient )->Titulo

            ( dbfFacCliT )->cCodCli       := cCodCli

            if ( dbfClient )->( dbSeek( cCodCli ) )
               ( dbfFacCliT )->cNomCli    := ( dbfClient )->Titulo
               ( dbfFacCliT )->cDirCli    := ( dbfClient )->Domicilio
               ( dbfFacCliT )->cPobCli    := ( dbfClient )->Poblacion
               ( dbfFacCliT )->cPrvCli    := ( dbfClient )->Provincia
               ( dbfFacCliT )->cPosCli    := ( dbfClient )->CodPostal
               ( dbfFacCliT )->cDniCli    := ( dbfClient )->Nif
               ( dbfFacCliT )->nTarifa    := Max( ( dbfClient )->nTarifa, 1 )
               lTotAlbCli                 := ( dbfClient )->lTotAlb
               cCodPgo                    := ( dbfClient )->CodPago
            end if

            // Recoje la forma de pago--------------------------------------------

            if lUniPgo
               ( dbfFacCliT )->cCodPago   := GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )
               cCodPgo                    := GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )
            else
               ( dbfFacCliT )->cCodPago   := oDbfTmp:cCodPgo
               cCodPgo                    := oDbfTmp:cCodPgo
            end if

            if Empty( ( dbfFacCliT )->nTarifa )
               ( dbfFacCliT )->nTarifa    := Max( ( dbfAlbCliT )->nTarifa, 1 )
            end if

            cCodAge                       := ( dbfAlbCliT )->cCodAge
            cDivFac                       := ( dbfAlbCliT )->cDivAlb
            nVdvFac                       := ( dbfAlbCliT )->nVdvAlb

            ( dbfFacCliT )->cCodAge       := ( dbfAlbCliT )->cCodAge
            ( dbfFacCliT )->cCodRut       := ( dbfAlbCliT )->cCodRut
            ( dbfFacCliT )->cCodTar       := ( dbfAlbCliT )->cCodTar
            ( dbfFacCliT )->cCodObr       := ( dbfAlbCliT )->cCodObr
            ( dbfFacCliT )->cDivFac       := ( dbfAlbCliT )->cDivAlb
            ( dbfFacCliT )->nVdvFac       := ( dbfAlbCliT )->nVdvAlb
            ( dbfFacCliT )->lRecargo      := ( dbfAlbCliT )->lRecargo
            ( dbfFacCliT )->lOperPv       := ( dbfAlbCliT )->lOperPv
            ( dbfFacCliT )->mComent       := ( dbfAlbCliT )->mComent
            ( dbfFacCliT )->mObserv       := ( dbfAlbCliT )->mObserv
            ( dbfFacCliT )->cCodTrn       := ( dbfAlbCliT )->cCodTrn
            ( dbfFacCliT )->cCodPro       := cProCnt( ( dbfAlbCliT )->cSerAlb )
            ( dbfFacCliT )->lIvaInc       := ( dbfAlbCliT )->lIvaInc
            ( dbfFacCliT )->lSndDoc       := .t.

            // Informamos de la factura que de ha generado------------------------

            aAdd( aMsg, {.t., "Factura generada : " + ( dbfFacCliT )->cSerie + "/" + Alltrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac } )

         end if

         // Descuentos globales------------------------------------------------

         if !empty( oDbfTmp:nPctDto1 ) .and. empty( ( dbfFacCliT )->cDtoEsp )
            ( dbfFacCliT )->cDtoEsp := Padr( "General", 50 )
            ( dbfFacCliT )->nDtoEsp := oDbfTmp:nPctDto1
         end if 

         if !empty( oDbfTmp:nPctDto2 ) .and. empty( ( dbfFacCliT )->cDpp )
            ( dbfFacCliT )->cDpp    := Padr( "Pronto pago", 50 )
            ( dbfFacCliT )->nDpp    := oDbfTmp:nPctDto2
         end if 

         if !empty( oDbfTmp:nPctDto3 ) .and. empty( ( dbfFacCliT )->cDtoUno )
            ( dbfFacCliT )->cDtoUno := Space( 50 ) 
            ( dbfFacCliT )->nDtoUno := oDbfTmp:nPctDto3
         end if 

         if !empty( oDbfTmp:nPctDto4 ) .and. empty( ( dbfFacCliT )->cDtoDos )
            ( dbfFacCliT )->cDtoDos := Space(50)
            ( dbfFacCliT )->nDtoDos := oDbfTmp:nPctDto4
         end if 

         /*
         Marca para no volver a facturar el albaran____________________________
         */

         //SetFacturadoAlbaranCliente( .t., , dbfAlbCliT, dbfAlbCliL, dbfAlbCliS, ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac )



Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFacturaLineas( oItem ) CLASS GeneraFacturasClientes

   MsgInfo( "Añado lineas facturas para " + oItem:Cargo[ 1 ] )

Return ( self )

//---------------------------------------------------------------------------//

METHOD cSerieFactura() CLASS GeneraFacturasClientes

   local cSerie := ""

Return cSerie

//---------------------------------------------------------------------------//

METHOD TestCreateTree() CLASS GeneraFacturasClientes

   TreeInit()

   ::oTreeTotales                := TreeBegin( "Navigate_Minus_16", "Navigate_Plus_16" )
   
   /*
   Primer registro-------------------------------------------------------------
   */

   TreeAddItem( "Cliente 0000000" ):Cargo := { "0000000", "Cliente 0000000 (2 Docs.)", "", .t., "" }

   TreeBegin()

   TreeAddItem( "A/1", "Detalles", , , , .f. ):Cargo := { "A        1  ", "A/1 28/01/2015", 250, .t., "000" }
   TreeAddItem( "A/2", "Detalles", , , , .f. ):Cargo := { "A        2  ", "A/2 31/01/2015", 350, .t., "000" }

   TreeEnd()

   /*
   Segundo registro------------------------------------------------------------
   */

   TreeAddItem( "Cliente 0000001" ):Cargo := { "0000001", "Cliente 0000001 (2 Docs.)", "", .t., "" }

   TreeBegin()

   TreeAddItem( "A/3", "Detalles", , , , .f. ):Cargo := { "A        3  ", "A/3 03/02/2015", 250, .t., "000" }
   TreeAddItem( "A/4", "Detalles", , , , .f. ):Cargo := { "A        4  ", "A/4 04/02/2015", 350, .t., "000" }

   TreeEnd()

Return ( self )

//---------------------------------------------------------------------------//