#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TItemAcceso

   DATA  aAccesos
   DATA  cPrompt
   DATA  cGroup
   DATA  cMessage
   DATA  cId
   DATA  bWhen
   DATA  cBmp
   DATA  cBmpBig
   DATA  nImageList

   DATA  bAction

   DATA  lShow
   DATA  lHide
   DATA  lLittle

   DATA  nBigItems
   DATA  nLittleItems

   DATA  oGroup

   Method New()

   Method Add()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TItemAcceso

   ::nImageList      := 0
   ::nBigItems       := 0
   ::nLittleItems    := 0

   ::aAccesos        := {}

   ::lShow           := .f.
   ::lLittle         := .f.
   ::lHide           := .f.

Return Self

//----------------------------------------------------------------------------//

METHOD Add() CLASS TItemAcceso

   local oAcceso  := TItemAcceso():New()

   AAdd( ::aAccesos, oAcceso )

return oAcceso

//----------------------------------------------------------------------------//

CLASS TGrupoAcceso

   DATA  cPrompt           INIT ""

   DATA  cBigBitmap        INIT ""
   DATA  cLittleBitmap     INIT ""

   DATA  nBigItems         INIT 0
   DATA  nLittleItems      INIT 0

ENDCLASS

//----------------------------------------------------------------------------//
