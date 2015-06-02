/**
 * Created by nucmed on 12/05/15.
 */
var serialport = require("serialport");
var SerialPort = serialport.SerialPort;

// list serial ports:
serialport.list(function (err, ports) {
    ports.forEach(function(port) {
        console.log(port.comName);
    });
});