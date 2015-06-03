var serialport = require('serialport'),// include the library
    SerialPort = serialport.SerialPort, // make a local instance of it
// get port name from the command line:
    portName = process.argv[2];            // get port name from the command line
//portName = "/dev/ttyUSB0";            // get port name from the command line

var myPort = new SerialPort(portName, {
    baudrate: 4800,
    dataBits: 8,
    parity: 'none',
    stopBits: 1,
    flowControl: false,
    // look for return and newline at the end of each data packet:
    parser: serialport.parsers.readline("\r\n")
});

myPort.on('open', showPortOpen);
myPort.on('data', saveLatestData);
myPort.on('close', showPortClose);
myPort.on('error', showError);

function showPortOpen() {
    console.log('port open. Data rate: ' + myPort.options.baudRate);
}

function saveLatestData(data) {
    console.log(data);
}

function showPortClose() {
    console.log('port closed.');
}

function showError(error) {
    console.log('Serial port error: ' + error);
}