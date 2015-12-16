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
   DATA nMetMsg                     INIT 0

   DATA oPeriodo
   DATA oClientes
   DATA oGruposClientes
   DATA oSeries
   DATA oAgruparCliente
   DATA oAgruparDireccion
   DATA oAgruparDescuentos
   DATA oEntregados
   DATA oUnificarPago
   DATA oTotalizar
   DATA oImpuestosIncluidos

   DATA oBrwAlbaranes
   DATA oTreeTotales

   DATA lNodoActivo                 INIT .f.
   DATA cClaveAnterior              INIT ""

   DATA oSerieFactura
   DATA cSerieFactura
   DATA nTipoSerie                  INIT 1

   DATA nRadFec                     INIT 1
   DATA dFecFac                     INIT GetSysDate()

   DATA cSerie
   DATA nNumero
   DATA cSufijo

   METHOD getFacturaId()            INLINE ( ::cSerie + Str( ::nNumero ) + ::cSufijo )

   DATA nNumLin                     INIT 1

   DATA lMedia                      INIT .f.

   DATA nBrutoAlbaran               INIT 0
   DATA nDescuentoAcumulado1        INIT 0
   DATA nDescuentoAcumulado2        INIT 0
   DATA nDescuentoAcumulado3        INIT 0
   DATA nDescuentoAcumulado4        INIT 0

   DATA nDescuento1                 INIT 0
   DATA nDescuento2                 INIT 0
   DATA nDescuento3                 INIT 0
   DATA nDescuento4                 INIT 0

   DATA nNumPgo                     INIT 1

   DATA aListaAlbaranes             INIT {}

   METHOD New()

   METHOD lOpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD NextPage()
   METHOD PrevPage()

   METHOD LoadAlbaranes()
   METHOD CreaFacturas()

   METHOD CreateListaAlbaranes()
   METHOD OrdenaListaAlbaranes()

   METHOD CreateTree()
   METHOD GetItemTree()
   METHOD GetImporteTree()
   METHOD GetItemCheck()
   METHOD GetFpagoTree()
   METHOD GetDto1()
   METHOD GetDto2()
   METHOD GetDto3()
   METHOD GetDto4()

   METHOD SetTreeBrowse()
   METHOD SetTotalesDocumentos()

   METHOD ChangeBrowse()

   METHOD SetValueCheck()

   METHOD UpdatePadre()

   METHOD isFechaFacturaActual()       INLINE ( ::nRadFec == 1 )

   METHOD lIsFacturable()
   METHOD lValidaNodo()
   METHOD CreaNodo()
   METHOD AbreNodo()                   INLINE ( TreeBegin(), ::lNodoActivo   := .t. )
   METHOD CierraNodo()
   METHOD cClaveAlbaran()
   METHOD AgregaNodo()
   METHOD ExisteNodo( hAlbaran )

   METHOD InitClaves()
   METHOD setClaveAnterior( cValor )   INLINE ( ::cClaveAnterior := cValor )

   METHOD AppendFactura( oItem )
   METHOD AppendFacturaCabecera( oItem )
   METHOD AppendFacturaLineas( oItem )

   METHOD cTextoNodoPadre( hCargo )
   METHOD cTextoNodoHijo( hCargo )

   METHOD GetHashAlbaranes( aTotal )    INLINE ( { "clave" => ::cClaveAlbaran(),;
                                                   "seleccionado" => .t.,;
                                                   "id" => D():AlbaranesClientesId( ::nView ),;
                                                   "textoid" => D():AlbaranesClientesIdTextShort( ::nView ),;
                                                   "cliente" => ( D():AlbaranesClientes( ::nView ) )->cCodCli,;
                                                   "nombre" => ( D():AlbaranesClientes( ::nView ) )->cNomCli,;
                                                   "serie" => ( D():AlbaranesClientes( ::nView ) )->cSerAlb,;
                                                   "formapago" => ( D():AlbaranesClientes( ::nView ) )->cCodPago,;
                                                   "direccion" => ( D():AlbaranesClientes( ::nView ) )->cCodObr,;
                                                   "fecha" => ( D():AlbaranesClientes( ::nView ) )->dFecAlb,;
                                                   "total" => ( D():AlbaranesClientes( ::nView ) )->nTotAlb,;
                                                   "pDto1" => ( D():AlbaranesClientes( ::nView ) )->nDtoEsp,;
                                                   "pDto2" => ( D():AlbaranesClientes( ::nView ) )->nDpp,;
                                                   "pDto3" => ( D():AlbaranesClientes( ::nView ) )->nDtoUno,;
                                                   "pDto4" => ( D():AlbaranesClientes( ::nView ) )->nDtoDos,;
                                                   "sualbaran" => ( D():AlbaranesClientes( ::nView ) )->cCodSuAlb,;
                                                   "documentos" => "",;
                                                   "nbruto" => aTotal[16],;
                                                   "ndto1" => aTotal[12],;
                                                   "ndto2" => aTotal[13],;
                                                   "ndto3" => aTotal[14],;
                                                   "ndto4" => aTotal[15] } )

   METHOD getSerie( oITem )
   METHOD getFormaPago( oItem )
   METHOD getDireccion( oItem )
   METHOD getFecha( oItem )

   METHOD getDescuentosFactura( oItem )
   METHOD lMediaDescuento( oItem )
   METHOD GetMediaDescuento( oItem )
   METHOD CompruebaDescuento( hash )

   METHOD initAcuDto()                          INLINE ( ::nBrutoAlbaran := 0, ::nDescuentoAcumulado1 := 0, ::nDescuentoAcumulado2 := 0, ::nDescuentoAcumulado3 := 0, ::nDescuentoAcumulado4 := 0 )
   METHOD initDescuentosTotales()               INLINE ( ::nDescuento1 := nil, ::nDescuento2 := nil, ::nDescuento3 := nil, ::nDescuento4 := nil )
   METHOD initNumeroLinea()                     INLINE ( ::nNumLin := 1 )
   METHOD initNumeroPago()                      INLINE ( ::nNumPgo := 1 )

   METHOD setDescuento( hash )
   METHOD AcumulaDatosAlbaran( hash )
   METHOD CalculaMediaDescuentos()
   METHOD appendCabeceraAlbaran( oItem )
   METHOD appendLineasAlbaran( oItem )
   METHOD SetTotalesFactura( oItem )
   METHOD AppendLineaTotal( oItem )

   METHOD GeneraPagos( oItem )
   METHOD EstadoFactura( oItem )

   METHOD appendPagosAbaranes( oItem )

   METHOD setEstadoAlbaran( oItem )
   
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

      ::oAgruparDireccion        := ComponentCheck():New( 280, .f., Self )
      ::oAgruparDireccion:bWhen  := {|| ::oAgruparCliente:Value() }

      ::oImpuestosIncluidos      := ComponentCheck():New( 294, lImpuestosIncluidos(), Self )

      ::oAgruparDescuentos := ComponentCheck():New( 293, .f., Self )

      ::oEntregados        := ComponentCheck():New( 290, .f., Self )

      ::oUnificarPago      := ComponentCheck():New( 291, .t., Self )

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

      D():AlbaranesClientesSeries( ::nView )

      D():AlbaranesClientesCobros( ::nView )

      D():FacturasClientes( ::nView )

      D():FacturasClientesLineas( ::nView )

      D():FacturasClientesSeries( ::nView )

      D():FacturasClientesCobros( ::nView )
      
      D():AnticiposClientes( ::nView )

      D():Divisas( ::nView )

      D():TiposIva( ::nView )

      D():FormasPago( ::nView )

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

   ::cSerieFactura         := cNewSer( "nFacCli", D():Contadores( ::nView ) )

   if Empty( ::cSerieFactura )
      ::cSerieFactura      := "A"
   end if

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

   REDEFINE RADIO ::nRadFec ;
      ID       210, 220 ;
      OF       ::oPag:aDialogs[ 1 ]

   REDEFINE GET ::dFecFac;
      WHEN     ( ::isFechaFacturaActual() ) ;
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

   ::oImpuestosIncluidos:Resource( ::oPag:aDialogs[ 1 ] )

   ::oEntregados:Resource( ::oPag:aDialogs[ 1 ] )

   ::oUnificarPago:Resource( ::oPag:aDialogs[ 1 ] )

   ::oTotalizar:Resource( ::oPag:aDialogs[ 1 ] )

   ::oAgruparDescuentos:Resource( ::oPag:aDialogs[ 1 ] )

   ::oMetMsg      := TApoloMeter():ReDefine( 120, { | u | if( pCount() == 0, ::nMetMsg, ::nMetMsg := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )          

   /*
   Segunda caja de diálogo-----------------------------------------------------
   */

   ::oBrwAlbaranes                  := IXBrowse():New( ::oPag:aDialogs[ 2 ] )

   ::oBrwAlbaranes:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwAlbaranes:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwAlbaranes:lVScroll         := .t.
   ::oBrwAlbaranes:lHScroll         := .t.
   ::oBrwAlbaranes:nMarqueeStyle    := 6

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "S."
      :bStrData                     := {|| "" }
      :bEditValue                   := {|| ::GetItemCheck() }
      :nWidth                       := 20
      :SetCheck( { "check2_16_2", "Nil16" } )
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Concepto"
      :nWidth                       := 480
      :bStrData                     := {|| ::GetItemTree() }
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Pago"
      :nWidth                       := 40
      :bStrData                     := {|| ::GetFpagoTree() }
      :lHide                        := .t.
   end with
   
   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Dto. 1"
      :nWidth                       := 40
      :bStrData                     := {|| ::GetDto1() }
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Dto. 2"
      :nWidth                       := 40
      :bStrData                     := {|| ::GetDto2() }
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Dto. 3"
      :nWidth                       := 40
      :bStrData                     := {|| ::GetDto3() }
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Dto. 4"
      :nWidth                       := 40
      :bStrData                     := {|| ::GetDto4() }
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Importes"
      :nWidth                       := 80
      :bStrData                     := {|| ::GetImporteTree() }
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
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

      if Empty( ::oTreeTotales )
         MsgStop( "No existen registros en las condiciones solicitadas." )
         Return .f.
      end if

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

   ::CreateListaAlbaranes()
   
   ::OrdenaListaAlbaranes()

   if Len( ::aListaAlbaranes ) > 0
   
      ::CreateTree()

      if ::oTreeTotales:nCount() > 0

         ::SetTreeBrowse()
         ::SetTotalesDocumentos()

      end if

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
   local cTexto   := ""

   if !Empty( ::oBrwAlbaranes:oTree )

      oItem := ::oBrwAlbaranes:oTree:oFirst

      while oItem != nil
         
         if !Empty( oItem:oTree )

            oItem:oTree:Eval( { | o | if( o:nLevel >= oItem:nLevel, nCount++, ) } )
            cTexto := " [" + AllTrim( Str( nCount ) ) + if( nCount > 1, " docs.]", " doc.]" )
            hSet( oItem:Cargo, "documentos", cTexto )

         end if   

         oItem = oItem:GetNext()
         nCount   := 0

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreateListaAlbaranes() CLASS GeneraFacturasClientes

   local nRec           := ( D():AlbaranesClientes( ::nView ) )->( Recno() )
   local nOrdAnt        := ( D():AlbaranesClientes( ::nView ) )->( OrdSetFocus( "LCLIOBR" ) )
   local aTotAlbaran

   ::aListaAlbaranes    := {}

   ::oMetMsg:SetTotal( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyCount() ) )

   ( D():AlbaranesClientes( ::nView ) )->( dbGoTop() )

   while !( D():AlbaranesClientes( ::nView ) )->( Eof() )

      if ::lIsFacturable()

         aTotAlbaran    := aTotAlbCli( D():AlbaranesClientesId( ::nView ), D():AlbaranesClientes( ::nView ), D():AlbaranesClientesLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )

         aAdd( ::aListaAlbaranes, ::GetHashAlbaranes( aTotAlbaran ) )

      end if

      ( D():AlbaranesClientes( ::nView ) )->( dbSkip() )

      ::oMetMsg:Set( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyNo() ) )

   end while

   ::oMetMsg:Set( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyCount() ) )
   
   ( D():AlbaranesClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():AlbaranesClientes( ::nView ) )->( dbGoTo( nRec ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD OrdenaListaAlbaranes() CLASS GeneraFacturasClientes

   aeval( ::aListaAlbaranes, {|x| msgAlert( hGet( x, "clave" ) } ) )

   if len( ::aListaAlbaranes ) > 1
      aSort( ::aListaAlbaranes, , , {|x, y| hGet( x, "clave" ) < hGet( y, "clave" ) }  )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreateTree() CLASS GeneraFacturasClientes

   local hAlbaran

   TreeInit()

   ::oTreeTotales                := TreeBegin( "Navigate_Minus_16", "Navigate_Plus_16" )

   ::InitClaves()

   for each hAlbaran in ::aListaAlbaranes

      ::ExisteNodo( hAlbaran )

      ::AgregaNodo( hAlbaran )

   next

   ::CierraNodo()

Return ( self )

//---------------------------------------------------------------------------//

METHOD ExisteNodo( hAlbaran ) CLASS GeneraFacturasClientes

   if !::lValidaNodo( hAlbaran )
      ::CierraNodo()
      ::CreaNodo( hAlbaran )
      ::AbreNodo()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetItemTree() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      if Empty( ::oBrwAlbaranes:oTreeItem:oTree )
         cItem       := ::cTextoNodoHijo( ::oBrwAlbaranes:oTreeItem:Cargo )
      else
         cItem       := ::cTextoNodoPadre( ::oBrwAlbaranes:oTreeItem:Cargo )
      end if   

   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetItemCheck() CLASS GeneraFacturasClientes

   local cItem    := .f.

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem       := hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "seleccionado" )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetFpagoTree() CLASS GeneraFacturasClientes

   local cItem    := .f.

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem       := hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "formapago" )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetImporteTree() CLASS GeneraFacturasClientes

   local cItem    := ""
   local nTotAlb  := 0

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      if Empty( ::oBrwAlbaranes:oTreeItem:oTree )
         cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "total" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
      else
         ::oBrwAlbaranes:oTreeItem:oTree:Eval( { | o | if( o:nLevel >= ::oBrwAlbaranes:oTreeItem:nLevel, ( nTotAlb := nTotAlb + hGet( o:Cargo, "total" ) ), ) } )
         cItem    := Trans( nTotAlb, cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
      end if
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto1() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "pDto1" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto2() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "pDto2" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto3() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "pDto3" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto4() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "pDto4" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
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

         ::SetValueCheck( ::oBrwAlbaranes:oTreeItem, !hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "seleccionado" ) )
         
         ::UpdatePadre( ::oBrwAlbaranes:oTreeItem )

      else

         /*
         Es un nodo padre------------------------------------------------------
         */

         nLevel := ::oBrwAlbaranes:oTreeItem:oTree:oFirst:nLevel
         
         ::oBrwAlbaranes:oTreeItem:oTree:Eval( { | oItem | If( oItem:nLevel >= nLevel, ::SetValueCheck( oItem, !hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "seleccionado" ) ), ) } )

         ::SetValueCheck( ::oBrwAlbaranes:oTreeItem, !hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "seleccionado" ) )

      end if

   end if 

   ::oBrwAlbaranes:Refresh()  
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD SetValueCheck( oItem, lValue ) CLASS GeneraFacturasClientes

   hSet( oItem:Cargo, "seleccionado", lValue )

Return ( self )

//---------------------------------------------------------------------------//

METHOD UpdatePadre( oHijo ) CLASS GeneraFacturasClientes

   local lSel     := .f.
   local oParent  := oHijo:Parent( oHijo:nLevel )

   oParent:oTree:Eval( { | oItem | If( oItem:nLevel >= oParent:nLevel, iif( hGet( oItem:Cargo, "seleccionado" ), lSel := .t., ), ) } )

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

   if !( ::oImpuestosIncluidos:Value() == ( D():AlbaranesClientes( ::nView ) )->lIvaInc )
      Return( .f. )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD InitClaves() CLASS GeneraFacturasClientes

   ::lNodoActivo     := .f.
   ::cClaveAnterior  := ""

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidaNodo( hCargo ) CLASS GeneraFacturasClientes

   local lValid         := .t.
   local cClaveActual   := hGet( hCargo, "clave" )

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

METHOD cClaveAlbaran() CLASS GeneraFacturasClientes

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

   if ::oUnificarPago:Value()
      cClave   += ( D():AlbaranesClientes( ::nView ) )->cCodPago
   end if

   if !::isFechaFacturaActual()
      cClave   += dToc( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
   end if 

   if ::oAgruparDescuentos:Value()
      cClave   += Str( ( D():AlbaranesClientes( ::nView ) )->nDtoEsp )
      cClave   += Str( ( D():AlbaranesClientes( ::nView ) )->nDpp )
      cClave   += Str( ( D():AlbaranesClientes( ::nView ) )->nDtoUno )
      cClave   += Str( ( D():AlbaranesClientes( ::nView ) )->nDtoDos )
   end if

Return ( cClave )

//---------------------------------------------------------------------------//

METHOD cTextoNodoPadre( hCargo ) CLASS GeneraFacturasClientes

   local cClave   := ""

   if !::oAgruparCliente:Value()
      cClave      := "Albarán: " + hGet( hCargo, "textoid" ) + " Cliente: " + AllTrim( hGet( hCargo, "nombre" ) ) + hGet( hCargo, "documentos" )
      Return ( cClave )
   end if

   if ::oAgruparDireccion:Value()
      cClave   := "Cliente: " + AllTrim( hGet( hCargo, "cliente" ) ) + " - " + AllTrim( hGet( hCargo, "nombre" ) ) + if( Empty( hGet( hCargo, "direccion" ) ), "   Sin dirección", "   Dirección: " ) + AllTrim( hGet( hCargo, "direccion" ) ) + hGet( hCargo, "documentos" )
   else
      cClave   := "Cliente: " + AllTrim( hGet( hCargo, "cliente" ) ) + " - " + AllTrim( hGet( hCargo, "nombre" ) ) + hGet( hCargo, "documentos" )
   end if

Return ( cClave )

//---------------------------------------------------------------------------//

METHOD cTextoNodoHijo( hCargo ) CLASS GeneraFacturasClientes

   local cClave   := ""
   
   cClave      := "Albarán: " + hGet( hCargo, "textoid" ) + " Fecha: " + dtoc( hGet( hCargo, "fecha" ) ) + " Cliente: " + AllTrim( hGet( hCargo, "nombre" ) )

Return ( cClave )

//---------------------------------------------------------------------------//

METHOD CreaNodo( hCargo ) CLASS GeneraFacturasClientes

   local h :=  {  "clave" => hGet( hCargo, "clave" ),;
                  "seleccionado" => .t.,;
                  "id" => hGet( hCargo, "id" ),;
                  "textoid" => hGet( hCargo, "textoid" ),;
                  "cliente" => hGet( hCargo, "cliente" ),;
                  "nombre" => hGet( hCargo, "nombre" ),;
                  "serie" => hGet( hCargo, "serie" ),;
                  "formapago" => hGet( hCargo, "formapago" ),;
                  "direccion" => hGet( hCargo, "direccion" ),;
                  "fecha" => hGet( hCargo, "fecha" ),;
                  "total" => hGet( hCargo, "total" ),;
                  "sualbaran" => hGet( hCargo, "sualbaran" ),;
                  "documentos" => "" }

   TreeAddItem( hGet( hCargo, "clave" ) ):Cargo := h

Return ( self )

//---------------------------------------------------------------------------//

METHOD CierraNodo() CLASS GeneraFacturasClientes

   if ::lNodoActivo
      TreeEnd()
      ::lNodoActivo := .f.
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD AgregaNodo( hCargo ) CLASS GeneraFacturasClientes

   TreeAddItem( hGet( hCargo, "id" ) ):Cargo := hCargo

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreaFacturas() CLASS GeneraFacturasClientes

   local oItem

   ::oDlg:Disable()

   if !Empty( ::oBrwAlbaranes:oTree )

      oItem := ::oBrwAlbaranes:oTree:oFirst

      while oItem != nil
         
         if !Empty( oItem:oTree ) .and. hGet( oItem:Cargo, "seleccionado" )

            ::AppendFactura( oItem )

         end if   

         oItem = oItem:GetNext()

      end while

   end if

   ::oDlg:Enable()

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFactura( oItem ) CLASS GeneraFacturasClientes

   ::getDescuentosFactura( oItem )

   ::AppendFacturaCabecera( oItem )

   ::initNumeroLinea()

   ::initNumeroPago()

   oItem:oTree:Eval( { | o | if( o:nLevel >= oItem:nLevel, iif( hGet( o:Cargo, "seleccionado" ), ::AppendFacturaLineas( o ), ), ) } )

   ::SetTotalesFactura( oItem )

   ::GeneraPagos( oItem )

   ::EstadoFactura( oItem )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDescuentosFactura( oItem ) CLASS GeneraFacturasClientes

   /*
   inicializamos en cada factura-----------------------------------------------
   */

   ::initDescuentosTotales()

   ::lMediaDescuento( oItem )

   if !::lMedia
      ::setDescuento( oItem:Cargo )
   else
      ::GetMediaDescuento( oItem )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD lMediaDescuento( oItem ) CLASS GeneraFacturasClientes

   ::initDescuentosTotales()

   oItem:oTree:Eval( { | o | if( o:nLevel >= oItem:nLevel, ::CompruebaDescuento( o ), ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setDescuento( hash ) CLASS GeneraFacturasClientes

   if isNil( ::nDescuento1 )
      ::nDescuento1 := hGet( hash:Cargo, "pDto1" )
   end if

   if isNil( ::nDescuento2 )
      ::nDescuento2 := hGet( hash:Cargo, "pDto2" )
   end if

   if isNil( ::nDescuento3 )
      ::nDescuento3 := hGet( hash:Cargo, "pDto3" )
   end if

   if isNil( ::nDescuento4 )
      ::nDescuento4 := hGet( hash:Cargo, "pDto4" )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CompruebaDescuento( hash ) CLASS GeneraFacturasClientes

   ::lMedia       := .f.

   ::setDescuento( hash )

   //Comprobamos que sean iguales todos los descuentos----------------------

   if ::nDescuento1 != hGet( hash:Cargo, "pDto1" ) .or.;
      ::nDescuento2 != hGet( hash:Cargo, "pDto2" ) .or.;
      ::nDescuento3 != hGet( hash:Cargo, "pDto3" ) .or.;
      ::nDescuento4 != hGet( hash:Cargo, "pDto4" )

      ::lMedia    := .t.

   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD GetMediaDescuento( oItem ) CLASS GeneraFacturasClientes

   oItem:oTree:Eval( { | o | if( o:nLevel >= oItem:nLevel, ::AcumulaDatosAlbaran( o ), ) } )

   ::CalculaMediaDescuentos()

Return ( self )

//---------------------------------------------------------------------------//

METHOD AcumulaDatosAlbaran( hash ) CLASS GeneraFacturasClientes

   ::nBrutoAlbaran         += hGet( hash:Cargo, "nbruto" )
   ::nDescuentoAcumulado1  += hGet( hash:Cargo, "ndto1" )
   ::nDescuentoAcumulado2  += hGet( hash:Cargo, "ndto2" )
   ::nDescuentoAcumulado3  += hGet( hash:Cargo, "ndto3" )
   ::nDescuentoAcumulado4  += hGet( hash:Cargo, "ndto4" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD CalculaMediaDescuentos() CLASS GeneraFacturasClientes

   ::nDescuento1    := ( ::nDescuentoAcumulado1 * 100 ) / ::nBrutoAlbaran
   ::nDescuento2    := ( ::nDescuentoAcumulado2 * 100 ) / ( ::nBrutoAlbaran - ::nDescuentoAcumulado1 )
   ::nDescuento3    := ( ::nDescuentoAcumulado3 * 100 ) / ( ::nBrutoAlbaran - ::nDescuentoAcumulado1 - ::nDescuentoAcumulado2 )
   ::nDescuento4    := ( ::nDescuentoAcumulado4 * 100 ) / ( ::nBrutoAlbaran - ::nDescuentoAcumulado1 - ::nDescuentoAcumulado2 - ::nDescuentoAcumulado3 )

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD AppendFacturaCabecera( oItem ) CLASS GeneraFacturasClientes

   local cCodCaj
   local cCodCli
   
   ::cSerie       := ::GetSerie( oItem )
   ::nNumero      := nNewDoc( ::cSerie, D():FacturasClientes( ::nView ), "NFACCLI", , D():Contadores( ::nView ) )
   ::cSufijo      := RetSufEmp()

   cCodCaj        := oUser():cCaja()
   cCodCli        := hGet( oItem:Cargo, "cliente" )

   ( D():FacturasClientes( ::nView ) )->( dbAppend() )
   ( D():FacturasClientes( ::nView ) )->cSerie        := ::cSerie
   ( D():FacturasClientes( ::nView ) )->nNumFac       := ::nNumero
   ( D():FacturasClientes( ::nView ) )->cSufFac       := ::cSufijo
   ( D():FacturasClientes( ::nView ) )->cCodCaj       := cCodCaj
   ( D():FacturasClientes( ::nView ) )->cTurFac       := cCurSesion()
   ( D():FacturasClientes( ::nView ) )->cCodUsr       := cCurUsr()
   ( D():FacturasClientes( ::nView ) )->dFecCre       := Date()
   ( D():FacturasClientes( ::nView ) )->cTimCre       := Time()
   ( D():FacturasClientes( ::nView ) )->lImpAlb       := .t.
   ( D():FacturasClientes( ::nView ) )->cCodDlg       := oUser():cDelegacion()
   ( D():FacturasClientes( ::nView ) )->cCodObr       := ::GetDireccion( oItem )
   ( D():FacturasClientes( ::nView ) )->cCodPago      := ::GetFormaPago( oItem )
   ( D():FacturasClientes( ::nView ) )->cCodAlm       := oUser():cAlmacen()
   ( D():FacturasClientes( ::nView ) )->dFecFac       := ::GetFecha( oItem )
   ( D():FacturasClientes( ::nView ) )->cDivFac       := cDivEmp()
   ( D():FacturasClientes( ::nView ) )->nVdvFac       := nChgDiv( cDivEmp(), D():Divisas( ::nView ) )
   ( D():FacturasClientes( ::nView ) )->lSndDoc       := .t.
   ( D():FacturasClientes( ::nView ) )->lIvaInc       := ::oImpuestosIncluidos:Value()
   ( D():FacturasClientes( ::nView ) )->cDtoEsp       := Padr( "General", 50 )
   ( D():FacturasClientes( ::nView ) )->cDpp          := Padr( "Pronto pago", 50 )
   ( D():FacturasClientes( ::nView ) )->cDtoUno       := Space( 50 ) 
   ( D():FacturasClientes( ::nView ) )->cDtoDos       := Space(50)
   ( D():FacturasClientes( ::nView ) )->nDtoEsp       := ::nDescuento1
   ( D():FacturasClientes( ::nView ) )->nDpp          := ::nDescuento2
   ( D():FacturasClientes( ::nView ) )->nDtoUno       := ::nDescuento3
   ( D():FacturasClientes( ::nView ) )->nDtoDos       := ::nDescuento4
   
   // Asignando datos del cliente----------------------------------------

   ( D():FacturasClientes( ::nView ) )->cCodCli       := cCodCli

   if ( D():Clientes( ::nView ) )->( dbSeek( cCodCli ) )
      ( D():FacturasClientes( ::nView ) )->cNomCli    := ( D():Clientes( ::nView ) )->Titulo
      ( D():FacturasClientes( ::nView ) )->cDirCli    := ( D():Clientes( ::nView ) )->Domicilio
      ( D():FacturasClientes( ::nView ) )->cPobCli    := ( D():Clientes( ::nView ) )->Poblacion
      ( D():FacturasClientes( ::nView ) )->cPrvCli    := ( D():Clientes( ::nView ) )->Provincia
      ( D():FacturasClientes( ::nView ) )->cPosCli    := ( D():Clientes( ::nView ) )->CodPostal
      ( D():FacturasClientes( ::nView ) )->cDniCli    := ( D():Clientes( ::nView ) )->Nif
      ( D():FacturasClientes( ::nView ) )->nTarifa    := Max( ( D():Clientes( ::nView ) )->nTarifa, 1 )
      ( D():FacturasClientes( ::nView ) )->lOperPv    := ( D():Clientes( ::nView ) )->lPntVer
      ( D():FacturasClientes( ::nView ) )->lRecargo   := ( D():Clientes( ::nView ) )->lReq
      ( D():FacturasClientes( ::nView ) )->cCodRut    := ( D():Clientes( ::nView ) )->cCodRut
   end if

   if !::oAgruparCliente:Value()

      if dbSeekInOrd( hGet( oItem:Cargo, "id" ), "nNumAlb", D():AlbaranesClientes( ::nView ) )

         ( D():FacturasClientes( ::nView ) )->cNumAlb   := ( D():AlbaranesClientes( ::nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) + ( D():AlbaranesClientes( ::nView ) )->cSufAlb
         ( D():FacturasClientes( ::nView ) )->cCodAge   := ( D():AlbaranesClientes( ::nView ) )->cCodAge
         ( D():FacturasClientes( ::nView ) )->cCodRut   := ( D():AlbaranesClientes( ::nView ) )->cCodRut
         ( D():FacturasClientes( ::nView ) )->cCodTar   := ( D():AlbaranesClientes( ::nView ) )->cCodTar
         ( D():FacturasClientes( ::nView ) )->cCodObr   := ( D():AlbaranesClientes( ::nView ) )->cCodObr
         ( D():FacturasClientes( ::nView ) )->mComent   := ( D():AlbaranesClientes( ::nView ) )->mComent
         ( D():FacturasClientes( ::nView ) )->mObserv   := ( D():AlbaranesClientes( ::nView ) )->mObserv
         ( D():FacturasClientes( ::nView ) )->cCodTrn   := ( D():AlbaranesClientes( ::nView ) )->cCodTrn

      end if

   end if

   ( D():FacturasClientes( ::nView ) )->( dbUnlock() )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFacturaLineas( oItem ) CLASS GeneraFacturasClientes

   ::appendCabeceraAlbaran( oItem )
   
   ::appendLineasAlbaran( oItem )

   ::appendLineaTotal( oItem )

   ::appendPagosAbaranes( oItem )

   ::setEstadoAlbaran( oItem )

Return ( self )

//---------------------------------------------------------------------------//

METHOD appendCabeceraAlbaran( oItem ) CLASS GeneraFacturasClientes

   local cDesAlb  := ""

   if lNumAlb() .or. lSuAlb() .or. lNumObr()
      
      ( D():FacturasClientesLineas( ::nView ) )->( dbAppend() )
      ( D():FacturasClientesLineas( ::nView ) )->nNumLin    := ::nNumLin
      ( D():FacturasClientesLineas( ::nView ) )->nPosPrint  := ::nNumLin
      ( D():FacturasClientesLineas( ::nView ) )->cSerie     := ::cSerie
      ( D():FacturasClientesLineas( ::nView ) )->nNumFac    := ::nNumero
      ( D():FacturasClientesLineas( ::nView ) )->cSufFac    := ::cSufijo
      cDesAlb                    := ""
      if lNumAlb()
         cDesAlb                 += Alltrim( cNumAlb() ) + " " + hGet( oItem:Cargo, "textoid" ) + Space( 1 )
      end if
      if lSuAlb()
         cDesAlb                 += Alltrim( cSuAlb() ) + " " + Rtrim( hGet( oItem:Cargo, "sualbaran" ) ) + Space( 1 )
      end if

      if lNumObr()
         cDesAlb                 += Alltrim( cNumObr() ) + " " + hGet( oItem:Cargo, "direccion" ) + Space( 1 )
      else 
         cDesAlb                 += dtoc( hGet( oItem:Cargo, "fecha" ) )
      end if 

      ( D():FacturasClientesLineas( ::nView ) )->cDetalle   := cDesAlb
      ( D():FacturasClientesLineas( ::nView ) )->mLngDes    := cDesAlb
      ( D():FacturasClientesLineas( ::nView ) )->lControl   := .t.
      ( D():FacturasClientesLineas( ::nView ) )->cAlmLin    := oUser():cAlmacen()

      ( D():FacturasClientesLineas( ::nView ) )->( dbUnlock() )

      ::nNumLin++

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD appendLineasAlbaran( oItem ) CLASS GeneraFacturasClientes

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbSeek( hGet( oItem:Cargo, "id" ) ) )
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cSerAlb + Str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumAlb ) + ( D():AlbaranesClientesLineas( ::nView ) )->cSufAlb == hGet( oItem:Cargo, "id" ) .and.;
            !( D():AlbaranesClientesLineas( ::nView ) )->( eof() )

            ( D():FacturasClientesLineas( ::nView ) )->( dbAppend() )

            ( D():FacturasClientesLineas( ::nView ) )->nNumLin    := ::nNumLin
            ( D():FacturasClientesLineas( ::nView ) )->nPosPrint  := ::nNumLin
            ( D():FacturasClientesLineas( ::nView ) )->cSerie     := ::cSerie
            ( D():FacturasClientesLineas( ::nView ) )->nNumFac    := ::nNumero
            ( D():FacturasClientesLineas( ::nView ) )->cSufFac    := ::cSufijo
            ( D():FacturasClientesLineas( ::nView ) )->cRef       := ( D():AlbaranesClientesLineas( ::nView ) )->cRef
            ( D():FacturasClientesLineas( ::nView ) )->cDetalle   := ( D():AlbaranesClientesLineas( ::nView ) )->cDetalle
            ( D():FacturasClientesLineas( ::nView ) )->mLngDes    := ( D():AlbaranesClientesLineas( ::nView ) )->mLngDes
            ( D():FacturasClientesLineas( ::nView ) )->mNumSer    := ( D():AlbaranesClientesLineas( ::nView ) )->mNumSer
            ( D():FacturasClientesLineas( ::nView ) )->nCanEnt    := ( D():AlbaranesClientesLineas( ::nView ) )->nCanEnt
            ( D():FacturasClientesLineas( ::nView ) )->cUnidad    := ( D():AlbaranesClientesLineas( ::nView ) )->cUnidad
            ( D():FacturasClientesLineas( ::nView ) )->nUniCaja   := ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja
            ( D():FacturasClientesLineas( ::nView ) )->nUndKit    := ( D():AlbaranesClientesLineas( ::nView ) )->nUndKit
            ( D():FacturasClientesLineas( ::nView ) )->nPesoKg    := ( D():AlbaranesClientesLineas( ::nView ) )->nPesoKg
            ( D():FacturasClientesLineas( ::nView ) )->nIva       := ( D():AlbaranesClientesLineas( ::nView ) )->nIva
            ( D():FacturasClientesLineas( ::nView ) )->nReq       := ( D():AlbaranesClientesLineas( ::nView ) )->nReq
            ( D():FacturasClientesLineas( ::nView ) )->nDto       := ( D():AlbaranesClientesLineas( ::nView ) )->nDto
            ( D():FacturasClientesLineas( ::nView ) )->nDtoDiv    := ( D():AlbaranesClientesLineas( ::nView ) )->nDtoDiv
            ( D():FacturasClientesLineas( ::nView ) )->nPntVer    := ( D():AlbaranesClientesLineas( ::nView ) )->nPntVer
            ( D():FacturasClientesLineas( ::nView ) )->nDtoPrm    := ( D():AlbaranesClientesLineas( ::nView ) )->nDtoPrm
            ( D():FacturasClientesLineas( ::nView ) )->nComAge    := ( D():AlbaranesClientesLineas( ::nView ) )->nComAge
            ( D():FacturasClientesLineas( ::nView ) )->dFecha     := ( D():AlbaranesClientesLineas( ::nView ) )->dFecha
            ( D():FacturasClientesLineas( ::nView ) )->cTipMov    := ( D():AlbaranesClientesLineas( ::nView ) )->cTipMov
            ( D():FacturasClientesLineas( ::nView ) )->cAlmLin    := ( D():AlbaranesClientesLineas( ::nView ) )->cAlmLin
            ( D():FacturasClientesLineas( ::nView ) )->cCodPr1    := ( D():AlbaranesClientesLineas( ::nView ) )->cCodPr1
            ( D():FacturasClientesLineas( ::nView ) )->cCodPr2    := ( D():AlbaranesClientesLineas( ::nView ) )->cCodPr2
            ( D():FacturasClientesLineas( ::nView ) )->cValPr1    := ( D():AlbaranesClientesLineas( ::nView ) )->cValPr1
            ( D():FacturasClientesLineas( ::nView ) )->cValPr2    := ( D():AlbaranesClientesLineas( ::nView ) )->cValPr2
            ( D():FacturasClientesLineas( ::nView ) )->nCtlStk    := ( D():AlbaranesClientesLineas( ::nView ) )->nCtlStk
            ( D():FacturasClientesLineas( ::nView ) )->nCosDiv    := ( D():AlbaranesClientesLineas( ::nView ) )->nCosDiv
            ( D():FacturasClientesLineas( ::nView ) )->lControl   := ( D():AlbaranesClientesLineas( ::nView ) )->lControl
            ( D():FacturasClientesLineas( ::nView ) )->lKitArt    := ( D():AlbaranesClientesLineas( ::nView ) )->lKitArt
            ( D():FacturasClientesLineas( ::nView ) )->lKitChl    := ( D():AlbaranesClientesLineas( ::nView ) )->lKitChl
            ( D():FacturasClientesLineas( ::nView ) )->lKitPrc    := ( D():AlbaranesClientesLineas( ::nView ) )->lKitPrc
            ( D():FacturasClientesLineas( ::nView ) )->lNotVta    := ( D():AlbaranesClientesLineas( ::nView ) )->lNotVta
            ( D():FacturasClientesLineas( ::nView ) )->lImpLin    := ( D():AlbaranesClientesLineas( ::nView ) )->lImpLin
            ( D():FacturasClientesLineas( ::nView ) )->nValImp    := ( D():AlbaranesClientesLineas( ::nView ) )->nValImp
            ( D():FacturasClientesLineas( ::nView ) )->lIvaLin    := ( D():AlbaranesClientesLineas( ::nView ) )->lIvaLin            
            ( D():FacturasClientesLineas( ::nView ) )->nPreUnit   := ( D():AlbaranesClientesLineas( ::nView ) )->nPreUnit
            ( D():FacturasClientesLineas( ::nView ) )->cImagen    := ( D():AlbaranesClientesLineas( ::nView ) )->cImagen
            ( D():FacturasClientesLineas( ::nView ) )->cCodFam    := ( D():AlbaranesClientesLineas( ::nView ) )->cCodFam
            ( D():FacturasClientesLineas( ::nView ) )->cGrpFam    := ( D():AlbaranesClientesLineas( ::nView ) )->cGrpFam
            ( D():FacturasClientesLineas( ::nView ) )->lLote      := ( D():AlbaranesClientesLineas( ::nView ) )->lLote
            ( D():FacturasClientesLineas( ::nView ) )->nLote      := ( D():AlbaranesClientesLineas( ::nView ) )->nLote
            ( D():FacturasClientesLineas( ::nView ) )->cLote      := ( D():AlbaranesClientesLineas( ::nView ) )->cLote
            ( D():FacturasClientesLineas( ::nView ) )->dFecCad    := ( D():AlbaranesClientesLineas( ::nView ) )->dFecCad
            ( D():FacturasClientesLineas( ::nView ) )->cNumPed    := ( D():AlbaranesClientesLineas( ::nView ) )->cNumPed

            ( D():FacturasClientesLineas( ::nView ) )->cCodAlb    := hGet( oItem:Cargo, "id" )
            ( D():FacturasClientesLineas( ::nView ) )->dFecAlb    := hGet( oItem:Cargo, "fecha" )
            ( D():FacturasClientesLineas( ::nView ) )->dFecFac    := hGet( oItem:Cargo, "fecha" )
            //( D():FacturasClientesLineas( ::nView ) )->cCodObr    := hGet( oItem:Cargo, "direccion" )
            ( D():FacturasClientesLineas( ::nView ) )->cCodObr    := ( D():AlbaranesClientesLineas( ::nView ) )->cObrLin

            // Metemos si tiene numeros de serie-------------------------------

            if ( D():AlbaranesClientesSeries( ::nView ) )->( dbSeek( hGet( oItem:Cargo, "id" ) + Str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumLin ) ) )

               while ( D():AlbaranesClientesSeries( ::nView ) )->cSerAlb + Str( ( D():AlbaranesClientesSeries( ::nView ) )->nNumAlb ) + ( D():AlbaranesClientesSeries( ::nView ) )->cSufAlb + Str( ( D():AlbaranesClientesSeries( ::nView ) )->nNumLin ) == hGet( oItem:Cargo, "id" ) + Str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumLin ) .and.;
                     !( D():AlbaranesClientesSeries( ::nView ) )->( Eof() )

                  ( D():FacturasClientesSeries( ::nView ) )->( dbAppend() )
                  ( D():FacturasClientesSeries( ::nView ) )->cSerFac  := ::cSerie
                  ( D():FacturasClientesSeries( ::nView ) )->nNumFac  := ::nNumero
                  ( D():FacturasClientesSeries( ::nView ) )->cSufFac  := ::cSufijo
                  ( D():FacturasClientesSeries( ::nView ) )->nNumLin  := ::nNumLin - 1
                  ( D():FacturasClientesSeries( ::nView ) )->cRef     := ( D():AlbaranesClientesSeries( ::nView ) )->cRef
                  ( D():FacturasClientesSeries( ::nView ) )->cAlmLin  := ( D():AlbaranesClientesSeries( ::nView ) )->cAlmLin
                  ( D():FacturasClientesSeries( ::nView ) )->cNumSer  := ( D():AlbaranesClientesSeries( ::nView ) )->cNumSer
                  ( D():FacturasClientesSeries( ::nView ) )->( dbUnLock() )

                  ( D():AlbaranesClientesSeries( ::nView ) )->( dbSkip() )

               end while

            end if

            ( D():AlbaranesClientesLineas( ::nView ) )->( dbUnlock() )

            ::nNumLin++

         ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() )

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetTotalesFactura( oItem ) CLASS GeneraFacturasClientes

   local aTotFac := aTotFacCli(  ::getFacturaId(),;
                                 D():FacturasClientes( ::nView ),; 
                                 D():FacturasClientesLineas( ::nView ),;
                                 D():TiposIva( ::nView ),;
                                 D():Divisas( ::nView ),;
                                 D():FacturasClientesCobros( ::nView ),;
                                 D():AnticiposClientes( ::nView ) )

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( ::getFacturaId() ) ) .and. dbLock( D():FacturasClientes( ::nView ) )

      ( D():FacturasClientes( ::nView ) )->nTotNet    := aTotFac[1]
      ( D():FacturasClientes( ::nView ) )->nTotIva    := aTotFac[2]
      ( D():FacturasClientes( ::nView ) )->nTotReq    := aTotFac[3]
      ( D():FacturasClientes( ::nView ) )->nTotFac    := aTotFac[4]

      ( D():FacturasClientes( ::nView ) )->( dbUnlock() )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendLineaTotal( oItem ) CLASS GeneraFacturasClientes

   if ::oTotalizar:Value()

      ( D():FacturasClientesLineas( ::nView ) )->( dbAppend() )
      ( D():FacturasClientesLineas( ::nView ) )->nNumLin    := ::nNumLin++
      ( D():FacturasClientesLineas( ::nView ) )->cSerie     := ::cSerie
      ( D():FacturasClientesLineas( ::nView ) )->nNumFac    := ::nNumero
      ( D():FacturasClientesLineas( ::nView ) )->cSufFac    := ::cSufijo
      ( D():FacturasClientesLineas( ::nView ) )->mLngDes    := "Total albaran..."
      ( D():FacturasClientesLineas( ::nView ) )->lTotLin    := .t.
      ( D():FacturasClientesLineas( ::nView ) )->( dbUnLock() )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetSerie( oItem ) CLASS GeneraFacturasClientes

   local cSerie   := ""

   do case
      case ::nTipoSerie == 1
         cSerie   := hGet( oItem:Cargo, "serie" )

      case ::nTipoSerie == 2
         cSerie   := RetFld( hGet( oItem:Cargo, "cliente" ), D():Clientes( ::nView ), "Serie" )

      case ::nTipoSerie == 3
         cSerie   := ::cSerieFactura

   end case

   if Empty( cSerie )
      cSerie      := cDefSer()
   end if

Return ( cSerie )

//---------------------------------------------------------------------------//

METHOD GetFormaPago( oItem ) CLASS GeneraFacturasClientes

   local cCodPago    := RetFld( hGet( oItem:Cargo, "cliente" ), D():Clientes( ::nView ), "CodPago" )

   if ::oUnificarPago:Value()
      cCodPago       := hGet( oItem:Cargo, "formapago" )
   end if

   if Empty( cCodPago )
      cCodPago       := cDefFpg()
   end if

Return ( cCodPago )

//---------------------------------------------------------------------------//

METHOD GetDireccion( oItem ) CLASS GeneraFacturasClientes

   local cDireccion  := ""

   if ::oAgruparDireccion:Value()
      cDireccion     := hGet( oItem:Cargo, "direccion" )
   end if

Return ( cDireccion )

//---------------------------------------------------------------------------//

METHOD GetFecha( oItem ) CLASS GeneraFacturasClientes

   local dFecha      := ::dFecFac

   if !::isFechaFacturaActual()
      dFecha         := hGet( oItem:Cargo, "fecha" )
   end if

Return ( dFecha )

//---------------------------------------------------------------------------//

METHOD GeneraPagos( oItem ) CLASS GeneraFacturasClientes

   GenPgoFacCli(  ::getFacturaId(),;
                  D():FacturasClientes( ::nView ),;
                  D():FacturasClientesLineas( ::nView ),;
                  D():FacturasClientesCobros( ::nView ),;
                  D():AnticiposClientes( ::nView ),;
                  D():Clientes( ::nView ),;
                  D():FormasPago( ::nView ),;
                  D():Divisas( ::nView ),;
                  D():TiposIva( ::nView ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD EstadoFactura( oItem ) CLASS GeneraFacturasClientes

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( ::getFacturaId() ) )

      ChkLqdFacCli(  nil,;
                     D():FacturasClientes( ::nView ),; 
                     D():FacturasClientesLineas( ::nView ),; 
                     D():FacturasClientesCobros( ::nView ),; 
                     D():AnticiposClientes( ::nView ),; 
                     D():TiposIva( ::nView ),; 
                     D():Divisas( ::nView ),; 
                     .f. )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD appendPagosAbaranes( oItem ) CLASS GeneraFacturasClientes

   if ( D():AlbaranesClientesCobros( ::nView ) )->( dbSeek( hGet( oItem:cargo, "id" ) ) )

      while D():AlbaranesClientesCobrosId( ::nView ) == hGet( oItem:cargo, "id" ) .and.;
            !( D():AlbaranesClientesCobros( ::nView ) )->( eof() )

            ( D():FacturasClientesCobros( ::nView ) )->( dbAppend() )

            ( D():FacturasClientesCobros( ::nView ) )->cSerie        := ::cSerie
            ( D():FacturasClientesCobros( ::nView ) )->nNumFac       := ::nNumero
            ( D():FacturasClientesCobros( ::nView ) )->cSufFac       := ::cSufijo
            ( D():FacturasClientesCobros( ::nView ) )->nNumRec       := ::nNumPgo++
            ( D():FacturasClientesCobros( ::nView ) )->cTurRec       := ( D():AlbaranesClientesCobros( ::nView ) )->cTurRec
            ( D():FacturasClientesCobros( ::nView ) )->lCloPgo       := ( D():AlbaranesClientesCobros( ::nView ) )->lCloPgo
            ( D():FacturasClientesCobros( ::nView ) )->cCodCaj       := ( D():AlbaranesClientesCobros( ::nView ) )->cCodCaj
            ( D():FacturasClientesCobros( ::nView ) )->cCodCli       := hGet( oItem:cargo, "cliente" )
            ( D():FacturasClientesCobros( ::nView ) )->cNomCli       := hGet( oItem:cargo, "nombre" )
            ( D():FacturasClientesCobros( ::nView ) )->dEntrada      := ( D():AlbaranesClientesCobros( ::nView ) )->dEntrega
            ( D():FacturasClientesCobros( ::nView ) )->dPreCob       := ( D():AlbaranesClientesCobros( ::nView ) )->dEntrega
            ( D():FacturasClientesCobros( ::nView ) )->dFecVto       := ( D():AlbaranesClientesCobros( ::nView ) )->dEntrega
            ( D():FacturasClientesCobros( ::nView ) )->nImporte      := ( D():AlbaranesClientesCobros( ::nView ) )->nImporte
            ( D():FacturasClientesCobros( ::nView ) )->nImpCob       := ( D():AlbaranesClientesCobros( ::nView ) )->nImporte

            if Empty( ( D():AlbaranesClientesCobros( ::nView ) )->cDescrip )
               ( D():FacturasClientesCobros( ::nView ) )->cDescrip   := "Cobro realizado desde el albarán " + hGet( oItem:cargo, "textoid" )
            else
               ( D():FacturasClientesCobros( ::nView ) )->cDescrip   := ( D():AlbaranesClientesCobros( ::nView ) )->cDescrip + " (" + hGet( oItem:cargo, "textoid" ) + ")"
            end if

            ( D():FacturasClientesCobros( ::nView ) )->cPgdoPor      := ( D():AlbaranesClientesCobros( ::nView ) )->cPgdoPor
            ( D():FacturasClientesCobros( ::nView ) )->cCodPgo       := ( D():AlbaranesClientesCobros( ::nView ) )->cCodPgo
            ( D():FacturasClientesCobros( ::nView ) )->cDivPgo       := ( D():AlbaranesClientesCobros( ::nView ) )->cDivPgo
            ( D():FacturasClientesCobros( ::nView ) )->nVdvPgo       := ( D():AlbaranesClientesCobros( ::nView ) )->nVdvPgo
            ( D():FacturasClientesCobros( ::nView ) )->cCodAge       := ( D():AlbaranesClientesCobros( ::nView ) )->cCodAge
            ( D():FacturasClientesCobros( ::nView ) )->lCobrado      := .t.
            ( D():FacturasClientesCobros( ::nView ) )->lConPgo       := .f.
            ( D():FacturasClientesCobros( ::nView ) )->lRecImp       := .f.
            ( D():FacturasClientesCobros( ::nView ) )->lRecDto       := .f.
            ( D():FacturasClientesCobros( ::nView ) )->lPasado       := .t.
         
            ( D():FacturasClientesCobros( ::nView ) )->( dbUnLock() )

         ( D():AlbaranesClientesCobros( ::nView ) )->( dbSkip() )

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setEstadoAlbaran( oItem )

   if ( D():AlbaranesClientes( ::nView ) )->( dbSeek( hGet( oItem:Cargo, "id" ) ) )

      SetFacturadoAlbaranCliente(   .t.,; 
                                    nil,;
                                    D():AlbaranesClientes( ::nView ),;
                                    D():AlbaranesClientesLineas( ::nView ),;
                                    D():AlbaranesClientesSeries( ::nView ),;
                                    ::getFacturaId() )

   end if

Return ( self )

//---------------------------------------------------------------------------//