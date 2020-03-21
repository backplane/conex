#!/bin/sh
# this file contains the unit tests for runner.sh you can use it as an example
# (or a counter-example) as needed

testShellCheck() {
  shellcheck "${TESTING_TARGET}" || fail "shellcheck failed"
}

testImportMode() {
  output=$(sh -c "export IMPORT=1; . ${TESTING_TARGET}")

  assertEquals "Import mode should output nothing" "$output" ""
}

# testFunctionRun() {
# }

oneTimeSetUp() {
  printf "importing $TESTING_TARGET" >ugh.sh
  IMPORT=1 . "${TESTING_TARGET}"
}

# shellcheck source=/dev/null
. "$SHUNIT_PATH"
