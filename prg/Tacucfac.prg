#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuCFac FROM TInfCli

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lExcRie     AS LOGIC
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oStock      AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   METHOD IncluyeRiesgo()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AcuCreate()
   ::AddField( "nRieEst", "N", 16, 6, {|| ::cPicOut },      "Establecido",         .f., "Riesgo establecido"          , 15, .t. )
   ::AddField( "nRieAlc", "N", 16, 6, {|| ::cPicOut },      "Alcanzado",           .f., "Riesgo alcanzado"            , 15, .t. )

   ::AddTmpIndex( "cCodCli", "cCodCli" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAcuCFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE "ANTCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   ::oStock                := TStock():Create( cPatEmp() )
   if ::oStock:lOpenFiles()
      ::oStock:cAlbCliT   := ::oAlbCliT:cAlias
      ::oStock:cFacCliP   := ::oFacCliP:cAlias
      ::oStock:cAntCliT   := ::oAntCliT:cAlias
      ::oStock:cTikT      := ::oTikCliT:cAlias
   end if

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TAcuCFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oDbfArt  := nil
   ::oAlbCliT := nil
   ::oTikCliT := nil
   ::oFacCliP := nil
   ::oAntCliT := nil
   ::oStock   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TAcuCFac

   if !::StdResource( "INFACUCLIA" )
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

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   REDEFINE CHECKBOX ::lExcRie ;
      ID       210 ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf()

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TAcuCFac

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

     if lChkSer( ::oFacCliT:cSerie, ::aSer )                     .AND.;
        ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

        while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

           if !( ::oFacCliL:lTotLin ) .and. !( ::oFacCliL:lControl )           .and.;
              !( ::lExcCero .and. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) .and.;
              ( !::lExcRie .or. RetFld( ::oFacCliT:cCodCli, ::oDbfCli:cAlias, "LCRESOL", "COD" ) )

              ::AddFac( .t. )

           end if

           ::oFacCliL:Skip()

        end while

     end if

     ::oFacCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )
    /*
   comenzamos con las rectificativas
   */

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
              !( ::lExcCero .and. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )  .and.;
              ( !::lExcRie .or. RetFld( ::oFacRecT:cCodCli, ::oDbfCli:cAlias, "LCRESOL", "COD" ) )

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

   ::IncluyeRiesgo()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD IncluyeRiesgo()

   /*
   Introducimos los riesgos----------------------------------------------------
   */

   ::oDbf:GoTop()

   ::oMtrInf:SetTotal( ::oDbf:OrdKeyCount() )

   while !::oDbf:Eof()

      ::oDbf:Load()

      ::oDbf:nRieEst    := RetFld( ::oDbf:cCodCli, ::oDbfCli:cAlias, "Riesgo", "COD" )
      
      if !Empty( ::oStock )
        ::oDbf:nRieAlc  := ::oStock:nRiesgo( ::oDbf:cCodcli )
      end if

      ::oDbf:Save()

      ::oDbf:Skip()

      ::oMtrInf:AutoInc()

   end if

   ::oMtrInf:AutoInc( ::oDbf:LastRec() )

   if !::lExcCero

      /*
      Repaso de todas los clientes---------------------------------------------
      */

      ::oDbfCli:GoTop()

      ::oMtrInf:SetTotal( ::oDbfCli:OrdKeyCount() )

      while !::oDbfCli:Eof()

         if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .AND. ::oDbfCli:Cod <= ::cCliDes ) )     .and.;
            ( !::lExcRie .or. RetFld( ::oFacCliT:cCodCli, ::oDbfCli:cAlias, "LCRESOL", "COD" ) )   .and.;
            !::oDbf:Seek( ::oDbfCli:Cod )

            ::oDbf:Append()
            
            ::oDbf:Blank()
            ::oDbf:cCodCli    := ::oDbfCli:Cod
            ::oDbf:cNomCli    := ::oDbfCli:Titulo
            ::oDbf:nRieEst    := RetFld( ::oDbf:cCodCli, ::oDbfCli:cAlias, "Riesgo", "COD" )
            
            if !Empty( ::oStock )
              ::oDbf:nRieAlc    := ::oStock:nRiesgo( ::oDbf:cCodcli )
            end if

            ::oDbf:Save()

         end if

         ::oDbfCli:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//