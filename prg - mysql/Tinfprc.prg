#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Factu.ch" 
   #include "MesDbf.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

//---------------------------------------------------------------------------//

CLASS TInfDetPre FROM TInfAlm

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create()

   ::CreateFields()

   ::AddTmpIndex( "CCODALM", "CCODALM + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodAlm },                     {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {||"Total almacén..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//
/*
Ficheros necesarios
*/

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oPreCliT  := TDataCenter():oPreCliT()

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

      DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource ( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN01C" )
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

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPreCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Creamos la cabcera del listado
   */

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacen: " + ::cAlmOrg         + " > " + ::cAlmDes },;
                        {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los presupuestos a proveedores
	*/

   while ! ::oPreCliT:Eof()

      if Eval( bValid )                                                                     .AND.;
         ::oPreCliT:dFecPre >= ::dIniInf                                                    .AND.;
         ::oPreCliT:dFecPre <= ::dFinInf                                                    .AND.;
         lChkSer( ::oPreCliT:cSerPre, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPreCliL:Seek( ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE )

            while ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre .AND. ! ::oPreCliL:eof()

               if ::oPreCliL:cRef >= ::cArtOrg                                    .AND.;
                  ::oPreCliL:cRef <= ::cArtDes                                    .AND.;
                  ::oPreCliL:cAlmLin >= ::cAlmOrg                                 .AND.;
                  ::oPreCliL:cAlmLin <= ::cAlmDes                                 .AND.;
                  !( ::lExcCero .AND. ::oPreCliL:NUNICAJA == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm    := ::oPreCliL:cAlmLin
                  ::oDbf:dFecMov    := ::oPreCliT:dFecPre

                  ::oDbf:cCodArt    := ::oPreCliL:cRef
                  ::oDbf:cNomArt    := RetArticulo( ::oPreCliL:cRef, ::oDbfArt )
                  ::oDbf:nCajEnt    := ::oPreCliL:nCanEnt
                  ::oDbf:nUnidad    := ::oPreCliL:NUNICAJA
                  ::oDbf:nUntEnt    := nTotNPreCli( ::oPreCliL )
                  ::oDbf:nPreDiv    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:cTipDoc := "Presupuesto"
                  ::oDbf:cDocMov    := lTrim ( ::oPreCliL:cSerPre ) + "/" + lTrim ( Str( ::oPreCliL:nNumPre ) ) + "/" +  lTrim( ::oPreCliL:cSufPre )

                  ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )

                  ::oDbf:Save()

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//