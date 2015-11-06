var express = require('express')
    , bodyParser = require('body-parser')
    , cors = require('cors')
    , app = express()
    , path = require('path')
    //, cookieParser = require('cookie-parser')
    //, session = require('express-session')
    , config = require('./scripts/config.js')
    , nconf = require('nconf')
    , serial = require('./scripts/serial.js')
    , barcode = require('./scripts/barcode.js')
    , printServer = require('./scripts/printServer2.js')
    , routes = require('./routes/index');

    //, flash = require('connect-flash');

/*//Temporary
var keypress = require('keypress'); // include keypress library
var BarcodeData ="";                    // latest data saved from the keyboard
var LastBarCode =""; */                    //Last read barcode




function SetupWebServer() {
// view engine setup
    app.set('views', path.join(__dirname, 'views'));
    app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
//app.use(logger('dev'));
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({extended: false}));
    //app.use(cookieParser('keyboard cat'));
    app.use(express.static(path.join(__dirname, 'public')));
    //app.use(cookieParser('keyboard cat'));
    //app.use(session({ cookie: { maxAge: 60000 }}));
    app.use(cors());

    app.use('/', routes);

    //app.post('/upload', upload, function(req, res) {
    //    // check req.files for your files
    //});



    app.listen(nconf.get('WebPort'), function () {
        console.log('CORS-enabled web server listening on port ' + nconf.get('WebPort'));
    });

}

Startup(tartWeb);

function StartWeb() {

    SetupWebServer();
    barcode.StartBarcode();

    //Check if dose calibrator is set to none otherwise start comms
    if (nconf.get('DoseCal:Type')=='none'){
        console.log("There is no dose calibrator set up")
    }
    else{
        serial.StartSerialComms();
    }

    //Check if print server is enabled. If so start the service
    if (nconf.get('Print:Server')) {
        printServer.Start();
        console.log ("The Print service is enabled");
    }


}

function Startup (callback) {
    callback(config.loadConfig());


}

