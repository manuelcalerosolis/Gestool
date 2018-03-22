#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuFFacRec FROM TInfFam

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

   ::AddTmpIndex( "cCodFam", "cCodFam" )

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles() CLASS TAcuFFacRec

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Cerramos las tablas abiertas anteriormente*/

METHOD CloseFiles() CLASS TAcuFFacRec

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
/*Se montan los recursos*/

METHOD lResource( cFld ) CLASS TAcuFFacRec

   if !::StdResource( "INFDETFAMB" )
      return .f.
   end if

   /*Se montan los desde - hasta*/

   if !::lDefFamInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   if !::oDefCliInf( 160, 161, 170, 171, , 150 )
      return .f.
   end if

   /*Check para no dejar pasar las líneas con precio 0*/

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )
   ::oDefSalInf( 201 )

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )

   ::CreateFilter( aItmFacRec(), ::oFacRecT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate() CLASS TAcuFFacRec

   local cExpHead    := ""
   local cExpLine    := "!lTotLin .and. !lControl"

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )     + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia   : " + if( ::lAllFam, "Todas", AllTrim (::cFamOrg) + " > " + AllTrim ( ::cFamDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim (::cArtOrg) + " > " + AllTrim ( ::cArtDes ) ) },;
                     {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim (::cCliOrg) + " > " + AllTrim ( ::cCliDes ) ) } }

   /*Monta los filtros para las tablas de fac. rec.*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += '.and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   if !::lAllFam
      cExpLine       += '.and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   /*Recorremos las cabeceras y líneas*/

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

     if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

                 if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 ) .AND.;
                    !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                    /*Llenamos la base de datos temporal*/

                    ::AcuFacRec()

                 end if

                 ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   /*Incluimos familias sin movimiento*/

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//