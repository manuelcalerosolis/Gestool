/*
ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Header file for class TExStruc                             ³
³         File: STRUC.CH                                                   ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (100042,3051)                                ³
³         Date: 01/03/97                                                   ³
³         Time: 12:20:07                                                   ³
³    Copyright: 1997 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#xcommand STRUC <oSt> ;
       => ;
          <oSt> := StrucBegin(<(oSt)>)

#xcommand END STRUC ;
       => ;
          StrucEnd()

#xcommand ENDSTRUC ;
       => ;
          END STRUC

#xcommand MEMBER <xData, ...> ;
                 [ AS <cType:LOGICAL,NUMERIC,NUMBER,CHARACTER,DATE,BLOCK,ARRAY,OBJECT> ] ;
                 [ <def: DEFAULT, INIT> <default> ] ;
                 [ SIZE <nSize> ] ;
        => ;
          StrucMember( {<(xData)>}, [<(cType)>], <default>, <nSize> )

#xcommand MEMBER <oSt> AS STRUC ;
       => ;
          StrucBegin(<(oSt)>)
