#!/usr/bin/env zsh
declare -A prov-map
declare -A smc
smc["packageName"]="smcIntelligenceAnalysis"
smc["tenantName"]="smc"
smc["provisionLocation"]=~/c3/c3smc

prov-map["smc"]=smc

function test() {
    packageName=$1
    echo "Entered package: $packageName"
    inner_array=${prov-map[$packageName]}
    echo "tenant name:     ${inner_array[\"tenantName\"]}"
    echo "package name:    ${inner_array[\"packageName\"]}"
}

function prov1() {
    currentDir=$(pwd)
    provisionLocation=~/c3/provisionLocation
    package=$1
    packageName=
    tenantName=
    case $package in
        aml)
            packageName="c3FisAml"
            tenantName="fisAml"
            ;;
        cda)
            packageName="c3FisCda"
            tenantName="fisCda"
            ;;
        uidemo)
            packageName="uiDemo"
            tenantName="uidemo"
            ;;
        hack)
            packageName="packageDependecyVisualizer"
            tenantName="hackathon"
            ;;
        so)
            packageName="sourcingOptimization"
            tenantName="so"
            ;;
        bhso)
            packageName="bhSourcingOptimization"
            tenantName="bhso"
            ;;
        shell|ghg)
            packageName="shellGhg"
            tenantName="shell"
            ;;
        smc)
            packageName="smcIntelligenceAnalysis"
            tenantName="smc"
            ;;
        repro)
            packageName="ReproPackage"
            tenantName="repro"
            ;;
        
        *)
            echo "Error in package name '$package' not recognized"
            echo "exiting"
            cd $currentDir
            return 1
            ;;
    esac

    shift

    testFlag=
    resetFlag=
    url="http://localhost:8080"
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -t|--test)
                echo "- running with tests"
                testFlag=-E
                shift
                ;;
            -g|--gittree)
                echo "- running from git trees location"
                provisionLocation=~/c3/provisionLocation2
                shift
                ;;
            -r|--reset)
                echo "- running with reset flag"
                resetFlag=-r
                shift
                ;;
            -p|--port)
                echo "- provisioning to local port 8081"
                url="http://localhost:8081"
                shift
                ;;
            *)
                echo "Unrecognized flag '$key' - returning with error code 1"
                cd $currentDir
                return 1
                ;;
        esac
    done
    cd $provisionLocation
    echo "###########################################################################"
    echo "# Provisioning from:                                                      #"
    echo -e "# \t$provisionLocation"
    echo -e "# Provision command:                                                      #"
    echo -e "# \tc3 prov tag -t $tenantName:dev -c $packageName -u BA:BA -e $url $testFlag $resetFlag"
    echo "###########################################################################"
    c3 prov tag -t $tenantName:dev -c $packageName -u BA:BA -e $url $testFlag $resetFlag
    cd $currentDir
    return $?
}
