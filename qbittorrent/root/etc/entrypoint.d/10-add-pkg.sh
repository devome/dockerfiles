if [[ $EXTRA_PACKAGES ]]; then
    echo "Install $EXTRA_PACKAGES ..."
    apk add --update --no-cache $EXTRA_PACKAGES
fi
