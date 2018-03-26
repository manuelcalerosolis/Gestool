#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TFamArticulo()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },          "Cod. família",  .f., "Cod. família"    ,  5, .f. } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },          "Família",       .f., "Família"         , 25, .f. } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },          "Cod. artículo", .t., "Codigo artículo" , 14, .f. } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },          "Descripción",   .t., "Descripción"     , 25, .f. } )
   aAdd( aCol, { "NUNTENT", "N", 16, 6, {|| MasUnd() },      "Unidades",      .t., "Unidades"        , 10, .t. } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut },  "Precio",        .t., "Precio artículo" , 10, .f. } )
   aAdd( aCol, { "NIVATIL", "N", 16, 6, {|| oInf:cPicOut },  "%" + cImp(),    .t., "%" + cImp()      ,  8, .f. } )
   aAdd( aCol, { "NTOTUNI", "N", 16, 6, {|| oInf:cPicOut },  "Total",         .t., "Total vendido"   , 10, .t. } )

   aAdd( aIdx, { "CCODFAM", "CCODFAM + CCODART" } )

   oInf        := TFamArt():New( "Informe resumido de ventas de artículos en tikets agrupados por familias", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cCodFam }, {|| "Família : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodFam, oInf:oDbfFam ) }, {||"Total família..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TFamArt FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikeT      AS OBJECT
   DATA  oTikeL      AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

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

   DATABASE NEW ::oTikeT PATH ( cPatEmp() ) CLASS "TIKETT" FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikeL PATH ( cPatEmp() ) CLASS "TIKETL" FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) CLASS "ARTICULO" FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN18" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Excluir si cero
   */

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodFam
   local nLasTik  := ::oTikeT:Lastrec()
   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikeT:GoTop()

   ::oMtrInf:SetTotal( nLasTik )

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Família : " + ::cFamOrg       + " > " + ::cFamDes       } }

   while !::oTikeT:Eof()

      if ::oTikeT:dFecTik >= ::dIniInf .and. ::oTikeT:dFecTik <= ::dFinInf

         if ::oTikeL:Seek( ::oTikeT:cSerTik + ::oTikeT:cNumTik + ::oTikeT:cSufTik )

            while ::oTikeL:cSerTil + ::oTikeL:cNumTil + ::oTikeL:cSufTil == ::oTikeT:cSerTik + ::oTikeT:cNumTik + ::oTikeT:cSufTik .and.;
                  !::oTikeL:eof()

               cCodFam := cCodFam( ::oTikeL:cCbaTil, ::oDbfArt )

               if cCodFam >= ::cFamOrg                             .and.;
                  cCodFam <= ::cFamDes                             .and.;
                  ::oTikeL:nCtlStk == 1                              .and.;
                  if( ::lExcCero, ::oTikeL:nUntTil != 0, .t. )

                  if ::oDbf:Seek( cCodFam + ::oTikeL:cCbaTil )

                     ::oDbf:Load()
                     ::oDbf:NUNTENT += if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil )
                     ::oDbf:NTOTUNI += if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil ) * ::oTikeL:nPvpTil
                     ::oDbf:NPREDIV := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:nIvaTil := ::oTikeL:nIvaTil
                     ::oDbf:Save()

                  else

                     ::oDbf:Append()
                     ::oDbf:CCODFAM := cCodFam
                     ::oDbf:CNOMFAM := cNomFam( cCodFam, ::oDbfFam )
                     ::oDbf:CCODART := ::oTikeL:cCbaTil
                     ::oDbf:CNOMART := ::oTikeL:cNomTil
                     ::oDbf:NUNTENT := if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil )
                     ::oDbf:NTOTUNI := if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil ) * ::oTikeL:nPvpTil
                     ::oDbf:NPREDIV := ::oTikeL:nPvpTil
                     ::oDbf:nIvaTil := ::oTikeL:nIvaTil
                     ::oDbf:Save()

                   end if

               end if

               ::oTikeL:Skip()

            end while

         end if

      end if

      ::oTikeT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//