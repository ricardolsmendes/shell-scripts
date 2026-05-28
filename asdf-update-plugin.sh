#!/usr/bin/env bash

set -euo pipefail

ASDF_PLUGIN=""
REMOVE_OLD_VERSIONS=false

usage() {
  cat <<EOF
Usage: $(basename "$0") <plugin-name> [--remove-old-versions]

Update an ASDF plugin to the latest version, install it, and pin that version
in ~/.tool-versions.

Options:
  --remove-old-versions, -r  Remove older installed versions after updating.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remove-old-versions|-r)
      REMOVE_OLD_VERSIONS=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      if [[ -z "${ASDF_PLUGIN}" ]]; then
        ASDF_PLUGIN="$1"
        shift
      else
        echo "Unknown argument: $1" >&2
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "${ASDF_PLUGIN}" ]]; then
  echo "Error: ASDF plugin name is required." >&2
  usage
  exit 1
fi

if ! command -v asdf >/dev/null 2>&1; then
  echo "Error: asdf is not installed or not available in PATH." >&2
  exit 1
fi

if ! asdf plugin list | sed 's/\r$//' | grep -Eq "^${ASDF_PLUGIN}[[:space:]]*$"; then
  echo "Error: ASDF plugin '${ASDF_PLUGIN}' is not installed." >&2
  echo "Install it with: asdf plugin add ${ASDF_PLUGIN}" >&2
  exit 1
fi

echo "Updating ASDF plugin '${ASDF_PLUGIN}'..."
asdf plugin update "${ASDF_PLUGIN}"

get_latest_version() {
  if asdf latest "${ASDF_PLUGIN}" >/dev/null 2>&1; then
    asdf latest "${ASDF_PLUGIN}"
  else
    asdf list all "${ASDF_PLUGIN}" | tail -n 1
  fi
}

LATEST_VERSION=$(get_latest_version || true)
if [[ -z "${LATEST_VERSION}" ]]; then
  echo "Error: unable to determine latest version for ${ASDF_PLUGIN}." >&2
  exit 1
fi

echo "Latest ${ASDF_PLUGIN} version is ${LATEST_VERSION}."

echo "Installing ${ASDF_PLUGIN} ${LATEST_VERSION}..."
asdf install "${ASDF_PLUGIN}" "${LATEST_VERSION}"

TOOL_VERSIONS_FILE="${HOME}/.tool-versions"
if [[ ! -e "${TOOL_VERSIONS_FILE}" ]]; then
  touch "${TOOL_VERSIONS_FILE}"
fi

if grep -qE "^${ASDF_PLUGIN}[[:space:]]+" "${TOOL_VERSIONS_FILE}"; then
  perl -pi -e "s/^${ASDF_PLUGIN}[[:space:]]+.*/${ASDF_PLUGIN} ${LATEST_VERSION}/" "${TOOL_VERSIONS_FILE}"
else
  printf '%s %s\n' "${ASDF_PLUGIN}" "${LATEST_VERSION}" >> "${TOOL_VERSIONS_FILE}"
fi

echo "Pinned ${ASDF_PLUGIN} ${LATEST_VERSION} in ${TOOL_VERSIONS_FILE}."

if [[ "${REMOVE_OLD_VERSIONS}" == true ]]; then
  ASDF_DIR="${ASDF_DIR:-${HOME}/.asdf}"
  INSTALL_DIR="${ASDF_DIR}/installs/${ASDF_PLUGIN}"

  if [[ ! -d "${INSTALL_DIR}" ]]; then
    echo "Warning: install directory ${INSTALL_DIR} does not exist. Nothing to remove."
    exit 0
  fi

  echo "Removing older ${ASDF_PLUGIN} installations..."
  shopt -s nullglob
  for version_dir in "${INSTALL_DIR}"/*; do
    version_name=$(basename "${version_dir}")
    if [[ "${version_name}" != "${LATEST_VERSION}" ]]; then
      rm -rf "${version_dir}"
      echo "Removed ${version_name}."
    fi
  done
  shopt -u nullglob
fi

echo "Done. ${ASDF_PLUGIN} is updated to ${LATEST_VERSION}."
