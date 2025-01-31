#!/usr/bin/env bash

###############################################################################
# Copyright 2020 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

# Usage:
#   apollo_format.sh [options] <path/to/src/dir/or/files>

# Fail on error
set -e

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${TOP_DIR}/scripts/apollo.bashrc"

function print_usage() {
  echo -e "\n${RED}Usage${NO_COLOR}:
  .${BOLD}$0${NO_COLOR} [OPTION] <path/to/src/dir/or/files>"
  echo -e "\n${RED}Options${NO_COLOR}:
  ${BLUE}-p|--python          ${NO_COLOR}Format Python code
  ${BLUE}-b|--bazel           ${NO_COLOR}Format Bazel code
  ${BLUE}-c|--cpp             ${NO_COLOR}Format cpp code
  ${BLUE}-s|--shell           ${NO_COLOR}Format Shell code
  ${BLUE}-a|--all             ${NO_COLOR}Format all (C++/Python/Bazel/Shell)
  ${BLUE}-h|--help            ${NO_COLOR}Show this message"
}

function run_clang_format() {
  bash "${TOP_DIR}/scripts/clang_format.sh" "$@"
}

function run_buildifier() {
  bash "${TOP_DIR}/scripts/buildifier.sh" "$@"
}

function run_autopep8() {
  bash "${TOP_DIR}/scripts/autopep8.sh" "$@"
}

function run_shfmt() {
  bash "${TOP_DIR}/scripts/shfmt.sh" "$@"
}

function run_format_all() {
  run_clang_format "$@"
  run_buildifier "$@"
  run_autopep8 "$@"
  run_shfmt "$@"
}

function main() {
  if [ "$#" -eq 0 ]; then
    print_usage
    exit 1
  fi

  local option="$1"
  shift
  case "${option}" in
    -p | --python)
      run_autopep8 "$@"
      ;;
    -c | --cpp)
      run_clang_format "$@"
      ;;
    -b | --bazel)
      run_buildifier "$@"
      ;;
    -s | --shell)
      run_shfmt "$@"
      ;;
    -a | --all)
      run_format_all "$@"
      ;;
    -h | --help)
      print_usage
      exit 1
      ;;
    *)
      echo "Unknown option: ${option}"
      print_usage
      exit 1
      ;;
  esac
}

main "$@"
