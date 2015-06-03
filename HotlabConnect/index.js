/*

Simple Serial Server
using servi.js and p5.js

To call this type the following on the command line:
node index.js portName

where portname is the name of your serial port, e.g. /dev/tty.usbserial-xxxx (on OSX)

created 19 Sept 2014
modified 17 Mar 2015
by Tom Igoe

*/

var serialport = require('serialport');// include the library
var keypress = require('keypress'); // include keypress library

SerialPort = serialport.SerialPort,    // make a local instance of it
portName = process.argv[2];            // get port name from the command line
//portName = "/dev/ttyUSB0";            // get port name from the command line



var serialData = "";                    // latest data saved from the serial port
var BarcodeData ="";                    // latest data saved from the keyboard
var LastBarCode ="";                     //Last read barcode
var servi = require('servi');          // include the servi library


var app = new servi(false);            // servi instance
app.port(8080);                        // port number to run the server on

// configure the server's behavior:
app.serveFiles("public");              // serve all static HTML files from /public
app.serveFiles("PDFToPrint");     // serve static HTML from PDFToPrint folder


app.route('/data', sendData);          // route requests for /data to sendData() function
route('/', form); // route requests for / to form()
route('/upload', upload);// route requests for /upload to upload()
// now that everything is configured, start the server:


// now that everything is configured, start the server:
app.start();

var myPort = new SerialPort(portName, {
  baudRate: 4800,
  databits: 8,
  stopbits: 1,
  parity: 'none',
  
  // look for return and newline at the end of each data packet:
  parser: serialport.parsers.readline('\r\n')
});

// these are the definitions for the serial events:
myPort.on('open', showPortOpen);
myPort.on('data', saveLatestData);
myPort.on('close', showPortClose);
myPort.on('error', showError);

// these are the functions called when the serial events occur:
function showPortOpen() {
  console.log('port open. Data rate: ' + myPort.options.baudRate);
}

function saveLatestData(data) {
  console.log("Serial Data:"+data);
  serialData = data;
}

function showPortClose() {
  console.log('port closed.');
}

function showError(error) {
  console.log('Serial port error: ' + error);
}

// ------------------------ Server function
function sendData(request) {
  // print out the fact that a client HTTP request came in to the server:
  console.log("Got a client request, sending them the data.");
  // respond to the client request with the latest serial string:

//serialData ="~1 Tc-99m 35.1 1.293 GBq";
//LastBarCode ="E2841 /n";

  var data = '{"data":[' +
      '{"CalibratorData":"'+serialData+'" , ' +
      '"BarcodeData":"'+ LastBarCode +'"}]}';


  request.respond(data);
}

function form(request){
    request.serveFile('form.html');
}

function upload(request) {
    var file = request.files.file;
    uploadFile(file, "PDFToPrint");
    request.respond('<div> Done </div>');
}

//-----------------------Server functions

// make `process.stdin` begin emitting "keypress" events
keypress(process.stdin);
// listen for the "keypress" event
process.stdin.on('keypress', function (ch, key) {
    //console.log('got "keypress"', ch); //original script

    BarcodeData = BarcodeData + ch;


    /*
     if (key.ctrl && key.name == 'c') {
     process.stdin.pause();
     }
     */
    if (key && key.name == 'enter') {
        BarcodeData = BarcodeData +"/n";
        console.log("Barcode:"+BarcodeData);
        LastBarCode = BarcodeData;
        BarcodeData ="";
    }
});
//process.stdin.setRawMode(true); //Use this to output one letter at a time
process.stdin.resume();
