#!/bin/csh
# tmgriffiths 2014-05-05.
# Don't forget to change the /path/to/<x> to the path to 
# each of the executables/files on your system.
set SYSTEM = mol1b_prot_b
set STEPPERFILE = 1000000
set SKIP = 1000

foreach T (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50)

/path/to/catdcd -o ${T}_${SYSTEM}_le.dcd -otype dcd -dcd /path/to/unflipped/files/${T}_${SYSTEM}.dcd

/path/to/dumpdcd ${T}_${SYSTEM}_le.dcd > temp_${T}.header

@ P = $T * $STEPPERFILE

sed -i "2s/.*/${P}/" temp_${T}.header
sed -i "3s/.*/${SKIP}/" temp_${T}.header
sed -i "4s/.*/${STEPPERFILE}/" temp_${T}.header

/path/to/loaddcd ${T}_${SYSTEM}_le.dcd < temp_${T}.header

end