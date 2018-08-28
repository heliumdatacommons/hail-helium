Spark Master with Hail 
======================

This image is built on top of *Ubuntu Bionic (18.04 LTS)* with 
[Hail v0.2 beta](https://hail.is/docs/devel/index.html) 
and [Spark v2.2.2](http://download.nextag.com/apache/spark/spark-2.2.2/). The author created 
 the image following the code and scripts in 
 [Hail on Google Cloud](https://github.com/hms-dbmi/Hail-on-Google-Cloud). 

#### Image build

```bash 
docker build -t heliumdatacommons/spark-master:hail .
```

The minimum and maximum Java heap size defaults to 1GB and 4GB, respectively. To customize the 
heap size(s):
```bash 
docker build \
    --build-arg MIN_HEAP_SIZE=2g \
    --build-arg MAX_HEAP_SIZE=6g \
    -t heliumdatacommons/spark-master:hail .
```

#### Build notes

1. Compiling Hail requires a significant amount of RAM. Make sure there is sufficient RAM 
on the machine for building the image.

2. Hail v0.2 requires Python 3.6 or above. The default Python 3 of *Ubuntu Xenial (16.04 LTS)* is 3.5.

3. Current image size is 1.61GB. Building with *Alpine 3.8* failed due to failing to install `libopenblas-dev`. 
 
#### Test case 
[GWAS Phase 1.ipynb](https://github.com/hms-dbmi/Hail-on-Google-Cloud/blob/master/GWAS%20Phase%201.ipynb)

#### Status

- [x] Hail environment and Python packages
- [ ] Import the Matrix Table Files - Failed
    ```python
    # Phase 1 - 1k Genome Project
    mt = hl.read_matrix_table("gs://1k-genome/1000-genomes/VDS-of-all/ALL.chr.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.mt")
    print('MT size: ', mt.count()) 
    ```
    ```console
    Java stack trace:
    java.io.IOException: No FileSystem for scheme: gs
        at org.apache.hadoop.fs.FileSystem.getFileSystemClass(FileSystem.java:2660)
        at org.apache.hadoop.fs.FileSystem.createFileSystem(FileSystem.java:2667)
        at org.apache.hadoop.fs.FileSystem.access$200(FileSystem.java:94)
        at org.apache.hadoop.fs.FileSystem$Cache.getInternal(FileSystem.java:2703)
        at org.apache.hadoop.fs.FileSystem$Cache.get(FileSystem.java:2685)
        at org.apache.hadoop.fs.FileSystem.get(FileSystem.java:373)
        at org.apache.hadoop.fs.Path.getFileSystem(Path.java:295)
        at is.hail.utils.richUtils.RichHadoopConfiguration$.fileSystem$extension(RichHadoopConfiguration.scala:19)
        at is.hail.utils.richUtils.RichHadoopConfiguration$.isDir$extension(RichHadoopConfiguration.scala:59)
        at is.hail.variant.RelationalSpec$.read(MatrixTable.scala:44)
        at is.hail.expr.ir.MatrixNativeReader.<init>(MatrixIR.scala:225)
        at is.hail.expr.ir.MatrixIR$.read(MatrixIR.scala:25)
        at is.hail.variant.MatrixTable$.read(MatrixTable.scala:129)
        at is.hail.HailContext.read(HailContext.scala:560)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at py4j.reflection.MethodInvoker.invoke(MethodInvoker.java:244)
        at py4j.reflection.ReflectionEngine.invoke(ReflectionEngine.java:357)
        at py4j.Gateway.invoke(Gateway.java:282)
        at py4j.commands.AbstractCommand.invokeMethod(AbstractCommand.java:132)
        at py4j.commands.CallCommand.execute(CallCommand.java:79)
        at py4j.GatewayConnection.run(GatewayConnection.java:238)
        at java.lang.Thread.run(Thread.java:748)
    
    Hail version: devel-3918a9e47b23
    Error summary: IOException: No FileSystem for scheme: gs
   ```
- [ ] Annotation file : encode the label Super_population
- [ ] Take a subset of the matrix
- [ ] Quality control
- [ ] GWAS
- [ ] PCA



 