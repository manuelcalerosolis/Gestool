#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Reporting FROM Editable

   DATA cReportType

   METHOD New()

   METHOD Resource()                   INLINE ( ::oViewNavigator:Resource() )   

   METHOD ExecuteReporting()

   METHOD ExecuteReportingArticulo()

   METHOD ExecuteReportingCliente()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Reporting

   ::oViewNavigator        := ViewReporting():New( self )
   ::oViewNavigator:setTitleDocumento( "Galería de informes: Artículos" )

   ::cReportType           := ART_TBL

Return ( self )

//---------------------------------------------------------------------------//

METHOD ExecuteReporting( hInforme ) CLASS Reporting

   if ::cReportType == ART_TBL
      ::ExecuteReportingArticulo( hInforme )
   end if

   if ::cReportType == CLI_TBL
      ::ExecuteReportingCliente( hInforme )
   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD ExecuteReportingArticulo( hInforme ) CLASS Reporting
   
   local oInf

   oInf                    := TFastVentasArticulos():New()
   oInf:lTabletVersion     := .t.
   oInf:cReportType        := hGet( hInforme, "cReportType" )
   oInf:cReportDirectory   := hGet( hInforme, "cReportDirectory" )
   oInf:cReportName        := hGet( hInforme, "cReportName" )
   oInf:cReportFile        := hGet( hInforme, "cReportFile" )
   oInf:cAlmacenDefecto    := oUser():cAlmacen()
   oInf:BuildReportCorrespondences()

   oInf:PlayTablet()

   oInf:end()

Return ( self )

//---------------------------------------------------------------------------//

METHOD ExecuteReportingCliente( hInforme ) CLASS Reporting

   local oInf

   oInf                    := TFastVentasClientes():New()
   oInf:lTabletVersion     := .t.
   oInf:cReportType        := hGet( hInforme, "cReportType" )
   oInf:cReportDirectory   := hGet( hInforme, "cReportDirectory" )
   oInf:cReportName        := hGet( hInforme, "cReportName" )
   oInf:cReportFile        := hGet( hInforme, "cReportFile" )
   oInf:dIniInf            := GetSysDate()
   oInf:dFinInf            := GetSysDate()

   oInf:PlayTablet()

   oInf:end()

Return ( self )

//---------------------------------------------------------------------------//