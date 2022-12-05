#!/bin/bash
# Creates a C# console project with associated folders
set -e

echo "Please input folder name." && read NAME

mkdir $NAME && cd $NAME
mkdir src
mkdir test

cd src
echo "Please input .csproject name " && read PROJNAME
mkdir $PROJNAME && cd $PROJNAME
dotnet new console --use-program-main