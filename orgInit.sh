#!/bin/bash
# create scratch org using regular definition file
sfdx force:org:create -a aademo -f config/project-scratch-def.json -s -d 30 -w 10
# deploy the basic configuration
sfdx force:source:deploy  -m "CustomObject, PermissionSet, CustomApplication, CustomTab, FlexiPage, ApexClass, Layout"
# assign EA admin to admin user
sfdx force:user:permset:assign  -n EinsteinAnalyticsPlusAdmin
# assign DF19 LMA permset to admin user
sfdx force:user:permset:assign  -n LMA
# assign DF19 LMA permset to EA integration user using anonymous apex
sfdx force:apex:execute  -f ./config/assign-lma-permset.apex
# deploy EA components
sfdx force:source:deploy  -m "WaveDataflow, WaveDataset, WaveLens, WaveApplication, WaveDashboard"
# load sample data
#sfdx force:data:tree:import -p data/account-Account-plan.json -u aademo
sfdx force:data:tree:import  -p data/version-Package__c-Package_Version__c-plan.json
sfdx force:data:tree:import  -p data/license-Account-License__c-plan.json

# run apex to send email to reset password
#sfdx force:apex:execute -f config/create-demo-data-setup.apex -u aademo
# open the default scratch org at EA Studio
sfdx force:org:open  -p /analytics/wave/wave.apexp
