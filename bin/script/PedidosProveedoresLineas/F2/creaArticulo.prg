#include "FiveWin.Ch"
#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

function InicioHRB( nView )

   fastAddArticulo():run( nView )

return .t.

//---------------------------------------------------------------------------//

CLASS fastAddArticulo

   DATA nView

   DATA oDlg
   DATA oBrw
   DATA oCol

   DATA aCampos               INIT {}
   DATA aFamilias             INIT {}

   METHOD run( nView )

   METHOD setCampos()

   METHOD Resource()

   METHOD lPreSave()

   METHOD addArticulo()

   METHOD getCodigoArticulo()

   METHOD startDialog()

   METHOD addCampoExtra( Codigo, Clave, Valor )

   METHOD getArrayFamilias()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD run( nView ) CLASS fastAddArticulo

   ::nView     := nView

   ::setCampos()

   if ::Resource()
      ::addArticulo()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setCampos() CLASS fastAddArticulo

   if isArray( ::aCampos )

      aAdd( ::aCampos, { 'clave' => 'Código', 'valor' => ::getCodigoArticulo(), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Nombre', 'valor' => Space( 100 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Familia', 'valor' => Space( 16 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Barco', 'valor' => Space( 100 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Marea', 'valor' => Space( 100 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Observaciones', 'valor' => Space( 200 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Costo', 'valor' => 0.000, "picture" => cPinDiv(), "obligatorio" => .f. } )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS fastAddArticulo
   
   local oBmp
   local oTxt
   local oBtnAceptar

   DEFINE DIALOG ::oDlg RESOURCE "EXTRADET" TITLE "Añadir artículo"

   REDEFINE BITMAP oBmp ;
      ID          600 ;
      RESOURCE    "Cube_Yellow_Alpha_48" ;
      TRANSPARENT ;
      OF          ::oDlg

      REDEFINE SAY oTxt ;
         VAR      "Añadiendo artículos" ;
         ID       610 ;
         OF       ::oDlg

      ::oBrw                        := IXBrowse():New( ::oDlg )

      ::oBrw:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:SetArray( ::aCampos, , , .f. )

      ::oBrw:nMarqueeStyle          := MARQSTYLE_HIGHLCELL
      ::oBrw:lRecordSelector        := .f.
      ::oBrw:lHScroll               := .f.
      ::oBrw:lFastEdit              := .t.

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Campo"
         :bStrData         := {|| AllTrim( hGet( ::aCampos[ ::oBrw:nArrayAt ], "clave" ) ) }
         :nWidth           := 250
      end with

      with object ( ::oCol := ::oBrw:AddCol() )
         :cHeader          := "Valor"
         :bEditValue       := {|| hGet( ::aCampos[ ::oBrw:nArrayAt ], "valor" ) }
         :nWidth           := 300
         :nEditType        := EDIT_GET
         :cEditPicture     := hGet( ::aCampos[ ::oBrw:nArrayAt ], "picture" )
         :bOnPostEdit      := {|o,x,n| hSet( ::aCampos[ ::oBrw:nArrayAt ], "valor", x ) }
      end with

   REDEFINE BUTTON oBtnAceptar ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( if( ::lPreSave(), ::oDlg:End( IDOK ), ) )

   REDEFINE BUTTON  ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      CANCEL ;
      ACTION      ( ::oDlg:End( IDCANCEL ) )

      ::oDlg:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

      ::oDlg:bStart  := {|| ::startDialog }

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS fastAddArticulo

   ::oBrw:GoDown()
   ::oBrw:GoToCol( ::oCol )

   ::oBrw:LDblClick( ::oBrw:nColSel, ::oBrw:nRowSel )

Return ( self )

//---------------------------------------------------------------------------//

METHOD addArticulo() CLASS fastAddArticulo

   if !isArray( ::aCampos ) .or. Empty( ::aCampos )
      Return nil
   end if

   /*
   Artículo--------------------------------------------------------------------
   */

   ( D():Articulos( ::nView ) )->( dbAppend() )

   ( D():Articulos( ::nView ) )->Codigo       := AllTrim( hGet( ::aCampos[ 1 ], "valor" ) )
   ( D():Articulos( ::nView ) )->Nombre       := AllTrim( hGet( ::aCampos[ 2 ], "valor" ) )
   ( D():Articulos( ::nView ) )->pCosto       := hGet( ::aCampos[ 7 ], "valor" )
   ( D():Articulos( ::nView ) )->LastChg      := GetSysDate()
   ( D():Articulos( ::nView ) )->Familia      := hGet( ::aCampos[ 3 ], "valor" )
   ( D():Articulos( ::nView ) )->nLabel       := 1
   ( D():Articulos( ::nView ) )->nCtlStock    := 1
   ( D():Articulos( ::nView ) )->lIvaInc      := uFieldEmpresa( "lIvaInc" )
   ( D():Articulos( ::nView ) )->TipoIva      := cDefIva()

   ( D():Articulos( ::nView ) )->( dbUnLock() )

   ::addCampoExtra( "004", AllTrim( hGet( ::aCampos[ 1 ], "valor" ) ), AllTrim( hGet( ::aCampos[ 4 ], "valor" ) ) )      // Barco
   ::addCampoExtra( "018", AllTrim( hGet( ::aCampos[ 1 ], "valor" ) ), AllTrim( hGet( ::aCampos[ 5 ], "valor" ) ) )      // Marea
   ::addCampoExtra( "005", AllTrim( hGet( ::aCampos[ 1 ], "valor" ) ), AllTrim( hGet( ::aCampos[ 6 ], "valor" ) ) )      // Observaciones

Return ( self )

//---------------------------------------------------------------------------//

METHOD addCampoExtra( Codigo, Clave, Valor ) CLASS fastAddArticulo

   local nOrdAnt  := ( D():DetCamposExtras( ::nView ) )->( OrdSetFocus( "cTotClave" ) )

   /*
   Campos Extra----------------------------------------------------------------
   */

   if !( D():DetCamposExtras( ::nView ) )->( dbSeek( "20" + Codigo + Clave ) )

      ( D():DetCamposExtras( ::nView ) )->( dbAppend() )

      ( D():DetCamposExtras( ::nView ) )->cTipDoc     :=  "20"
      ( D():DetCamposExtras( ::nView ) )->cCodTipo    :=  Codigo
      ( D():DetCamposExtras( ::nView ) )->cClave      :=  Clave
      ( D():DetCamposExtras( ::nView ) )->cValor      :=  Valor

      ( D():DetCamposExtras( ::nView ) )->( dbUnLock() )

   else

      if dbLock( D():DetCamposExtras( ::nView ) )
         ( D():DetCamposExtras( ::nView ) )->cValor   :=  Valor
         ( D():DetCamposExtras( ::nView ) )->( dbUnLock() )
      end if

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD getCodigoArticulo() CLASS fastAddArticulo

   local cCodArt  := ""
   local nOrdAnt  := ( D():Articulos( ::nView ) )->( OrdSetFocus( "Codigo" ) )

   ( D():Articulos( ::nView ) )->( dbSeek( "999999", .t. ) )

   ( D():Articulos( ::nView ) )->( dbSkip( -1 ) )

   cCodArt        := ( D():Articulos( ::nView ) )->Codigo
   cCodArt        := AllTrim( str( val( ( D():Articulos( ::nView ) )->Codigo ) + 1 ) )

   ( D():Articulos( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

Return ( padr( cCodArt, 18 ) )

//---------------------------------------------------------------------------//

METHOD lPreSave() CLASS fastAddArticulo

   /*if isArray( ::aCampos )

      aAdd( ::aCampos, { 'clave' => 'Código', 'valor' => ::getCodigoArticulo(), "picture" => "", "obligatorio" => .f. } )
      aAdd( ::aCampos, { 'clave' => 'Nombre', 'valor' => Space( 100 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Familia', 'valor' => Space( 16 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Barco', 'valor' => Space( 100 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Marea', 'valor' => Space( 100 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Observaciones', 'valor' => Space( 200 ), "picture" => "", "obligatorio" => .t. } )
      aAdd( ::aCampos, { 'clave' => 'Costo', 'valor' => 0.000, "picture" =>, "obligatorio" => .f. cPinDiv() } )

   end if*/

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getArrayFamilias() CLASS fastAddArticulo


   //D():Familias( nView )


Return ( nil )

//---------------------------------------------------------------------------//