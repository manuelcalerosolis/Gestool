#include "FiveWin.ch"  
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastreportOptions 

	DATA hOptions

	METHOD setOptions()
	METHOD getOptions()
	METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD setOptions( hOptions ) CLASS TFastReportOptions

   ::hOptions 		:= hOptions

RETURN ( hOptions )

//---------------------------------------------------------------------------//

METHOD getOptions( key ) CLASS TFastReportOptions
		
	local cValor

	if hhaskey( hOptions, key ) .and. hget( ::hOptions, key ) != 0
      cValor         := hget( ::hOptions, key ) 
   end if 

RETURN ( cValor )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastReportOptions

   ::BuildTree()

   ::BuildReportCorrespondences()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastVentasArticulos

   local aReports

   DEFAULT oTree           := ::oTreeReporting
   DEFAULT lLoadFile       := .t. 

   aReports := {  {  "Title" => "Listado",                        "Image" => 0,  "Type" => "Listado",                      "Directory" => "Articulos\Listado",                            "File" => "Listado.fr3"  },;
                  
   ::BuildNode( aReports, oTree, lLoadFile )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildReportCorrespondences()
   
   ::hReport   := {  "Listado" =>                     {  "Generate" =>  {||   ::listadoArticulo() } ,;
                                                         "Variable" =>  {||   nil },;
                                                         "Data" =>      {||   nil },;
                                                         "Options" =>   {  "Estado"                =>  { "Todos", "Finalizado", "No finalizado" },;
                                                                           "Excluir importe cero"  => .f.,;
                                                                           "Excluir unidades cero" => .f. } } }

 RETURN ( Self )

//---------------------------------------------------------------------------//