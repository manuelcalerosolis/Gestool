#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRnkArticulo FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
    
   DATA  oLimit      AS OBJECT
   DATA  nLimit                  INIT 0
   DATA  lAllPrc     AS LOGIC    INIT .t.
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD SumaImporte( lSuma )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!"          },"Código",                    .t., "Código artículo",            9 )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!"          },"Artículo",                  .t., "Nombre artículo",           35 )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd()      },cNombreCajas(),              .f., cNombreCajas(),              10 )
   ::AddField( "nTotUnd", "N", 16, 6, {|| MasUnd()      },cNombreUnidades(),           .f., cNombreUnidades(),           10 )
   ::AddField( "nTotTot", "N", 16, 3, {|| MasUnd()      },"Tot. " + cNombreUnidades(), .t., "Total " + cNombreunidades(),10 )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut     },"Neto",                      .t., "Neto",                      10 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut     },cImp(),                       .t., cImp(),                       10 )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut     },"Rec",                       .f., "Recargo equivalencia",      10 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut     },"Total",                     .t., "Total",                     10 )
   ::AddField( "nAcuCaj", "N", 16, 6, {|| MasUnd()      },"Acu. Caj.",                 .f., "Cajas acumuladas",          10 )
   ::AddField( "nAcuUnd", "N", 16, 6, {|| MasUnd()      },"Acu. Und.",                 .f., "Unidades acumulada",        10 )
   ::AddField( "nAcuTot", "N", 16, 3, {|| MasUnd()      },"Acu. Tot.",                 .f., "Total unidades acumuladas", 10 )
   ::AddField( "nAcuNet", "N", 16, 6, {|| ::cPicOut     },"Acu. Neto",                 .f., "Neto acumulado",            10 )
   ::AddField( "nAcuIva", "N", 16, 6, {|| ::cPicOut     },"Acu. " + cImp(),                  .f., cImp() + " acumulado",             10 )
   ::AddField( "nAcuReq", "N", 16, 3, {|| ::cPicOut     },"Acu. Rec.",                 .f., "Recargo equivalencia acumulado", 10 )
   ::AddField( "nAcuDoc", "N", 16, 6, {|| ::cPicOut     },"Acu. Total",                .f., "Total acumulado",           10 )

   ::AddTmpIndex( "CCODART", "CCODART", , , , .t. )
   ::AddTmpIndex( "NTOTDOC", "NTOTDOC", , , , .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRnkArticulo

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::bForReport   := {|| ::lAllPrc .or. ::oDbf:nTotNet >= ::nLimit }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRnkArticulo

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
    
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
    
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRnkArticulo

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN15A" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   REDEFINE CHECKBOX ::lAllPrc ;
      ID       160 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oLimit VAR ::nLimit ;
		COLOR 	CLR_GET ;
      PICTURE  PicOut() ;
      WHEN     !::lAllPrc ;
      ID       150 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRnkArticulo

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()
   ::oDbf:OrdSetFocus( "CCODART" )

   ::aHeader   :={ {|| "Fecha     : "  + Dtoc( Date() ) },;
                   {|| "Artículos : "  + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg )+ " > " + AllTrim( ::cArtDes ) ) },;
                   {|| "Importe   : "  + if( ::lAllPrc, "Todos los importes", "Mayor de : " + Str( ::nLimit ) ) },;
                   {|| "Estado    : "  + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         ::SumaImporte( .t. )

      else

         ::SumaImporte( .f. )

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( "NTOTDOC" )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD SumaImporte( lSuma ) CLASS TRnkArticulo

   local nTotCaj     := 0
   local nTotUnd     := 0
   local nTotTot     := 0
   local nTotNet     := 0
   local nTotIva     := 0
   local nTotReq     := 0
   local nTotDoc     := 0

   if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

      while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .and. !::oFacCliL:eof()

         if !( ::oFacCliL:lTotLin ) .and. !( ::oFacCliL:lControl )                           .and.;
            ( ::lAllArt .or. ( ::oFacCliL:cRef >= ::cArtOrg .AND. ::oFacCliL:cRef <= ::cArtDes ) )

            nTotCaj     := ::oFacCliL:nCanEnt
            nTotUnd     := ::oFacCliL:nUniCaja
            nTotTot     := nTotNFacCli( ::oFacCliL )
            nTotNet     := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
            nTotIva     := Round( nTotNet * ::oFacCliL:nIva / 100, ::nDerOut )
            nTotReq     := If( ::oFacCliT:lRecargo, Round( nTotNet * nPReq( ::oDbfIva:cAlias, ::oFacCliL:nIva ) / 100, ::nDerOut ), 0 )
            nTotDoc     := nTotNet + nTotIva + nTotReq

            if ::oDbf:Seek( ::oFacCliL:cRef )

               ::oDbf:Load()

               if lSuma
                  ::oDbf:nTotCaj += nTotCaj
                  ::oDbf:nTotUnd += nTotUnd
                  ::oDbf:nTotTot += nTotTot
                  ::oDbf:nTotNet += nTotNet
                  ::oDbf:nTotIva += nTotIva
                  ::oDbf:nTotReq += nTotReq
                  ::oDbf:nTotDoc += nTotDoc
               end if

               ::oDbf:nAcuCaj    += nTotCaj
               ::oDbf:nAcuUnd    += nTotUnd
               ::oDbf:nAcuTot    += nTotTot
               ::oDbf:nAcuNet    += nTotNet
               ::oDbf:nAcuIva    += nTotIva
               ::oDbf:nAcuReq    += nTotReq
               ::oDbf:nAcuDoc    += nTotDoc

               ::oDbf:Save()

            else

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodArt    := ::oFacCliL:cRef
               ::oDbf:cNomArt    := ::oFacCliL:cDetalle

               if lSuma
                  ::oDbf:nTotCaj := nTotCaj
                  ::oDbf:nTotUnd := nTotUnd
                  ::oDbf:nTotTot := nTotTot
                  ::oDbf:nTotNet := nTotNet
                  ::oDbf:nTotIva := nTotIva
                  ::oDbf:nTotReq := nTotReq
                  ::oDbf:nTotDoc := nTotDoc
               end if

               ::oDbf:nAcuCaj    := nTotCaj
               ::oDbf:nAcuUnd    := nTotUnd
               ::oDbf:nAcuTot    := nTotTot
               ::oDbf:nAcuNet    := nTotNet
               ::oDbf:nAcuIva    := nTotIva
               ::oDbf:nAcuReq    := nTotReq
               ::oDbf:nAcuDoc    := nTotDoc

               ::oDbf:Save()

            end if

         end if

         ::oFacCliL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//