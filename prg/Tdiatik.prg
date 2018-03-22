#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaTik FROM TInfGen

   DATA  oTikCliP    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//
/*Creamos la temporal y el orden*/

METHOD Create()

   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",         .t., "Fecha",               16, .f. )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },   "Neto",          .t., "Neto",                15, .t. )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },   cImp(),           .t., cImp(),                 15, .t. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },   "Total",         .t., "Total",               15, .t. )
   ::AddField( "nCobTik", "N", 16, 6, {|| ::cPicOut },   "Cobrado",       .t., "Cobrado tiket",       15, .t. )

   ::AddTmpIndex( "DFECMOV", "DFECMOV" )

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles() CLASS TDiaTik

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oTikCliP  PATH ( cPatEmp() ) FILE "TIKEP.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Cerramos las tablas abiertas anteriormente*/

METHOD CloseFiles() CLASS TDiaTik

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
   ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
   ::oTikCliL:End()
   end if
   if !Empty( ::oTikCliP ) .and. ::oTikCliP:Used()
   ::oTikCliP:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oTikCliP := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaTik

   if !::StdResource( "INF_GEN26D" )
      return .f.
   end if

   /*Check para no dejar pasar las líneas con precio 0*/

   ::oDefExcInf()

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate() CLASS TDiaTik

   local aTotTmp  := {}
   local cExpHead := ""

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   /*Monta los filtros para la tabla de tickets*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead       := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*Recorremos las cabeceras*/

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*Tomamos los valores del tiket en un array*/

         aTotTmp                 := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         if !( ::lExcCero .AND. aTotTmp[3]== 0 )

            if !::oDbf:Seek( ::oTikCliT:dFecTik )

               /*Añadimos */

               ::oDbf:Append()

               ::oDbf:dFecMov    := ::oTikCliT:dFecTik
               ::oDbf:nTotNet    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[1], aTotTmp[1] )
               ::oDbf:nTotIva    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[2], aTotTmp[2] )
               ::oDbf:nTotDoc    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[3], aTotTmp[3] )
               ::oDbf:nCobTik    := nTotCobTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliP:cAlias, ::oDbfDiv:cAlias )

               ::oDbf:Save()

            else

               /*Acumulamos*/

               ::oDbf:Load()

               ::oDbf:nTotNet    += if( ::oTikCliT:cTipTik == "4", - aTotTmp[1], aTotTmp[1] )
               ::oDbf:nTotIva    += if( ::oTikCliT:cTipTik == "4", - aTotTmp[2], aTotTmp[2] )
               ::oDbf:nTotDoc    += if( ::oTikCliT:cTipTik == "4", - aTotTmp[3], aTotTmp[3] )
               ::oDbf:nCobTik    += nTotCobTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliP:cAlias, ::oDbfDiv:cAlias )

               ::oDbf:Save()

            end if

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oTikCliT:Skip()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//