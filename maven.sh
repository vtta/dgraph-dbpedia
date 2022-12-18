#!/bin/bash
set -ex

DIR="$(dirname "$(readlink -f "$0")")"
MVN="$DIR/apache-maven-3.8.6/bin/mvn"
MVN_RELEASE="https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz"
export MAVEN_OPTS="-Xmx$((2*$(nproc)))g"

cd "$DIR"
[ -f "$MVN" ] || ( wget "$MVN_RELEASE" && tar axvf apache-maven-3.8.6-bin.tar.gz )


"$MVN" compile exec:java \
  -Dexec.cleanupDaemonThreads=false \
  -Dexec.topInfoboxPropertiesPerLang=None \
  -Dexec.mainClass="uk.co.gresearch.dgraph.dbpedia.DbpediaToParquetSparkApp" \
  -Dexec.args="dbpedia 2016-10"

"$MVN" compile exec:java \
  -Dexec.cleanupDaemonThreads=false \
  -Dexec.topInfoboxPropertiesPerLang=None \
  -Dexec.mainClass="uk.co.gresearch.dgraph.dbpedia.DbpediaDgraphSparkApp" \
  -Dexec.args="dbpedia 2016-10"

