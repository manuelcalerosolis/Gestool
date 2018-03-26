#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfDetTik FROM TInfAlm

   DATA  nEstado     AS NUMERIC  INIT 1
   DATA  oTikeT      AS OBJECT
   DATA  oTikeL      AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFields()

   ::AddTmpIndex ( "CCODALM", "CCODALM + CCODART" )
   ::AddGroup( {|| ::oDbf:cCodAlm },                     {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) },  {||"Total almacén ..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

    /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   DATABASE NEW ::oTikeT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikeL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oTikeT ) .and. ::oTikeT:Used()
      ::oTikeT:End()
   end if
   if !Empty( ::oTikeL ) .and. ::oTikeL:Used()
      ::oTikeL:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN01A" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikeT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   /* REDEFINE RADIO ::nEstado ;
      ID       201, 202, 203, 204 ;
      OF       ::oFld:aDialogs[1] */

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikeT:GoTop()

   /*
   Nos movemos por las cabeceras de los pedidos a proveedores
	*/

   WHILE ! ::oTikeT:Eof()

      if ( ::oTikeT:cTipTik == "1" .OR. ::oTikeT:cTipTik == "4" ) .AND.;
         ::oTikeT:DFECTIK >= ::dIniInf                            .AND.;
         ::oTikeT:DFECTIK <= ::dFinInf

         if ::oTikeL:Seek( ::oTikeT:CSERTIK +  ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK )

            /*
            Posicionamos en las lineas de detalle --------------------------------
            */

            while ::oTikeT:CSERTIK + ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. !::oTikeL:eof()

               if !Empty( ::oTikeL:cCbaTil )                      .AND.;
                  ::oTikeL:cCbaTil >= ::cArtOrg                   .AND.;
                  ::oTikeL:cCbaTil <= ::cArtDes                   .AND.;
                  ::oTikeL:CALMLIN >= ::cAlmOrg                   .AND.;
                  ::oTikeL:CALMLIN <= ::cAlmDes                   .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  /*
                  Viene de la clase padre
                  */
                  ::AddTik()

               end if

               /*
               Para los productos combinados-----------------------------------
               */

               if !Empty( ::oTikeL:cComTil )                      .AND.;
                  ::oTikeL:cComTil >= ::cArtOrg                   .AND.;
                  ::oTikeL:cComTil <= ::cArtDes                   .AND.;
                  ::oTikeL:CALMLIN >= ::cAlmOrg                   .AND.;
                  ::oTikeL:CALMLIN <= ::cAlmDes                   .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  ::AddTik()

               end if

               ::oTikeL:Skip()

            end while

         end if

      end if

      ::oTikeT:Skip()

      ::oMtrInf:AutoInc( ::oTikeT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oTikeT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//