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

function InicioHRB( oRem )

   changeFPago():run( oRem )

return ( nil )

//---------------------------------------------------------------------------//

CLASS changeFPago

   DATA oRemCli
   DATA oDlg
   DATA aFormaPago

   METHOD run( oRem )

   METHOD GetArrayFPago()

   METHOD CambiaFormaPago( cFormaPago )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD run( oRem ) CLASS changeFPago

   local cFormaPago

   ::oRemCli     := oRem

   ::GetArrayFPago()

   if MsgCombo( "Seleccione una opción", "Forma de pago a cambiar.", ::aFormaPago, @cFormaPago )

      ::CambiaFormaPago( cFormaPago )

   end if

   if !Empty( ::oRemCli:oBrwDet )
      ::oRemCli:oBrwDet:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD GetArrayFPago()  CLASS changeFPago

   local nRec     := ::oRemCli:oFormaPago:Recno()
   local nOrdAnt  := ::oRemCli:oFormaPago:OrdSetFocus( "cCodPago" )

   ::aFormaPago   := {}

   ::oRemCli:oFormaPago:GoTop()

   while !::oRemCli:oFormaPago:Eof()

      aAdd( ::aFormaPago, ::oRemCli:oFormaPago:cCodPago + "-" + ::oRemCli:oFormaPago:cDesPago )

      ::oRemCli:oFormaPago:Skip()

   end while

   ::oRemCli:oFormaPago:OrdSetFocus( nOrdAnt )
   ::oRemCli:oFormaPago:GoTo( nRec )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD CambiaFormaPago( cFormaPago )

   ::oRemCli:oDbfVir:GoTop()

   while !::oRemCli:oDbfVir:Eof()

      ::oRemCli:gotoRecibo()

      ::oRemCli:oDbfDet:Load()

      ::oRemCli:oDbfDet:cCodPgo   := SubStr( cFormaPago, 1, 2 )

      ::oRemCli:oDbfDet:Save()

      ::oRemCli:oDbfVir:Skip()

   end while

   ::oRemCli:oDbfVir:GoTop()

Return ( nil )

//---------------------------------------------------------------------------//

