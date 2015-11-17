
static fechaProceso
static grupoParte
static objetoParte

//---------------------------------------------------------------------------//

function InicioHRB( oParte )
   
   fechaProceso         := GetSysDate()
   grupoParte           := Padr( "Todos", 20 )
   objetoParte          := oParte


   getFechaProceso()
   getGrupoParte()


   //MsgInfo( fechaProceso, "fechaProceso" )
   //MsgInfo( grupoParte, "grupoParte" )

return .t.

//---------------------------------------------------------------------------//

function getFechaProceso()
   
   while .t.
      MsgGet( "Seleccione una fecha", "Fecha: ", @fechaProceso )
      if compruebaFechaProceso()
         exit
      end if
   end while

Return .t.

//---------------------------------------------------------------------------//

function compruebaFechaProceso()

   local lResult  := .f.

   objetoParte:oDbf:getStatus()

   objetoParte:oDbf:OrdSetFocus( "dFecOrd" )
      
   if objetoParte:oDbf:Seek( dTos( fechaProceso ) )
      lResult     := .t.
   else
      MsgStop( "No existen partes para la fecha seleccionada" )
   end if

   objetoParte:oDbf:setStatus()

Return lResult

//---------------------------------------------------------------------------//

function getGrupoParte()

   while .t.
      MsgGet( "Seleccione un grupo", "Grupo: ", @grupoParte )
      if compruebaGrupoParte()
         exit
      end if
   end while

Return .t.

//---------------------------------------------------------------------------//

function compruebaGrupoParte()

   local lReturn  := .f.

   if AllTrim( grupoParte ) == "Todos"
      Return .t.
   end if

   objetoParte:oTemporada:getStatus()

   objetoParte:oTemporada:OrdSetFocus( "Codigo" )
      
   if objetoParte:oTemporada:Seek( AllTrim( grupoParte ) )
      lResult     := .t.
   else
      MsgStop( "No existen partes para la fecha seleccionada" )
   end if

   objetoParte:oTemporada:setStatus()

return lReturn

//---------------------------------------------------------------------------//