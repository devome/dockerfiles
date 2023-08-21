if [[ $INSTALL_PYTHON == true ]]; then
    echo "Install python3 ..."
    apk add --update --no-cache python3
fi

if [[ $EXTRA_PACKAGES ]]; then
    echo "Install $EXTRA_PACKAGES ..."
    apk add --update --no-cache $EXTRA_PACKAGES
fi
