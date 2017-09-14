
static lWin95Look:= .F.
static aClass3DRegister:= { "TWBROWSE","TCBROWSE","TLISTBOX",;
                            "TCOMBOBOX","TGET", "TMULTIGET" }

//----------------------------------------------------------------------------//

function SetWin95Look( lNewState ) // (lOn/lOff)
 LOCAL lOldState:= lWin95Look

   if "L" $ ValType( lNewState )
       lWin95Look:= lNewState
   endif

return lOldState

//----------------------------------------------------------------------------//

function Class3DRegister( cClass )
 LOCAL nAt

   if "C" $ Valtype( cClass )
      cClass:= AllTrim( Upper( cClass ) )

      if ( nAt:= AScan( aClass3DRegister, {|cData| cClass == cData } ) ) == 0
         Aadd( aClass3DRegister, cClass )
         return .T.
      endif
   endif

return .F.

//----------------------------------------------------------------------------//

function Class3DUnRegister( cClass )
 LOCAL nAt

   if "C" $ Valtype( cClass )
      cClass:= AllTrim( Upper( cClass ) )

      if ( nAt:= AScan( aClass3DRegister, {|cData| cClass == cData } ) ) > 0
         ADel( aClass3DRegister, nAt )
         ASize( aClass3DRegister, Len( aClass3DRegister ) - 1 )
         return .T.
      endif
   endif

return .F.

//----------------------------------------------------------------------------//

function lClass3DRegister( cClass )
 LOCAL nAt

   if lWin95Look .and. "C" $ Valtype( cClass )
      cClass:= AllTrim( Upper( cClass ) )

      if ( nAt:= AScan( aClass3DRegister, {|cData| cClass == cData } ) ) > 0
         return .T.
      endif
   endif

return .F.
//----------------------------------------------------------------------------//
