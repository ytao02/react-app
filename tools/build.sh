#!/bin/bash
set -e

__DIRNAME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

APP_NAME=react-app

BUILD_ENV=${BUILD_ENV:-${1:-production}}

export NODE_OPTIONS="--max-old-space-size=4096"

cd "${__DIRNAME}/.." # repo root

main() {
  echo "🏗️ BUILD_ENV=${BUILD_ENV}"

  initialize_env


  install_yarn

 install_dependencies

  if [ "$BUILD_ENV" == "production" ]; then
    build_ui
  fi
}

build_ui() {
  echo "🏗️ Building 💄..."
  yarn build
  echo " ✅ Done building💄"
}

initialize_env() {
  export YARN_CACHE_FOLDER="${HOME}/.yarn_cache/${APP_NAME}/${BUILD_TAG}"

  # Add nvm to session if available
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  command -v nvm || install_nvm
}

install_dependencies() {
  echo "➡️ Installing ui dependencies 💄..."
  yarn --cwd install --frozen-lockfile
  echo "✅ Done installing ui dependencies 💄"
}

install_yarn() {
  echo "👌 Ensuring that yarn is installed and up-to-date 🧶..."
  npm install --global --no-progress yarn
  echo "✅ Yarn is up-to-date 🧶"
}

main
