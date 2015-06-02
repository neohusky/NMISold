var express = require('express')
    , cors = require('cors')
    , app = express();

app.use(cors());

app.get('/', function(req, res, next){

    serialData ='~1 Tc-99m 35.1 1.293 GBq';
    LastBarCode ='E2841 /n';

    var data = '{"data":[' +
        '{"CalibratorData":"'+serialData+'" , ' +
        '"BarcodeData":"'+ LastBarCode +'"}]}';
    //res.json({msg: 'This is CORS-enabled for all origins!'});
        res.json({CalibratorData:serialData,BarcodeData:LastBarCode});

});

app.listen(8181, function(){
    console.log('CORS-enabled web server listening on 192.168.0.110 port 8181');
});