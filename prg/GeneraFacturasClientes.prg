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
   DATA nMetMsg      INIT 0

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

   METHOD ChangeBrowse()

   METHOD SetValueCheck()

   METHOD UpdatePadre()

   METHOD AppendFactura( oItem )

   METHOD AppendFacturaCabecera( oItem )

   METHOD AppendFacturaLineas( oItem )

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
   local oSerieFactura
   local cSerieFactura     := cNewSer( "nFacCli", D():Contadores( ::nView ) )
   local nTipoSerie        := 1

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

   REDEFINE RADIO nTipoSerie ;
      ID       240, 250 ;
      OF       ::oPag:aDialogs[ 1 ]

   REDEFINE GET oSerieFactura VAR cSerieFactura;
      ID       260 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerieFactura ) );
      ON DOWN  ( DwSerie( oSerieFactura ) );
      VALID    ( cSerieFactura >= "A" .and. cSerieFactura <= "Z"  );
      OF       ::oPag:aDialogs[ 1 ]      

      oSerieFactura:bWhen := {|| ( nTipoSerie == 2 ) }

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
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := ""
      :nWidth                       := 420
      :bStrData                     := {|| ::GetItemTree() }
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                      := "Importes"
      :nWidth                       := 140
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

   MsgInfo( "Cargamos los albaranes dependiendo de las condiciones" )

   ::TestCreateTree()

   ::SetTreeBrowse()

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

METHOD CreateTree() CLASS GeneraFacturasClientes

   //*******EMPEZAR POR AQUI*******\\

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

METHOD CreaFacturas() CLASS GeneraFacturasClientes

   local oItem

   if !Empty( ::oBrwAlbaranes:oTree )

      oItem := ::oBrwAlbaranes:oTree:oFirst

      while oItem != nil
         
         if !Empty( oItem:oTree ) .and. oItem:Cargo[ 4 ]

            ::AppendFactura( oItem )

         end if   

         oItem = oItem:GetNext()

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFactura( oItem ) CLASS GeneraFacturasClientes

   ::AppendFacturaCabecera( oItem )

   oItem:oTree:Eval( { | o | If( o:nLevel >= oItem:nLevel, iif( o:Cargo[ 4 ], ::AppendFacturaLineas( o ), ), ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFacturaCabecera( oItem ) CLASS GeneraFacturasClientes

   MsgInfo( "Añado cabecera facturas para " + oItem:Cargo[ 1 ] )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendFacturaLineas( oItem ) CLASS GeneraFacturasClientes

   MsgInfo( "Añado lineas facturas para " + oItem:Cargo[ 1 ] )

Return ( self )

//---------------------------------------------------------------------------//