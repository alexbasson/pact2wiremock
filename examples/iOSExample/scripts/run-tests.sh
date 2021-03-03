#!/usr/bin/env bash

PATH_TO_PACT='./tmp/pacts/ingredient-ios-ingredient-service.json'
WIREMOCK_DIR='./wiremock/'
WIREMOCK_PORT=9000
XCODE_PROJECT_FILE='iOSExample.xcodeproj'
UNIT_TEST_SCHEME='UnitTests'
UI_TEST_SCHEME='UITests'

function set_bash_error_handling() {
  set -o errexit
  set -o errtrace
  set -o nounset
  set -o pipefail
}

function go_to_project_root_directory() {
  local -r script_dir=$(dirname "${BASH_SOURCE[0]}")

  cd "$script_dir/.." || exit 1
}

function install_brew_dependencies_if_necessary() {
  if ! command -v pact-mock-service $> /dev/null
  then
    echo "Installing brew dependencies"
    brew bundle
  fi
}

function clean_project() {
  xcodebuild clean -project $XCODE_PROJECT_FILE | cat
}

function get_ios_simulator_id() {
  IOS_SIMULATOR_ID=$(xcrun simctl list \
  | grep '^[ ]*iPhone'\
  | grep -v 'unavailable'\
  | grep -o '[0-9A-Z]\{8\}-[0-9A-Z]\{4\}-[0-9A-Z]\{4\}-[0-9A-Z]\{4\}-[0-9A-Z]\{12\}'\
  | tail -1)
}

function run_unit_tests() {
  xcodebuild test \
    -project $XCODE_PROJECT_FILE \
    -scheme $UNIT_TEST_SCHEME \
    -destination "platform=iOS Simulator,id=${IOS_SIMULATOR_ID}" | cat
}

function kill_wiremock_if_already_running() {
  set +o pipefail
  WIREMOCK_PID=$(lsof -i tcp:$WIREMOCK_PORT | awk 'END {print $2}')
  set -o pipefail

  if [ "$WIREMOCK_PID" ]
  then
    kill -9 "$WIREMOCK_PID"
  fi
}

function generate_wiremock_stubs() {
  pact2wiremock -p $PATH_TO_PACT -m "${WIREMOCK_DIR}mappings/"
}

function start_wiremock() {
  pushd $WIREMOCK_DIR
  java -jar wiremock-standalone-2.27.2.jar --port $WIREMOCK_PORT &
  WIREMOCK_PID=$!
  popd
}

function stop_wiremock() {
  kill $WIREMOCK_PID
}

function run_ui_tests() {
  xcodebuild test \
    -project $XCODE_PROJECT_FILE \
    -scheme $UI_TEST_SCHEME \
    -destination "platform=iOS Simulator,id=${IOS_SIMULATOR_ID}" | cat
}

function main() {
  go_to_project_root_directory
  set_bash_error_handling
  install_brew_dependencies_if_necessary
  get_ios_simulator_id

  clean_project

  run_unit_tests

  generate_wiremock_stubs

  kill_wiremock_if_already_running
  start_wiremock
  run_ui_tests
  stop_wiremock
}

main
