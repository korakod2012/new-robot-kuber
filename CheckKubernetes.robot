*** Settings ***
Library    Process 
Library    SSHLibrary
Library    OperatingSystem

Suite Teardown    Close All Connections

*** Variables ***
${host}                       10.3.97.36
${keyfile}                    /Users/blackip/Desktop/PrivateKey-finema.pem
${password}                   P@ssw0rd@1234
${userName}                   finema
${promptUser}                 finema@d3odbsunm01
${dir_xmlschema_uat}          xmlschema_uat
${cmdWhoAmI}                  who am i
${listAllPod_UAT}             kubectl get pods -n uat 
${syncteda-deploy}            kubectl get pod -n uat | grep syncteda-deploy    
${tsa-api-deploy}             kubectl get pod -n uat | grep tsa-api-deploy
${status_CrashLoopBackOff}    CrashLoopBackOff
${get-SyncTrustRoot-log}      kubectl logs trustroot-deploy-5c985cf599-65s5m -n uat

*** Test Cases ***
Able to Login Kubernetes correctly
    [Documentation]    \n command : ssh -i /Users/kod/Desktop/PrivateKey-finema.pem finema@10.3.97.36
    Open Connection    ${host}
    ${output}=         Login With Public Key      ${userName}      ${keyfile}    ${password}    
    Log                ${output}
    Should Contain     ${output}      ${promptUser}

All pod should not contain status CrashLoopBackOff
    [Documentation]       \n test grap text display on console and check
    Write                 ${listAllPod_UAT}
    ${std_output} =       Read        delay=2s
    should not Contain    ${std_output}        ${status_CrashLoopBackOff}

Verify module syncteda should running
    [Documentation]    \n test grap text display on console and check
    Write              ${syncteda-deploy}
    ${std_output} =    Read       delay=2s
    should contain     ${std_output}        Running

Verify module 3 pods of tsa-api-deploy should running
    [Documentation]    \n test grap text display on console and check 3 pods that start with "tsa-api-deploy"
    Write              ${tsa-api-deploy}
    ${std_output} =    Read       delay=2s
    should contain     ${std_output}      Running

Get all log from kubernetes then create file
    [Documentation]    \n ....
    Write              ${get-SyncTrustRoot-log}
    ${std_output} =    Read       delay=5s
    Append To file      ${CURDIR}/logKuber.txt      ${std_output}

*** comment *** # remove this line will enable below test .
Log should not contain error of TrustRoot
    Create file     ${CURDIR}/errorLog.txt
    ${response} =       Grep file   ${CURDIR}/logKuber.txt       Cannot Fetch Trustroot
    Append To file      ${CURDIR}/errorLog.txt      ${response}
    should not contain     ${response}      Cannot Fetch Trustroot













