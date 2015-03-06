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

   METHOD CreateTree()

   METHOD GetItemTree()

   METHOD GetImporteTree()

   METHOD SetTreeBrowse()

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

   ::oBrwAlbaranes                 := IXBrowse():New( ::oPag:aDialogs[ 2 ] )

   ::oBrwAlbaranes:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwAlbaranes:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwAlbaranes:lVScroll        := .t.
   ::oBrwAlbaranes:lHScroll        := .t.
   ::oBrwAlbaranes:nMarqueeStyle   := 5

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                   := ""
      :nWidth                    := 440
      :bStrData                  := {|| ::GetItemTree() }
      :lHide                     := .f.
   end with

   with object ( ::oBrwAlbaranes:AddCol() )
      :cHeader                   := "Importes"
      :nWidth                    := 140
      :bStrData                  := {|| ::GetImporteTree() }
      :lHide                     := .f.
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

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

   ::CreateTree()

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

   TreeInit()

   ::oTreeTotales                := TreeBegin( "Navigate_Minus_16", "Navigate_Plus_16" )
   
   TreeAddItem( "Cliente 0000000" ):Cargo := { "Cliente 0000000 (2 Docs.)", "" }

   TreeBegin()

   TreeAddItem( "A/1", "Detalles", , , , .f. ):Cargo := { "A/1  28/01/2015", 250 }
   TreeAddItem( "A/2", "Detalles", , , , .f. ):Cargo := { "A/2  31/01/2015", 350 }

   /*for each aItem in ::aDatAlbCliVentas
      if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
         TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
      end if
   next*/

   TreeEnd()



   TreeAddItem( "Cliente 0000001" ):Cargo := { "Cliente 0000001 (2 Docs.)", "" }

   TreeBegin()

   TreeAddItem( "A/3", "Detalles", , , , .f. ):Cargo := { "A/3  03/02/2015", 250 }
   TreeAddItem( "A/4", "Detalles", , , , .f. ):Cargo := { "A/4  04/02/2015", 350 }

   /*for each aItem in ::aDatAlbCliVentas
      if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
         TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
      end if
   next*/

   TreeEnd()

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetItemTree() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      cItem       := ::oBrwAlbaranes:oTreeItem:Cargo[ 1 ]
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetImporteTree() CLASS GeneraFacturasClientes

   local cItem    := ""

   if !Empty( ::oBrwAlbaranes:oTreeItem ) 
      if ::oBrwAlbaranes:oTreeItem:cPrompt != "Espacio"
         cItem    := Trans( ::oBrwAlbaranes:oTreeItem:Cargo[ 2 ], cPorDiv( cDivEmp(), D():Divisas( ::nView ) ) )
      end if 
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD CreaFacturas() CLASS GeneraFacturasClientes

   MsgInfo( "Creamos las facturas tirando de los albaranes" )  

Return ( self )

//---------------------------------------------------------------------------//