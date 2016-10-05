#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcel( nView )                	 
	      
   TImportarExcel():New( nView ):Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TImportarExcel

   DATA nView

   DATA oExcel

   DATA cFicheroExcel

   DATA nFilaInicioImportacion
   
   DATA lProcesa

   METHOD New()

   METHOD Run()
   
   METHOD procesaFicheroExcel()
   
END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView
   ::lProcesa                 := .t.

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\Importar.xlsx"

   /*
   Cambiar la fila de cominezo de la importacion
   */

   ::nFilaInicioImportacion   := 7

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   ::procesaFicheroExcel()

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::oExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   ::oExcel:oExcel:Visible         := .t.
   ::oExcel:oExcel:DisplayAlerts   := .f.
   ::oExcel:oExcel:WorkBooks:Open( ::cFicheroExcel )

   while ( ::lProcesa )

            for n := 9 to 33

            nUnidad  := oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value
            nCajas   := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value
            cCodigo  := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value

            if !Empty( nUnidad ) .and. !Empty( nCajas ) .and. !Empty( cCodigo )
               cProp1   := Str( nCajas, 3 )
               cProp2   := StrTran( cCodigo, "V", "T" )
               cCodigo  := "2044" + StrTran( Str( nCajas, 3 ), Space( 1 ), "0" )

               /*
               Buscamos el articulo en la tabla--------------------------------
               */

               if ( cArticulo )->( dbSeek( cCodigo ) )

                  ( dbfTmp )->( dbAppend() )

                  ( dbfTmp )->nNumLin     := nLastNum( dbfTmp )
                  ( dbfTmp )->nPosPrint   := nLastNum( dbfTmp, "nPosPrint" )
                  ( dbfTmp )->cRef        := ( cArticulo )->Codigo
                  ( dbfTmp )->cDetalle    := ( cArticulo )->Nombre
                  ( dbfTmp )->cCodPr1     := "1"
                  ( dbfTmp )->cValPr1     := cProp1
                  ( dbfTmp )->cCodPr2     := "2"
                  ( dbfTmp )->cValPr2     := cProp2
                  ( dbfTmp )->nIva        := nIva( D():TiposIva( nView ), ( cArticulo )->TipoIva )
                  ( dbfTmp )->nUniCaja    := nUnidad
                  ( dbfTmp )->cCodFam     := ( cArticulo )->Familia
                  ( dbfTmp )->cGrpFam     := cGruFam( ( cArticulo )->Familia, cFamilia )

                  if lPedido

                     ( dbfTmp )->nCanPed  := nCajas / 100
                     ( dbfTmp )->nPreDiv  := nRetPreArt( 1, cDivEmp(), .f., cArticulo, cDiv, cKit, D():TiposIva( nView ) )

                  else

                     ( dbfTmp )->nCanEnt     := nCajas / 100

                     nComPro                 := nComPro( ( dbfTmp )->cRef, ( dbfTmp )->cCodPr1, ( dbfTmp )->cValPr1, ( dbfTmp )->cCodPr2, ( dbfTmp )->cValPr2, cArtCom )
                     if nComPro != 0
                        ( dbfTmp )->nPreDiv  := nComPro // nCnv2Div( nComPro, cDivEmp(), aTmpAlb[ _CDIVALB ], cDiv, .f. )
                     else
                        ( dbfTmp )->nPreDiv  := ( cArticulo )->pCosto // nCnv2Div( ( cArticulo )->pCosto, cDivEmp(), aTmpAlb[ _CDIVALB ], cDiv, .f. )
                     end if

                  end if

                  /*
                  Tratamos de obtener el precio por propiedades----------------
                  */

                  ( dbfTmp )->( dbUnLock() )

               end if

            end if

         next

      next

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts := .t.

      oOleExcel:End()

      ( dbfTmp )->( dbGoTop() )

      oBrw:Refresh()

   end if

Return nil

//---------------------------------------------------------------------------//

METHOD getExcelValue( columna, nFila )

