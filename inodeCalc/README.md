Bash script that calculates the number of data blocks and blocks of direct, indirect, double+triple indirect pointers, and total blocks needed for an inode, given the file size and data unit type.

Uses a fixed size of 4B block addresses as well as 4KB blocks; Inspired by inode calculation problems done in Systems Programming. Special thanks to my professor for the idea of using a perl command. 

#Need to come back to this program and make it more flexible.

Example of use:


./inodeCalc.bash


Enter file size (e.g. 64): 734.15


Enter data unit type (KB, MB, or GB): GB


Number of data blocks (# of direct pointers): 192453018


Blocks of direct pointers (# of indirect pointers needed): 187943


Blocks of indirect pointers (# of double indirect pointers needed): 184


Blocks of double indirect pointers (# of triple indirect pointers needed): 1


Total blocks needed: 192641146
