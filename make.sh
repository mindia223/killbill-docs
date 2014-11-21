#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Actual content
USERGUIDE_INPUT_DIR=$DIR/userguide
# WordPress layout, per section
WP_INPUT_DIR=$USERGUIDE_INPUT_DIR/layout/wp
SELFCONTAINED_INPUT_DIR=$USERGUIDE_INPUT_DIR/layout/selfcontained
# Common options
COMMON_OPTS="-a sourcedir=$USERGUIDE_INPUT_DIR,imagesdir=$USERGUIDE_INPUT_DIR/assets"
# Special options for WordPress
WP_EXTRA_OPTS="$COMMON_OPTS -a data-uri,stylesheet! -s"
# Selfcontained options
SELFCONTAINED_EXTRA_OPTS="$COMMON_OPTS -a doctype=book,toc,toclevels=6,data-uri,linkcss!,source-highlighter=highlightjs,homepage=http://killbill.io"

BUILD_DIR=$DIR/build
WP_BUILD_DIR=$BUILD_DIR/wp
SELFCONTAINED_BUILD_DIR=$BUILD_DIR/selfcontained

WP_BUILD="asciidoctor $WP_EXTRA_OPTS -B $USERGUIDE_INPUT_DIR -D $WP_BUILD_DIR"
SELFCONTAINED_BUILD="asciidoctor $SELFCONTAINED_EXTRA_OPTS -B $USERGUIDE_INPUT_DIR -D $SELFCONTAINED_BUILD_DIR"

# Setup
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR

echo "*** Building WordPress sections"
for doc in `find $WP_INPUT_DIR -type d -maxdepth 1`; do
  for section in `find $doc -type f -maxdepth 1`; do
    echo "Building $section"
    $WP_BUILD $section
  done
done
for doc in `find $WP_INPUT_DIR -type f -maxdepth 1`; do
  echo "Building $doc"
  $WP_BUILD $doc
done

echo "*** Building standalone guides"
for doc in `find $SELFCONTAINED_INPUT_DIR -type f -maxdepth 1`; do
  echo "Building $doc"
  $SELFCONTAINED_BUILD $doc
done