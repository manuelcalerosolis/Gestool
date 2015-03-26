#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TPreArt()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Cod. Artículo",  .t., "Cod. Artículo", 14 } )
   aAdd( aCol, { "CNOMART", "C", 50, 0, {|| "@!" },         "Descripción",    .t., "Descripción",   35 } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },         "Familia",        .f., "Familia",        5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },         "Descripción",    .f., "Descripción",   20 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut }, "Precio",         .t., "Precio",         8 } )

   aAdd( aIdx, { "CCODFAM", "CCODFAM + CCODART" } )

   oInf  := TInfPreArt():New( "Informe detallado de los precios de cada artículo", aCol, aIdx, "01048" )

   oInf:AddGroup( {|| oInf:oDbf:cCodFam },                     {|| "Familia  : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodFam, oInf:oDbfFam ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfPreArt FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oStock      AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD oDefIniInf()  VIRTUAL
   METHOD oDefFinInf()  VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local cEstado := "Precio 1"

   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GEN09" )
      return .f.
   end if

   /*
   Monta las Familias de manera automatica
   */

   ::lDefFamInf( 70, 80, 90, 100 )

   ::oDefExcInf()

   /*
   Monta los Artículos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

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

METHOD lGenerate()

   local nPreDiv

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dIniInf ) },;
                     {|| "Familia: " + ::cFamOrg       + " > " + ::cFamDes },;
                     {|| "Precio : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oDbfArt:GoTop()

      while !::oDbfArt:Eof() .AND. ( ::oDbfArt:CODIGO >= ::cArtOrg .AND. ::oDbfArt:CODIGO <= ::cArtDes )

         if ::oDbfArt:FAMILIA >= ::cFamOrg .AND. ::oDbfArt:FAMILIA <= ::cFamDes


         do case
            case ::oEstado:nAt == 1
               nPreDiv    := Round( ::oDbfArt:pVenta1 / ::nValDiv, ::nDecOut )
            case ::oEstado:nAt == 2
               nPreDiv    := Round( ::oDbfArt:pVenta2 / ::nValDiv, ::nDecOut )
            case ::oEstado:nAt == 3
               nPreDiv    := Round( ::oDbfArt:pVenta3 / ::nValDiv, ::nDecOut )
            case ::oEstado:nAt == 4
               nPreDiv    := Round( ::oDbfArt:pVenta4 / ::nValDiv, ::nDecOut )
            case ::oEstado:nAt == 5
               nPreDiv    := Round( ::oDbfArt:pVenta5 / ::nValDiv, ::nDecOut )
            case ::oEstado:nAt == 6
               nPreDiv    := Round( ::oDbfArt:pVenta6 / ::nValDiv, ::nDecOut )
         end case

         if !(::lExcCero .AND. nPreDiv == 0 )

            ::oDbf:Append()

            ::oDbf:CCODART := ::oDbfArt:CODIGO
            ::oDbf:CNOMART := ::oDbfArt:NOMBRE
            ::oDbf:CCODFAM := ::oDbfArt:FAMILIA
            ::oDbf:CNOMFAM := RetFamilia (::oDbfArt:Familia, ::oDbfFam:cAlias )
            ::oDbf:nPreDiv := nPreDiv

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
      ::oDbfArt:Skip()

   end while

   ::oDbfArt:GoBottom()
   ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//