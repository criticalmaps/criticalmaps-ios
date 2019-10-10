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
    ./bin/swiftformat .
}

run_license_plist() {
    ./bin/license-plist
    cp -fR ./com.mono0926.LicensePlist.Output/* ./Settings.bundle
    rm -rf ./com.mono0926.LicensePlist.Output
}

check_bundle;
execute_fastlane_snapshot; 
run_swiftformat;
run_license_plist;
