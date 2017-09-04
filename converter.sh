#!/usr/bin/env bash

# PARAMETERS
###################

# > The path of the dir above the original ModelNet 'off' Dataset
# > The 'pcd' dataset will be created in the same dir
ROOT_PATH="/root/path/for/both/datasets/";

# > Path where the converter (off2pcd) is
PATH_TO_CONVERTER="/path/to/converter/"

# > Max number of parallel jobs during the process 
let "MAX_PAR_JOBS=10";

# > The size of the step between each sampled point
STEP_SIZE="0.05"

###################

# CONSTANTS
###################

# > Output extension - there is no need to change it
EXTENSION="pcd";

###################

parse_train()
{
  cd "train/"

  # Converts the files
  for OBJ_FILE in $( ls *.off ); do
    OBJ_NAME=${OBJ_FILE%.*};
    ${PATH_TO_CONVERTER}off2pcd -p "${OBJ_NAME}.off" -f -s ${STEP_SIZE} -o $TRAIN_PATH/${OBJ_NAME}.${EXTENSION}
    echo "Storing at ${TRAIN_PATH}${OBJ_NAME}.${EXTENSION}" ;
    rm -rf "${OBJ_NAME}.${EXTENSION}";
  done
  cd .. ;
}

parse_test()
{
  cd "test/";

  # Converts the files
  for OBJ_FILE in $( ls *.off ); do
    OBJ_NAME=${OBJ_FILE%.*};
    ${PATH_TO_CONVERTER}off2pcd -p "${OBJ_NAME}.off" -f -s ${STEP_SIZE} -o $TEST_PATH/${OBJ_NAME}.${EXTENSION}
    rm -rf "${OBJ_NAME}.${EXTENSION}";
  done
  cd .. ;

}

parse_class()
{
  CLASS_DIR=$1;
  # Creates class dir on PCD Dataset
  mkdir ${ROOT_PATH}ModelNet10${EXTENSION}/${CLASS_DIR} ;
  cd $CLASS_DIR ;

  # Creates train dir on PCD class dir
  TRAIN_PATH="${ROOT_PATH}ModelNet10${EXTENSION}/${CLASS_DIR}train/";
  mkdir $TRAIN_PATH;

  # Creates test dir on PCD class dir
  TEST_PATH="${ROOT_PATH}ModelNet10${EXTENSION}/${CLASS_DIR}test/";
  mkdir $TEST_PATH;

  parse_train &
  parse_test
  wait ;
  cd .. ;
}

wait_max_jobs()
{
  # . Count the number of jobs
  declare -i JOBS_COUNT &&
  let "JOBS_COUNT=0";
  JOBS=`jobs -p`
  for JOB in $JOBS
  do
    let "JOBS_COUNT+=1";
  done
  while [ "$JOBS_COUNT" -ge "$MAX_PAR_JOBS" ]
  do
    # . Count the number of jobs
    let "JOBS_COUNT=0";
    JOBS=`jobs -p`
    for JOB in $JOBS
    do
      let "JOBS_COUNT+=1";
    done
  done
}

# MAIN FLOW
###################

cd $ROOT_PATH &&
mkdir ModelNet10${EXTENSION} &&
cd ModelNet10 &&
for CLASS_DIR in $( ls -d */); do
  wait_max_jobs ;
  parse_class $CLASS_DIR &
done

wait ;

echo "> Done!";

###################
