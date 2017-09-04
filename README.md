# ModelNet2PCD

## About
This script automatizes the conversion from `off` to `pcd` objects from the [Princeton ModelNet 3D object dataset](http://modelnet.cs.princeton.edu/), with points sampled over each polygon surface for each object.

## How to use
Simply edit the parameters at the script `converter.sh` and run `bash converter.sh`. Also, you will need to use the binary file _off2pcd_ [(repository here)](https://github.com/cabraile/off2pcd). The original dataset file tree structure must be `<DIR_NAME>/<CLASS_NAME>/<train|test>/<file.off>`.

## Parameters

* **ROOT\_PATH**: The path of the dir above the original ModelNet 'off' Dataset. The 'pcd' dataset will be created in the same dir. For instance: if the dataset is in the dir  `~/datasets/`, then it must be `ROOT_PATH="~/datasets/"`.
* **PATH\_TO\_CONVERTER**: Path where the converter (off2pcd) is.
* **MAX\_PAR\_JOBS**: Max number of parallel jobs during the process.
* **STEP\_SIZE**: The size of the step between each sampled point.
* **DIR\_NAME**: Original dataset directory. The default value is `ModelNet10`.
