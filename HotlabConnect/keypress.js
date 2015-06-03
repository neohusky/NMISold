
var keypress = require('keypress'); // include keypress library

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
