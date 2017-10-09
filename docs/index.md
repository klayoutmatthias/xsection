# XSection@KLayout Project Home Page

[xsection](https://github.com/klayoutmatthias/xsection) is a script that implements a cross-section generator for the KLayout VLSI
layout viewer and editor [http://www.klayout.de](http://www.klayout.de).

## Installation

For installation install the package in KLayout's package manager (requires KLayout 0.25). 
Open the package manager with "Tools/Manage Packages". Search for "xsection" in the list
of available packages. Mark the package for installation (check button above) and use
"Apply" to actually install the package.

In order to use the cross section generator, a description of the process must be provided. 
Such a description is stored in files with extension ".xs". They contain a step-by-step 
receipe how the layer stack is formed. Statements will describe individual process steps 
such as etching, deposition and material conversion (i.e. implant). 

The source tree contains one example for such a file in "samples/cmos.xs". This example 
illustrates how to create a ".xs" and has a lot of documentation inside. Have a look at 
this file here: [cmos.xs](../samples/cmos.xs).

## Using The Cross Section Module

Start KLayout after you have installed the script. You will find a new entry in the "Tools" menu. 
Choosing "Tools/XSection Scripts/XSection Script" opens a file browser and you are prompted for the .xs file.

To create a cross section, draw a ruler into the layout indicating the line along which the 
cross section is created. Choose "Tools/XSection Scripts/XSection Script" to select 
the ".xs" file and to generate the cross section in a new layout window. Once you have 
used a ".xs" file, it is available in the recently used files list below the "XSection Script" 
menu entry for quick access.

An introduction into writing XS files can be found here: [DocIntro]. 

A function reference is also available here: [DocReference].

## Example

The following screenshot shows a sample cross section taken from the [cmos.xs](../samples/cmos.xs) sample file and the [sample.gds](../samples/sample.gds) layout found in the samples folder:

![xsection_70p](xsection_70p.png)

