
/*
ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
º                                                                           º
º  Syntax:                                                                  º
º                                                                           º
º    CCCheck(cCard) --> nCardType                                           º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Purpose:                                                                 º
º                                                                           º
º    Verifies that a credit card number is valid against the checksum.      º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Written by:                                                              º
º                                                                           º
º    Mark Vivanco                                                           º
º          Compuserve: 72360,2114                                           º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Arguments:                                                               º
º                                                                           º
º    cCard - a credit card number to be validated                           º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Returns:                                                                 º
º                                                                           º
º    a numeric value as follows:                                            º
º                                                                           º
º       -1 - number is invalid                                              º
º        0 - unknown card type (account number valid)                       º
º        1 - American Express                                               º
º        2 - Visa                                                           º
º        3 - MasterCard                                                     º
º        4 - Discover                                                       º
º        5 - Carte Blanche                                                  º
º        6 - Diners Club                                                    º
º        7 - JCB                                                            º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Notes:                                                                   º
º                                                                           º
º     CCCheck() is useful in a POS application or any application which     º
º     requires to validate a credit card number.                            º
º                                                                           º
º     This function will check the credit card number against the check     º
º     digit on the card.  If the credit card number checks out okay then    º
º     a positive number is returned indicating the type of card.  If the    º
º     credit card number does not check against the check digit then a -1   º
º     is returned to the calling program.  Note that the term "validate the º
º     credit card number" mearly means checking the card number against the º
º     check digit on the card.  This routine is useful for checking manual  º
º     entry of credit card numbers so you can verify the users key errors.  º
º     DO NOT ASSUME THE CREDIT CARD IS VALID BY THIS ROUTINE!  This is just º
º     one step to validating a credit card number.  Enjoy.                  º
º                                                                           º
º     I can determine 7 types of credit cards.  If this routine does not    º
º     correctly validate a credit card number or you find a bug then let me º
º     know.                                                                 º
º                                                                           º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Example:                                                                 º
º     FUNCTION Test()                                                       º
º        LOCAL cCard:=Space(20)                                             º
º        LOCAL nResult                                                      º
º        LOCAL acCardTypes:={"American Express", "Visa", "MasterCard", ;    º
º                            "Discover", "Carte Blanche", "Diners", "JCB"}  º
º        CLEAR                                                              º
º        @ 5, 5 SAY "Enter card number :" GET cCard PICTURE "@9"            º
º        READ                                                               º
º                                                                           º
º        IF ( !Empty(cCard) )                                               º
º           cCard:=Alltrim(cCard)                                           º
º           nResult:=CCCheck(cCard)                                         º
º           @ 6, 5 SAY "Card #" + cCard                                     º
º           DO CASE                                                         º
º              CASE ( nResult < 0 )                                         º
º                 @ Row(), Col() SAY " is invalid."                         º
º              CASE ( nResult == 0 )                                        º
º                 @ Row(), Col() SAY " is of unknown type."                 º
º              CASE ( nResult > 0 )                                         º
º                 @ Row(), Col() SAY " is a " + acCArdTypes[nResult]        º
º           ENDCASE                                                         º
º        ENDIF                                                              º
º     RETURN ( NIL )                                                        º
º                                                                           º
ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
º                                                                           º
º  Notice:                                                                  º
º                                                                           º
º    Copyright (c) Mark Vivanco, 1993.  All rights reserved.                º
º    Donated to the Public domain for its free use.                         º
º    The author does not assume any liability for damages resulting from theº
º    use of this function.  Use this function at your own risk.             º
º                                                                           º
ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
*/

  FUNCTION CCCheck(cCard)

     LOCAL nCheckSum:=0
     LOCAL I, nCardLen
     LOCAL anDigit:={0,2,4,6,8,1,3,5,7,9}
     LOCAL nDigit, nRetValue

     nRetValue:=CardType(cCard)
     nCardLen:=Len(cCard)
     FOR I:=2 TO nCardLen
        IF ( I % 2 == 1 )
           nCheckSum:=nCheckSum + Val(SubStr(cCard, nCardLen - I + 1, 1))
        ELSE
           nCheckSum:=nCheckSum + anDigit[Val(SubStr(cCard, ;
           nCardLen - I + 1, 1)) + 1]
        ENDIF
     NEXT I

     nDigit:=nCheckSum % 10
     IF ( nDigit > 0 )
        nDigit:=10 - nDigit
     ENDIF

  RETURN ( IIF(nDigit <> Val(Right(cCard, 1)), -1, nRetValue) )


  // This function is used to return the credit card type given a card number.
  STATIC FUNCTION CardType(cCard)
     LOCAL nResult:=0, I
     LOCAL aCardTypes:={ ;
                          { '37'   , 1}, ;       // Amer Xpr
                          { '037'  , 1}, ;
                          { '07'   , 1}, ;
                          { '007'  , 1}, ;
                          { '4'    , 2}, ;       // Visa
                          { '51'   , 3}, ;       // MstrCrd
                          { '52'   , 3}, ;
                          { '53'   , 3}, ;
                          { '54'   , 3}, ;
                          { '55'   , 3}, ;
                          { '519'  , 3}, ;
                          { '60110', 4}, ;       // Discover
                          { '389'  , 5}, ;       // Carte B.
                          { '95'   , 5}, ;
                          { '30'   , 6}, ;       // Diner's
                          { '36'   , 6}, ;
                          { '380'  , 6}, ;
                          { '381'  , 6}, ;
                          { '382'  , 6}, ;
                          { '383'  , 6}, ;
                          { '384'  , 6}, ;
                          { '385'  , 6}, ;
                          { '386'  , 6}, ;
                          { '387'  , 6}, ;
                          { '388'  , 6}, ;
                          { '5081' , 7}, ;       // Choice
                          { '81'   , 7}  ;
                       }

     // Find the type of card this is
     FOR I:=1 TO Len(aCardTypes)
        IF ( Left(cCard, Len(aCardTypes[I, 1])) == aCardTypes[I, 1] )
           nResult:=aCardTypes[I, 2]
           EXIT
        ENDIF
     NEXT I

RETURN ( nResult )
