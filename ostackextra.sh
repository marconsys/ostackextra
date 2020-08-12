#!/bin/bash

#
# Copyright (c) 2020 Marco Napolitano
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# coded by: Marco Napolitano    email: mannysys-AaaaT-outlook.com put at sign instead of -AaaaT-
#


# customizable variables

NOVA_VOL_COMPUTE_HOST="hostname_of_compute_host"


# non-customizable variables

STANDARDIFS=$IFS
LINEIFS=$'\n'


# declaration of functions

getInstanceName () {
   if [ -z $1 ]
   then
      return
   fi
   
    openstack server show $1 2>/dev/null | grep '^| name' | awk -F'|' '{print $3}'  | awk '{$1=$1;print}'
}

getNovaVolSize () {
   if [ -z $1 ]
   then
      return
   fi

   IFS=$LINEIFS
   for csvline in $(cat ./nova_instance_volumes.csv)
   do
      local instance=$(echo $csvline | awk -F',' '{print $1}')
      local volsize=$(echo $csvline | awk -F',' '{print $2}')
      if [ "$1" = "$instance" ]
      then
         echo $volsize
	 return
      fi
   done
   IFS=$STANDARDIFS
}

getImageName () {
   if [ -z $1 ]
   then
      return
   fi

   openstack image show $1 2>/dev/null | grep '^| name' | awk -F'|' '{print $3}'  | awk '{$1=$1;print}'
}

getVolType () {
   if [ -z $1 ]
   then
      return
   fi

   openstack volume show $1 2>/dev/null | grep '^| type' | awk -F'|' '{print $3}'  | awk '{$1=$1;print}'
}

getVolSize () {
   if [ -z $1 ]
   then
      return
   fi
   
   size_in_gb=$(openstack volume show $1 2>/dev/null | grep '^| size' | awk -F'|' '{print $3}'  | awk '{$1=$1;print}')
   if [[ $size_in_gb == ?(-)+([0-9]) ]]
   then
      echo $(($size_in_gb*1048576))
   fi
}


# control flow starts here

echo "Instance,Image,Volume 01,Volume 02,Volume 03,Volume 04,Volume 05,Volume 06,Volume 07,Volume 08,Volume 09,Volume 10,Volume 11" > out_ist_ima_vol.csv
for serv in $(openstack server list --all | awk -F'|' '{print $2}' | awk -F' ' '{print $1}' | sort -u | grep -v ID | grep -vE '^$')
do
   echo -n "${serv}," >> out_ist_ima_vol.csv
   openstack server show $serv | grep image | awk -F'|' '{print $3}' | sed "s/ //g" | awk -F'[()]' '{print $(NF-1)}' 2>/dev/null | tr -d '\n' >> out_ist_ima_vol.csv
   echo -ne "," >> out_ist_ima_vol.csv
   openstack server show $serv | grep volumes_attached | awk -F'|' '{print $3}' | tr -d "'" | sed "s/://g" | sed "s/\[//g" |  sed "s/\]//g" | sed "s/{uid u//g" | sed "s/ //g" | sed "s/}//g" >> out_ist_ima_vol.csv
done
cat out_ist_ima_vol.csv | awk -F',' '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13}' > ist_ima_vol.csv

ssh $NOVA_VOL_COMPUTE_HOST "du /var/lib/nova/instances 2>/dev/null | sort -h" > du_var_lib_nova_instances.log
echo "Instance ID;Nova Volume Size" > nova_instance_volumes.csv
cat du_var_lib_nova_instances.log | awk -F' ' '{print $2,",",$1}' | sed 's/ //g' | sed 's/.\///g' | sed 's/\.;/TOTAL;/g'  >> nova_instance_volumes.csv

echo "Instance ID,Instance Name,Nova Volume Size,Image ID,Image Name,Volume 01 ID,Volume 01 Type,Volume 01 Size,Volume 02,Volume 02 Type,Volume 02 Size,Volume 03,Volume 03 Type,Volume 03 Size,Volume 04,Volume 04 Type,Volume 04 Size,Volume 05,Volume 05 Type,Volume 05 Size,Volume 06,Volume 06 Type,Volume 06 Size,Volume 07,Volume 07 Type,Volume 07 Size,Volume 08,Volume 08 Type,Volume 08 Size,Volume 09,Volume 09 Type,Volume 09 Size,Volume 10,Volume 10 Type,Volume 10 Size,Volume 11,Volume 11 Type,Volume 11 Size"

IFS=$LINEIFS
for csvline in $(tail -n +2 ./ist_ima_vol.csv)
do
   instance_id=$(echo $csvline | awk -F',' '{print $1}')
   instance_name=$(getInstanceName $instance_id)
   nova_vol_size=$(getNovaVolSize $instance_id)
   image_id=$(echo $csvline | awk -F',' '{print $2}')
   image_name=$(getImageName $image_id)
   vol01_id=$(echo $csvline | awk -F',' '{print $3}')
   vol01_type=$(getVolType $vol01_id)
   vol01_size=$(getVolSize $vol01_id)
   vol02_id=$(echo $csvline | awk -F',' '{print $4}')
   vol02_type=$(getVolType $vol02_id)
   vol02_size=$(getVolSize $vol02_id)
   vol03_id=$(echo $csvline | awk -F',' '{print $5}')
   vol03_type=$(getVolType $vol03_id)
   vol03_size=$(getVolSize $vol03_id)
   vol04_id=$(echo $csvline | awk -F',' '{print $6}')
   vol04_type=$(getVolType $vol04_id)
   vol04_size=$(getVolSize $vol04_id)
   vol05_id=$(echo $csvline | awk -F',' '{print $7}')
   vol05_type=$(getVolType $vol05_id)
   vol05_size=$(getVolSize $vol05_id)
   vol06_id=$(echo $csvline | awk -F',' '{print $8}')
   vol06_type=$(getVolType $vol06_id)
   vol06_size=$(getVolSize $vol06_id)
   vol07_id=$(echo $csvline | awk -F',' '{print $9}')
   vol07_type=$(getVolType $vol07_id)
   vol07_size=$(getVolSize $vol07_id)
   vol08_id=$(echo $csvline | awk -F',' '{print $10}')
   vol08_type=$(getVolType $vol08_id)
   vol08_size=$(getVolSize $vol08_id)
   vol09_id=$(echo $csvline | awk -F',' '{print $11}')
   vol09_type=$(getVolType $vol09_id)
   vol09_size=$(getVolSize $vol09_id)
   vol10_id=$(echo $csvline | awk -F',' '{print $12}')
   vol10_type=$(getVolType $vol10_id)
   vol10_size=$(getVolSize $vol10_id)
   vol11_id=$(echo $csvline | awk -F',' '{print $13}')
   vol11_type=$(getVolType $vol11_id)
   vol11_size=$(getVolSize $vol11_id)
   echo "$instance_id,$instance_name,$nova_vol_size,$image_id,$image_name,$vol01_id,$vol01_type,$vol01_size,$vol02_id,$vol02_type,$vol02_size,$vol03_id,$vol03_type,$vol03_size,$vol04_id,$vol04_type,$vol04_size,$vol05_id,$vol05_type,$vol05_size,$vol06_id,$vol06_type,$vol06_size,$vol07_id,$vol07_type,$vol07_size,$vol08_id,$vol08_type,$vol08_size,$vol09_id,$vol09_type,$vol09_size,$vol10_id,$vol10_type,$vol10_size,$vol11_id,$vol11_type,$vol11_size"
done
IFS=$STANDARDIFS
