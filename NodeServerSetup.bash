#!/bin/bash

#
#install all node components and modules
#

function installSeanStack(){
  echo "Server installation for S.E.A.N. stack beginning";
  say "Server installation for sean stack beginning";
   npm init -yes &&
   npm install express path body-parser pg angular angular-route angular-material angular-animate angular-aria angular-messages bootstrap moment grunt grunt-contrib-copy grunt-contrib-uglify grunt-contrib-jshint grunt-contrib-watch --save;
}

function installMeanStack(){
  echo "Server installation for M.E.A.N. stack beginning";
  say "Server installation for mean stack beginning";
   npm init -yes &&
   npm install express path body-parser mongoose mongoose-schema-formatdate mongoose angular angular-route angular-material angular-material angular-animate angular-aria angular-messages bootstrap moment grunt grunt-contrib-copy grunt-contrib-uglify grunt-contrib-jshint grunt-contrib-watch --save;
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
