#include "FiveWin.Ch"

CLASS Documento FROM Editable

   DATA Style  INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )

   METHOD ResourceBrowse

   METHOD NumeroDocumento()
   METHOD FechaDocumento() 
   METHOD AlmacenDocumento()

END CLASS

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

   local oDlg

   MsgAlert( "Monto el browse general" )

   oDlg  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   TGridSay():Build(    {  "nRow"      => 0,;
                           "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                           "bText"     => {|| "Pedidos de clientes" },;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 8, oDlg ) },;
                           "nHeight"   => 32,;
                           "lDesign"   => .f. } )

   oDlg:bResized         := {|Self| GridResize( oDlg ) }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

Return ( self )

//---------------------------------------------------------------------------//