#!/bin/sh

pod lib lint Tiercel-Sky.podspec \
--allow-warnings \
--verbose \
--no-clean \
--sources=https://cdn.cocoapods.org/

# --skip-import-validation