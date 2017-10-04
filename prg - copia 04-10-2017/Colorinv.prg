FUNCTION nColorInve( nColor )

   local nColorInve := nXor( CLR_HGRAY, nColor )

   If    nColorInve  = nColor
         nColorInve := CLR_WHITE
   End

RETURN   nColorInve
