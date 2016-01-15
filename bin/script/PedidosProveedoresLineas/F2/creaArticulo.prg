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
   METHOD run( nView )

   METHOD setCampos()

   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD run( nView ) CLASS fastAddArticulo

   ::nView     := nView

   ::setCampos()

   ::Resource()

   MsgInfo( hb_valtoexp( ::aCampos ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setCampos() CLASS fastAddArticulo

   MsgInfo( cPinDiv(), "setCampos picture" )

   if isArray( ::aCampos )

      aAdd( ::aCampos, { 'clave' => 'Código', 'valor' => Space( 18 ), "picture" => "" } )
      aAdd( ::aCampos, { 'clave' => 'Nombre', 'valor' => Space( 100 ), "picture" => "" } )
      aAdd( ::aCampos, { 'clave' => 'Familia', 'valor' => Space( 16 ), "picture" => "" } )
      aAdd( ::aCampos, { 'clave' => 'Barco', 'valor' => Space( 100 ), "picture" => "" } )
      aAdd( ::aCampos, { 'clave' => 'Marea', 'valor' => Space( 100 ), "picture" => "" } )
      aAdd( ::aCampos, { 'clave' => 'Observaciones', 'valor' => Space( 200 ), "picture" => "" } )
      aAdd( ::aCampos, { 'clave' => 'Costo', 'valor' => 0, "picture" => cPinDiv() } )

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
         :bStrData         := {|| hGet( ::aCampos[ ::oBrw:nArrayAt ], "valor" ) }
         :nWidth           := 300
         :nEditType        := EDIT_GET
         :cEditPicture     := hGet( ::aCampos[ ::oBrw:nArrayAt ], "picture" )
         :bOnPostEdit      := {|o,x,n| hSet( ::aCampos[ ::oBrw:nArrayAt ], "valor", x ) }
      end with

   REDEFINE BUTTON oBtnAceptar ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End( IDOK ) )

   REDEFINE BUTTON  ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      CANCEL ;
      ACTION      ( ::oDlg:End( IDCANCEL ) )

      ::oDlg:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//