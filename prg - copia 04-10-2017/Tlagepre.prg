#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TdlAgePre FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Pedidos" , "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFields()

   ::AddTmpIndex( "cCodAge", "cCodAge + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgeAlb

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL  PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TdlAgeAlb

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

METHOD Resource( cFld ) CLASS TdlAgeAlb

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN17" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefResInf ()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TdlAgeAlb

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPreCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPreCliT:lEstado  }
      case ::oEstado:nAt == 2
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader      := {{|| "Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE ! ::oPreCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPreCliT:DFECPRE >= ::dIniInf                                                    .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                    .AND.;
         ::oPreCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oPreCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPreCliL:Seek( ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE )

            while ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE == ::oPreCliL:CSERPRE + Str( ::oPreCliL:NNUMPRE ) + ::oPreCliL:CSUFPRE .AND. ! ::oPreCliL:eof()

                /* Preguntamos y tratamos el tipo de venta */

                if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oPreCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge := ::oPreCliT:cCodAge
                        ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
                        ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
                        ::oDbf:DFECMOV := ::oPreCliT:DFECPRE
                        ::oDbf:CDOCMOV := ::oPreCliT:CSERPRE + "/" + Str( ::oPreCliT:NNUMPRE ) + "/" + ::oPreCliT:CSUFPRE
                        ::oDbf:CREFART := ::oPreCliL:CREF
                        ::oDbf:CDESART := ::oPreCliL:cDetalle

                        if ::oDbfCli:Seek ( ::oPreCliT:CCODCLI )

                           ::oDbf:CNIFCLI := ::oDbfCli:Nif
                           ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                           ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                           ::oDbf:CPROCLI := ::oDbfCli:Provincia
                           ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                           ::oDbf:CTLFCLI := ::oDbfCli:Telefono

                        end if

                        if ( ::oDbfAge:Seek (::oPreCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                        end if

                        ::oDbf:Save()

                    end if

                /*
                Pasamos de los tipos de ventas
                */

                else

                  ::oDbf:Append()

                  ::oDbf:cCodAge := ::oPreCliT:cCodAge
                  ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oPreCliT:DFECPRE
                  ::oDbf:CDOCMOV := ::oPreCliT:CSERPRE + "/" + Str( ::oPreCliT:NNUMPRE ) + "/" + ::oPreCliT:CSUFPRE
                  ::oDbf:CREFART := ::oPreCliL:CREF
                  ::oDbf:CDESART := ::oPreCliL:cDetalle

                  if ::oDbfCli:Seek ( ::oPreCliT:CCODCLI )

                     ::oDbf:CNIFCLI := ::oDbfCli:Nif
                     ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                     ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                     ::oDbf:CPROCLI := ::oDbfCli:Provincia
                     ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                     ::oDbf:CTLFCLI := ::oDbfCli:Telefono

                  end if

                  if ( ::oDbfAge:Seek (::oPreCliT:cCodAge) )
                     ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                  end if

                  ::oDbf:NUNDCAJ := ::oPreCliL:NCANENT
                  ::oDbf:NCAJUND := NotCaja( ::oPreCliL:NCANENT )* ::oPreCliL:NUNICAJA
                  ::oDbf:NUNDART := ::oPreCliL:NUNICAJA
                  ::oDbf:nComAge := ( ::oPreCliL:nComAge )
                  ::oDbf:nBasCom := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                  ::oDbf:nTotCom := nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:Save()

                end if

                ::oPreCliL:Skip()

            end while

         end if

         end if

         ::oPreCliT:Skip()

         ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//