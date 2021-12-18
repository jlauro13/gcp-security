#!/bin/bash
echo "ProjectID ServiceAccountName UserCreatedKey" > ./sakeyreport.txt
for project in $(gcloud projects list --format="value(projectId)")
do
for eachsa in $(gcloud iam service-accounts list --project $project --format="value(email)")
do
sainfo=`echo "$project $eachsa"`
for key in $(gcloud iam service-accounts keys list --iam-account $eachsa --project $project --managed-by="user" --format="value(name.basename())")
do
echo "$sainfo $key" >> ./sakeyreport.txt
done done
done

#cat sakeyreport.txt | grep -v "ProjectID" | awk -F' ' '{print $1}' | sort | uniq -c | sort -rn
