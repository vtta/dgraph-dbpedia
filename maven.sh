#!/bin/bash
set -ex

DIR="$(dirname "$(readlink -f "$0")")"
MVN="$DIR/apache-maven-3.8.6/bin/mvn"
MVN_RELEASE="https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz"
export MAVEN_OPTS="-Xmx$((2*$(nproc)))g"
JAVA_RELEASE="https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java8/java8u351/jdk/jdk-8u351-linux-x64.tar.gz"
JAVA="$DIR/jdk1.8.0_351/bin/java"
export JAVA_HOME="$DIR/jdk1.8.0_351"

cd "$DIR"
[ -f "$MVN" ] || ( wget "$MVN_RELEASE" && tar axvf apache-maven-3.8.6-bin.tar.gz )
[ -f "$JAVA" ] || ( wget "$JAVA_RELEASE" && tar axvf jdk-8u351-linux-x64.tar.gz )


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

