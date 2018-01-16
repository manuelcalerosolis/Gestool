#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

function InicioHRB( oParte )

   MsgInfo( "Ruta normal" )

return ( .t. )

//---------------------------------------------------------------------------//

CLASS createParte

   DATA fechaProceso
   DATA grupoParte
   DATA arrayGrupos
   DATA oParteProduccion
   DATA cDocumento
   DATA newNumero

   METHOD new()

   METHOD run()

   METHOD runTest()

   METHOD getFechaProceso()
   METHOD compruebaFechaProceso()

   METHOD getGrupoParte()
   METHOD compruebaGrupoParte()
   METHOD compruebaArrayGrupoParte()

   METHOD getArrayGruposOfParte()

   METHOD isOnlyOneGrupoOfParte()            INLINE ( Len( ::getArrayGruposOfParte() ) <= 1 )
   
   METHOD isOnlyOneGrupoToProcess()          INLINE ( Len( ::arrayGrupos ) <= 0 )

   METHOD procesaGrupo()

   METHOD procesaParte( cGrupo )

   METHOD createCabecera()
   
   METHOD updateElaborado()

   METHOD updateMateriaPrima()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD new( oParte ) CLASS createParte

   ::fechaProceso         := GetSysDate()
   ::grupoParte           := Padr( "Todos", 20 )
   ::oParteProduccion     := oParte
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD run() CLASS createParte

   ::getFechaProceso()
   ::getGrupoParte()
   
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

   while .t.
      if !msgGet( "Seleccione un grupo", "Grupo: ", @::grupoParte )
         exit
      end if

      if ::compruebaGrupoParte()
         exit
      end if 

   end while

Return .t.

//---------------------------------------------------------------------------//

METHOD compruebaGrupoParte() CLASS CreateParte

   local lResult  := .f.

   ::arrayGrupos    := hb_aTokens( ::grupoParte, "," )

return ::compruebaArrayGrupoParte()

//---------------------------------------------------------------------------//

METHOD compruebaArrayGrupoParte() CLASS CreateParte

   local lReturn     := .t.
   local aGrupoParte

   if len( ::arrayGrupos ) == 0
      Return .f.
   end if

   if len( ::arrayGrupos ) == 1 .and. AllTrim( ::arrayGrupos[1] ) == "Todos"
      Return .t.
   end if

   ::oParteProduccion:oTemporada:getStatus()

   ::oParteProduccion:oTemporada:OrdSetFocus( "Codigo" )

   for each aGrupoParte in ::arrayGrupos
      
      if !::oParteProduccion:oTemporada:Seek( Padr( aGrupoParte, 10 ) )
         lReturn     := .f.
      end if

   next

   ::oParteProduccion:oTemporada:setStatus()

   if !lReturn
      msgInfo( "Algunos de los valores introducidos no son válidos" )
   end if

Return lReturn

//---------------------------------------------------------------------------//

METHOD getArrayGruposOfParte() CLASS CreateParte

   local arrayGruposOfParte   := {}

   if Empty( ::cDocumento )
      Return .f.
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

   if ::isOnlyOneGrupoToProcess()
      Return .f.
   end if

   //Todos---------------------------------------------------------------------

   if len( ::arrayGrupos ) == 1 .and. AllTrim( ::arrayGrupos[1] ) == "Todos"

      arrayTodos  := ::getArrayGruposOfParte()

      for each cGrupo in arrayTodos

         if !::isOnlyOneGrupoOfParte()
            ::procesaParte( cGrupo )
         end if

      next

   end if

   //Otros valores-------------------------------------------------------------

   for each cGrupo in ::arrayGrupos

      if !::isOnlyOneGrupoOfParte()

         if aScan( ::getArrayGruposOfParte(), AllTrim( cGrupo ) ) != 0
            ::procesaParte( cGrupo )
         else
            MsgStop( "El grupo que intenta crear no existe en el parte: " + ::cDocumento )
         end if

      end if

   next

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

      ::newNumero    := nNewDoc( ::oParteProduccion:oDbf:cSerOrd, ::oParteProduccion:oDbf:nArea, "nParPrd" )

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