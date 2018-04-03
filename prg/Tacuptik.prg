#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuPTik FROM TInfTrn

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AcuCreate()

   ::AddTmpIndex( "cCodRut", "cCodRut" )

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAcuUTik

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"
   ::oTikCliT:OrdSetFocus( "dFecTik" )

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TAcuUTik

   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oDbfArt:End()
   ::oDbfFam:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TAcuUTik

   if !::StdResource( "INFACUTRN" )
      return .f.
   end if

   /*
   Monta las rutas de manera automatica
   */

   ::oDefRutInf( 70, 71, 80, 81 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oDefExcInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TAcuUTik

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Rutas  : " + AllTrim( ::cRutOrg )+ " > " + AllTrim( ::cRutDes ) } }

   ::oTikCliT:Seek( ::dIniInf , .t. )

   while ::oTikCliT:dFecTik <= ::dFinInf .and. !::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" ) .AND.;
         ::oTikCliT:cCodRut >= ::cRutOrg                              .AND.;
         ::oTikCliT:cCodRut <= ::cRutDes                              .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

               if !Empty( ::oTikCliL:cCbaTil )               .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                  ::AddTik( ::oTikCliL:cCbaTil, 1, .t. )

               end if

               if !Empty( ::oTikCliL:cComTil )                                                      .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPcmTil == 0 )

                  ::AddTik( ::oTikCliL:cComTil, 2, .t. )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//