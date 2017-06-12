#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS Propiedades FROM SQLBaseView

<<<<<<< HEAD
=======
   DATA     oEditControl

   DATA     cEditControl 

>>>>>>> SQLite
   METHOD   New()
 
   METHOD   Dialog()

<<<<<<< HEAD
=======
   METHOD   createEditControl( hControl )

>>>>>>> SQLite
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName		:= "gc_coathanger_16"

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
<<<<<<< HEAD
   local oGetNombre
   local oGetCodigo
   local oControlBrw
=======
   local oBtnOk
   local oGetNombre
   local oGetCodigo
>>>>>>> SQLite

   DEFINE DIALOG oDlg RESOURCE "PROP_SQL" TITLE ::lblTitle() + "propiedades"

   REDEFINE GET   oGetCodigo ;
      VAR         ::oController:oModel:hBuffer[ "codigo" ] ;
<<<<<<< HEAD
      MEMO ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
=======
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validCodigo( oGetCodigo ) ) ;
>>>>>>> SQLite
      OF          oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
<<<<<<< HEAD
      MEMO ;
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
=======
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validNombre( oGetNombre ) ) ;
>>>>>>> SQLite
      OF          oDlg

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "is_color" ] ;
      ID       	200 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      OF       	oDlg

<<<<<<< HEAD
msgalert( hb_valtoexp( ::oController:oPropiedadesLineasController:oModel ) ,"propiedades lineas")      

   oControlBrw 	:= ::oController:oPropiedadesLineasController:showBrowseInDialog( 120, oDlg )
=======
   ::oController:getController( 'lineas' ):oView:buildSQLNuclearBrowse( 120, oDlg )
>>>>>>> SQLite

   REDEFINE BUTTON;
      ID       	500 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
<<<<<<< HEAD
      ACTION   	( ::oController:oPropiedadesLineasController:Append( ::oController:oPropiedadesLineasController:oView:oBrowse ) )
=======
      ACTION   	( ::oController:getController( 'lineas' ):Append() )
>>>>>>> SQLite

   REDEFINE BUTTON;
      ID       	501 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
<<<<<<< HEAD
      ACTION   	( ::oController:oPropiedadesLineasController:Edit( ::oController:oPropiedadesLineasController:oView:oBrowse ) )
=======
      ACTION   	( ::oController:getController( 'lineas' ):Edit() )
>>>>>>> SQLite

   REDEFINE BUTTON;
      ID       	502 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
<<<<<<< HEAD
      ACTION   	( ::oController:oPropiedadesLineasController:Delete( ::oController:oPropiedadesLineasController:oView:oBrowse ) )

   /*REDEFINE BUTTON;
      ID      		503 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( UpDet( ::oController:oPropiedadesLineasController:oView:oBrowse ) )
=======
      ACTION   	( ::oController:getController( 'lineas' ):Delete() )

   REDEFINE BUTTON;
      ID      		503 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( ::oController:getController( 'lineas' ):UpDet() )
>>>>>>> SQLite

   REDEFINE BUTTON;
      ID       	504 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
<<<<<<< HEAD
      ACTION   	( DownDet( ::oController:oPropiedadesLineasController:oView:oBrowse ) )*/

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( ::oController:validDialog( oDlg, oGetNombre, oGetCodigo ) )
=======
      ACTION   	( ::oController:getController( 'lineas' ):DownDet() )

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )
>>>>>>> SQLite

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

<<<<<<< HEAD
   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetNombre:setFocus() }
=======
   oDlg:AddFastKey( VK_F2, {|| ::oController:getController( 'lineas' ):Append() } )
   oDlg:AddFastKey( VK_F3, {|| ::oController:getController( 'lineas' ):Edit() } )
   oDlg:AddFastKey( VK_F4, {|| ::oController:getController( 'lineas' ):Delete() } )
   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )



   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetCodigo:setFocus() }
>>>>>>> SQLite

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

<<<<<<< HEAD
//---------------------------------------------------------------------------//
=======
//---------------------------------------------------------------------------//

METHOD createEditControl( uValue, hControl )

   local idSay

   if hb_isnil( uValue )
      RETURN ( Self )
   end if 

   if hhaskey( hControl, "idSay" )
      idSay       := hget( hControl, "idSay" )
   end if 

   if !hhaskey( hControl, "idGet" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "idText" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "dialog" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "when" )
      RETURN ( Self )
   end if 

   REDEFINE GET   ::oEditControl ;
      VAR         uValue ;
      BITMAP      "Lupa" ;
      ID          ( hGet( hControl, "idGet" ) ) ;
      IDSAY       ( idSay ) ;
      IDTEXT      ( hGet( hControl, "idText" ) ) ;
      OF          ( hGet( hControl, "dialog" ) )

   ::oEditControl:bWhen    := hGet( hControl, "when" ) 
   ::oEditControl:bHelp    := {|| ::oController:assignBrowse( ::oEditControl ) }
   ::oEditControl:bValid   := {|| ::oController:isValidCodigo( ::oEditControl ) }

RETURN ( Self )

//---------------------------------------------------------------------------//

>>>>>>> SQLite
