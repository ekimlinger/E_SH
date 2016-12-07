nstall all node components and modules
#

function installSeanStack(){
  #Check for internet connectivity before attempting to install
  if ping -q -c 1 -W 1 google.com >/dev/null; then
    echo "Server installation for S.E.A.N. stack beginning";
    say "Server installation for sean stack beginning";
    npm init -yes &&
    npm install express path body-parser pg angular angular-route angular-material angular-animate angular-aria angular-messages bootstrap moment grunt grunt-contrib-copy grunt-contrib-uglify grunt-contrib-jshint grunt-contrib-watch --save &&
    __createNodeFolders sql;

  else
    echo "The network is down"
  fi
}

function installMeanStack(){
  echo "Server installation for M.E.A.N. stack beginning";
  say "Server installation for mean stack beginning";
   npm init -yes &&
   npm install express path body-parser mongoose mongoose-schema-formatdate mongoose angular angular-route angular-material angular-material angular-animate angular-aria angular-messages bootstrap moment grunt grunt-contrib-copy grunt-contrib-uglify grunt-contrib-jshint grunt-contrib-watch --save &&
   __createNodeFolders mongo;
}

#
# Creates standard node architecture
#

function __createNodeFolders {
   echo "Creating Node architecture with $1";
   echo "node_modules \n.DS_STORE \nnpm-debug.log \nplansToTakeOverTheWorld.md" > .gitignore;

   __createGruntfile;

   mkdir server;

   if [ "$1" = "mongo" ]; then
      __createServerApp mongo;
   elif [ "$1" = "sql" ]; then
      __createServerApp sql;
   fi

   mkdir server/public;
   mkdir server/public/assets;
   mkdir server/public/assets/scripts;
   mkdir server/public/assets/styles;
   mkdir server/modules && __createRouterFile;
   mkdir server/models;
   mkdir client;
   mkdir client/scripts;
   __createClientApp;
   mkdir client/views;
   __createIndexFile;
   mkdir client/views/partials;
   mkdir client/views/routes;
}







#
# Used by createNodeFolders to create Gruntfile.js needed
#
function __createGruntfile(){
  GRUNTFILE="
  module.exports = function(grunt){
    grunt.initConfig({
      pkg:grunt.file.readJSON('package.json'),
      uglify: {
        options: {
          banner: '/*! <%= pkg.name %> <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n'
        },
        build: {
          src: 'client/scripts/app.js',
          dest: 'server/public/assets/scripts/app.min.js'
        }
      },
      jshint:{
        files:'client/*.js'
      },
      watch: {
        scripts:{
          files:'client/app.js',
          tasks: ['jshint', 'uglify'],
          options:{
            spawn: false
          }
        }
      },
      copy: {
        html: {
          expand: true,
          cwd: \"client\",
          src: \"/views/*\"
        },
        angular: {
          expand: true,
          cwd: \"node_modules/angular\",
          src: [
            \"angular/*\",
            \"angular-animate/*\",
            \"angular-aria/*\",
            \"angular-material/*\",
            \"angular-messages/*\",
            \"angular-route/*\"
          ],
          dest: \"server/public/vendors/\"
        },
        bootstrap: {
          expand: true,
          cwd: \"node_modules/bootstrap/dist/css/\",
          src: [
            \"*\"
          ],
          dest: \"server/public/vendors\"
        }
      }
    });
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.registerTask('default', ['copy','uglify','jshint']);

  }
  ";
  echo $GRUNTFILE > ./Gruntfile.js;

}


function __createServerApp(){
  if [ "$1" = "mongo" ]; then
    APP="var express = require('express');
    var app = express();
    var path = require('path');
    var bodyParser = require('body-parser');
    var pg = require('pg');
    var routes = require('./routes/index.js');



    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({extended: true}));

    // ***************** IF USING A DATABASE *****************//
    var connectionString;
    if(process.env.DATABASE_URL){
      pg.defaults.ssl = true;
      connectionString = process.env.DATABASE_URL;
    } else {
      connectionString = 'postgres://localhost:5432/task_manager_DB';
    }
    pg.connect(connectionString, function(err, client,done){
      if (err){
        console.log('Error connecting to the DB: ', err)
      } else{
        var query = client.query(

          //  CREATES employee_table,
          //          columns:        id, name, number, job, salary

          'CREATE TABLE IF NOT EXISTS task_list (' +
          'id SERIAL PRIMARY KEY,'+
          'name varchar(100) NOT NULL,'+
          'description varchar(160) NOT NULL,'+
          \"complete BOOLEAN DEFAULT 'false');\"
        );

        query.on('end',function(){
          done();
          console.log('Successfully ensured our tables exists');
        });

        query.on('error', function(error){
          done();
          console.log('Error creating table', error);
        });
      }
    });


    app.use('/', router);

    app.get(\"/*\", function(req,res){
      var file = req.params[0] || \"/views/index.html\";
      res.sendFile(path.join(__dirname,\"/public/\", file));
    });

    app.set(\"port\",(process.env.PORT || 3000));

    app.listen(app.get(\"port\"),function(){
      console.log(\"Listening on port: \", app.get(\"port\"));
    });

    module.exports = app;
    "
  else
    APP="var express = require(\"express\");
    var app = express();
    var bodyParser = require(\"body-parser\");
    var router = require(\"./modules/index.js\");

    //MONGO
    var mongoose = require(\"mongoose\");
    var mongoURI =
        process.env.MONGODB_URI ||
        process.env.MONGOHQ_URL ||
        'mongodb://127.0.0.1:27017/parent_journal';

    var MongoDB = mongoose.connect(mongoURI).connection;


    MongoDB.on(\"error\", function(err) {
        console.log(\"Mongo Connection Error: \", err);
    });

    MongoDB.once(\"open\", function(err) {
        console.log(\"Mongo Connection Open on: \", mongoURI);
    });




    app.use('/', router);

    app.set(\"port\", (process.env.PORT || 3000));

    app.listen(app.get(\"port\"), function() {
        console.log(\"Listening on port: \", app.get(\"port\"));
    });



    //PASSPORT
    // var cookieParser = require(\"cookie-parser\");
    // var passport = require(\"passport\");
    // var session = require(\"express-session\");
    // var localStrategy = require(\"passport-local\");

    // var register = require(\"./modules/register.js\");
    // var user = require(\"./modules/users.js\");

    // Passport
    // app.use(session({
    //     secret: \"secret\",
    //     key: \"user\",
    //     resave: true,
    //     saveUninitialized: true,
    //     s: false,
    //     cookie: {
    //         maxAge: 6000000000000000000000000000,
    //         secure: false
    //     }
    // }));

    // Passport
    // app.use(cookieParser());
    // app.use(bodyParser.json());
    // app.use(bodyParser.urlencoded({
    //     extended: true
    // }));
    // app.use(passport.initialize());
    // app.use(passport.session());
    //
    //PASSPORT SESSION
    // passport.serializeUser(function(user, done) {
    //     done(null, user.id);
    // });
    //
    // passport.deserializeUser(function(id, done) {
    //     User.findById(id, function(err, user) {
    //         if (err) done(err);
    //         done(null, user);
    //     });
    // });
    //
    // passport.use(\"local\", new localStrategy({
    //     passReqToCallback: true,
    //     usernameField: 'username'
    // }, function(req, username, password, done) {
    //     User.findOne({
    //         username: username
    //     }, function(err, user) {
    //         if (err) throw err;
    //         if (!user) {
    //             return done(null, false, {
    //                 message: \"Incorrect username or password\"
    //             });
    //         }
    //
    //         user.comparePassword(password, function(err, isMatch) {
    //             if (err) throw err;
    //             if (isMatch) {
    //                 return done(null, user);
    //             } else {
    //                 done(null, false, {
    //                     message: \"Incorrect username or password\"
    //                 });
    //             }
    //         });
    //     });
    // }));
    // // Routers
    // app.post(\"/login\", passport.authenticate(\"local\", {
    //     successRedirect: \"/assets/views/index.html\",
    //     failureRedirect: \"/assets/views/login.html\"
    // }));

    // app.use('/register', register);
    // app.use('/user', user);




    module.exports = app;
    "
  fi
  echo "$APP" > ./server/app.js;
}

function __createRouterFile(){
  INDEX="var express = require('express');
  var router = express.Router();
  router.get(\"/*\", function(req, res) {
    var file = req.params[0] || \"assets/views/index.html\";
    res.sendFile(path.join(__dirname, \"../public/\", file));
  });

  module.exports = router;";
  echo "$INDEX" > ./server/modules/index.js;
}

function __createIndexFile(){
  INDEX="<!DOCTYPE html>
  <html ng-app=\"myApp\">

    <head>
      <meta charset=\"utf-8\">
      <title>Parent Journal</title>

      <!-- STYLES -->
         <link rel=\"stylesheet\" href=\"/assets/vendors/angular-material/angular-material.min.css\">
         <!-- SCRIPTS -->

         <script type=\"text/javascript\" src=\"/assets/vendors/angular/angular.min.js\"></script>
         <script type=\"text/javascript\" src=\"/assets/vendors/angular-animate/angular-animate.min.js\"></script>
         <script type=\"text/javascript\" src=\"/assets/vendors/angular-messages/angular-messages.min.js\"></script>
         <script type=\"text/javascript\" src=\"/assets/vendors/angular-aria/angular-aria.min.js\"></script>
         <script type=\"text/javascript\" src=\"/assets/vendors/angular-material/angular-material.min.js\"></script>
         <script type=\"text/javascript\" src=\"/assets/vendors/angular-route/angular-route.min.js\"></script>

      <!-- MYSCRIPTS -->
      <script type=\"text/javascript\" src=\"/assets/scripts/app.js\"></script>

      <link rel=\"stylesheet\" type=\"text/css\" href=\"/assets/styles/stylesheet.css\" />

    </head>


    <body class=\"md-primary\" style=\"background: rgb(66,66,66);\" ng-cloak>
        <main ng-view ng-cloak ></main>
    </body>
  </html>";

  echo "$INDEX" > ./client/views/index.html;
}

function __createClientApp(){
  APP="var myApp = angular.module(\"myApp\", ['ngMaterial', 'ngRoute']);
  myApp.factory(\"MyService\", [\"\$http\",'\$window','\$filter', function(\$http, \$window, \$filter){
    return {

    };
  }]);

  myApp.controller(\"MyController\", [\"\$scope\", \"\$timeout\", \"\$mdSidenav\", \"\$log\", function(\$scope, \$timeout, \$mdSidenav, \$log) {

  }]);
  ";

  echo "$APP" > ./client/scripts/app.js;
}

