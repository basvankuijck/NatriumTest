all: help

build:
	mv ./Package.swift ./Package.swift_; mv ./Package.local.swift ./Package.swift
	swiftlint; swift build --configuration release
	mv ./Package.swift ./Package.local.swift; mv ./Package.swift_ ./Package.swift
	cp .build/release/natrium Natrium/
	chmod +x Natrium/natrium
	mkdir -p Example/Cocoapods/Pods/Natrium
	chmod -R 7777 Example/CocoaPods/Pods/Natrium/
	cp Natrium/Sources/*.swift Example/CocoaPods/Pods/Natrium/
	cp Natrium/natrium Example/CocoaPods/Pods/Natrium/
	cp Natrium/Sources/Natrium.h Example/CocoaPods/Pods/Natrium/
	rm -rf Example/CocoaPods/Pods/Natrium/Natrium.lock
	cp Natrium/natrium Example/Manual/
	rm -rf Example/Manual/Natrium.lock
	rm -rf Res/Natrium.framewok/run
	cp Natrium/natrium Res/Natrium.framework/run
	rm -rf Res/Natrium.framewok.zip
	zip -r -X "Res/Natrium.framework.zip" Res/Natrium.framework/*
	sh Res/update_version_json.sh

xcodeproj:
	mv ./Package.swift ./Package.swift_; mv ./Package.local.swift ./Package.swift
	swift package generate-xcodeproj
	mv ./Package.swift ./Package.local.swift; mv ./Package.swift_ ./Package.swift

help:
	@echo "Available make commands:"
	@echo "   $$ make help - display this message"
	@echo "   $$ make build - creates a new build"
	@echo "   $$ make xcodeproj - creates a xcodeproj"
