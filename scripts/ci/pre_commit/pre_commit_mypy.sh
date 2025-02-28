#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
export FORCE_ANSWER_TO_QUESTIONS=${FORCE_ANSWER_TO_QUESTIONS:="no"}
export PYTHON_MAJOR_MINOR_VERSION="3.7"
export PRINT_INFO_FROM_SCRIPTS="false"

# shellcheck source=scripts/ci/libraries/_script_init.sh
. "$( dirname "${BASH_SOURCE[0]}" )/../libraries/_script_init.sh"

function run_mypy() {
    local files=()
    if [[ "${#@}" == "0" ]]; then
      files=(airflow tests docs)
    else
      files=("$@")
    fi

    docker_v run "${EXTRA_DOCKER_FLAGS[@]}" -t \
        "-v" "${AIRFLOW_SOURCES}/.mypy_cache:/opt/airflow/.mypy_cache" \
        -e "SKIP_ENVIRONMENT_INITIALIZATION=true" \
        "${AIRFLOW_CI_IMAGE_WITH_TAG}" \
        "/opt/airflow/scripts/in_container/run_mypy.sh" "${files[@]}"
}

build_images::prepare_ci_build

build_images::rebuild_ci_image_if_confirmed_for_pre_commit

run_mypy "$@"
