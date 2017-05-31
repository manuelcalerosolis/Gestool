#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuFPed FROM TInfFam

   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }

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

METHOD OpenFiles() CLASS TAcuFPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL    PATH ( cPatEmp() )   FILE "PEDCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Cerramos las tablas abiertas anteriormente*/

METHOD CloseFiles() CLASS TAcuFPed

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   ::oPedCliT := nil
   ::oPedCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Se montan los recursos*/

METHOD lResource( cFld ) CLASS TAcuFPed

   local cEstado := "Todos"

   if !::StdResource( "INFDETFAM" )
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

   /*Definimos el combo con los tipos de pedido*/

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ::oPedcliT:Lastrec() )

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate() CLASS TAcuFPed

   local cExpHead    := ""
   local cExpLine    := "!lTotLin .and. !lControl"

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia   : " + if( ::lAllFam, "Todas", AllTrim ( ::cFamOrg ) + " > " + AllTrim ( ::cFamDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim ( ::cArtOrg ) + " > " + AllTrim ( ::cArtDes ) ) },;
                     {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   /*Monta los filtros para las tablas de pedidos*/

   ::oPedCliT:OrdSetFocus( "dFecPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   cExpHead          := "!lCancel "

   do case
      case ::oEstado:nAt == 1
         cExpHead    += ' .and. nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    += ' .and. nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    += ' .and. nEstado == 3'
   end case

   cExpHead          += ' .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   if !::lAllFam
      cExpLine       += '.and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oPedCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   /*Recorremos las cabeceras y líneas*/

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed .AND. ! ::oPedCliL:eof()

               if !( ::lExcCero .AND. nTotNPedCli( ::oPedCliL ) == 0 ) .AND.;
                  !( ::lExcImp .AND. nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*Llenamos la base de datos temporal*/

                  ::AcuPed()

                 end if

                 ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )
   ::oPedCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   /*Incluimos almacenes sin movimiento*/

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//