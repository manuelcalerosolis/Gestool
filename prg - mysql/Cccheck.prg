
/*
���������������������������������������������������������������������������ͻ
�                                                                           �
�  Syntax:                                                                  �
�                                                                           �
�    CCCheck(cCard) --> nCardType                                           �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Purpose:                                                                 �
�                                                                           �
�    Verifies that a credit card number is valid against the checksum.      �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Written by:                                                              �
�                                                                           �
�    Mark Vivanco                                                           �
�          Compuserve: 72360,2114                                           �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Arguments:                                                               �
�                                                                           �
�    cCard - a credit card number to be validated                           �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Returns:                                                                 �
�                                                                           �
�    a numeric value as follows:                                            �
�                                                                           �
�       -1 - number is invalid                                              �
�        0 - unknown card type (account number valid)                       �
�        1 - American Express                                               �
�        2 - Visa                                                           �
�        3 - MasterCard                                                     �
�        4 - Discover                                                       �
�        5 - Carte Blanche                                                  �
�        6 - Diners Club                                                    �
�        7 - JCB                                                            �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Notes:                                                                   �
�                                                                           �
�     CCCheck() is useful in a POS application or any application which     �
�     requires to validate a credit card number.                            �
�                                                                           �
�     This function will check the credit card number against the check     �
�     digit on the card.  If the credit card number checks out okay then    �
�     a positive number is returned indicating the type of card.  If the    �
�     credit card number does not check against the check digit then a -1   �
�     is returned to the calling program.  Note that the term "validate the �
�     credit card number" mearly means checking the card number against the �
�     check digit on the card.  This routine is useful for checking manual  �
�     entry of credit card numbers so you can verify the users key errors.  �
�     DO NOT ASSUME THE CREDIT CARD IS VALID BY THIS ROUTINE!  This is just �
�     one step to validating a credit card number.  Enjoy.                  �
�                                                                           �
�     I can determine 7 types of credit cards.  If this routine does not    �
�     correctly validate a credit card number or you find a bug then let me �
�     know.                                                                 �
�                                                                           �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Example:                                                                 �
�     FUNCTION Test()                                                       �
�        LOCAL cCard:=Space(20)                                             �
�        LOCAL nResult                                                      �
�        LOCAL acCardTypes:={"American Express", "Visa", "MasterCard", ;    �
�                            "Discover", "Carte Blanche", "Diners", "JCB"}  �
�        CLEAR                                                              �
�        @ 5, 5 SAY "Enter card number :" GET cCard PICTURE "@9"            �
�        READ                                                               �
�                                                                           �
�        IF ( !Empty(cCard) )                                               �
�           cCard:=Alltrim(cCard)                                           �
�           nResult:=CCCheck(cCard)                                         �
�           @ 6, 5 SAY "Card #" + cCard                                     �
�           DO CASE                                                         �
�              CASE ( nResult < 0 )                                         �
�                 @ Row(), Col() SAY " is invalid."                         �
�              CASE ( nResult == 0 )                                        �
�                 @ Row(), Col() SAY " is of unknown type."                 �
�              CASE ( nResult > 0 )                                         �
�                 @ Row(), Col() SAY " is a " + acCArdTypes[nResult]        �
�           ENDCASE                                                         �
�        ENDIF                                                              �
�     RETURN ( NIL )                                                        �
�                                                                           �
���������������������������������������������������������������������������Ķ
�                                                                           �
�  Notice:                                                                  �
�                                                                           �
�    Copyright (c) Mark Vivanco, 1993.  All rights reserved.                �
�    Donated to the Public domain for its free use.                         �
�    The author does not assume any liability for damages resulting from the�
�    use of this function.  Use this function at your own risk.             �
�                                                                           �
���������������������������������������������������������������������������ͼ
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
