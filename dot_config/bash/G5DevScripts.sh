

export JDXARCH="wr8-baytrail_64"
alias jt='jdx build $JDXARCH && jdx test $JDXARCH'
alias jp='jdx build $JDXARCH && jdx package $JDXARCH && jdx publish-artifacts $JDXARCH'

pin_into(){
    PIN=$(cat ./jdx/$JDXARCH/artifacts/pin.txt)
    PIN_NAME=$(echo $PIN | cut -d= -f1)
    VERSION_ID=$(echo $PIN | cut -d= -f2)
    DESTINATION_FILE=$1/do/common/$2.jdx
    EXISTING_PIN_NAME=$(cat $DESTINATION_FILE | grep $PIN_NAME | cut -d= -f1)
    NEW_PIN="$EXISTING_PIN_NAME=$VERSION_ID"
    sed -i "s/$EXISTING_PIN_NAME.*/$NEW_PIN/" $DESTINATION_FILE
}

alias pin_into_test_suite='pin_into ~/g5/uno-test-suite runbox'

