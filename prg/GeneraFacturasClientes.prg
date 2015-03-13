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
   DATA oAgruparDescuentos
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

   DATA nRadFec         INIT 1
   DATA dFecFac         INIT GetSysDate()

   DATA cSerie
   DATA nNumero
   DATA cSufijo

   DATA aDtoEsp         INIT {}
   DATA aDtoPP          INIT {}
   DATA aDto1           INIT {}
   DATA aDto2           INIT {}

   DATA aListaAlbaranes INIT {}

   METHOD New()

   METHOD lOpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD NextPage()
   METHOD PrevPage()

   METHOD LoadAlbaranes()
   METHOD CreaFacturas()
   METHOD TestCreateTree()

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

   METHOD lIsFacturable()
   METHOD lValidaNodo()
   METHOD CreaNodo()
   METHOD AbreNodo()                   INLINE ( TreeBegin(), ::lNodoActivo   := .t. )
   METHOD CierraNodo()
   METHOD cClaveAlbaran()
   METHOD cClaveActual()
   METHOD AgregaNodo()
   METHOD ExisteNodo( hAlbaran )

   METHOD InitClaves()
   METHOD setClaveAnterior( cValor )   INLINE ( ::cClaveAnterior := cValor )

   METHOD AppendFactura( oItem )
   METHOD AppendFacturaCabecera( oItem )
   METHOD AppendFacturaLineas( oItem )

   METHOD cTextoNodoPadre()

   METHOD GetHashAlbaranes()            INLINE ( { "clave" => ::cClaveAlbaran(),;
                                                   "id" => D():AlbaranesClientesId( ::nView ),;
                                                   "textoid" => D():AlbaranesClientesIdTextShort( ::nView ),;
                                                   "seleccionado" => .t.,;
                                                   "cliente" => ( D():AlbaranesClientes( ::nView ) )->cCodCli,;
                                                   "nombre" => ( D():AlbaranesClientes( ::nView ) )->cNomCli,;
                                                   "serie" => ( D():AlbaranesClientes( ::nView ) )->cSerAlb,;
                                                   "formapago" => ( D():AlbaranesClientes( ::nView ) )->cCodPago,;
                                                   "direccion" => ( D():AlbaranesClientes( ::nView ) )->cCodObr,;
                                                   "fecha" => ( D():AlbaranesClientes( ::nView ) )->dFecAlb,;
                                                   "total" => ( D():AlbaranesClientes( ::nView ) )->nTotAlb,;
                                                   "nDto1" => ( D():AlbaranesClientes( ::nView ) )->nDtoEsp,;
                                                   "nDto2" => ( D():AlbaranesClientes( ::nView ) )->nDpp,;
                                                   "nDto3" => ( D():AlbaranesClientes( ::nView ) )->nDtoUno,;
                                                   "nDto4" => ( D():AlbaranesClientes( ::nView ) )->nDtoDos } )
   
   METHOD getSerie( oITem )
   METHOD getFormaPago( oItem )
   METHOD getDireccion( oItem )
   METHOD getFecha( oItem )

   METHOD getDescuentos( aDto )
   METHOD getMediaDescuento( aDto )
   METHOD setDescuento()
   METHOD lValidDescuentos( aDto )

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

   D():FacturasClientes( ::nView )

   D():FacturasClientesLineas( ::nView )

   D():Divisas( ::nView )

   D():TiposIva( ::nView )

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
      WHEN     ( ::nRadFec == 1 ) ;
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
         //::SetTotalesDocumentos()

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
   local nTotAlb  := 0
   local cTexto   := ""

   if !Empty( ::oBrwAlbaranes:oTree )

      oItem := ::oBrwAlbaranes:oTree:oFirst

      while oItem != nil
         
         if !Empty( oItem:oTree )

            oItem:oTree:Eval( { | o | if( o:nLevel >= oItem:nLevel, nCount++, ), if( o:nLevel >= oItem:nLevel, ( nTotAlb := nTotAlb + hGet( o:Cargo, "total" ) ), ) } )
            cTexto         := hGet( oItem:Cargo, "texto" ) + " [" + AllTrim( Str( nCount ) ) + if( nCount == 1, " doc.]", " docs.]" )
            hSet( oItem:Cargo, "texto", cTexto )
            hSet( oItem:Cargo, "total", nTotAlb )

         end if   

         oItem = oItem:GetNext()
         nCount   := 0
         nTotAlb  := 0

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreateListaAlbaranes() CLASS GeneraFacturasClientes

   local nRec           := ( D():AlbaranesClientes( ::nView ) )->( Recno() )
   local nOrdAnt        := ( D():AlbaranesClientes( ::nView ) )->( OrdSetFocus( "LCLIOBR" ) )

   ::aListaAlbaranes    := {}

   ::oMetMsg:SetTotal( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyCount() ) )

   ( D():AlbaranesClientes( ::nView ) )->( dbGoTop() )

   while !( D():AlbaranesClientes( ::nView ) )->( Eof() )

      if ::lIsFacturable()

         aAdd( ::aListaAlbaranes, ::GetHashAlbaranes )

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

   /*::oMetMsg:SetTotal( ( D():AlbaranesClientes( ::nView ) )->( OrdKeyCount() ) )

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

   end while*/

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
      cItem       := hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "textoid" )
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

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "total" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto1() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "nDto1" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto2() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "nDto2" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto3() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "nDto3" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetDto4() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem    := Trans( hGet( ::oBrwAlbaranes:oTreeItem:Cargo, "nDto4" ), cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
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

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD InitClaves() CLASS GeneraFacturasClientes

   ::lNodoActivo     := .f.
   ::cClaveAnterior  := ""

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidaNodo( hCargo ) CLASS GeneraFacturasClientes

   local lValid         := .t.
   local cClaveActual   := ::cClaveActual( hCargo )

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

METHOD cClaveActual( hCargo ) CLASS GeneraFacturasClientes

Return hGet( hCargo, "clave" )

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

   if ::nRadFec == 2
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

METHOD CreaNodo( hCargo ) CLASS GeneraFacturasClientes

   TreeAddItem( ::cClaveActual( hCargo ) ):Cargo := hCargo

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

   TreeAddItem( hGet( hCargo, "id" ), "Detalles", , , , .f. ):Cargo := hCargo

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

   ::aDtoEsp    := {}
   ::aDtoPP     := {}
   ::aDto1      := {}
   ::aDto2      := {}

   ::AppendFacturaCabecera( oItem )

   oItem:oTree:Eval( { | o | If( o:nLevel >= oItem:nLevel, iif( hGet( o:Cargo, "seleccionado" ), ::AppendFacturaLineas( o ), ), ) } )

   ::SetDescuento( oItem )

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
   ( D():FacturasClientes( ::nView ) )->lIvaInc       := uFieldEmpresa( "lIvaInc" )
   ( D():FacturasClientes( ::nView ) )->cDtoEsp       := Padr( "General", 50 )
   ( D():FacturasClientes( ::nView ) )->cDpp          := Padr( "Pronto pago", 50 )
   ( D():FacturasClientes( ::nView ) )->cDtoUno       := Space( 50 ) 
   ( D():FacturasClientes( ::nView ) )->cDtoDos       := Space(50)
   ( D():FacturasClientes( ::nView ) )->nDtoEsp       := 0
   ( D():FacturasClientes( ::nView ) )->nDpp          := 0
   ( D():FacturasClientes( ::nView ) )->nDtoUno       := 0
   ( D():FacturasClientes( ::nView ) )->nDtoDos       := 0
   
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

   end if

   ( D():FacturasClientes( ::nView ) )->( dbUnlock() )

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

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFacturaLineas( oItem ) CLASS GeneraFacturasClientes

   local aTotAlbaran

   if dbSeekInOrd( hGet( oItem:Cargo, "id" ), "nNumAlb", D():AlbaranesClientes( ::nView ) )

      aTotAlbaran    := aTotAlbCli( hGet( oItem:Cargo, "id" ), D():AlbaranesClientes( ::nView ), D():AlbaranesClientesLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )

      aAdd( ::aDtoEsp, {   "descuento" => ( D():AlbaranesClientes( ::nView ) )->nDtoEsp,;
                           "bruto" => aTotAlbaran[ 16 ],;
                           "impdescuento" => aTotAlbaran[ 12 ] } )
      aAdd( ::aDtoPP, {    "descuento" => ( D():AlbaranesClientes( ::nView ) )->nDpp,;
                           "bruto" => aTotAlbaran[ 16 ],;
                           "impdescuento" => aTotAlbaran[ 13 ] } )
      aAdd( ::aDto1, {     "descuento" => ( D():AlbaranesClientes( ::nView ) )->nDtoUno,;
                           "bruto" => aTotAlbaran[ 16 ],;
                           "impdescuento" => aTotAlbaran[ 14 ] } )
      aAdd( ::aDto2, {     "descuento" => ( D():AlbaranesClientes( ::nView ) )->nDtoDos,;
                           "bruto" => aTotAlbaran[ 16 ],;
                           "impdescuento" => aTotAlbaran[ 15 ] } )
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

   if ::nRadFec != 1
      dFecha         := hGet( oItem:Cargo, "fecha" )
   end if

Return ( dFecha )

//---------------------------------------------------------------------------//

METHOD GetDescuentos() CLASS GeneraFacturasClientes

   if (  ::lValidDescuentos( ::aDtoEsp ) .or.;
         ::lValidDescuentos( ::aDtoPp ) .or.; 
         ::lValidDescuentos( ::aDto1 ) .or.; 
         ::lValidDescuentos( ::aDto2 ) )

         ::getMediaDescuento()

   else

      ?"no hago la media"

   end if

Return ( self  )

//---------------------------------------------------------------------------//

METHOD lValidDescuentos( aDto ) CLASS GeneraFacturasClientes

   local n
   local lMedia      := .f.
   local nDescuento  := hGet( aDto[ 1 ], "descuento" )

   if len( aDto ) > 1

      for n := 2 to len( aDto )

         if nDescuento != hGet( aDto[ n ], "descuento" )
            lMedia      := .t.
            exit
         end if
      next

   end if

Return ( lMedia )

//---------------------------------------------------------------------------//

METHOD getMediaDescuento( aDto ) CLASS GeneraFacturasClientes

   local n        := 1
   local nMedia   := 0

   ?"Hacer la Media"

   /*for n := 1 to len( aDto )
      nMedia      += aDto[ n ]
   next*/

   /*::aDtoEsp
   ::aDtoPp
   ::aDto1
   ::aDto2*/

return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuento() CLASS GeneraFacturasClientes

   local nRec     := ( D():FacturasClientes( ::nView ) )->( Recno() )
   local nOrdAnt  := ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( "nNumFac" ) )

   ::GetDescuentos()

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( ::cSerie + Str( ::nNumero ) + ::cSufijo ) )

      if dbLock( D():FacturasClientes( ::nView ) )
         ( D():FacturasClientes( ::nView ) )->nDtoEsp    := 1
         ( D():FacturasClientes( ::nView ) )->nDpp       := 1
         ( D():FacturasClientes( ::nView ) )->nDtoUno    := 1
         ( D():FacturasClientes( ::nView ) )->nDtoDos    := 1
         ( D():FacturasClientes( ::nView ) )->( dbUnLock() )
      end if

   end if

   ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientes( ::nView ) )->( dbGoTo( nRec ) )

Return ( self )

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