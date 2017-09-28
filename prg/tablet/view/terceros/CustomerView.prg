#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS CustomerView FROM ViewBase

   DATA oCheckVisLun
   DATA oCheckVisMar
   DATA oCheckVisMie
   DATA oCheckVisJue
   DATA oCheckVisVie
   DATA oCheckVisSab
   DATA oCheckVisDom

   DATA oCheckRecargo

   DATA oCodigoGrupo
   DATA oNombreGrupo
  
   METHOD New()

   METHOD getTextoTipoDocumento()      INLINE ( LblTitle( ::getMode() ) + "cliente" ) 

   METHOD insertControls()

   METHOD defineCodigo()

   METHOD defineNombre()

   METHOD defineNIF()

   METHOD defineDomicilio()

   METHOD definePoblacion()

   METHOD defineCodigoPostal()

   METHOD defineProvincia()

   METHOD defineEstablecimiento()

   METHOD defineTipoCliente()

   METHOD defineTelefono()

   METHOD defineEmail()

   METHOD defineGrupo()

   METHOD defineRuta()

   METHOD defineRecargo()

   METHOD whenControl()                INLINE ( ::getMode() != ZOOM_MODE )

   //METHOD whenControl()                INLINE ( ::getMode() == EDIT_MODE .and. oUser():lAdministrador() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS CustomerView

   ::oSender               := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS CustomerView

   ::defineCodigo(40)

   ::defineTipoCliente(70)
   
   ::defineNombre(100)

   ::defineNIF(130)

   ::defineGrupo(160)

   ::defineDomicilio(190)

   ::definePoblacion(220)

   ::defineCodigoPostal(250)

   ::defineProvincia(280)
   
   ::defineTelefono(310)

   ::defineEmail(340)

   ::defineEstablecimiento(370)

   ::defineRuta(400)

   ::defineRecargo(430)

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCodigo(nRow) CLASS CustomerView

   local oCodigo

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Código *" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23 } )
   
   oCodigo  := TGridGet():Build( {  "nRow"      => nRow,;
                                    "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                    "bSetGet"   => {|u| ::SetGetValue( u, "Codigo" ) },;
                                    "oWnd"      => ::oDlg,;
                                    "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                    "bWhen"     => {|| ::getMode() == APPD_MODE },;
                                    "bValid"    => {|| iif( !validKey( oCodigo, ( D():Clientes( ::getView() ) ), .t., "0", 1, RetNumCodCliEmp() ),;
                                                            ApoloErrorMsgStop( "El código ya existe" ),;
                                                            .t. ) },;
                                    "nHeight"   => 23,;
                                    "cPict"     => Replicate( "X", RetNumCodCliEmp() ),;
                                    "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNIF(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "NIF *" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "NIF" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9.0, ::oDlg ) },;
                        "bWhen"     => {|| ::whenControl() },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "bValid"    => {||   iif( empty( hGet( ::oSender:hDictionaryMaster, "NIF" ) ),;
                                                ApoloErrorMsgStop( "El campo NIF es un dato obligatorio" ),;
                                                .t. ) },;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNombre(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Nombre *" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Nombre" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9.0, ::oDlg ) },;
                        "bWhen"     => {|| ::whenControl() },;
                        "bValid"    => {||   iif( empty( hGet( ::oSender:hDictionaryMaster, "Nombre" ) ),;
                                                ApoloErrorMsgStop( "El nombre es un dato obligatorio" ),;
                                                .t. ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDomicilio(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Domicilio" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Domicilio" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCodigoPostal(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Cod postal" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "CodigoPostal" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD definePoblacion(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Población" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Poblacion" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineProvincia(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Provincia" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Provincia" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineEstablecimiento(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Establec." },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "NombreEstablecimiento" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineTipoCliente( nRow ) CLASS CustomerView

   TGridSay():Build( {  "nRow"      =>  nRow ,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Tipo" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )


   TGridComboBox():Build(  {  "nRow"      =>  nRow ,;
                              "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                              "bSetGet"   => {|u| iif( empty( u ), ::oSender:cTipoCliente, ::oSender:cTipoCliente := u ) },;
                              "oWnd"      => ::oDlg,;
                              "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                              "nHeight"   => 25,;
                              "bWhen"     => {|| ::whenControl() },;
                              "aItems"    => hGetValues( ::oSender:hTipoCliente ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineTelefono(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Teléfono" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Telefono" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineEmail(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "E-mail" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Email" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| ::whenControl() },;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineRuta(nRow) CLASS CustomerView

   TGridSay():Build( {  "nRow"      => nRow,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Ruta " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )


   ::oCheckVisLun    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                   "cCaption"  => " L",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisLun" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

   ::oCheckVisMar    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 3.5, ::oDlg ) },;
                                                   "cCaption"  => " M",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisMar" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

   ::oCheckVisMie    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                                   "cCaption"  => " X",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisMie" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

   ::oCheckVisJue    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 5.5, ::oDlg ) },;
                                                   "cCaption"  => " J",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisJue" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

   ::oCheckVisVie    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 6.5, ::oDlg ) },;
                                                   "cCaption"  => " V",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisVie" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

   ::oCheckVisSab    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 7.5, ::oDlg ) },;
                                                   "cCaption"  => " S",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisSab" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

   ::oCheckVisDom    := TGridCheckBox():Build(  {  "nRow"      => nRow,;       
                                                   "nCol"      => {|| GridWidth( 8.5, ::oDlg ) },;
                                                   "cCaption"  => " D",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "lVisDom" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )

Return( self )

//---------------------------------------------------------------------------//

METHOD defineGrupo( nRow )

   TGridUrllink():Build({  "nTop"      => nRow,;
                           "nLeft"     => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                           "cURL"      => "Grupo ",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| ::oSender:runGridGroupCustomer() } } )  //"bAction"   => {|| ::oSender:runGridGroupCustomer() } } )

   ::oCodigoGrupo   := TGridGet():Build( {   "nRow"      => nRow,;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| ::SetGetValue( u, "CodigoGrupo" ) },;
                                             "oWnd"      => ::oDlg,;
                                             "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lPixels"   => .t.,;
                                             "bValid"    => {|| ::oSender:lValidGroupCustomer() } } )

   ::oNombreGrupo   := TGridGet():Build(  {  "nRow"      => nRow,;
                                             "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                             "oWnd"      => ::oDlg,;
                                             "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                             "lPixels"   => .t.,;
                                             "bWhen"     => {|| .f. },;
                                             "nHeight"   => 23 } )

Return( self )

//---------------------------------------------------------------------------//

METHOD defineRecargo( nRow )

   ::oCheckRecargo    := TGridCheckBox():Build(  { "nRow"      => nRow,;
                                                   "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                   "cCaption"  => "Recargo equivalencia",;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "Recargo" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 5, ::oDlg ) },;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::whenControl() },;
                                                   "oFont"     => oGridFont(),;
                                                   "lPixels"   => .t. } )


Return( self )

//---------------------------------------------------------------------------//