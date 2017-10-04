// FiveWin TCP/IP multiple clients layer
// (c) FiveTech 1997
// by: Jesus Salas

#include "FiveWin.Ch"

//----------------------------------------------------------------//

CLASS TCtrlSocket

   DATA aRequests               // Active Sockets

   DATA abEnd                   // Array of Codeblocks to perform action
                                // when multiplexor End a Socket......

   DATA abChance                // Array of Codeblocks to perform action
                                // when multiplexor Give a Chance to a Socket......

   DATA anSended                // Per Socket, Bytes Sended

   DATA lServerWorking          // server working?

   DATA nPendings               // Total Sockets in list

   METHOD New()  CONSTRUCTOR
   METHOD ServeClients()
   METHOD AddRequest( oSocket, bEnd )

ENDCLASS

//--------------------------------------------------------------------------//

METHOD New() Class TCtrlSocket

   ::aRequests := {}
   ::abEnd     := {}
   ::abChance  := {}
   ::anSended  := {}
   ::lServerWorking := .f.

return Self

//--------------------------------------------------------------------------//

METHOD AddRequest( oSocket , bEnd , bChance ) CLASS TCtrlSocket

  AAdd( ::aRequests, oSocket )
  AAdd( ::abEnd    , bEnd    )
  AAdd( ::abChance , bChance )
  AAdd( ::anSended , 0 )

return nil

//--------------------------------------------------------------------------//

METHOD ServeClients() CLASS TCtrlSocket

   local nLong
   local nServe

   ::lServerWorking := .t.                                  // Serving

   ::nPendings = Len( ::aRequests )

   While Len( ::aRequests ) > 0

      for nServe = 1 To Len(::aRequests)
          if !::aRequests [ nServe ]:lCandestroy .And.;
              ::aRequests [ nServe ]:nSocket != 0

              ::aRequests [ nServe ]:Give_Chance()          // Serve Socket.

              if ::abChance [ nServe ] != Nil
                 Eval( ::abChance [ nServe ], ::aRequests [ nServe ]:nPosInBuffer ) // bChance eval..
              endif

          endif
          SysRefresh()
      next

      nLong := Len( ::aRequests )

      for nServe = 1 To Len( ::aRequests )

          if ::aRequests [ nServe ]:lCanDestroy .Or. ;
             ::aRequests [ nServe ]:nSocket == 0

             if ::abEnd [ nServe ] != Nil                   // bEnd Action
                 Eval( ::abEnd [ nServe ] )                 // --
             endif                                            // ------------


             ::aRequests [ nServe ]:End()                   // End Socket
             aDel( ::aRequests , nServe )                   // Delete from...
             aSize( ::aRequests , Len( ::aRequests ) - 1 )  // ... list.

             nServe--                                       // Delete from list

             if Len( ::aRequests ) == 0                     // list Empty?
                exit
             endif
          endif

          SysRefresh()
      next
   enddo

   ::lServerWorking:=.f.                                    // Not Serving

Return Nil

//--------------------------------------------------------------------------//