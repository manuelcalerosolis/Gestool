#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Documento FROM Editable

   DATA Style           INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )
   
   METHOD New()

   METHOD ResourceBrowse()
   METHOD DialogResize()
   METHOD InitDialog()

   METHOD TituloBrowse()
   METHOD cTextoTipoDocumento() VIRTUAL

   METHOD BotonSalirBrowse()

   METHOD NumeroDocumento()

   METHOD FechaDocumento() 

   METHOD AlmacenDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

Return ( self )

//---------------------------------------------------------------------------//

METHOD NumeroDocumento() CLASS Documento

   MsgAlert( "Metemos el número" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD FechaDocumento() CLASS Documento

   MsgAlert( "Metemos el fecha" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AlmacenDocumento() CLASS Documento

   MsgAlert( "Metemos el Almacén" )

Return ( self )   

//---------------------------------------------------------------------------//

METHOD ResourceBrowse() CLASS Documento

   //Definimos el diálogo------------------------------------------------------

   ::oDlg  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   //Montamos el título de la ventana------------------------------------------

   ::TituloBrowse()

   //Boton salir de la aplicación----------------------------------------------

   ::BotonSalirBrowse()

   //Activamos el diálogo------------------------------------------------------

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DialogResize() CLASS Documento

   GridResize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS Documento

   GridMaximize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD TituloBrowse() CLASS Documento

   TGridSay():Build(    {  "nRow"      => 0,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| ::cTextoTipoDocumento() },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 8, ::oDlg ) },;
                           "nHeight"   => 32,;
                           "lDesign"   => .f. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonSalirBrowse() CLASS Documento

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_end_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//