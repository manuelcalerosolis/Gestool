#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuCFacRec FROM TInfCli

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfArt     AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AcuCreate()

   ::AddTmpIndex( "cCodCli", "cCodCli" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

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

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INFACUCLI" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )

   ::oDefExcInf()

   ::CreateFilter( aItmFacRec(), ::oFacRecT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

     if lChkSer( ::oFacRecT:cSerie, ::aSer )                     .AND.;
        ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

           if !( ::oFacRecL:lTotLin ) .and. !( ::oFacRecL:lControl )           .and.;
              !( ::lExcCero .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              ::AddFacRec( .t. )

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------// 