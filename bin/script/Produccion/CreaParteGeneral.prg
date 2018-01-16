#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

function InicioHRB( oParte )

   local oCreateParte   := createParte():new( oParte )

   if !Empty( oCreateParte )
      //oCreateParte:runTest()
      oCreateParte:run()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

CLASS createParte

   DATA fechaProceso
   DATA grupoParte
   DATA arrayGrupos
   DATA oParteProduccion
   DATA cDocumento
   DATA newNumero
   DATA aItems

   METHOD new()

   METHOD run()

   METHOD runTest()

   METHOD getFechaProceso()
   METHOD compruebaFechaProceso()

   METHOD getGrupoParte()

   METHOD getArrayGruposOfParte()

   METHOD isOnlyOneGrupoOfParte()            INLINE ( Len( ::getArrayGruposOfParte() ) <= 1 )
   
   METHOD isOnlyOneGrupoToProcess()          INLINE ( Len( ::arrayGrupos ) <= 0 )

   METHOD procesaGrupo()

   METHOD procesaParte( cGrupo )

   METHOD createCabecera()
   
   METHOD updateElaborado()

   METHOD updateMateriaPrima()

   METHOD aItemsTemporadas()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD new( oParte ) CLASS createParte

   ::fechaProceso         := GetSysDate()
   ::grupoParte           := Padr( "Todos", 20 )
   ::oParteProduccion     := oParte
   ::aItemsTemporadas()

Return ( self )

//---------------------------------------------------------------------------//

METHOD aItemsTemporadas() CLASS createParte

   ::aItems   := {}

   aAdd( ::aItems, "Todos" )

   ::oParteProduccion:oTemporada:GoTop()

   while !::oParteProduccion:oTemporada:Eof()

      aAdd( ::aItems, AllTrim( ::oParteProduccion:oTemporada:cCodigo ) )

      ::oParteProduccion:oTemporada:Skip()

   end while

Return ( self )

//---------------------------------------------------------------------------//

METHOD run() CLASS createParte

   ::getFechaProceso()
   ::getGrupoParte()
   
   if Empty( ::cDocumento )
      MsgStop( "No existe ningun documento con las condiciones seleccionadas" )
      Return .t.
   end if

   if ::isOnlyOneGrupoOfParte()
      MsgStop( "Existe un solo grupo de parte" )
      Return .t.
   end if

   ::procesaGrupo()

Return .t.

//---------------------------------------------------------------------------// 

METHOD runTest() CLASS createParte

   ::arrayGrupos  := { "Todos" }
   ::cDocumento   := "P        7  "
   
   if ::isOnlyOneGrupoOfParte()
      MsgStop( "Existe un solo grupo de parte" )
      Return .t.
   end if

   ::procesaGrupo()

Return .t.

//---------------------------------------------------------------------------//

METHOD getFechaProceso() CLASS createParte
   
   while .t.
      if MsgGet( "Seleccione una fecha", "Fecha: ", @::fechaProceso )
         if ::compruebaFechaProceso()
            exit
         end if
      else
         exit
      end if
   end while

Return .t.

//---------------------------------------------------------------------------//

METHOD compruebaFechaProceso() CLASS createParte

   local lResult  := .f.

   ::oParteProduccion:oDbf:getStatus()

   ::oParteProduccion:oDbf:OrdSetFocus( "dFecOrd" )
      
   if ::oParteProduccion:oDbf:Seek( dTos( ::fechaProceso ) )
      ::cDocumento   := ::oParteProduccion:oDbf:cSerOrd + Str( ::oParteProduccion:oDbf:nNumOrd ) + ::oParteProduccion:oDbf:cSufOrd
      lResult        := .t.
   else
      MsgStop( "No existen partes para la fecha seleccionada" )
   end if

   ::oParteProduccion:oDbf:setStatus()

Return lResult

//---------------------------------------------------------------------------//

METHOD getGrupoParte() CLASS CreateParte

   if MsgCombo( "Seleccione un grupo", "Grupo: ", ::aItems, @::grupoParte )
      Return .t.
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD getArrayGruposOfParte() CLASS CreateParte

   local arrayGruposOfParte   := {}

   if Empty( ::cDocumento )
      Return arrayGruposOfParte
   end if

   //Estudiamos los materiales elaborados--------------------------------------

   ::oParteProduccion:oDetProduccion:oDbf:getStatus()

   ::oParteProduccion:oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )
   
   ::oParteProduccion:oDetProduccion:oDbf:GoTop()

   if ::oParteProduccion:oDetProduccion:oDbf:Seek( ::cDocumento )

      while ::oParteProduccion:oDetProduccion:oDbf:cSerOrd + Str( ::oParteProduccion:oDetProduccion:oDbf:nNumOrd ) + ::oParteProduccion:oDetProduccion:oDbf:cSufOrd == ::cDocumento .and.;
            !::oParteProduccion:oDetProduccion:oDbf:Eof()

         if aScan( arrayGruposOfParte, ::oParteProduccion:oDetProduccion:oDbf:cCodTmp ) == 0
            aAdd( arrayGruposOfParte, AllTrim( ::oParteProduccion:oDetProduccion:oDbf:cCodTmp ) )
         end if

         ::oParteProduccion:oDetProduccion:oDbf:Skip()

      end while

   end if

   ::oParteProduccion:oDetProduccion:oDbf:setStatus()

   //Estudiamos las materias primas--------------------------------------------

   ::oParteProduccion:oDetMaterial:oDbf:getStatus()

   ::oParteProduccion:oDetMaterial:oDbf:OrdSetFocus( "cNumOrd" )
   
   ::oParteProduccion:oDetMaterial:oDbf:GoTop()

   if ::oParteProduccion:oDetMaterial:oDbf:Seek( ::cDocumento )

      while ::oParteProduccion:oDetMaterial:oDbf:cSerOrd + Str( ::oParteProduccion:oDetMaterial:oDbf:nNumOrd ) + ::oParteProduccion:oDetMaterial:oDbf:cSufOrd == ::cDocumento .and.;
            !::oParteProduccion:oDetMaterial:oDbf:Eof()

         if aScan( arrayGruposOfParte, ::oParteProduccion:oDetMaterial:oDbf:cCodTmp ) == 0
            aAdd( arrayGruposOfParte, AllTrim( ::oParteProduccion:oDetMaterial:oDbf:cCodTmp ) )
         end if            

         ::oParteProduccion:oDetMaterial:oDbf:Skip()

      end while

   end if

   ::oParteProduccion:oDetMaterial:oDbf:setStatus()

Return arrayGruposOfParte

//---------------------------------------------------------------------------//

METHOD ProcesaGrupo() CLASS CreateParte

   local cGrupo
   local arrayTodos  := {}

   if Empty( ::GrupoParte )
      Return .f.
   end if

   //Todos---------------------------------------------------------------------

   if AllTrim( ::grupoParte ) == "Todos" 

      arrayTodos  := ::getArrayGruposOfParte()

      for each cGrupo in arrayTodos

         if !::isOnlyOneGrupoOfParte()
            ::procesaParte( cGrupo )
         end if

      next

   end if

   //Otros valores-------------------------------------------------------------

   if !::isOnlyOneGrupoOfParte()

      if aScan( ::getArrayGruposOfParte(), AllTrim( ::GrupoParte ) ) != 0
         ::procesaParte( AllTrim( ::grupoParte ) )
      else
         MsgStop( "El grupo que intenta crear no existe en el parte: " + ::cDocumento )
      end if

   end if


Return .t.

//---------------------------------------------------------------------------//

METHOD procesaParte( cGrupo ) CLASS CreateParte

   ::createCabecera()

   ::updateElaborado( cGrupo )

   ::updateMateriaPrima( cGrupo )

Return .t.

//---------------------------------------------------------------------------//

METHOD createCabecera() CLASS CreateParte

   local aCabecera

   ::oParteProduccion:oDbf:getStatus()

   ::oParteProduccion:oDbf:OrdSetFocus( "cNumOrd" )
      
   if ::oParteProduccion:oDbf:Seek( ::cDocumento )

      ::newNumero    := nNewDoc( ::oParteProduccion:oDbf:cSerOrd, ::oParteProduccion:oDbf:nArea, "nParPrd", , ::oParteProduccion:oDbfCount:cAlias )

      aCabecera      := dbScatter( ::oParteProduccion:oDbf:cAlias )

      aCabecera[2]   := ::newNumero

      dbGather( aCabecera, ::oParteProduccion:oDbf:cAlias, .t. )

   end if

   ::oParteProduccion:oDbf:setStatus()

Return .t.

//---------------------------------------------------------------------------//
   
METHOD updateElaborado( cGrupo ) CLASS CreateParte

   ::oParteProduccion:oDetProduccion:oDbf:getStatus()

   ::oParteProduccion:oDetProduccion:oDbf:OrdSetFocus( "cCodTmp" )
   
   while ::oParteProduccion:oDetProduccion:oDbf:Seek( ::cDocumento + Padr( cGrupo, 10 ) )
 
      ::oParteProduccion:oDetProduccion:oDbf:Load()
      ::oParteProduccion:oDetProduccion:oDbf:nNumOrd    := ::newNumero
      ::oParteProduccion:oDetProduccion:oDbf:Save()

   end while

   ::oParteProduccion:oDetProduccion:oDbf:setStatus()

Return .t.

//---------------------------------------------------------------------------//

METHOD updateMateriaPrima( cGrupo ) CLASS CreateParte

   ::oParteProduccion:oDetMaterial:oDbf:getStatus()

   ::oParteProduccion:oDetMaterial:oDbf:OrdSetFocus( "cCodTmp" )
   
   while ::oParteProduccion:oDetMaterial:oDbf:Seek( ::cDocumento + Padr( cGrupo, 10 ) )

      ::oParteProduccion:oDetMaterial:oDbf:Load()
      ::oParteProduccion:oDetMaterial:oDbf:nNumOrd    := ::newNumero
      ::oParteProduccion:oDetMaterial:oDbf:Save()

   end while

   ::oParteProduccion:oDetMaterial:oDbf:setStatus()

Return .t.

//----------------------------------------------------------------------------//