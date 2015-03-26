#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfNotas FROM TInfGen

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "dFecNot", "D",   8, 0, {|| "@!" },  "Fecha",       .t., "Fecha",             12 )
   ::AddField( "cHorNot", "C",   4, 0, {|| "@!" },  "Hora",        .f., "Hora",              10 )
   ::AddField( "cTexNot", "C", 100, 0, {|| "@!" },  "Asunto",      .t., "Asunto",            50 )
   ::AddField( "cIntNot", "C",  35, 0, {|| "@!" },  "Interesado",  .f., "Interesado",        20 )
   ::AddField( "cCodigo", "C",  12, 0, {|| "@!" },  "Código",      .t., "Código",            12 )
   ::AddField( "cNombre", "C", 100, 0, {|| "@!" },  "Nombre",      .t., "Nombre",            35 )
   ::AddField( "cTipNot", "C",  30, 0, {|| "@!" },  "Tipo",        .t., "Tipo",              20 )
   ::AddField( "dVctNot", "D",   8, 0, {|| "@!" },  "Vencim.",     .f., "Vencimiento",       12 )
   ::AddField( "cEstNot", "C",  50, 0, {|| "@!" },  "Estado",      .t., "Estado",            25 )
   ::AddField( "cUsrNot", "C",   3, 0, {|| "@!" },  "Usuario",     .f., "Usuario",            5 )
   ::AddField( "cTipDoc", "C",  20, 0, {|| "@!" },  "Tipo doc.",   .f., "Tipo de documento", 20 )
   ::AddField( "cNumDoc", "C",  12, 0, {|| "@!" },  "Documento",   .t., "Documento",         18 )
   ::AddField( "mDesNot", "M",  10, 0, {|| "@!" },  "Descrip.",    .f., "Texto largo nota",  20 )
   ::AddField( "mObsNot", "M",  10, 0, {|| "@!" },  "Observa.",    .f., "Observaciones",     20 )

   ::AddTmpIndex( "dFecNot", "dFecNot" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_ENT01" )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::xOthers:Lastrec() )

   ::CreateFilter( ,::xOthers )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nRec     := ::xOthers:Recno()
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   ::xOthers:OrdSetFocus( "DFECNOT" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::xOthers:AddTmpIndex( cCurUsr(), GetFileNoExt( ::xOthers:cFile ), ::xOthers:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::xOthers:GoTop()

   while !::lBreak .and. !::xOthers:Eof()

      if ::xOthers:dFecNot >= ::dIniInf .and. ::xOthers:dFecNot <= ::dFinInf

         ::oDbf:Append()

         ::oDbf:dFecNot  := ::xOthers:dFecNot
         ::oDbf:cHorNot  := ::xOthers:cHorNot
         ::oDbf:cTexNot  := ::xOthers:cTexNot

         do case
            case ::xOthers:nIntNot  == 1
               ::oDbf:cIntNot  := "Cliente"
            case ::xOthers:nIntNot  == 2
               ::oDbf:cIntNot  := "Proveedor"
            case ::xOthers:nIntNot  == 3
               ::oDbf:cIntNot  := "Artículo"
            case ::xOthers:nIntNot  == 4
               ::oDbf:cIntNot  := "Agente"
            case ::xOthers:nIntNot  == 5
               ::oDbf:cIntNot  := "Almacén"
         end case

         ::oDbf:cCodigo  := ::xOthers:cIntNot
         ::oDbf:cNombre  := ::xOthers:cNomNot
         ::oDbf:cTipNot  := ::xOthers:cTipNot
         ::oDbf:dVctNot  := ::xOthers:dVctNot
         ::oDbf:cEstNot  := ::xOthers:cEstNot
         ::oDbf:cUsrNot  := ::xOthers:cUsrNot
         ::oDbf:cTipDoc  := cTextDocument( ::xOthers:cTipDoc )
         ::oDbf:cNumDoc  := ::xOthers:cNumDoc
         ::oDbf:mDesNot  := ::xOthers:cDesNot
         ::oDbf:mObsNot  := ::xOthers:cObsNot

         ::oDbf:Save()

      end if

      ::xOthers:Skip()

      ::oMtrInf:AutoInc( ::xOthers:OrdKeyNo() )

   end while

   ::xOthers:IdxDelete( cCurUsr(), GetFileNoExt( ::xOthers:cFile ) )

   ::oMtrInf:AutoInc( ::xOthers:Lastrec() )

   ::oDlg:Enable()

   ::xOthers:GoTo( nRec )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//