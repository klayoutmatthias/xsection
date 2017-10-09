# XSection

This is a fork of the former xsection@klayout project on SourceForge. It's been turned into a 
KLayout package now and is available through KLayout's new package manager (available from 0.25 on).

The goal of this project is to provide an add-on to KLayout (www.klayout.de) to 
create and visualize a realistic cross-section view for VLSI designs supporting a wide range of 
technology options.

## User Documentation

For the project description see [XSection Project Home Page](https://klayoutmatthias.github.io/xsection).

For an introduction into writing XS files, see [Writing XS Files - an Introduction](https://klayoutmatthias.github.io/xsection/DocIntro).

For a reference of the elements of the XS scripts, see [XS File Reference](https://klayoutmatthias.github.io/xsection/DocIntro).

## Project Files

The basic structure is:

 * <tt>docs</tt> The documentation
 * <tt>samples</tt> Some sample files
 * <tt>src</tt> The package sources
 * <tt>tests</tt> Test sources and golden data

The `docs` folder contain the MD file and images for the GitHub pages.

The `samples` folder holds a few files for playing around.

The `src` folder contains the package definition file (`grain.xml`), the `macros` folder with the
actual package code (`xsection.lym`). The download URL for the package index is therefore the pseudo-SVN
URL `https://github.com/klayoutmatthias/xsection.git/tags/x.y/src`.

The <tt>tests</tt> folder contains some regression tests for the package. To run the tests,
make sure "klayout" is in your path and use

```sh
$ cd tests
$ ./run_tests.sh
```
