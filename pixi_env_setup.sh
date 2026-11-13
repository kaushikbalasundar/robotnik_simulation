#!/usr/bin/bash

export LIBRARY_PATH="${CONDA_PREFIX}/lib:${LIBRARY_PATH}"
export CMAKE_PYTHON_ARGS="-DPython3_ROOT_DIR=$CONDA_PREFIX -DPython_ROOT_DIR=$CONDA_PREFIX -DPython3_EXECUTABLE=$CONDA_PREFIX/bin/python -DPython_EXECUTABLE=$CONDA_PREFIX/bin/python"
export RMW_IMPLEMENTATION="${RMW_IMPLEMENTATION_OVERRIDE:-rmw_fastrtps_cpp}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PIXI_PROJECT_ROOT="${PIXI_PROJECT_ROOT:-${SCRIPT_DIR}}"

if [ "$(basename "$(realpath "${PIXI_PROJECT_ROOT}/..")")" = "src" ]; then
  export ROBOTNIK_WS="$(realpath "${PIXI_PROJECT_ROOT}/../..")"
else
  export ROBOTNIK_WS="$(realpath -m "${PIXI_PROJECT_ROOT}/../robotnik_ws")"
fi

if [ -f "${ROBOTNIK_WS}/install/setup.bash" ]; then
  source "${ROBOTNIK_WS}/install/setup.bash"
fi
