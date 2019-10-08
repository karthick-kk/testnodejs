# Helpers
# -------

exitWithMessageOnError () {
  if [ ! $? -eq 0 ]; then
    echo "An error has occurred during web site deployment."
    echo $1
    exit 1
  fi
}

# Prerequisites
# -------------

# Verify node.js installed
hash node 2>/dev/null
exitWithMessageOnError "Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment."

# Setup
# -----
APP_DIR=/var/www/testnodejs
NPM_CMD=npm
CURR_DIR=`pwd`
echo "Current working directory $CURR_DIR"

mkdir -p $APP_DIR
cp server.js $APP_DIR/
cp package.json $APP_DIR/

cd $APP_DIR
echo "Running $NPM_CMD install --production"
eval $NPM_CMD install --production

hash pm2 2>/dev/null
  if [ ! $? -eq 0 ]; then
    eval $NPM_CMD install -g pm2
  fi

pm2 stop server.js
pm2 start server.js --watch

echo "Deployment Succeeded"
