#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION InfDetAge()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODAGE", "C",  3, 0, {|| "@!" },         "Cod. Agente",    .f. } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. Cliente",   .f. } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",        .t. } )
   aAdd( aCol, { "CCODALB", "C", 12, 0, {|| "@!" },         "Documento",      .t. } )
   aAdd( aCol, { "CCSUALB", "C", 12, 0, {|| "@!" },         "Su albaran",     .t. } )
   aAdd( aCol, { "DFECALB", "D",  8, 0, {|| "" },           "Fecha",          .t. } )
   aAdd( aCol, { "NUNDCAJ", "N", 13, 6, {|| MasUnd() },     "Cajas",          .t. } )
   aAdd( aCol, { "NUNDART", "N", 13, 6, {|| MasUnd() },     "Unidades",       .t. } )
   aAdd( aCol, { "CREFART", "C", 14, 0, {|| "@!" },         "Cod. Artículo",  .t. } )
   aAdd( aCol, { "CDESART", "C", 50, 0, {|| "@!" },         "Artículo",       .t. } )
   aAdd( aCol, { "CCODMOV", "C",  2, 0, {|| "@!" },         "Mov.",           .t. } )
   aAdd( aCol, { "NBASCOM", "N", 13, 0, {|| oInf:cPicOut }, "Base",           .t. } )
   aAdd( aCol, { "NCOMAGE", "N",  4, 1, {|| oInf:cPicOut }, "%Comisión",      .t. } )
   aAdd( aCol, { "NTOTCOM", "N", 13, 0, {|| oInf:cPicOut }, "Comisión",       .t. } )

   aAdd( aIdx, { "CCODAGE", "CCODAGE + CREFART" } )

   oInf  := TInfDetAge():New( "Informe de liquidación de agentes", aCol, aIdx, "01043" )

   oInf:AddGroup( {|| oInf:oDbf:cCodAge }, {|| "Agente : " + Rtrim( oInf:oDbf:cCodAge ) + "-" + oRetFld( oInf:oDbf:cCodAge, oInf:oDbfAge ) }, {||"Total agente..."} )
   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfDetAge FROM TInfGen

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  cVta        INIT  Space( 2 )
   DATA  lVta        AS LOGIC

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODAGE", "C",  3, 0, {|| "@!" },         "Cod. Agente",    .f. )
   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. Cliente",   .f. )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",        .t. )
   ::AddField( "CCODALB", "C", 12, 0, {|| "@!" },         "Documento",      .t. )
   ::AddField( "CCSUALB", "C", 12, 0, {|| "@!" },         "Su albaran",     .t. )
   ::AddField( "DFECALB", "D",  8, 0, {|| "" },           "Fecha",          .t. )
   ::AddField( "NUNDCAJ", "N", 13, 6, {|| MasUnd() },     "Cajas",          .t. )
   ::AddField( "NUNDART", "N", 13, 6, {|| MasUnd() },     "Unidades",       .t. )
   ::AddField( "CREFART", "C", 14, 0, {|| "@!" },         "Cod. Artículo",  .t. )
   ::AddField( "CDESART", "C", 50, 0, {|| "@!" },         "Artículo",       .t. )
   ::AddField( "CCODMOV", "C",  2, 0, {|| "@!" },         "Mov.",           .t. )

   ::AddTmpIndex( "CCODAGE", "CCODAGE + CREFART" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

    ::oAlbCliT := TDataCenter():oAlbCliT()
   ::oAlbCliT:OrdSetFocus( "CCODAGE" )

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local oGet1
   local cGet2
   local oGet2
   local This  := Self

   if !::StdResource( "INF_GEN_AGE" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oDefExcInf()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefResInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nUndCaj
   local nUndArt
   local nComAge
   local nBasCom
   local nTotCom
   local nComUnd  := 1
   local nComImp  := 1

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oAlbCliT:Seek( ::cAgeOrg )
   ::oAlbCliT:Load()

   WHILE ::oAlbCliT:CCODAGE >= ::cAgeOrg           .AND.;
         ::oAlbCliT:CCODAGE <= ::cAgeDes           .AND.;
         lFacturado( ::oAlbCliT )                  .AND.;
         !::oAlbCliT:Eof()

         IF ::oAlbCliT:DFECALB >= ::dIniInf        .AND.;
            ::oAlbCliT:DFECALB <= ::dFinInf

				/*
				Posicionamos en las lineas de detalle
				*/

            ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )
            ::oAlbCliL:Load()

            WHILE ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND.;
                  !::oAlbCliT:Eof()

               IF ::oAlbCliL:CREF >= ::cArtOrg     .AND. ;
                  ::oAlbCliL:CREF <= ::cArtDes

                  nUndCaj     := abs( ::oAlbCliL:NCANENT )              * nComUnd
                  nUndArt     := abs( nUnitEnt( ::oAlbCliL:cAlias ) )   * nComUnd
                  nComAge     := abs( ::oAlbCliL:NCOMAGE )              * nComImp
                  nBasCom     := abs( nNetLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) ) * nComImp
                  nTotCom     := abs( Round( nBasCom * ::oAlbCliL:NCOMAGE / 100, ::nDerOut ) ) * nComImp

                  IF ( ::lVta .AND. ( ::oAlbCliL:CTIPMOV == ::cVta .OR. empty( ::cVta ) ) ) .OR. ;
                     !::lVta

                     IF !::lResumen .or. !::oDbf:Seek( ::oAlbCliT:CCODAGE + ::oAlbCliL:CREF )

                        ::oDbf:Append()
                        ::oDbf:CCODAGE := ::oAlbCliT:CCODAGE
                        ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                        ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                        ::oDbf:CCODALB := ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB
                        ::oDbf:CCSUALB := ::oAlbCliT:CCODSUALB
                        ::oDbf:DFECALB := ::oAlbCliT:DFECALB
                        ::oDbf:NUNDCAJ := nUndCaj
                        ::oDbf:NUNDART := nUndArt
                        ::oDbf:CREFART := ::oAlbCliL:CREF
                        ::oDbf:CDESART := ::oAlbCliL:CDETALLE
                        ::oDbf:CCODMOV := ::oAlbCliL:CTIPMOV
                        ::oDbf:NBASCOM := nBasCom
                        ::oDbf:NCOMAGE := nComAge
                        ::oDbf:NTOTCOM := nTotCom
                        ::oDbf:Save()

                     ELSE

                        ::oDbf:NUNDCAJ += nUndCaj
                        ::oDbf:NUNDART += nUndArt
                        ::oDbf:NBASCOM += nBasCom
                        ::oDbf:NTOTCOM += nTotCom
                        ::oDbf:Save()

                     END IF

                  END IF

               END IF

               ::oAlbCliL:Skip():Load()

            END DO

			END IF

         ::oAlbCliT:Skip():Load()

         ::oMtrInf:AutoInc()

	END DO

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//