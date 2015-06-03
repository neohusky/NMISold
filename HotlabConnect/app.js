var express = require('express')
    , cors = require('cors')
    , app = express()
    , serialport = require('serialport')
    , keypress = require('keypress');


///Serial Port Params
portName = "/dev/ttyUSB0";            // get port name from the command line
baud = 4800;
//////////////////

var CalIsotope,CalUnits,CalActivity,serialData,ScannedBarcode,LastBarCode,StatusString;

//////Set up web server
app.use(cors());

app.get('/', function(req, res, next){

    //serialData ='~1 Tc-99m 35.1 1.293 GBq';
    //LastBarCode ='E2841 /n';

/*    var data = '{"data":[' +
        '{"CalibratorData":"'+serialData+'" , ' +
        '"BarcodeData":"'+ LastBarCode +'"}]}';*/
    //res.json({msg: 'This is CORS-enabled for all origins!'});
   StatusString = "OK";
    res.json({Status:StatusString,CalibratorData:serialData,BarcodeData:LastBarCode});
    //Erase LastBarcode when value has been retrieved
    //LastBarCode = ""
});

// accept get request at /user
app.get('/test', function (req, res) {
    res.send('Got a get request at /test');
});

app.listen(8080, function(){
    console.log('CORS-enabled web server listening on port 8181');
});


/////////////////////////////

/////////////////Set up Serial Port Functions
SerialPort = serialport.SerialPort;    // make a local instance of it
var myPort = new SerialPort(portName, {
    baudRate: baud,
    // look for return and newline at the end of each data packet:
    parser: serialport.parsers.readline('\n')
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
    StatusString = "OK";
}

function showPortClose() {
    console.log('port closed.');
    StatusString = "Comm Closed";
}

function showError(error) {
    console.log('Serial port error: ' + error);
    StatusString = "Comm Error";
}
///////////////////////////////////////////////


// make `process.stdin` begin emitting "keypress" events
keypress(process.stdin);
// listen for the "keypress" event
process.stdin.on('keypress', function (ch, key) {
    //console.log('got "keypress"', ch); //original script

    ScannedBarcode = ScannedBarcode + ch;


    /*
     if (key.ctrl && key.name == 'c') {
     process.stdin.pause();
     }
     */
    if (key && key.name == 'enter') {

        ScannedBarcode = ScannedBarcode; //Add +"/n" if CR is required
        console.log("Barcode:"+ScannedBarcode);
        LastBarCode = ScannedBarcode;
        ScannedBarcode ="";
    }
});
//process.stdin.setRawMode(true); //Use this to output one letter at a time
process.stdin.resume();


/*



Isotopestring = Left(inputstring, 9);
Isotopestring = Right(Isotopestring, 6); //removes the tilde
Isotopestring = Trim(Isotopestring); //removes the blanks


//////////////////////////Check units are SI
Unitstring = Right(inputstring, 3)
Unitstring = Trim(Unitstring)
If Unitstring = "GBq" Or Unitstring = "MBq" Then
// do nothing as this is the correct string/units
Else
MsgBox "The calibrator is not set to SI units.  Please correct and retry.", vbCritical, "Error- non-SI units."
Exit Function
End If


'Get the activity
Activitystring = Right(inputstring, 11)
Activitystring = Left(Activitystring, 7) 'removes units
Activitystring = Trim(Activitystring)  'removes blanks

'check activity measured is not negative
If Left(Activitystring, 1) = "-" Then
MsgBox "The calibrator reading is negative.  Please check the calibrator and retry, or seek assistance.", vbCritical, "Error- negative units."
Exit Function
End If

'change activity string to single data type for maths.

'Convertedactivitystring = CSng(Activitystring)
Convertedactivitystring = CDbl(Activitystring) 'Changed to doble to allow for decimal value


' Check units and if GBq then multiply by 1000. Need to round the integer for decimal point after any multiplication.
If Unitstring = "GBq" Then
Convertedactivitystring = Convertedactivitystring * 1000
End If
' Don't want to strip Decimal 'strip decimal points

'Convertedactivitystring = Int(Convertedactivitystring) 'debug note- this may have to be a double not a single.



*/
