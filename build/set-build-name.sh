if [ ! -z "${TAG_VERES}" ] ; then
    echo BUILD_NAME overridden to \"${BUILD_NAME}\"
else

    if [ ! -z "${GITHUB_RUN_ID}" ]; then
        BUILD_NUMBER=${GITHUB_RUN_ID}
    fi

    if [ -z "${BUILD_NUMBER}" ]; then
        BUILD_NUMBER="`date +'%s'`"
    fi

    if [ -z "${BRANCH_NAME}" ]; then
        BRANCH_NAME=`git branch | sed -n -e 's/^\* \(.*\)/\1/p' | sed -n -e 's@/@-@p'`
    fi

    if [ ${CI} ] ; then
        if [ "${BRANCH_NAME}" == "master" ] ; then
            BRANCH_NAME="stable"
        fi
    fi

    if [ -z "${ENVIRONMENT}" ] ; then
        if [ ${GITHUB_ACTIONS} ] ; then
            ENVIRONMENT="github"
        elif [ ${CIRCLECI} ] ; then
            ENVIRONMENT="circleci"
        elif [ ${CI} ] ; then
            ENVIRONMENT="ci"
        else
            ENVIRONMENT="local"
        fi
    fi

    BUILD_NAME="${BRANCH_NAME}-${ENVIRONMENT}-${BUILD_NUMBER}"

    echo BUILD_NAME set to "${BUILD_NAME}"
fi
