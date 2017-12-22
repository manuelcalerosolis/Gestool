#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS InfCentroCoste

   DATA cCentroCoste
   DATA cSelInfoCentroCoste            INIT ""

   METHOD New( cCodigoArticulo, cNombreArticulo )

   METHOD Resource()

   METHOD selectCentroCoste()

   METHOD cTextoWindow()               INLINE ( "Informe del centro de coste : " + Rtrim( ::cCentroCoste ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cCentroCoste ) CLASS InfCentroCoste

   if Empty( cCentroCoste )
      Return ( self )
   end if

   ::cCentroCoste          := cCentroCoste

   if ::selectCentroCoste()
      ::Resource()
   else
      MsgStop( "No hay movimientos con el centro de coste seleccionado" )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD selectCentroCoste()

   local cStm
   local cSql     := ""

   cSql           += PedidosProveedoresLineasModel():getSelectCentroCosteStatement( ::cCentroCoste )

   if TDataCenter():ExecuteSqlStatement( cSql, @cStm )
      ::cSelInfoCentroCoste   := cStm
      return ( .t. )
   else
      ::cSelInfoCentroCoste   := ""
   end if

Return ( .f. )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS InfCentroCoste

   local oDlg
   local oBmp
   local oBrwDocumentos

   DEFINE DIALOG oDlg RESOURCE "Info_5" TITLE ::cTextoWindow()

   REDEFINE BITMAP oBmp ID 500 RESOURCE "gc_folder_money_48" TRANSPARENT OF oDlg

   REDEFINE SAY PROMPT ::cTextoWindow() ID 200 OF oDlg

      oBrwDocumentos                      := IXBrowse():New( oDlg )

      oBrwDocumentos:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDocumentos:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDocumentos:cAlias               := ::cSelInfoCentroCoste

      oBrwDocumentos:nMarqueeStyle        := 6
      oBrwDocumentos:cName                := "Informe por centro de coste"

      oBrwDocumentos:CreateFromResource( 300 )

      //oBrwDocumentos:bLDblClick  := {|| EdtSatCli( SatCliArticulos->serieLineaSAT + str( SatCliArticulos->numeroLineaSAT, 9 ) + SatCliArticulos->sufijoLineaSAT ) }

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Artículo"
         :bEditValue       := {|| ( ::cSelInfoCentroCoste )->cRef }
         :nWidth           := 260
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "C.Coste"
         :bEditValue       := {|| ( ::cSelInfoCentroCoste )->cCtrCoste }
         :nWidth           := 120
      end with

      /*with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Operario"
         :bEditValue       := {|| SatCliArticulos->operarioNombre }
         :nWidth           := 120
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| SatCliArticulos->observacionesLineaSAT }
         :nWidth           := 120
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| SatCliArticulos->fechaSAT }
         :nWidth           := 80
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Inicio"
         :bEditValue       := {|| trans( SatCliArticulos->horaInicioSAT, "@R 99:99" ) }
         :nWidth           := 40
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| trans( SatCliArticulos->horaFinSAT, "@R 99:99" ) }
         :nWidth           := 40
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| trans( SatCliArticulos->horaFinSAT, "@R 99:99" ) }
         :nWidth           := 40
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "S.A.T."
         :bEditValue       := {|| iif( !empty( SatCliArticulos->serieLineaSAT ),;
                                       SatCliArticulos->serieLineaSAT + "/" + alltrim( str( SatCliArticulos->numeroLineaSAT ) ) + "/" + SatCliArticulos->sufijoLineaSAT,;
                                       "" ) }
         :nWidth           := 150
      end with

      with object ( oBrwDocumentos:addCol() )
         :cHeader          := "Contador"
         :bEditValue       := {|| if( !Empty( SatCliArticulos->contadorLineaSAT ), Trans( SatCliArticulos->contadorLineaSAT, "999999999999" ), "" ) }
         :nWidth           := 130
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      //oDlg:bStart     := {|| oBrwDocumentos:Load() }*/

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if
  
RETURN ( Self )

//----------------------------------------------------------------------------//

