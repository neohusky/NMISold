/**
 * Created by nucmed on 4/11/2015.
 */
var chokidar = require('chokidar')
    ,nconf = require('nconf')
    ,fs = require("fs")
    ,async = require("async")
    ,exec = require('child_process').exec;

var request = require('request');
var ipp = require('ipp');
var path = require('path');
var appDir = path.dirname(require.main.filename);


exports.Start = function () {
// One-liner for current directory, ignores .dotfiles
    var watcher = chokidar.watch('print', {
        ignored: /[\/\\]\./,
        ignoreInitial: false,
        persistent: true
    });

    /*
     .on('all', function(event, path) {
     console.log(event, path);
     });*/


    //var log = console.log.bind(console);

    watcher.on('add', function (path) {
        console.log('File', path, 'has been added');
        //deletefile(path, printfile(path));
        PrintDelete(path);
    });
};

function lpr(file) {
    var cmd;
    CupsPrinterName = nconf.get('Print:PrinterName');
    cmd = 'lpr -P ' + CupsPrinterName + ' -o raw ' + file;
    exec(cmd, function(error, stdout, stderr) {
        // command output is in stdout
    });
    console.log("file printed")
    callback();
}


function DeleteFile(name){
    fs.unlink(name, function (err) {
        console.log('   deleting ' + name);
    });

};


function PrintDelete(file){
    async.series([
        //Load user to get userId first
        function(callback) {
            var cmd;
            CupsPrinterName = nconf.get('Print:PrinterName');
            cmd = 'lpr -P ' + CupsPrinterName + ' -o raw ' + file;
            exec(cmd, function(error, stdout, stderr) {
                // command output is in stdout
                callback();
            });
            console.log("file printed")

        },
        //won't be called before task 1's "task callback" has been called)
        function(callback) {
            fs.unlink(file, function (err) {
                console.log('   deleting ' + file);
                callback();
            });
        }
    ])
}