#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TInfRemCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "nNumRem", "N",  9, 0, {|| "999999999" },  "Num. remesa",       .t. } )
   aAdd( aCol, { "cSufRem", "C",  2, 0, {|| "@!" },         "Sufijo remesa",     .t. } )
   aAdd( aCol, { "cCodRem", "C",  3, 0, {|| "@!" },         "Codigo de remesa",  .t. } )
   aAdd( aCol, { "dFecRem", "D",  8, 0, {|| "" },           "Cliente",           .t. } )
   aAdd( aCol, { "cSerRec", "c",  1, 0, {|| "" },           "Serie",             .t. } )
   aAdd( aCol, { "nNumRec", "N",  9, 0, {|| "999999999" },  "Número",            .t. } )
   aAdd( aCol, { "dFecRec", "D",  8, 0, {|| "" },           "Fecha del recibo",  .t. } )
   aAdd( aCol, { "nImpRec", "N", 16, 6, {|| oInf:cPicOut }, "Importe",           .t. } )

   aAdd( aIdx, { "cNumRem", "Str( nNumRem ) + cSufRem" } )

   oInf  := TInfCliArt():New( "Listado de remesas", aCol, aIdx, "01043" )

   oInf:AddGroup( {|| Str( oInf:oDbf:nNumRem ) + oInf:oDbf:cSufRem }, {|| "Remesa  : " + Str( oInf:oDbf:nNumRem ) + oInf:oDbf:cSufRem }, {|| "Total remesa..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfRemCli FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  nEstado     AS NUMERIC  INIT 1
   DATA  oRemCliT    AS OBJECT
   DATA  oFacCliP    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   DATABASE NEW ::oRemCliT PATH ( cPatEmp() ) FILE "REMCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "REMCLIT.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oRemCliT ) .and. ::oRemCliT:Used()
      ::oRemCliT:End()
   end if

   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN04" )
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

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE RADIO ::nEstado ID 201, 202, 203 OF ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oAlbCliT:GoTop():Load()

   do case
      case ::nEstado == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::nEstado == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::nEstado == 3
         bValid   := {|| .t. }
   end case

	/*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   WHILE ! ::oAlbCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                    .AND.;
         ::oAlbCliT:CCODALM >= ::cAlmOrg                                                    .AND.;
         ::oAlbCliT:CCODALM <= ::cAlmDes                                                    .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            ::oAlbCliL:load()

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if ::oAlbCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oAlbCliL:CREF <= ::cArtDes                 .AND.;
                  !( ::lExcCero .AND. ::oAlbCliL:NPREUNIT == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODALM := ::oAlbCliT:CCODALM
                  ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oAlbCliT:DFECALB
                  ::oDbf:CCODAGE := ::oAlbCliT:CCODAGE

                  ::oDbf:CCODART := ::oAlbCliL:CREF
                  ::oDbf:NCAJENT := ::oAlbCliL:NCANENT
                  ::oDbf:NUNTENT := NotCaja( ::oAlbCliL:NCANENT ) * ::oAlbCliL:NUNICAJA
                  ::oDbf:nPreDiv := nNetLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:CDOCMOV := ::oAlbCliL:CSERALB + "/" + Str( ::oAlbCliL:NNUMALB ) + "/" + ::oAlbCliL:CSUFALB

                  ::oDbf:Save()

               end if

               ::oAlbCliL:Skip():Load()

            end while

         end if

      end if

      ::oAlbCliT:Skip():Load()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//