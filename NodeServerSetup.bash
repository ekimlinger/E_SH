#!/bin/bash

#
#install all node components and modules
#

function installSeanStack(){
   npm init -yes &&
   npm install express path body-parser pg angular angular-route bootstrap grunt grunt-contrib-copy grunt-contrib-uglify grunt-contrib-jshint grunt-contrib-watch --save;
}

function installMeanStack(){
   npm init -yes &&
   npm install express path body-parser mongodb angular angular-route bootstrap grunt grunt-contrib-copy grunt-contrib-uglify grunt-contrib-jshint grunt-contrib-watch --save;
}

#
# Creates standard node architecture
#

function createNodeFolders(){
   echo "node_modules \n.DS_STORE \nnpm-debug.log \nplansToTakeOverTheWorld.md" > .gitignore;
   cp ~/Documents/__groundZERO/Gruntfile.js .;
   mkdir server;
   cp ~/Documents/__groundZERO/server/app.js ./server/;
   mkdir server/public;
   mkdir server/public/assets;
   mkdir server/public/assets/scripts;
   mkdir server/public/assets/styles;
   mkdir client/views;
   cp ~/Documents/__groundZERO/server/views/index.html ./server/public/views/;
   mkdir server/modules;
   cp ~/Documents/__groundZERO/server/routes/index.js ./server/modules/;
   mkdir client;
   mkdir client/scripts;
   cp ~/Documents/__groundZERO/client/app.js ./client/scripts/;
}
