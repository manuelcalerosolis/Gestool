#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGrpTik FROM TInfGrp

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

   ::DetalleCreateFields()

   ::AddTmpIndex( "CGRPFAM", "CGRPFAM + CCODART" )
   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo Familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf ) }, {||"Total Grupo de Familia..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )


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

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

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

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INFGRPTIK" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefGrFInf( 70, 80, 90, 100 )

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


RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Nos movemos por las cabeceras de los pedidos a proveedores
	*/

   ::oTikeT:GoTop()
   WHILE !::oTikeT:Eof()

      if ( ::oTikeT:cTipTik == "1" .OR. ::oTikeT:cTipTik == "4" ) .AND.;
         ::oTikeT:dFecTik  >= ::dIniInf                           .AND.;
         ::oTikeT:dFecTik  <= ::dFinInf

         if ::oTikeL:Seek( ::oTikeT:CSERTIK +  ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK )

            while ::oTikeT:CSERTIK + ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. !::oTikeL:eof()

               if !Empty( ::oTikeL:cCbaTil )                                                                  .AND.;
                  ::oTikeL:cCbaTil >= ::cArtOrg                                                               .AND.;
                  ::oTikeL:cCbaTil <= ::cArtDes                                                               .AND.;
                  cCodGruFam( ::oTikeL:cCbaTil, ::oDbfArt, ::oDbfFam )  >= ::cGruFamOrg                       .AND.;
                  cCodGruFam( ::oTikeL:cCbaTil, ::oDbfArt, ::oDbfFam )  <= ::cGruFamDes                       .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  /*
                  Nuevo registro
                  */
                  ::AddTik()

               end if

               if !Empty( ::oTikeL:cComTil )                                                                  .AND.;
                  ::oTikeL:cComTil >= ::cArtOrg                                                               .AND.;
                  ::oTikeL:cComTil <= ::cArtDes                                                               .AND.;
                  cCodGruFam( ::oTikeL:cComTil, ::oDbfArt, ::oDbfFam )  >= ::cGruFamOrg                       .AND.;
                  cCodGruFam( ::oTikeL:cComTil, ::oDbfArt, ::oDbfFam )  <= ::cGruFamDes                       .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  /*
                  Nuevo registro
                  */
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