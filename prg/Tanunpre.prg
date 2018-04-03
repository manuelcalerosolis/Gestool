#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuNPre FROM TInfPAge

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AgeAnuCreateFld()

   ::AddTmpIndex( "cCodAge", "cCodAge" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

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
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oPreCliT := nil
   ::oPreCliL := nil
   ::oDbfCli  := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_ANU17" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /* Monta tipo de artículos */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefExcInf( 210 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPreCli(), ::oPreCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Año     : " + AllTrim( Str( ::nYeaInf ) ) },;
                        {|| "Agentes : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPreCliT:OrdSetFocus( "dFecPre" )
   ::oPreCliL:OrdSetFocus( "nNumPre" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lEstado'
      case ::oEstado:nAt == 2
         cExpHead    := 'lEstado'
      case ::oEstado:nAt == 3
         cExpHead    := '.t.'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPreCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

   /*
   Líneas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   ::oPreCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliL:cFile ), ::oPreCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPreCliT:GoTop()

   while !::lBreak .and. !::oPreCliT:Eof()

      if Year( ::oPreCliT:dFecPre ) == ::nYeaInf                                                      .AND.;
         lChkSer( ::oPreCliT:cSerPre, ::aSer )

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre

               if !( ::lExcCero .AND. nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0  )

                  if !::oDbf:Seek( ::oPreCliT:cCodAge )

                     ::oDbf:Blank()
                     ::oDbf:cCodAge := ::oPreCliT:cCodAge
                     if ( ::oDbfAge:Seek (::oPreCliT:cCodAge) )
                        ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                     end if
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oPreCliT:dFecPre, nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  ::nMediaMes( ::nYeaInf )

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oPreCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ) )

   ::oPreCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//