#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuAFacRec FROM TInfAlm

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//
/*Creamos la temporal, los ordenes y los grupos*/

METHOD Create ()

   ::AcuCreate()

   ::AddTmpIndex( "cCodAlm", "cCodAlm" )

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles() CLASS TAcuAFacRec

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Cerramos las tablas abiertas anteriormente*/

METHOD CloseFiles() CLASS TAcuAFacRec

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lResource( cFld ) CLASS TAcuAFacRec

   if !::StdResource( "INF_GEN01AB" )
      return .f.
   end if

   /*Se montan los desde - hasta*/

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   if !::oDefCliInf( 160, 161, 170, 171, , 150 )
      return .f.
   end if

   /*Check para no dejar pasar las líneas con precio 0*/

   ::oDefExcInf()

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )

   ::CreateFilter( aItmFacRec(), ::oFacRecT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate() CLASS TAcuAFacRec

   local cExpHead  := ""
   local cExpLine  := ""

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                        {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   /*Monta los filtros para las tablas de presupuestos*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   /*Recorremos las cabeceras y líneas*/

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

     if lChkSer( ::oFacRecT:cSerie, ::aSer )                                 .AND.;
        ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

           if !( ::lExcCero .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              /*Llenamos la base de datos temporal*/

              ::AcuFacRec()

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   /*Incluimos almacenes sin movimiento*/

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//