# TxRegInfra

Some Bioconductor-oriented infrastructure for exploring transcriptional regulatory networks.

Data from studies of eQTL, DNAse footprinting and hotspot
location, and sequence-based TF binding are collected in a MongoDB
database.

A small example of such a database is available in a [google drive](https://drive.google.com/drive/folders/1fR9DTypKWrUmEnbjiIy_n--9EZJ6AHci?usp=sharing).  The file `txreg_tiny.zip` unzips to
a folder `VJCDUMP`, which is the result of a `mongodump` process.

On a system with a running mongodb instance, `mongorestore` can be used
with standard connection string and the path to the `VJCDUMP` folder as
second argument to populate MongoDB collections for use with this package.
