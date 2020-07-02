#!/bin/bash



copy_order(){

  DIR=$destdir_order$tmp2_dir
  if [ ! -d $DIR ];then
    mkdir $DIR
  fi
  if [ -d $DIR ];then
    if [ ! -e $DIR$basename ];then
      cp $path_order $DIR
      echo "$DIR$basename copy success."
    else 
      echo "$DIR$basename exist."
    fi
  fi
}


get_lib_array(){
  ldds_array=(`ldd $path_order| tr " " "\n"|grep "/lib"`)
}


cp_lib(){
 
  destdir_lib=${destdir_order%/*}
  get_lib_array
  for i in $(seq 0 $((${#ldds_array[*]}-1)));do
      tmp_dir=$destdir_lib${ldds_array[$i]}
      mkdir_dir=${tmp_dir%/*}
    if [ ! -d $mkdir_dir ];then
      mkdir -p $mkdir_dir
    else
      if [ ! -e $destdir_lib${ldds_array[$i]} ];then
      if `cp -f ${ldds_array[$i]} $destdir_lib${ldds_array[$i]}`;then
        echo "$destdir_lib${ldds_array[$i]} copy success."
      else
        echo "copy $destdir_lib${ldds_array[$i]} fail."
      fi
      else
        echo "$destdir_lib${ldds_array[$i]} exist."
      fi
    fi
  done
}

while true;do
  read -p "pl input a order:" order
  destdir_order=/mnt/sysroot/
  path_order=$(which $order)
  basename="$(basename $path_order)"
  tmp1_dir=${path_order%/*}
  tmp2_dir=${tmp1_dir#*/}
  copy_order
  cp_lib
done
