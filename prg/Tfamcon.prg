#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TFamConta FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  oTurnoT     AS OBJECT
   DATA  oTurnoL     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODTUR", "C",  6, 0, {|| "@!" },          "Cod. turno",    .f., "Sesión"           ,  6 )
   ::AddField( "CSUFTUR", "C",  2, 0, {|| "@!" },          "Sufijo turno",  .f., "Sufijo"          ,  2 )
   ::AddField( "CCODFAM", "C", 16, 0, {|| "@!" },          "Cod. familia",  .f., "Cod. familia"    ,  5 )
   ::AddField( "CNOMFAM", "C", 50, 0, {|| "@!" },          "Familia",       .f., "Familia"         , 25 )
   ::AddField( "CCODART", "C", 18, 0, {|| "@!" },          "Cod. Artículo", .t., "Codigo artículo" , 14 )
   ::AddField( "CNOMART", "C",100, 0, {|| "@!" },          "Descripción",   .t., "Descripción"     , 25 )
   ::AddField( "NUNTENT", "N", 16, 6, {|| MasUnd() },      "Unidades",      .t., "Unidades"        , 10 )
   ::AddField( "NPREDIV", "N", 16, 6, {|| ::cPicOut },     "Precio",        .t., "Precio artículo" , 10 )
   ::AddField( "NTOTUNI", "N", 16, 6, {|| ::cPicOut },     "Total",         .t., "Total vendido"   , 10 )

   ::AddTmpIndex ( "CCODFAM", "CCODFAM + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {||"Total familia..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTurnoT PATH ( cPatEmp() ) CLASS "TURNOT" FILE "TURNO.DBF" VIA ( cDriver() ) SHARED INDEX "TURNO.CDX"

   DATABASE NEW ::oTurnoL PATH ( cPatEmp() ) CLASS "TURNOL" FILE "TURNOL.DBF" VIA ( cDriver() ) SHARED INDEX "TURNOL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) CLASS "ARTICULO" FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oTurnoT ) .and. ::oTurnoT:Used()
      ::oTurnoT:End()
   end if
   if !Empty( ::oTurnoL ) .and. ::oTurnoL:Used()
      ::oTurnoL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oTurnoT := nil
   ::oTurnoL := nil
   ::oDbfArt := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN18B" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefFamInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   /*
   Excluir si cero
   */

   ::oDefExcInf()

   ::oDefResInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodFam

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oTurnoT:GoTop()

   ::oMtrInf:SetTotal( ::oTurnoT:Lastrec() )

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       } }

   while !::lBreak .and. !::oTurnoT:Eof()

      if ::oTurnoT:dOpnTur >= ::dIniInf      .AND.;
         ::oTurnoT:dCloTur <= ::dFinInf

         if ::oTurnoL:Seek( ::oTurnoT:cNumTur + ::oTurnoT:cSufTur )

            while ::oTurnoL:cNumTur + ::oTurnoL:cSufTur == ::oTurnoT:cNumTur + ::oTurnoT:cSufTur

               cCodFam := cCodFam( ::oTurnoL:cCodArt, ::oDbfArt )

               if ( ::lAllFam .or. ( cCodFam >= ::cFamOrg .and. cCodFam <= ::cFamDes ) ) .and.;
                  ( if( ::lExcCero, ( ::oTurnoL:nCanAct - ::oTurnoL:nCanAnt != 0 ), .t. ) )

                  if ::oDbf:Seek( cCodFam + ::oTurnoL:cCodArt )

                     ::oDbf:Load()
                     ::oDbf:nUntEnt += ::oTurnoL:nCanAct - ::oTurnoL:nCanAnt
                     ::oDbf:nTotUni += ( ::oTurnoL:nCanAct - ::oTurnoL:nCanAnt ) * ::oTurnoL:nPvpArt
                     ::oDbf:nPreDiv := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:Save()

                  else

                     ::oDbf:Append()
                     ::oDbf:cCodTur := ::oTurnoL:cNumTur
                     ::oDbf:cSufTur := ::oTurnoL:cSufTur
                     ::oDbf:cCodFam := cCodFam
                     ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTurnoL:cCodArt
                     ::oDbf:cNomArt := ::oTurnoL:cNomArt
                     ::oDbf:nUntEnt := ::oTurnoL:nCanAct - ::oTurnoL:nCanAnt
                     ::oDbf:nTotUni := ( ::oTurnoL:nCanAct - ::oTurnoL:nCanAnt ) * ::oTurnoL:nPvpArt
                     ::oDbf:nPreDiv := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:Save()

                   end if

               end if

               ::oTurnoL:Skip()

            end while

         end if

      end if

      ::oTurnoT:Skip()

      ::oMtrInf:AutoInc( ::oTurnoT:OrdKeyNo() )

   end while

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//