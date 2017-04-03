#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS backupView FROM ViewBase

   DATA oGetFolder
   DATA cGetFolder
   DATA cFileLog
   DATA oMeter
   DATA nMeter
   DATA oMeterTarget
   DATA nMeterTarget

   METHOD New()

   METHOD insertControls()

   METHOD defineAceptarCancelar()

   METHOD defineFolder()

   METHOD defineMeter

   METHOD getTitleTipoDocumento()   INLINE ( ::getTextoTipoDocumento() )

   METHOD CargarPreferencias()

   METHOD GuardarPreferencias()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS backupView

   ::oSender         := oSender

   ::nMeter          := 0
   ::nMeterTarget    := 0
   
   ::CargarPreferencias()

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS backupView

   ::defineFolder()

   ::defineMeter()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD defineFolder() CLASS backupView

   TGridSay():Build(    {  "nRow"      => 40,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Destino" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oGetFolder      := TGridGet():Build( {  "nRow"      => 40,;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::cGetFolder, ::cGetFolder := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "nWidth"    => {|| GridWidth( 7.1, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lPixels"   => .t. } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD defineMeter() CLASS backupView


   ::oMeter          := TGridMeter():Build( {   "nRow"            => 65,;
                                                "nCol"            => {|| GridWidth( 0.5, ::oDlg ) },;
                                                "bSetGet"         => {|u| if( PCount() == 0, ::nMeter, ::nMeter := u ) },;
                                                "oWnd"            => ::oDlg,;
                                                "nWidth"          => {|| GridWidth( 11.5, ::oDlg ) },;
                                                "nHeight"         => 23,;
                                                "lPixel"          => .t.,;
                                                "lUpdate"         => .t.,;
                                                "lNoPercentage"   => .t.,;
                                                "nClrPane"        => rgb( 255,255,255 ),;
                                                "nClrBar"         => rgb( 128,255,0 ) } )

   ::oMeterTarget    := TGridMeter():Build( {   "nRow"            => 90,;
                                                "nCol"            => {|| GridWidth( 0.5, ::oDlg ) },;
                                                "bSetGet"         => {|u| if( PCount() == 0, ::nMeterTarget, ::nMeterTarget := u ) },;
                                                "oWnd"            => ::oDlg,;
                                                "nWidth"          => {|| GridWidth( 11.5, ::oDlg ) },;
                                                "nHeight"         => 23,;
                                                "lPixel"          => .t.,;
                                                "lUpdate"         => .t.,;
                                                "lNoPercentage"   => .t.,;
                                                "nClrPane"        => rgb( 255,255,255 ),;
                                                "nClrBar"         => rgb( 128,255,0 ) } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS backupView
   
   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_error_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_ok_64",;
                           "bLClicked" => {|| ::oSender:runBackup(), ::GuardarPreferencias(), ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

Method CargarPreferencias() CLASS backupView

   local oIniApp                 := TIni():New( cIniAplication() )

   ::cGetFolder                  := PadR( oIniApp:Get( "Backup", "Destino",            "C:\",                  ::cGetFolder ),         200 )
   ::cFileLog                    := PadR( oIniApp:Get( "Backup", "Informe",            "C:\InfomeCopia.Txt",   ::cFileLog ),           200 )

return ( Self )

//---------------------------------------------------------------------------//

Method GuardarPreferencias() CLASS backupView

   local oIniApp                 := TIni():New( cIniAplication() )

   oIniApp:Set( "Backup",  "Destino",           ::cGetFolder )

return ( Self )

//---------------------------------------------------------------------------//