EXTENSION="pcd";
ROOT_PATH="/media/braile/HDD/Workspace/Datasets/";
let "MAX_PARALLEL_CLASSES=10";

parse_train()
{
  cd "train/"

  # Converts the files
  for OBJ_FILE in $( ls *.off ); do
    OBJ_NAME=${OBJ_FILE%.*};
    ~/Desktop/off2pcd -p "${OBJ_NAME}.off" -f -s 0.05 -o $TRAIN_PATH/${OBJ_NAME}.${EXTENSION}
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
    ~/Desktop/off2pcd -p "${OBJ_NAME}.off" -f -s 0.05 -o $TEST_PATH/${OBJ_NAME}.${EXTENSION}
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
  while [ "$JOBS_COUNT" -ge "$MAX_PARALLEL_CLASSES" ]
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

cd $ROOT_PATH &&
mkdir ModelNet10${EXTENSION} &&
cd ModelNet10 &&
for CLASS_DIR in $( ls -d */); do
  wait_max_jobs ;
  parse_class $CLASS_DIR &
done

wait ;

echo "> Done!";
