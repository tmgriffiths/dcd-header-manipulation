# DCD-HEADER-MANIPUTLATION

## Why?

If you've run a MD simulation on a machine of opposite endianness to 
your local analysis machine (e.g. on the VLSCI BlueGene machine AVOCA 
(big endian) vs the local UOW's HPC or NCI's Raijin) you'll need to 
flip the binary data of your trajectories before you can perform 
analysis with CHARMM on the local machine (as above `hpc.its.uow.edu.au` 
(little endian)).

## Will No-one Rid me of This Turbulent Priest?
                                                
There are two methods of doing this, either you can use the `flipdcd`
utility supplied as a separate executable with VMD or the `catdcd` 
utility (http://www.ks.uiuc.edu/Development/MDTools/catdcd/) to
flip the endianness of you binary data. Unfortunately, when using 
`flipdcd` any unit cell information from a PBC calculation is lost in 
the flipping process. Hindering any attempts at re-centering a 
constant pressure simulation and severely impeding a constant 
volume simulation if you don't know the initial setup conditions.

`catdcd` will take an input of any endianness, and output a 
trajectory with the local endianness. During this process, 
unfortunately, header information is lost regarding the previous 
integration steps, number of steps, and the frequency of saving. 
This will present a problem later on if you're trying to combine or
manipulate the trajectories with the `MERGe` commands in CHARMM, and 
any subsequent analyses. This header information however is easier 
to fix than the unit cell for every set of coordinates. There are two 
very nice packages written by Jim Phillips at UIUC to just this, 
`dumpdcd` and `loaddcd`. The former dumps out the DCD header, and the 
latter reloads it. 

## The Solution

In this directory are the uncompiled dumpdcd.c and loaddcd.c 
files. along with the require library, largefiles.h. To compile 
dumpdcd and loaddcd on your system run these commands:

```bash
   gcc dumpdcd.c -o dumpdcd

   gcc loaddcd.c -o loaddcd
```    

This should make the binary executable for both, which you can now 
use to change up the header details of your trajectory files as you 
see fit. Ensure that the full contents of the directory are present 
when you compile the two binaries, in particular `largefiles.h`.

The output plain text file from dumpdcd will contain the header 
information (see the format below). 

```bash
   /path/to/executable/dumpdcd <filename> > <data>
```

Once you've changed the details on the text file it can be inserted 
back into the trajectory file with loaddcd

```bash
   /path/to/executable/loaddcd <filename> < <data>
```

There is a c-shell script (`big-little-and-headfix.csh`) included in 
the directory as an example of a full conversion process.

1. Taking the big endian trajectories and flipping them with catdcd. 
2. Printing out the header information with dumpdcd.
3. Changing the header info. with sed.
4. Reloading the header information with loaddcd.


### Header Field Details (Line# Field)

1. Number of frames in this file
2. Number of previous integration steps
3. Frequency (integration steps) for saving of frames
4. Number of integration steps in the run that created this file
5. Frequency of coordinate saving (if this is a velocity trajectory??)
6. 
7. 
8. Number of degrees of freedom during the run
9. Number of fixed atoms
10. Timestep in AKMA-units. Bit-copy from the 32-bit real number
11. 1 if crystal lattice information is present in the frames
12. 1 if this is a 4D trajectory
13. 1 if fluctuating charges are present
14. 1 if trajectory is the result of merge without consistency checks
15.
16.
17.
18.
19.
20. CHARMM version number

Lines 11 -- 14 are either a 0 or 1 value indicating that the property
doesn't exist (0) or does (1).
