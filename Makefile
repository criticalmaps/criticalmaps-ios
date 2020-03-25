all: bootstrap

bootstrap: dependencies

dependencies:
	$(shell ./update_dependencies.sh run_swiftformat)
	$(shell ./update_dependencies.sh run_license_plist)