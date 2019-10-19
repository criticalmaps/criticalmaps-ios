#!/bin/bash

execute_fastlane_snapshot() {
    echo "Updating fastlane snapshot"
    bundle exec fastlane snapshot update
}

check_bundle() {
    echo "Checking for missing bundle dependencies"
    bundle check
    if [ $? -ne 0 ]
    then
        echo "Dependencies missing, running bundle install"
        bundle install --path vendor/bundle && bundle update
    else
        echo "No dependencies missing, checking for update"
        bundle update
    fi
}

run_swiftformat() {
    echo "Creating a folder for swiftformat download meta"
    mkdir extract_swiftformat
    cd extract_swiftformat

    echo "Downloading swiftformat executable"
    curl -Ls https://api.github.com/repos/nicklockwood/Swiftformat/zipball > swiftformat.zip

    unzip -q swiftformat.zip

    echo "Forcefully copying the extracted swiftformat executble to bin"
    yes | cp -rf nicklockwood*/CommandLineTool/swiftformat ../bin/

    echo "Removing the created swiftformat meta folder"
    cd ..
    rm -rf extract_swiftformat
}

run_license_plist() {
    echo "Creating a folder for license-plist download meta"
    mkdir extract_license_plist
    cd extract_license_plist

    echo "Downloading license-plist executable"
    curl -Ls https://api.github.com/repos/mono0926/LicensePlist/releases/latest \
    | grep "browser_download_url.*portable_licenseplist.zip" | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -

    unzip -q portable_licenseplist.zip

    echo "Forcefully copying the extracted license-plist executble to bin"
    yes | cp -rf ./license-plist ../bin/

    echo "Removing the created license-plist meta folder"
    cd ..
    rm -rf extract_license_plist
}

check_bundle;
execute_fastlane_snapshot; 
run_swiftformat;
run_license_plist;
