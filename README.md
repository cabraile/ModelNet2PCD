# ModelNet2PCD

## About
This script runs a program that creates a new `pcd` for each object from the Princeton ModelNet 3D object dataset, with points samplied over each polygon surface.

## How to use
Simply edit the parameters at the script `converter.sh` and run `bash converter.sh`. You need to use the binary file off2pcd [(repository here)](https://github.com/cabraile/off2pcd). The dataset root directory must be named as "ModelNet10", and it's file tree structure is `ModelNet10/`

## Parameters

* _ROOT\_PATH_: The path of the dir above the original ModelNet 'off' Dataset. The 'pcd' dataset will be created in the same dir. For instance: if the dataset is in the dir  `~/datasets/`, then it must be `ROOT_PATH="~/datasets/"`.
* _PATH\_TO\_CONVERTER_: Path where the converter (off2pcd) is.
* _MAX\_PAR\_JOBS_: Max number of parallel jobs during the process
* _STEP\_SIZE_: The size of the step between each sampled point

## Todo
* [ ] Adapt to any dataset directory name
