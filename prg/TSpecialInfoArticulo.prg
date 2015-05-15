#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TSpecialInfoArticulo

   DATA cCodigoArticulo    
   DATA cNombreArticulo    

   METHOD New( cCodigoArticulo, cNombreArticulo )

   METHOD Resource()

   METHOD isSelectSATFromArticulo()    INLINE ( TDataCenter():selectSATFromArticulo( ::cCodigoArticulo ) )

   METHOD Run( cCodigoArticulo, cNombreArticulo )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cCodigoArticulo, cNombreArticulo ) CLASS TSpecialInfoArticulo

   ::cCodigoArticulo    := cCodigoArticulo
   ::cNombreArticulo    := cNombreArticulo

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run( cCodigoArticulo, cNombreArticulo )

   ::New( cCodigoArticulo, cNombreArticulo )

   if ::isSelectSATFromArticulo()
      ::Resource()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS TSpecialInfoArticulo

   local oDlg
   local oBmp
   local oBrwArticulo

   DEFINE DIALOG oDlg RESOURCE "Info_5" TITLE "Información del artículo : " + Rtrim( ::cCodigoArticulo ) + " - " + Rtrim( ::cNombreArticulo )

   REDEFINE BITMAP oBmp ID 500 RESOURCE "Cube_Yellow_Alpha_48" TRANSPARENT OF oDlg

      oBrwArticulo                      := IXBrowse():New( oDlg )

      oBrwArticulo:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwArticulo:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwArticulo:cAlias               := "SatCliArticulos"

      oBrwArticulo:nMarqueeStyle        := 6
      oBrwArticulo:cName                := "Máquinas en informe de articulos"

      oBrwArticulo:CreateFromResource( 300 )

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| SatCliArticulos->clienteNombre }
         :nWidth           := 260
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Estado"
         :bEditValue       := {|| SatCliArticulos->tipoEstadoSAT }
         :nWidth           := 120
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Operario"
         :bEditValue       := {|| SatCliArticulos->operarioNombre }
         :nWidth           := 120
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| SatCliArticulos->observacionesLineaSAT }
         :nWidth           := 120
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| SatCliArticulos->fechaSAT }
         :nWidth           := 80
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Inicio"
         :bEditValue       := {|| trans( SatCliArticulos->horaInicioSAT, "@R 99:99" ) }
         :nWidth           := 40
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| trans( SatCliArticulos->horaFinSAT, "@R 99:99" ) }
         :nWidth           := 40
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| trans( SatCliArticulos->horaFinSAT, "@R 99:99" ) }
         :nWidth           := 40
      end with

      with object ( oBrwArticulo:addCol() )
         :cHeader          := "S.A.T."
         :bEditValue       := {|| iif( !empty( SatCliArticulos->serieLineaSAT ),;
                                       SatCliArticulos->serieLineaSAT + "/" + alltrim( str( SatCliArticulos->numeroLineaSAT ) ) + "/" + SatCliArticulos->sufijoLineaSAT,;
                                       "" ) }
         :nWidth           := 150
      end with

      oDlg:bStart     := {|| oBrwArticulo:LoadData() }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if
  
RETURN ( Self )

//----------------------------------------------------------------------------//

