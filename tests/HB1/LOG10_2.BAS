10 REM 'LOG10' TEST PROGRAM
11 GOTO 20
15 PROC LOG10(X): RETURN LOG(@X)*.4342945
20 PRINT "ENTER A POSITIVE NUMBER";
30 INPUT N
40 L=FN LOG10(N)
50 PRINT "THE NATURAL LOG OF ";N;" IS ";L
99 END
