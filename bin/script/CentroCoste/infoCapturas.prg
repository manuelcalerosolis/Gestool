#include "FiveWin.ch"
#include "Factu.ch"
#include "Xbrowse.ch"

/*
Hay que crear los campos extra necesarios para este script---------------------
*/

Function InfoCapturas( oCentroCoste )                  
         
   TInfCapturas():New( oCentroCoste )

Return nil

//---------------------------------------------------------------------------//  

CLASS TInfCapturas

   DATA oDialog

   DATA oCentroCoste

   DATA oCodigoCentroCoste
   DATA cCodigoCentroCoste

   DATA oNombreCentroCoste
   DATA cNombreCentroCoste

   DATA oFechaInicio
   DATA cFechaInicio

   DATA oFechaFin
   DATA cFechaFin

   DATA oDias
   DATA cDias

   DATA oComentarios
   DATA cComentarios

   DATA oBarco
   DATA cBarco
   DATA oMarea
   DATA cMarea

   DATA cCapturas          INIT "cCapturas"
   DATA cCapturasLineas    INIT "cCapturasLineas"

   DATA oBrwCapturas
   DATA oBrwCapturasLineas

   METHOD New()

   METHOD SetResources()      INLINE ( SetResources( fullcurdir() + "Script\CentroCoste\InfoCapturas.dll" ) )

   METHOD FreeResources()     INLINE ( FreeResources() )

   METHOD LoadCentroCoste()

   METHOD LoadCapturas()

   METHOD ChangeBrowseCapturas()

   METHOD LoadCapturasLineas()

   METHOD Resource()

   METHOD CloseAreas()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oCentroCoste ) CLASS TInfCapturas

   ::oCentroCoste             := oCentroCoste

   ::LoadCentroCoste()

   ::LoadCapturas()

   ::LoadCapturasLineas()

   ::SetResources()

   ::Resource()  

   ::FreeResources()

   ::CloseAreas()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD CloseAreas() CLASS TInfCapturas

   ADSBaseModel():CloseArea( ::cCapturas )
   ADSBaseModel():CloseArea( ::cCapturasLineas )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD LoadCentroCoste() CLASS TInfCapturas

   ::cCodigoCentroCoste       := ::oCentroCoste:oDbf:cCodigo
   ::cNombreCentroCoste       := ::oCentroCoste:oDbf:cNombre
   ::cFechaInicio             := ::oCentroCoste:oDbf:dFecIni
   ::cFechaFin                := ::oCentroCoste:oDbf:dFecFin
   ::cComentarios             := ::oCentroCoste:oDbf:cComent
   ::cBarco                   := ::oCentroCoste:oDbf:cValPr1
   ::cMarea                   := ::oCentroCoste:oDbf:cValPr2
   ::cDias                    := ::oCentroCoste:oDbf:dFecFin - ::oCentroCoste:oDbf:dFecIni

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD LoadCapturas() CLASS TInfCapturas
   
   local cSql  := "SELECT " + ;
                        "lineaPed.cSerPed AS Serie, " + ;
                        "lineaPed.nNumPed AS Numero, " + ;
                        "lineaPed.cSufPed AS Sufijo, " + ;
                        "SUM( lineaPed.nBultos ) AS [nTotalBultos], " + ;
                        "SUM( lineaPed.nCanPed ) AS [nTotalCajas], " + ;
                        "SUM( lineaPed.nUniCaja ) AS [nTotalUnidades], " + ;
                        "cabeceraPed.dFecPed AS Fecha, " + ;
                        "cabeceraPed.cSituac AS Situacion, " + ;
                        "cabeceraPed.cExped AS Expedicion, " + ;
                        "cabeceraPed.nTotNet AS Neto, " + ;
                        "cabeceraPed.nTotIva AS Iva, " + ;
                        "cabeceraPed.nTotReq AS RE, " + ;
                        "cabeceraPed.nTotPed AS Total " + ;
                     "FROM " + cPatEmp() + "PedProvL lineaPed " + ;
                     "INNER JOIN " + cPatEmp() + "PedProvT cabeceraPed " + ;
                     "ON lineaPed.cSerPed = cabeceraPed.cSerPed and lineaPed.nNumPed = cabeceraPed.nNumPed and lineaPed.cSufPed = cabeceraPed.cSufPed " + ;
                     "WHERE lineaPed.cSerPed = 'A' AND lineaPed.cCtrCoste = " + quoted( ::cCodigoCentroCoste  ) + " " + ;
                     "GROUP BY   lineaPed.cSerPed, " + ;
                                "lineaPed.nNumPed, " + ;
                                "lineaPed.cSufPed, " + ;
                                "cabeceraPed.dFecPed, " + ;
                                "cabeceraPed.cSituac, " + ;
                                "cabeceraPed.cExped, " + ;
                                "cabeceraPed.nTotNet, " + ;
                                "cabeceraPed.nTotIva, " + ;
                                "cabeceraPed.nTotReq, " + ;
                                "cabeceraPed.nTotPed"

   ADSBaseModel():ExecuteSqlStatement( cSql, @::cCapturas )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS TInfCapturas

   DEFINE DIALOG ::oDialog RESOURCE "CentroCoste" 

      REDEFINE GET   ::oCodigoCentroCoste ;
         VAR         ::cCodigoCentroCoste ;
         ID          100 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oNombreCentroCoste ;
         VAR         ::cNombreCentroCoste ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oFechaInicio ;
         VAR         ::cFechaInicio ;
         ID          120 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oFechaFin ;
         VAR         ::cFechaFin ;
         ID          130 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oComentarios ;
         VAR         ::cComentarios ;
         ID          140 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oBarco ;
         VAR         ::cBarco ;
         ID          170 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oMarea ;
         VAR         ::cMarea ;
         ID          180 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oDias ;
         VAR         ::cDias ;
         ID          190 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      /*
      Browse de las cabeceras--------------------------------------------------
      */

      ::oBrwCapturas                 := IXBrowse():New( ::oDialog )

      ::oBrwCapturas:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwCapturas:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwCapturas:cAlias          := ::cCapturas

      ::oBrwCapturas:nMarqueeStyle   := 6
      ::oBrwCapturas:lFooter         := .t.
      ::oBrwCapturas:cName           := "Cabecera capturas"
      ::oBrwCapturas:bChange         := {|| ::ChangeBrowseCapturas() }

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| ( ::cCapturas )->Serie + "/" + AllTrim( Str( ( ::cCapturas )->Numero ) ) + "/" + ( ::cCapturas )->Sufijo }
            :nWidth           := 100
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| ( ::cCapturas )->Fecha }
            :nWidth           := 100
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Semana"
            :bEditValue       := {|| ( ::cCapturas )->Expedicion }
            :nWidth           := 100
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Situación"
            :bEditValue       := {|| ( ::cCapturas )->Situacion }
            :nWidth           := 100
            :lHide            := .t.
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Bultos"
            :bEditValue       := {|| ( ::cCapturas )->nTotalBultos }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nFooterType      := AGGR_SUM
         end with
         
         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Cajas"
            :bEditValue       := {|| ( ::cCapturas )->nTotalCajas }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nFooterType      := AGGR_SUM
         end with
         
         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Unidades"
            :bEditValue       := {|| ( ::cCapturas )->nTotalUnidades }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nFooterType      := AGGR_SUM
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Neto"
            :bEditValue       := {|| ( ::cCapturas )->Neto }
            :nWidth           := 100
            :cEditPicture     := cPorDiv()
            :nFooterType      := AGGR_SUM
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Iva"
            :bEditValue       := {|| ( ::cCapturas )->Iva }
            :nWidth           := 100
            :cEditPicture     := cPorDiv()
            :nFooterType      := AGGR_SUM
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "RE"
            :bEditValue       := {|| ( ::cCapturas )->RE }
            :nWidth           := 100
            :cEditPicture     := cPorDiv()
            :nFooterType      := AGGR_SUM
         end with

         with object ( ::oBrwCapturas:AddCol() )
            :cHeader          := "Total"
            :bEditValue       := {|| ( ::cCapturas )->Total }
            :nWidth           := 100
            :cEditPicture     := cPorDiv()
            :nFooterType      := AGGR_SUM
         end with

      ::oBrwCapturas:CreateFromResource( 150 )

      /*
      Browse de las líneas-----------------------------------------------------
      */

      ::oBrwCapturasLineas                 := IXBrowse():New( ::oDialog )

      ::oBrwCapturasLineas:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwCapturasLineas:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwCapturasLineas:cAlias          := ::cCapturasLineas

      ::oBrwCapturasLineas:nMarqueeStyle   := 6
      ::oBrwCapturasLineas:lFooter         := .t.
      ::oBrwCapturasLineas:cName           := "Lineas capturas"

         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "Especie"
            :bEditValue       := {|| ( ::cCapturasLineas )->CodigoArticulo }
            :nWidth           := 50
         end with

         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ( ::cCapturasLineas )->NombreArticulo }
            :nWidth           := 200
         end with

         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "T. Bultos"
            :bEditValue       := {|| ( ::cCapturasLineas )->Bultos }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nFooterType      := AGGR_SUM
         end with
         
         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "Cajas"
            :bEditValue       := {|| ( ::cCapturasLineas )->Cajas }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nFooterType      := AGGR_SUM
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with
         
         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "T. Kilos"
            :bEditValue       := {|| ( ::cCapturasLineas )->Unidades }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nFooterType      := AGGR_SUM
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( ::oBrwCapturasLineas:AddCol() )   
            :cHeader          := "Precio"
            :bEditValue       := {|| ( ::cCapturasLineas )->PrecioArticulo }
            :nWidth           := 100
            :cEditPicture     := cPorDiv()
            :nFooterType      := AGGR_SUM
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| ( ( ::cCapturasLineas )->Unidades * ( ::cCapturasLineas )->PrecioArticulo ) }
            :nWidth           := 100
            :cEditPicture     := cPorDiv()
            :nFooterType      := AGGR_SUM
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "C.Bultos"
            :bEditValue       := {|| ( ::cCapturasLineas )->NumeroCajas }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( ::oBrwCapturasLineas:AddCol() )
            :cHeader          := "P.Cajas"
            :bEditValue       := {|| ( ::cCapturasLineas )->PesoCaja }
            :nWidth           := 75
            :cEditPicture     := MasUnd()
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

      ::oBrwCapturasLineas:CreateFromResource( 160 )

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End() )

      ::oDialog:bStart := {|| ::oBrwCapturas:MakeTotals(), ::oBrwCapturasLineas:MakeTotals() }

   ACTIVATE DIALOG ::oDialog CENTER

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadCapturasLineas() CLASS TInfCapturas

   ( ::cCapturas )->( dbGoTop() )

   ::ChangeBrowseCapturas()   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeBrowseCapturas() CLASS TInfCapturas
   
   local cSql  := "SELECT lineaPed.cRef AS CodigoArticulo, " + ;
                        " lineaPed.cDetalle AS NombreArticulo, " + ;
                        " lineaPed.nBultos AS Bultos, " + ;
                        " lineaPed.nCanPed AS Cajas, " + ;
                        " lineaPed.nUniCaja AS Unidades, " + ;
                        " lineaPed.nPreDiv AS PrecioArticulo, " + ;
                        " Articulos.nCajEnt AS NumeroCajas, " + ;
                        " Articulos.nPesCaj AS PesoCaja " + ;
                     "FROM " + cPatEmp() + "PedProvL lineaPed " + ;
                     "INNER JOIN " + cPatEmp() + "Articulo Articulos " + ;
                     "ON lineaPed.cRef = Articulos.Codigo " + ;
                     "WHERE cSerPed = " + quoted( ( ::cCapturas )->Serie ) + " AND " + ;
                     "nNumPed = " + str( ( ::cCapturas )->Numero ) + " AND " +  ;
                     "cSufPed = " + quoted( ( ::cCapturas )->Sufijo )


   ADSBaseModel():ExecuteSqlStatement( cSql, @::cCapturasLineas )

   ( ::cCapturasLineas )->( dbGoTop() )

   if !Empty( ::oBrwCapturasLineas )
      ::oBrwCapturasLineas:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//