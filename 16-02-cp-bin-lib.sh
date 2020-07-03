#!/bin/bash



copy_order(){

  DIR="$destdir_order$tmp2_dir/"
  if [ ! -d $DIR ];then
    mkdir $DIR #/mnt/sysroot/bin/
  fi
  if [ ! -e $DIR$basename ];then #/mnt/sysroot/bin/ls
    cp $path_order $DIR
    echo "$DIR$basename copy success."
    echo "#############################"
  else 
    echo "$DIR$basename exist."
    echo "#############################"
    exit 1
  fi
  
}


get_lib_array(){
  ldds_array=(`ldd $path_order| tr " " "\n"|grep "/lib"`)
}


cp_lib(){
 
  destdir_lib=${destdir_order%/*}   #/mnt/sysroot
  get_lib_array
  for i in $(seq 0 $((${#ldds_array[*]}-1)));do
      tmp_dir=$destdir_lib${ldds_array[$i]}  #/mnt/sysroot/lib/.../xx.io
      mkdir_dir=${tmp_dir%/*}  #/mnt/sysroot/lib/...
    if [ ! -d $mkdir_dir ];then
      mkdir -p $mkdir_dir
    fi
      if [ ! -e $destdir_lib${ldds_array[$i]} ];then #/mnt/sysroot/lib/./xx.io
      if `cp -f ${ldds_array[$i]} $mkdir_dir`;then
        echo "$destdir_lib${ldds_array[$i]} copy success."
      else
        echo "copy $destdir_lib${ldds_array[$i]} fail."
      fi
      else
        echo "$destdir_lib${ldds_array[$i]} exist."
      fi
  done
}

main(){

  destdir_order=/mnt/sysroot/  #new /  : /mnt/sysroot/
  path_order=$(which $order)
  if (($?==0));then #order path
    basename="$(basename $path_order)" #order
    tmp1_dir=${path_order%/*} #/bin
    tmp2_dir=${tmp1_dir#*/}   #bin
    copy_order
    cp_lib
  else
    echo "no $order order."
    exit 1
 fi
}
while true;do
  read -p "pl input a Order or quit:" order
  case $order in
  quit)
    exit 0
    ;;
  *)
    main
    ;;
esac
done
