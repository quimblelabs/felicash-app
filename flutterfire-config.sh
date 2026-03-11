#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'stg', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=felicash-dev \
      --out=lib/main/firebase_options_dev.dart \
      --ios-bundle-id=com.quimblelabs.felicash.dev \
      --ios-out=ios/Runner/development/GoogleService-Info.plist \
      --android-package-name=com.quimblelabs.felicash.dev \
      --android-out=android/app/src/development/google-services.json
    ;;
  stg)
    flutterfire config \
      --project=felicash-stg \
      --out=lib/main/firebase_options_stg.dart \
      --ios-bundle-id=com.quimblelabs.felicash.stg \
      --ios-out=ios/Runner/staging/GoogleService-Info.plist \
      --android-package-name=com.quimblelabs.felicash.stg \
      --android-out=android/app/src/staging/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=felicash-prod \
      --out=lib/main/firebase_options_prod.dart \
      --ios-bundle-id=com.quimblelabs.felicash \
      --ios-out=ios/Runner/production/GoogleService-Info.plist \
      --android-package-name=com.quimblelabs.felicash \
      --android-out=android/app/src/production/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'stg', or 'prod'."
    exit 1
    ;;
esac
