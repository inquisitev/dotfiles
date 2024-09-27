source ~/.config/bash/G5DevScripts.sh

if ! which jdx >/dev/null; then
    echo "Skipping setup of workspace because JDX is not found" 
    exit 1
fi

PC_ORG="Precision-Construction"
WORKSPACE_DIR=~/g5

clone_apps(){
    UNO_APPS=$(gh repo list $PC_ORG --json name -L 300 | jq .[].name | grep -i uno | grep -Ev "tool|test|documentation|tutorials" | tr -d '"')
    SERVICES=$(gh repo list $PC_ORG --json name -L 300 | jq .[].name | grep -Ei "platform-config|Soup|Multiplexed-Instance" | tr -d '"')

    (
        cd $WORKSPACE_DIR

        for repo in $UNO_APPS $SERVICES
        do
            if [[ ! -d $WORKSPACE_DIR/$repo ]]; then
                gh repo clone $PC_ORG/$repo
            fi
        done
    )
}

prepare_hw_bundle(){
    UNO_APPS=$(gh repo list $PC_ORG --json name -L 300 | jq .[].name | grep -i uno | grep -Ev "tool|test|documentation|tutorials" | tr -d '"')
    SERVICES=$(gh repo list $PC_ORG --json name -L 300 | jq .[].name | grep -Ei "platform-config|Soup|Multiplexed-Instance")

    (
        cd $WORKSPACE_DIR
        export JDXARCH="qs-arm_64"
        (
            cd Soup-Of-Underlying-Protocols 
            echo "Building: Soup-Of-Underlying-Protocols" 

            # jp > /dev/null

            for repo in $UNO_APPS
            do
                if [[ -d $WORKSPACE_DIR/$repo ]]; then
                    echo "Pinning into $WORKSPACE_DIR/$repo  for $JDXARCH" 
                    pin_into $WORKSPACE_DIR/$repo buildbox
                fi
            done
        )

        for repo in $UNO_APPS
        do
            if [[ -d $WORKSPACE_DIR/$repo ]]; then
                (cd $repo && echo "Building: $repo" && jp > /dev/null)
            fi
        done
        
        (cd "platform-config" && echo "Building: platform-config" && jp . > /dev/null)
        (cd "Multiplexed-Instance-Controls-System" && echo "Building: Multiplexed-Instance-Controls-System" && jp > /dev/null)

    )
}

checkout_for_apps(){

    UNO_APPS=$(gh repo list $PC_ORG --json name -L 300 | jq .[].name | grep -i uno | grep -Ev "tool|test|documentation|tutorials" | tr -d '"')
    for repo in $UNO_APPS
    do
        if [[ -d $WORKSPACE_DIR/$repo ]]; then
            (cd $WORKSPACE_DIR/$repo && git restore . && git checkout $1)
        fi
    done
}

collect_tars(){
    PACKAGES_DIR=$WORKSPACE_DIR/packages
    rm -r $PACKAGES_DIR
    mkdir $PACKAGES_DIR
    (cd $PACKAGES_DIR && find $WORKSPACE_DIR -type f -path '**/jdx/qs-arm_64/artifacts/*.tar.gz' | xargs -I {} tar -xvf {})
    tar -czvf "packages.tar.gz" $PACKAGES_DIR 
    rm -r $PACKAGES_DIR
}
