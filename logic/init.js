var hla = {};
var layout,maintoolbar,mainForm,mainDP,statusbar,grid;
var UserName = getUrlVars()["id"];
var StaffName = "";



function init() {
    //Set Application Layout
    hla.layout = new dhtmlXLayoutObject(document.body, '3L');
    hla.layout.cells("a").setText('Main');
    hla.layout.cells("a").hideHeader();

    hla.layout.cells("b").setText('Login');
    hla.layout.cells("b").setWidth('300');
    hla.layout.cells("b").fixSize(1,1);

    hla.layout.cells("c").setText('BarcodeType1');
    hla.layout.cells("c").setHeight('300');
    hla.layout.cells("c").setWidth('300');

    statusbar = hla.toolbar = hla.layout.attachStatusBar();
    statusbar.setText("Welcome " + " " + UserName);



    maintoolbar = hla.layout.attachToolbar();
    //hla.toolbar.setIconPath("codebase/imgs/");
    //maintoolbar.loadStruct('data/tlbMain.xml');

    maintoolbar.loadStruct('data/tlbMain.xml',function(){
        maintoolbar.setItemText("user", UserName);
    });
    maintoolbar.attachEvent("onClick",hla.tlbMain_click);
    maintoolbar.setIconSize(48);


};




function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
        function(m,key,value) {
            vars[key] = value;
        });
    return vars;
}


hla.tlbMain_click = function(id) {
    switch(id) {

        case "btnPatients":
            hla.fOpenPatientsMenu();
            break;
        case "btnGenerators":
            hla.fOpenGeneratorMenu();
            break;
        case "btnEluates":
            hla.StaffLogin();
            break;
        case "btnKits":
            hla.OpenGenerators();
            break;
        case "btnDoses":
            hla.OpenGenerators();
            break;
        case "btnOrdering":
            hla.OpenGenerators();
            break;
        case "btnAdministration":
            fStaffName();
            //hla.Staff();
            break;
        case "btnSettings":
            hla.OpenSettingsMenu();
            break;
        case "btnDaySheet":
            hla.OpenDaySheetMenu();
            break;
        case "btnLogout":
            hla.Logout();
            break;
    }
};


hla.Profile = function(){


    var myPop;
    var myForm;
    var formData;

    formData = [
        {type: "settings", position: "label-left", labelWidth: 110, inputWidth: 130},
        {type: "input", label: "Email Address", name: "email"},
        {type: "password", label: "Password", name: "pwd"},
        {type: "combo", label: "Role", options: [
            {text: "Administrator"},
            {text: "Power User", selected: true},
            {text: "Guest"}
        ]},
        {type: "checkbox", label: "Remember me", checked: 1},
        {type: "button", value: "Proceed", offsetLeft: 149}
    ];
    myPop = new dhtmlXPopup({ toolbar: maintoolbar, id: "btnLogout" });
    myPop.attachEvent("onShow", function(){
        if (myForm == null) {
            myForm = myPop.attachForm(formData);
            myForm.attachEvent("onButtonClick", function(){
                myPop.hide();
            });
        }
        myForm.setFocusOnFirstActive();
    });
};



hla.Logout = function() {


    window.location.href = "./logic/logout.php";
};


hla.tlbGenerators_click = function(id) {
    switch(id) {

        case "btnGeneratorNew":
            hla.fGeneratorsAddNew();
            break;
        case "btnGeneratorDecomission":
            openWin();
            break;
    }
};

hla.tlbDaysheet_click = function(id) {
    switch(id) {
        case "btnPDF":
            hla.grid.toPDF('codebase/grid-pdf-php/generate.php','grey');
            break;
    }

};

hla.fDaysheetPDF = function() {


};



hla.fOpenPatientsMenu = function() {


    hla.grid =  hla.layout.cells("a").attachGrid();

    hla.grid.setHeader("PatientName, PatientID, PatientDOB, PatientSex, RequestedProcedureDescription");
    hla.grid.setColTypes("ed,ed,ed,ed,ed");
    hla.grid.setColSorting('str,str,str,str,str');
    hla.grid.setInitWidths('*,*,*,*,*');
    hla.grid.load("data/dwl.php");
    hla.grid.init();


};

hla.fOpenGeneratorMenu = function() {
    toolbar = hla.layout.cells("a").detachToolbar();
    toolbar = hla.layout.cells("a").attachToolbar();
    toolbar.loadStruct('data/tlbGenerators.xml');
    toolbar.attachEvent("onClick",hla.tlbGenerators_click);

    grid = hla.layout.cells("a").attachGrid();

    grid.setImagePath("codebase/imgs/");
    grid.setHeader("id, BatchNo, Supplier, ArrivalDate");
    grid.setColTypes("ed,ed,ed,ed");
    grid.setColSorting('str,str,str,str');
    grid.setInitWidths('*,*,*,*');
    grid.load("data/gridGenerators.php");
    grid.init();




};

hla.Generators = function() {


    hla.windows = new dhtmlXWindows();
    hla.windows.setSkin('dhx_web');


    hla.windowGenerator = hla.windows.createWindow('Generators', 200, 200, 620, 450);
    hla.windowGenerator.setText("Generators");
    hla.windowGeneratorGrid = hla.windowGenerator.attachGrid();

    hla.windowGeneratorGrid.setImagePath("codebase/imgs/");
    hla.windowGeneratorGrid.setHeader("id, BatchNo, Supplier, ArrivalDate");
    hla.windowGeneratorGrid.setColTypes("ed,ed,ed,ed");
    hla.windowGeneratorGrid.setColSorting('str,str,str,str');
    hla.windowGeneratorGrid.setInitWidths('*,*,*,*');
    hla.windowGeneratorGrid.load("data/gridGenerators.php");
    hla.windowGeneratorGrid.init();

    hla.windows.show();
    hla.windows.setModal(true);
    hla.windows.print()
};


hla.StaffLogin = function(){
    mainForm = hla.layout.cells("a").attachForm();
    mainForm.loadStruct("data/frmStaffLogin.xml");
    mainForm.load("data/gridStaff.php?id=2");
};



hla.Staff = function() {


    grid = hla.layout.cells("a").attachGrid();

    grid.setImagePath("codebase/imgs/");
    grid.setHeader("Staff ID,StaffName,UserName, Classification, Currently employed");
    grid.setColTypes("ro,ro,ro,ro,ch");
    grid.setColSorting('str,str,str,str,ch');
    grid.setInitWidths('*,*,*,*,*');
    //"data/gridStaff.php?connector=true&dhx_filter[2]=" + UserName
    //"data/gridStaff.php"

    grid.load("data/gridStaff.php?connector=true&dhx_filter[2]=" + UserName,function() {
        grid.selectRow(0);
        grid.setCellTextStyle(UserName, 1, "background-color:#ff0000;");
        StaffName = grid.cells(UserName,1).getValue();
        statusbar.setText(StaffName);
        //grid.forEachRow(function(id,ind) {

        //})
        });



    grid.attachEvent("onRowDblClicked",doOnRowDblClicked);
    grid.init();




};

function doOnRowDblClicked(rowId){
    //protocolIt("Rows with id: "+id+" was selected by user")
    var searchResult=grid.findCell("theok",2,false);
    dhtmlx.message({

        //text: searchResult,
        text: "User pressed Enter on row with id "+rowId+"Staff Name is "+StaffName,
        //text: "Rows with id: "+id+" was selected by " +StaffName,

        expire: 2000
    })
    statusbar.setText("Welcome " + " " + StaffName);
};


hla.fGeneratorsAddNew = function() {


    //console.log(getDateTime());
    mainForm = hla.layout.cells("a").attachForm();
    mainForm.loadStruct("data/frmGeneratorNew.xml",function() {

            //console.log(calArrivalDate.getDate());

        }
    );
    mainForm.setFontSize("20px");


    mainDP = new dataProcessor("data/frmGenerators.php");
    mainDP.init(mainForm);

    mainForm.attachEvent("onButtonClick", function(id){
        if (id == "save") {
            //console.log(calArrivalDate.getDate());
            mainForm.save();



            //hla.layout.cells("a").detachObject(true);
            //mainForm = null;
            }
    })
};

hla.ViewSettings = function() {

    hla.windows = new dhtmlXWindows();
    hla.windows.setSkin('dhx_web');


    hla.windowSettings = hla.windows.createWindow('Settings', 200, 200, 620, 450);
    hla.windowSettings.setText("Settings");


    hla.windowSettingsForm = hla.windowSettings.attachForm();
    hla.windowSettingsForm.loadStruct("data/frmSettings.xml");
    hla.windowSettingsForm.load("data/frmSettings.php?id=1");

};

hla.OpenSettings = function() {


    dhxWins = new dhtmlXWindows();

    w1 = dhxWins.createWindow("w1", 20, 30, 400, 280);
    w1.setText("Settings");

    //
    myTabbar = w1.attachTabbar({
        tabs: [
            {id: "a1", label: "Tab 1", active: true},
            {id: "a2", label: "Tab 2"},
            {id: "a3", label: "Tab 3"}
        ]
    });

    myForm = myTabbar.cells("a1").attachForm();
    myForm.loadStruct("data/frmSettings.xml", function(){
    myTabbar.cells("a2").attachObject("tab2");
    myTabbar.cells("a3").attachObject("tab3");
    });
    myForm.load("data/frmSettings.php?id=1");
};

hla.OpenSettingsMenu = function() {
    toolbar = hla.layout.cells("a").detachToolbar();

    hla.myTabbar = hla.layout.cells("a").attachTabbar({
        tabs: [
            {id: "a1", label: "Tab 1", active: true},
            {id: "a2", label: "Tab 2"},
            {id: "a3", label: "Tab 3"}
        ]
    });

    myForm = hla.myTabbar.cells("a1").attachForm();
    myForm.loadStruct("data/frmSettings.xml", function(){
        hla.myTabbar.cells("a2").attachObject("tab2");
        hla.myTabbar.cells("a3").attachObject("tab3");
    });
    myForm.load("data/frmSettings.php?id=1");

    myForm.setFontSize("20px");
};

hla.OpenDaySheetMenu = function() {

    toolbar = hla.layout.cells("a").attachToolbar();
    toolbar.loadStruct('data/tlbDaySheet.xml');
    toolbar.attachEvent("onClick",hla.tlbDaysheet_click);


    hla.grid =  hla.layout.cells("a").attachGrid();

    //mygrid.setImagePath("./codebase/imgs/");          //the path to images required by grid
    hla.grid.setHeader("<div style='font-weight: bold; text-align:center;'>DaySheet</div>,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan");
    hla.grid.attachHeader("Patient Name,MRN,DOB,Ward,APPT_TYPE,APPTBEGIN,RESOURCE");//the headers of columns
    //myGrid.setInitWidths("100,250,150,100,100,100,100,100,100");          //the widths of columns
    hla.grid.setColAlign("left,left,left,left,left,left,left,left,left");       //the alignment of columns
    hla.grid.setColTypes("ro,ro,ro,ed,ro,ro,ro,ro,ro,ro,ro,ro,ro");                //the types of columns
    //mygrid.setColSorting("int,str,str,int");          //the sorting types
    hla.grid.load("data/DaySheet.php");
    hla.grid.init();      //finishes initialization and renders the grid on the page


};
getDateTime = function() {
    var now     = new Date();
    var year    = now.getFullYear();
    var month   = now.getMonth()+1;
    var day     = now.getDate();
    var hour    = now.getHours();
    var minute  = now.getMinutes();
    var second  = now.getSeconds();
    if(month.toString().length == 1) {
        var month = '0'+month;
    }
    if(day.toString().length == 1) {
        var day = '0'+day;
    }
    if(hour.toString().length == 1) {
        var hour = '0'+hour;
    }
    if(minute.toString().length == 1) {
        var minute = '0'+minute;
    }
    if(second.toString().length == 1) {
        var second = '0'+second;
    }
    var dateTime = year+'-'+month+'-'+day+' '+hour+':'+minute+':'+second;
    return dateTime;
};

function openWin()
{
    myWindow=window.open('','','width=200,height=100');
    myWindow.document.write("<p>This is 'myWindow'</p>");


    myWindow.document.close(); //missing code


    myWindow.focus();
    myWindow.print();
}

hla.fTestForm = function() {

    //varDivForm = $(div.dhxform_obj_dhx_web);

    //console.log(getDateTime());
    mainForm = hla.layout.cells("a").attachForm();
    mainForm.loadStruct("data/frmGeneratorNew.xml",function() {
        });
    mainForm.setFontSize("20px");


    mainDP = new dataProcessor("data/frmGenerators.php");
    mainDP.init(mainForm);


    mainForm.attachEvent("onButtonClick", function(id){
        if (id == "save") {
            console.log("option", id );
            dhtmlx.message({
                type:"confirm-warning",
                text:"The SAVE button was pressed."
            });
        }
    });
    mainForm.attachEvent("onClick",doOnClick);


};
function msgbox(Text) {
    dhtmlx.alert(Text);
    console.log("Message Box " + Text);
};
function protocolIt(str){
    var p = document.getElementById("protocol")
    p.innerHTML = "<li style='height:auto;'>"+str+"</li>" + p.innerHTML
}
function doOnClick(rowId,cellInd,state){
    protocolIt("User clicked on checkbox or radiobutton on row "+rowId+" and cell with index "+cellInd+".State changed to "+state);
    return true;
}
hla.fTest = function() {



    mainForm = hla.layout.cells("a").attachForm();
    mainForm.loadStruct("data/frmGeneratorNew.xml");
    mainForm.setFontSize("20px");

    mainDP = new dataProcessor("data/generators.php");
    mainDP.init(mainForm);

    mainForm.attachEvent("onButtonClick", function(id) {


        if (id == "save") {
            mainForm.save();
            hla.layout.cells("a").detachObject(true);
            mainForm = null;
        }
    });
    mainForm.attachEvent("onFocus", function(name, value){
        if (name == "BatchNo") {
            var opts = mainForm.getInput("BatchNo");
            //var id = mainForm._getHandle();
           /* dhtmlx.message({
                type: "confirm-warning",
                text: opts
            });*/

            var availableTags = ["ActionScript", "AppleScript", "Asp", "BASIC", "C", "C++", "Clojure",
                "COBOL", "ColdFusion", "Erlang", "Fortran", "Groovy", "Haskell", "Java", "JavaScript",
                "Lisp", "Perl", "PHP", "Python", "Ruby", "Scala", "Scheme"];

            $( document ).ready(function() {
                console.log( 'ready!'+ opts );
                //$('.dhxform_textarea:eq(0)')
                $('input[name=BatchNo]')
                    .keyboard({ layout: 'qwerty',
                        position     : {
                            of : $(window),//null, // optional - null (attach to input/textarea) or a jQuery object (attach elsewhere)
                            my : 'center top',
                            at : 'center top',
                            at2: 'left bottom' // used when "usePreview" is false (centers keyboard at bottom of the input/textarea)
                        },
                        reposition   : true,
                        usePreview   : false })
                    .autocomplete({
                        source: availableTags
                    })
                    .addAutocomplete()
                    .addTyping();


            });



        }


    });


};