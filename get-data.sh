#!/usr/bin/env bash

# download the data using curl
if [ ! -f dataset.zip ]; then
    curl -o dataset.zip -L \
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fi

# unzip dataset
unzip dataset.zip
