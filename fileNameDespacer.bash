#!/bin/bash


function removeSpaces(){
    for f in *\ *; do mv "$f" "${f// /_}";
}

