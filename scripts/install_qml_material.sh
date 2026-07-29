#!/usr/bin/env bash
# Build and install QmlMaterial into a stable prefix outside the ROS workspace.
# Cleaning ros2_ws/{build,install,log} must NOT require re-running a full rebuild
# of this library (unless the submodule commit changes).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/thirdparty/qml_material"

PREFIX="${QML_MATERIAL_PREFIX:-${HOME}/opt/qml_material}"
BUILD_DIR="${QML_MATERIAL_BUILD_DIR:-${HOME}/.cache/pipe-crawler/qml_material-build}"
JOBS="${QML_MATERIAL_JOBS:-$(nproc 2>/dev/null || echo 4)}"
FORCE="${QML_MATERIAL_FORCE:-0}"

usage() {
  cat <<EOF
Usage: $(basename "$0") [--force] [--prefix DIR] [--build-dir DIR]

Installs the pinned QmlMaterial submodule to a prefix outside the colcon workspace.

Environment:
  QML_MATERIAL_PREFIX     Install prefix (default: \$HOME/opt/qml_material)
  QML_MATERIAL_BUILD_DIR  CMake build directory (default: \$HOME/.cache/pipe-crawler/qml_material-build)
  QML_MATERIAL_JOBS       Parallel build jobs (default: nproc)
  QML_MATERIAL_FORCE=1    Force reconfigure/rebuild even if stamp matches

Options:
  --force       Same as QML_MATERIAL_FORCE=1
  --prefix DIR  Override install prefix
  --build-dir DIR  Override build directory
  -h, --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --prefix) PREFIX="$2"; shift 2 ;;
    --build-dir) BUILD_DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ ! -d "${SOURCE_DIR}/.git" && ! -f "${SOURCE_DIR}/.git" ]]; then
  echo "error: QmlMaterial submodule missing at ${SOURCE_DIR}" >&2
  echo "hint: git submodule update --init --recursive" >&2
  echo "hint: Git LFS is required (git lfs install && git lfs pull)" >&2
  exit 1
fi

if ! command -v git-lfs >/dev/null 2>&1 && ! git lfs version >/dev/null 2>&1; then
  echo "warning: Git LFS not found; icon fonts may be missing" >&2
fi

COMMIT="$(git -C "${SOURCE_DIR}" rev-parse HEAD)"
SHORT_COMMIT="$(git -C "${SOURCE_DIR}" rev-parse --short HEAD)"
STAMP_FILE="${PREFIX}/.qml_material_commit"

find_config() {
  local root="$1"
  local candidate
  for candidate in \
    "${root}/lib/cmake/qml_material/qml_material-config.cmake" \
    "${root}/lib/"*/cmake/qml_material/qml_material-config.cmake
  do
    if [[ -f "${candidate}" ]]; then
      echo "${candidate}"
      return 0
    fi
  done
  return 1
}

if [[ "${FORCE}" != "1" && -f "${STAMP_FILE}" ]]; then
  INSTALLED_COMMIT="$(tr -d '[:space:]' < "${STAMP_FILE}")"
  if [[ "${INSTALLED_COMMIT}" == "${COMMIT}" ]] && find_config "${PREFIX}" >/dev/null; then
    echo "QmlMaterial already installed at ${PREFIX} (commit ${SHORT_COMMIT}) — no-op"
    echo "Re-run with --force to rebuild."
    exit 0
  fi
fi

echo "Installing QmlMaterial ${SHORT_COMMIT}"
echo "  source: ${SOURCE_DIR}"
echo "  build:  ${BUILD_DIR}"
echo "  prefix: ${PREFIX}"

mkdir -p "${BUILD_DIR}" "${PREFIX}"

# Prefer system cmake (avoids Qt installer cmake without a default generator toolchain).
CMAKE_BIN="${CMAKE_BIN:-}"
if [[ -z "${CMAKE_BIN}" ]]; then
  if [[ -x /usr/bin/cmake ]]; then
    CMAKE_BIN=/usr/bin/cmake
  else
    CMAKE_BIN="$(command -v cmake)"
  fi
fi

CMAKE_GENERATOR="${CMAKE_GENERATOR:-}"
if [[ -z "${CMAKE_GENERATOR}" ]]; then
  if command -v ninja >/dev/null 2>&1; then
    CMAKE_GENERATOR=Ninja
  else
    CMAKE_GENERATOR="Unix Makefiles"
  fi
fi

# Absolute install RPATH so QML plugins (esp. nested Layouts) find libqml_material*.so
# without relying on LD_LIBRARY_PATH. QmlMaterial's default $ORIGIN depth is wrong for Layouts.
"${CMAKE_BIN}" -S "${SOURCE_DIR}" -B "${BUILD_DIR}" \
  -G "${CMAKE_GENERATOR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DQM_BUILD_EXAMPLE=OFF \
  -DQM_BUILD_TESTS=OFF

"${CMAKE_BIN}" --build "${BUILD_DIR}" --parallel "${JOBS}"
"${CMAKE_BIN}" --install "${BUILD_DIR}"

printf '%s\n' "${COMMIT}" > "${STAMP_FILE}"

CONFIG_PATH="$(find_config "${PREFIX}")" || {
  echo "error: install finished but qml_material-config.cmake was not found under ${PREFIX}" >&2
  exit 1
}

echo "Installed QmlMaterial to ${PREFIX}"
echo "  commit: ${COMMIT}"
echo "  cmake:  ${CONFIG_PATH}"
echo
echo "Next: colcon build (CMAKE_PREFIX_PATH includes ${PREFIX} automatically if present)."
