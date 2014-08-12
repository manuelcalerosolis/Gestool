#include "HbClass.ch"
#include "Fivewin.ch"

FUNCTION DialogExtend()

TDialog(); __clsAddMsg( __ClsGetHandleFromName( "TDialog" ), "aFastKeys", __cls_IncData( __ClsGetHandleFromName( "TDialog" ) ), 9, {}, 1, .f., .f. )

TDialog(); __clsAddMsg( __ClsGetHandleFromName( "TDialog" ), "bTmpValid", __cls_IncData( __ClsGetHandleFromName( "TDialog" ) ), 9, nil, 1, .f., .f. )

TDialog(); __clsAddMsg( __ClsGetHandleFromName( "TDialog" ), "AddFastKey", {|Self, nKey, bAction| Self, aAdd( ::aFastKeys, { nKey, bAction } ) }, 3, nil, 1, .f., .f. )

TDialog(); __clsAddMsg( __ClsGetHandleFromName( "TDialog" ), "Enable()", {|Self| Self, ( ::bValid := ::bTmpValid, aEval( ::aControls, { |o| if( o:ClassName <> "TSAY" .AND. o:ClassName <> "TBITMAP", o:Enable(), ) } ), CursorArrow() ) }, 3, nil, 1, .f., .f. )

TDialog(); __clsAddMsg( __ClsGetHandleFromName( "TDialog" ), "Disable()", {|Self| Self, ( CursorWait(), ::bTmpValid := ::bValid, ::bValid := {|| .f. }, aEval( ::aControls, { |o| if( o:ClassName <> "TSAY" .AND. o:ClassName <> "TBITMAP", o:Disable(), ) } ) ) }, 3, nil, 1, .f., .f. )

TDialog(); __clsAddMsg( __ClsGetHandleFromName( "TDialog" ), "aEvalValid", @DialogEvalValid(), 0, nil, 1, .f., .f. )

TDialog(); __clsModMsg( __ClsGetHandleFromName( "TDialog" ), "KeyDown", @DialogKeyDown(), 1 )

/*
EXTEND CLASS TDialog WITH DATA aFastKeys//  AS ARRAY INIT {} 

EXTEND CLASS TDialog WITH DATA bTmpValid

EXTEND CLASS TDialog WITH MESSAGE AddFastKey( nKey, bAction );
    INLINE (  if( isNil(::aFastKeys), ::aFastKeys := {}, ),;
              aAdd( ::aFastKeys, { nKey, bAction } ) )

EXTEND CLASS TDialog WITH MESSAGE Enable();
    INLINE (  ::bValid    := ::bTmpValid,;
              aEval( ::aControls, { |o| if( o:ClassName != "TSAY" .and. o:ClassName != "TBITMAP", o:Enable(), ) } ),;
              CursorArrow() )

EXTEND CLASS TDialog WITH MESSAGE Disable();
    INLINE (  CursorWait(),;
              ::bTmpValid := ::bValid,;
              ::bValid    := {|| .f. },;
              aEval( ::aControls, { |o| if( o:ClassName != "TSAY" .and. o:ClassName != "TBITMAP", o:Disable(), ) } ) )

EXTEND CLASS TDialog WITH MESSAGE aEvalValid METHOD DialogEvalValid

OVERRIDE METHOD KeyDown IN CLASS TDialog WITH DialogKeyDown
*/
//EXTEND CLASS HBObject WITH MESSAGE log METHOD LogData

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogEvalValid() 

   local n
   local lValid     := .t.
   local Self       := HB_QSelf()
   local aControls  := Self:aControls

   if aControls != nil .and. !Empty( aControls )
      for n = 1 to Len( aControls )
          if aControls[ n ] != nil .and. aControls[ n ]:bValid != nil
             if !Eval( aControls[ n ]:bValid )
                lValid  := .f.
                aControls[ n ]:SetFocus()  // keep this as ::
             endif
         endif
      next
   endif

return ( lValid )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogKeyDown( nKey, nFlags ) 

   local Self       := HB_QSelf()

   if nKey == VK_ESCAPE

      if ::oWnd == nil
         if SetDialogEsc()
            ::End()
         endif
      else
         if ::oWnd:IsKindOf( "TMDICHILD" )
            if SetDialogEsc()
               ::End()
            endif
         else
            if ::oWnd:IsKindOf( "TDIALOG" )
               if SetDialogEsc()
                  ::End()
               endif
            elseif Upper( ::oWnd:ClassName() ) == "TMDIFRAME"
               if SetDialogEsc() // To avoid ESC being ignored
                  ::End()
               endif
            else
               return ::Super:KeyDown( nKey, nFlags )
            endif
         endif
      endif

   else

      aEval( ::aFastKeys, {|aKey| if( nKey == aKey[1], Eval( aKey[2] ), ) } )
/*
      if !Empty( ::aFastKeys )
         for n := 1 to len( ::aFastKeys )
            if nKey == ::aFastKeys[ n, 1 ]
               Eval( ::aFastKeys[ n, 2 ] )
               Return nil
            end if
         next
      end if
*/
      return ::Super:KeyDown( nKey, nFlags )

   endif

Return ( nil )

//----------------------------------------------------------------------------//
