10 REM CLS$=CHR$(26):REM SET FOR YOUR TERMINAL
20 REM  *Hurricane  Locate*    By:  ???
30 REM   Mod. By: K.D. Wentzel,  Charlotte, NC
40 REM   CP/M Conversion by Jim Lill 
50 REM   Input your coordinates in degrees, example:
60 REM    23 deg 30 min. you would enter as  23.5
70 REM   ********************
80 CLS :PRINT "";:GOSUB 1220:FOR TT= 1 TO  2000:NEXT
90 CLS :PRINT :GOSUB 1220:PRINT : PRINT
100 PRINT"ENTER  (H) for  HOME  Location ..."
110 PRINT"       (W) for Wilmington / Wrightsville Beach area"
120 PRINT"       (M) for Myrtle Beach area"
130 PRINT"       (C) for Charleston area."
140 PRINT : PRINT "or just press <cr> to input your own Local Coordinates: ";: INPUT MHC$
150 IF MHC$="H" OR MHC$="h" THEN II$="East Charlotte" : A=35.208 : G=80.808 : GOTO 220
160 IF MHC$="W" OR MHC$="w" THEN II$="Wilmington NC" : A=34.167 : G=77.867 : GOTO 220
170 IF MHC$="M" OR MHC$="m" THEN II$="Myrtle Beach SC" : A=33.7 : G=78.85 : GOTO 220
180 IF MHC$="C" OR MHC$="c" THEN II$="Charleston SC" : A=32.783 : G=79.933 : GOTO 220
190 PRINT :PRINT
200 INPUT "Enter The Name of Your Location ";II$
210 PRINT :INPUT "Enter Your LATITUDE in Degrees";A:PRINT :INPUT "Your LONGITUDE in Degrees";G
220 CLS :PRINT :GOSUB  1220:PRINT 
230 INPUT "What is the Name of the Hurricane ";A$:PRINT
240 PRINT "Input LATITUDE of Hurricane ";A$;" in Degrees";:INPUT  B:PRINT
250 PRINT "Input LONGITUDE of Hurricane ";A$;" in Degrees";:INPUT  H
255 IF B = 0 AND H = 0 THEN END ' for automated testing
260 PRINT :PRINT "What is ";A$;"'s Current Direction of Travel (in Degrees)";:INPUT DD
270 PRINT :PRINT "What is ";A$;"'s Current Speed (MPH)";:INPUT SS
280 REM  **** CALCULATE LOCATION AND DISTANCE ****
290 CLS :IF  A=B AND G=H THEN  H=H+.1
300 PRINT :GOSUB 1220:I=G-H:L=I
310 IF (I<180) AND (I>-180) GOTO 350
320 J=I+360:L=J
330 IF (J<180) AND (J>-180) GOTO 350
340 L=I-360
350 IF L>0 THEN R=1
360 IF L<0 THEN R=0
370 E=SIN(A*.0174533):F=SIN(B*.0174533):K=COS(A*.0174533)
380 M=COS(B*.0174533):N=COS(L*.0174533):D=(E*F)+(K*M*N)
390 O=(-ATN(D/SQR(-D*D+1))+1.5708)*57.2958
400 P=SIN(O*.0174533):Q=(F-(E*D))/(K*P)
410 C=INT((-ATN(Q/SQR(-Q*Q+1))+1.5708)*57.2958)
420 IF R=0 THEN C=360-C
430 QQ=(E-(F*D))/(M*P)
440 CC=INT((-ATN(QQ/SQR(-QQ*QQ+1))+1.5708)* 57.2958)
450 IF R=1 THEN CC=360-CC
460 D=O*60*1.15078:D=INT(D+.5):PRINT
470 REM  **** DETERMINE DIRECTION ****
480 IF C>=0 AND C<15 THEN G$="NORTH":GOTO  570
490 IF C>=15 AND C<75 THEN G$="NORTHEAST":GOTO 570
500 IF C>=75 AND C<105 THEN G$="EAST":GOTO  570
510 IF C>=105 AND C<165 THEN G$="SOUTHEAST":GOTO  570
520 IF C>=165 AND C<195 THEN G$="SOUTH":GOTO  570
530 IF C>=195 AND C<225 THEN G$="SOUTHWEST":GOTO  570
540 IF C>=255 AND C<285 THEN G$="WEST":GOTO  570
550 IF C>=285 AND C<345 THEN G$="NORTWEST":GOTO  570
560 G$="NORTH"
570 GOSUB 780:GOSUB 1210
580 REM ****  PRINT NO ALARM TEXT  ****
590 PRINT "HURRICANE ";A$;" is Currently ";D;" Miles ";G$;" Of"
600 PRINT II$;".   Bearing From ";II$
610 PRINT "IS ";C;"  Degrees From True North."
620 GOSUB 1210
630 PRINT "If Hurricane ";A$;" Maintains its Current Speed of ";SS;"(mph)
640 PRINT "THERE IS NO CAUSE FOR ALARM. Please Continue To Monitor"
650 PRINT "Hurricane ";A$;" Closely."
660 GOSUB  1210
670 PRINT :PRINT
680 PRINT"  N O A A Weather Radio" : PRINT
690 PRINT" Charlotte          162.475  MHz"
700 PRINT" Wilmington NC      162.55"
710 PRINT" Myrtle Beach SC    162.4"
720 PRINT" Charleston   SC    162.55"
730 PRINT" Beaufort     SC    162.475"
740 PRINT" Cape Hatteras      162.55"  : PRINT
750 PRINT :FOR  TT= 1 TO  1000:NEXT :PRINT "Press <cr> to Input New Status On Hurricane ";A$;:INPUT  UU$
760 CLS :PRINT :GOSUB 1220:PRINT :GOTO 240
770 REM ****  DETERMINE IF PATH IS IN YOUR DIRECTION  ****
780 KK=10:IF D<200 THEN KK=20
790 IF D<400 THEN KK=15
800 IF D<90 THEN 1450
810 P$=II$
820 IF DD<(CC+KK) AND DD>(CC-KK) THEN 880
830 IF DD<KK AND CC>360-(KK-DD) THEN 880
840 IF DD>(360-KK) AND CC<KK-(360-DD) THEN 880
850 IF D<100 THEN 880
860 RETURN
870 REM **** PRINT INITIAL WARNING ****
880 CLS 
890 FOR  XX=1 TO 4
900 PRINT "   * * * H U R R I C A N E * * * "
910 PRINT "   * * *    A L E R T    * * *"
920 FOR TT=1 TO 250:NEXT TT:CLS:FOR TT=1 TO 10:NEXT TT
930 NEXT XX
940 T_IME=D/SS
950 TS=INT(T_IME):TB=T_IME-TS:TC=INT(TB*60)
960 II= 5
970 REM  **** DETERMINE HURCON NUMBER ****
980 IF TS<72 THEN II= 4
990 IF TS<48 THEN II= 3
1000 IF TS<24 THEN II= 2
1010 IF TS<12 THEN II= 1
1020 REM **** PRINT HURCON WARNING TEXT ****
1030 GOSUB 1220:PRINT :PRINT "   * * *   H U R C O N  ";II;"  N O W   I N   E F F E C T  * * *":GOSUB 1210
1040 PRINT "HURRICANE ";A$;" IS CURRENTLY ";D;"MILES ";G$;" OF ";II$
1050 PRINT "BEARING FROM ";II$;": ";C;" DEGREES FROM TRUE NORTH."
1060 GOSUB  1210
1070 PRINT "IF THIS HURRICANE MAINTAINS ITS CURRENT SPEED OF ";SS;" MILES"
1080 PRINT "PER HOUR AND CURRENT DIRECTION OF ";DD;" DEGREES, THE CENTER"
1090 PRINT "OF THE STORM CAN BE EXPECTED TO HIT THE ";II$
1100 PRINT "AREA IN APPROXIMATELY ";TS;" HOURS."
1110 GOSUB  1210
1120 PRINT "PRESS LETTER  - H - TO INPUT NEW STATUS ON HURRICANE"
1130 PRINT "      PRESS LETTER  - C - TO REVIEW HURRICANE CONDITION NUMBERS";
1140 PRINT "    * * *   H U R R I C A N E   W A R N I N G   * * *"
1150 FOR TT=1 TO 200:NEXT TT
1160 PRINT "                                                        "
1170 FOR  TT= 1 TO  20:NEXT TT
1180 INPUT MM$ :IF MM$="H" OR MM$="h" THEN CLS :PRINT:GOSUB 1220:PRINT:GOTO 240
1190 IF MM$="C" OR MM$="c" THEN CLS:PRINT:GOTO 1250
1200 GOTO 1140
1210 FOR TT=1 to 63:PRINT"*";:NEXT:PRINT:RETURN
1220 PRINT "   * * *  HURRICANE LOCATION AND DISTANCE CALCULATOR  * * *"
1230 RETURN
1240 REM  * * *  HURCON LISTING * * *
1250 PRINT "          H U R R I C A N E   C O N D I T I O N S ":PRINT
1260 PRINT "       A. H U R C O N   5 :  A HURRICANE READINESS STATUS"
1270 PRINT "       CONSISTANT WITH SOUND PRECAUTIONARY MEASURES EFFECTIVE"
1280 PRINT "       JUNE 1 THROUGH NOVEMBER 30 EACH YEAR.":PRINT
1290 PRINT "       B. H U R C O N   4:  A HURRICANE HAS BECOME A THREAT"
1300 PRINT "       TO THE ";II$;" AREA. SURFACE WINDS IN EXCESS OF 50"
1310 PRINT "       COULD ARRIVE WITHIN 72 HOURS.":PRINT 
1320 PRINT "       C. H U R C O N   3:  A HURRICANE HAS BECOME A THREAT"
1330 PRINT "       TO THE ";II$;" AREA.  SURFACE WINDS IN EXCESS OF 50"
1340 PRINT "       KNOTS COULD ARRIVE WITHIN 48 HOURS."
1350 PRINT :INPUT "     Press  <<cr>> To Continue";UU$:CLS
1360 PRINT :PRINT "       H U R R I C A N E   C O N D I T I O N S":PRINT 
1370 PRINT "       D. H U R C O N   2:  A HURRICANE HAS BECOME A THREAT"
1380 PRINT "       TO THE ";II$;" AREA.  SURFACE WINDS IN EXCESS OF 50"
1390 PRINT "       KNOTS COULD ARRIVE WITHIN 24 HOURS.":PRINT 
1400 PRINT "       E. H U R C O N   1:  A HURRICANE HAS BECOME A THREAT"
1410 PRINT "       TO THE ";II$;" AREA.  SURFACE WINDS IN EXCESS OF 50"
1420 PRINT "       KNOTS COULD ARRIVE WITHIN 12 HOURS.":PRINT :PRINT 
1430 INPUT "    Press <<cr>> To Continue";UU$:CLS :GOTO 1030
1440 REM  **** TOO LATE MESSAGE ****
1450 CLS :PRINT "YOU ARE NOW IN A HURRICANE "
1460 EE=INT(LEN(A$)/2)
1470 IF EE/2<>INT(EE/2) THEN EE=EE+1
1480 PRINT "* * * ";A$;" * * *"
1490 PRINT "G O O D   L U C K"
1500 FOR X=1 TO 250:NEXT
1510 PRINT "+ - + - + - + - + "
1520 FOR X= 1 TO  250:NEXT
1530 GOTO  1490
2000 REM -------------------------------------------------
2010 REM changed :' to REM
2020 REM changed PRINT CLS$ to CLS
2030 REM added line 255 for automated testing
2999 END
