#!/bin/bash

REDMINE_SOURCE_URL="http://www.redmine.org/releases"

REDMINE_NAME="redmine-${REDMINE_VERSION}"
REDMINE_PACKAGE="${REDMINE_NAME}.tar.gz"
REDMINE_URL="${REDMINE_SOURCE_URL}/${REDMINE_PACKAGE}"

PLUGIN_SOURCE="lpirl"
PLUGIN_NAME="redmine_diff_email"

CURRENT_DIR=$(pwd)

echo ""
echo "######################"
echo "REDMINE INSTALLATION SCRIPT"
echo ""
echo "REDMINE_VERSION : ${REDMINE_VERSION}"
echo "REDMINE_URL     : ${REDMINE_URL}"
echo "CURRENT_DIR     : ${CURRENT_DIR}"
echo "PLUGIN_ORIGIN   : ${PLUGIN_SOURCE}/${PLUGIN_NAME}"
echo ""

echo "#### GET TARBALL"
wget "${REDMINE_URL}"
echo "Done !"
echo ""

echo "#### EXTRACT IT"
tar xf "${REDMINE_PACKAGE}"
echo "Done !"
echo ""

echo "#### MOVE PLUGIN"
mv "${PLUGIN_SOURCE}/${PLUGIN_NAME}" "${REDMINE_NAME}/plugins"
rmdir "${PLUGIN_SOURCE}"
echo "Done !"
echo ""

echo "#### CREATE SYMLINK"
ln -s "${REDMINE_NAME}" "redmine"
echo "Done !"
echo ""

echo "#### INSTALL DATABASE FILE"
if [ "$DATABASE_ADAPTER" == "mysql" ] ; then
  echo "Type : mysql"
  cp "redmine/plugins/${PLUGIN_NAME}/spec/database_mysql.yml" "redmine/config/database.yml"
else
  echo "Type : postgres"
  cp "redmine/plugins/${PLUGIN_NAME}/spec/database_postgres.yml" "redmine/config/database.yml"
fi

echo "Done !"
echo ""

echo "#### INSTALL RSPEC FILE"
mkdir "redmine/spec"
cp "redmine/plugins/${PLUGIN_NAME}/spec/root_spec_helper.rb" "redmine/spec/spec_helper.rb"
echo "Done !"
echo ""

echo "######################"
echo "CURRENT DIRECTORY LISTING"
echo ""

ls -l "${CURRENT_DIR}"
echo ""

echo "######################"
echo "REDMINE PLUGIN DIRECTORY LISTING"
echo ""

ls -l "${REDMINE_NAME}/plugins"
echo ""
