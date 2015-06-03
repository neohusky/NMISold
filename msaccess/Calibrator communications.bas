Attribute VB_Name = "Calibrator communications"
Option Compare Database
Option Explicit
'Theo Add
Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Function Formsetup_for_calibrator_reading_option2(Calibrator_reading_destination As Control, Fetchreading_button As Control, Extralabel As Boolean, Optional Label As Control)
' Note this is only called from "HL dispense radiopharmaceutical 3" form. All other forms call Public Function Formsetup_for_calibrator_reading_option(....)
'This function is used to determine which buttons to show on form
'determined by the the automatic calibrator interface option setting

Dim Calibrator_option As String

'check study type to see if it requires bypass of the auto calibrator interface. This value is set for each study in the study type form on the administration switchboard.
 'bug corrected here where on the reconstruct kit form there was an eluate scan after the kit scan and therefore the strippedbarcode applied to the eluate not the kit and a null error was generated
Dim strStudyType As String, kitID As Long

strStudyType = Forms![HL dispense radiopharmaceutical 3]![Study type]
    
'check options table for the appropriate options
Dim dbx As Database, rst As Recordset
Set dbx = CurrentDb()
Set rst = dbx.OpenRecordset("Options", dbOpenDynaset)

        rst.MoveFirst
        Calibrator_option = rst.[Automatic Calibrator Interface]
        
rst.Close
dbx.Close

        If Calibrator_option = "None" Then
            GoTo NoAutointerface
        End If

'Now check study type to see whether it bypasses automatic calibrator interface
Dim dbx2 As Database, rst2 As Recordset
Set dbx2 = CurrentDb()
Set rst2 = dbx2.OpenRecordset("Hotlab Study Types", dbOpenDynaset)
Dim strCriteria As String, strManual As String
    
    strCriteria = "[Study Type] = '" & strStudyType & "'"
    rst2.FindFirst strCriteria
    strManual = rst2![Manual activity recording]

rst2.Close
dbx2.Close

    If strManual = True Then
        GoTo NoAutointerface
    Else
        Calibrator_reading_destination.Visible = False
        Fetchreading_button.Visible = True
            If Extralabel = True Then
                Label.Visible = False
            End If
            Exit Function
    End If
            
NoAutointerface:
        Calibrator_reading_destination.Visible = True
        Fetchreading_button.Visible = False
            If Extralabel = True Then
                Label.Visible = True
            End If
            
End Function


Public Function Getcalibratorreading(Calibrator_reading_destination As Control, Extralabel As Boolean, Optional Label As Control, Optional RPID_control As Control, Optional Isotope As String)
On Error GoTo Err_Getcalibratorreading

'this function looks up the options table to get the current selected option for the calibrator (ie manual or automatic)
'if automatic it launches the appropriate Function for the calibrator disclosed in the option

Dim Calibrator_option As String
Dim dbx As Database, rst As Recordset
Set dbx = CurrentDb()
Set rst = dbx.OpenRecordset("Options", dbOpenDynaset)

    rst.MoveFirst
        Calibrator_option = rst.[Automatic Calibrator Interface]
        
rst.Close
dbx.Close

Select Case Calibrator_option
    Case "Biodex Atomlab 200"
        Calibrator_reading_destination = Atomlab200_Read(RPID_control, Isotope)   'Calibratorreading = Atomlab200_Read(Frm, Ctrl, Iso)     'debug note- may hang here because of optional arguments
                                                    'these arguments are passed from this functions input arguments
    Case "Biodex Atomlab 100"
        Calibrator_reading_destination = Atomlab100_Read(RPID_control, Isotope)   'Calibratorreading = Atomlab200_Read(Frm, Ctrl, Iso)     'debug note- may hang here because of optional arguments
                                                    'these arguments are passed from this functions input arguments
    Case "Capintec CRC25R"
'        Calibrator_reading_destination = CapintecCRC25R_Read(RPID_control, Isotope)   'Calibratorreading = Atomlab200_Read(Frm, Ctrl, Iso)     'debug note- may hang here because of optional arguments
'                                                    'these arguments are passed from this functions input arguments
'
    End Select
    
    If Calibrator_reading_destination > 1 Then
        Calibrator_reading_destination.Visible = True
        If Extralabel = True Then
            Label.Visible = True
        End If
    End If
    
Exit_Getcalibratorreading:
    Exit Function

Err_Getcalibratorreading:
    MsgBox Error$
    Resume Exit_Getcalibratorreading

End Function
Public Function Atomlab200_Read(Optional RPID_control As Control, Optional Isotope As String)
'The input arguments give the option of either specifying the Isotope manually - which case the full isotope designation
'should be used (eg "technetium-99m") or specifying the control that has the Radiopharmaceutical ID on the original form
'in which case the code will look up the isotope itself.
'NOTE have to test for presence of optional Isotope first as if it is present a dummy value will be entered for the
'optional RPID_control and should be ignored.  This is because calling a function straight from a form bombs out if there
'are two commas such ", ," with nothing in between.

'************************************************************************************
'This code is being debugged. The original has been copied to same module in backup.
'*************************************************************************************

'This code is called to return dose calibrator readings from the Biodex Atomlab 200.
'Isotope is used to set the correct calibrator isotope button and then verify the string read has the correct isotope
'Isotope should be in the form of the standard abbreviation, eg "Mo-99".
Dim Counter As Integer
    Counter = 0
Dim Outputstring As String, Checkstring As String, Isotopestring As String, Activitystring As String
Dim Unitstring As String, inputstring As String
Dim Convertedactivitystring As Single 'this is used to store the converted Activitystring (which is a string) when it is converted to a single precision number for math manipulation (units correction for GBq to MBq).

    If Isotope = "" Or Isotope = "x" Then
        Dim db As Database
        Dim qd As QueryDef
        Dim RS As Recordset
        Set db = CurrentDb()
        Set qd = db.QueryDefs("Find reconstituting isotope (Calibrator comms module) Q")    'where xxx is a paramater query
        qd![RPID] = RPID_control      'where [ppp] is a paramater defined in the query
                            'and yyy is the paramater value to set in code (may be variable)(not in quotes).
        Set RS = qd.OpenRecordset()
            RS.MoveFirst
                Isotope = RS![Reconstituting isotope]
        RS.Close
        qd.Close
        db.Close
    End If

Select Case Isotope
    Case "Technetium-99m"
        Outputstring = "A"
        Isotope = "Tc-99m"
    Case "Molybdenum-99"
    '    Exit Function ' there shouldn't be anything dispensed with moly 99!
        Outputstring = "B"
        Isotope = "Mo-99"
    Case "Thallium-201"
        Outputstring = "C"
        Isotope = "Tl-201"
    Case "Iodine-123"
        Outputstring = "D"
        Isotope = "I-123"
    Case "Xenon-133"
        Outputstring = "E"
        Isotope = "Xe-133"
    Case "Gallium-67"
        Outputstring = "F"
        Isotope = "Ga-67"
    Case "Indium-111"
        Outputstring = "G"
        Isotope = "In-111"
    Case "Iodine-131"
        Outputstring = "H"
        Isotope = "I-131"
    Case "Cesium-137"
        Outputstring = "I"
        Isotope = "Cs-137"
    Case "Cobalt-57"
        Outputstring = "J"
        Isotope = "Co-57"
    Case "Chromium-51"
        Outputstring = "K"
        Isotope = "#2"

    'Case "Caesium-137"
    '    Exit Function ' there shouldn't be anything dispensed with Cs-137!
    '    Outputstring = "I"
   ' Case "Co-57"
    '    Exit Function ' there shouldn't be anything dispensed with cobalt-57!
    '    Outputstring = "J"
    Case Else
        MsgBox "This dose calibrator does not support this isotope. Seek help.", vbCritical, "Warning."
        Exit Function
    End Select

'Sets the dose calibrator isotope setting to the correct isotope
Close #1
Open "COM1:4800,N8,1" For Output As #1
        Write #1, "3"
        Write #1, Outputstring
Close #1

If Isotope = "Mo-99" Then 'it takes 30 seconds for moly calbration
    MsgBox "Hotlab will now wait 35 seconds for the calibrator.", , "Hotlab."
    Dim PauseTime, start

    PauseTime = 35   ' Set duration.
    start = Timer   ' Set start time.
    Do While Timer < start + PauseTime
        DoEvents    ' Yield to other processes.
    Loop
    Beep 'signals the end of the loop
End If
    
Fetchreading:
    'Open "Testfile" For Input As #1
Close #1
'Theo Change
'Open "COM1:" For Input As #1
'    inputstring = Input(25, #1)
Open "COM1:4800,N8,1" For Input As #1 Len = 27
    inputstring = Input(27, #1)
    'Input #1, inputstring

    Debug.Print inputstring
Close #1

Checkstring = Left(inputstring, 1)
    'the initial character of the atomlab 200 string is the tilde.
    'If the string has been intercepted midway or there is an error it will try another 5 times to get a valid string.
    'If no valid string it will give an error message and exit.
    If Not Checkstring = "~" Then
        If Counter = 5 Then
            MsgBox "There is an error in the calibrator reading.  Please check the calibrator or seek assistance.  If no assistance is available change the Calibrator setting on the 'Options' form to 'None' as this will allow manual entry of the dose. The options form is on the 'Administration Switchboard' form.", vbCritical, "Error encountered in calibrator reading."
            Exit Function
        End If
        
        Counter = Counter + 1
        GoTo Fetchreading
    End If
        
'check isotope string to ensure it is the correct isotope on the calibrator's setting
Isotopestring = Left(inputstring, 9)
Isotopestring = Right(Isotopestring, 6) 'removes the tilde
Isotopestring = Trim(Isotopestring) 'removes the blanks
    If IsNull(Isotope) Then
        'Need to add code for case where isotope is looked up.  Perhpas "Isotope" could then be set manually after the seek operation at the start.  Then one set of code would handle all.
        
    ElseIf Not Isotopestring = Isotope Then
            MsgBox "There is an error in the isotope type.  Please check the calibrator, seek assistance or retry.", vbCritical, "Error in isotope type."
            Exit Function
    End If
    
'Check units are SI
Unitstring = Right(inputstring, 3)
Unitstring = Trim(Unitstring)
    If Unitstring = "GBq" Or Unitstring = "MBq" Then
        '.....  do nothing as this is the correct string/units
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

Convertedactivitystring = CSng(Activitystring)

' Check units and if GBq then multiply by 1000. Need to round the integer for decimal point after any multiplication.
    If Unitstring = "GBq" Then
        Convertedactivitystring = Convertedactivitystring * 1000
    End If
'strip decimal points
Convertedactivitystring = Int(Convertedactivitystring) 'debug note- this may have to be a double not a single.

'Return value to function
Atomlab200_Read = Convertedactivitystring

'Reset calibrator to Technetium.
'Close #1
'Open "COM1:" For Output As #1
'Write #1, "A"
'Close #1

End Function


Public Function Atomlab100_Read(Optional RPID_control As Control, Optional Isotope As String)
'The input arguments give the option of either specifying the Isotope manually - which case the full isotope designation
'should be used (eg "technetium-99m") or specifying the control that has the Radiopharmaceutical ID on the original form
'in which case the code will look up the isotope itself.
'NOTE have to test for presence of optional Isotope first as if it is present a dummy value will be entered for the
'optional RPID_control and should be ignored.  This is because calling a function straight from a form bombs out if there
'are two commas such ", ," with nothing in between.

'************************************************************************************
'This code is being debugged. The original has been copied to same module in backup.
'*************************************************************************************

'This code is called to return dose calibrator readings from the Biodex Atomlab 200.
'Isotope is used to set the correct calibrator isotope button and then verify the string read has the correct isotope
'Isotope should be in the form of the standard abbreviation, eg "Mo-99".
Dim Counter As Integer
    Counter = 0
Dim Outputstring As String, Checkstring As String, Isotopestring As String, Activitystring As String
Dim Unitstring As String, inputstring As String
'Dim Convertedactivitystring As Single 'this is used to store the converted Activitystring (which is a string) when it is converted to a single precision number for math manipulation (units correction for GBq to MBq).
Dim Convertedactivitystring As Double 'this is used to store the converted Activitystring (which is a string) when it is converted to a single precision number for math manipulation (units correction for GBq to MBq).

    If Isotope = "" Or Isotope = "x" Then
        Dim db As Database
        Dim qd As QueryDef
        Dim RS As Recordset
        Set db = CurrentDb()
        Set qd = db.QueryDefs("Find reconstituting isotope (Calibrator comms module) Q")    'where xxx is a paramater query
        qd![RPID] = RPID_control      'where [ppp] is a paramater defined in the query
                            'and yyy is the paramater value to set in code (may be variable)(not in quotes).
        Set RS = qd.OpenRecordset()
            RS.MoveFirst
                Isotope = RS![Reconstituting isotope]
        RS.Close
        qd.Close
        db.Close
    End If

Select Case Isotope
    Case "Technetium-99m"
        Outputstring = "A"
        Isotope = "Tc-99m"
    Case "Molybdenum-99"
    '    Exit Function ' there shouldn't be anything dispensed with moly 99!
        Outputstring = "B"
        Isotope = "Mo-99"
    Case "Thallium-201"
        Outputstring = "C"
        Isotope = "Tl-201"
    Case "Iodine-123"
        Outputstring = "D"
        Isotope = "I-123"
    Case "Xenon-133"
        Outputstring = "E"
        Isotope = "Xe-133"
    Case "Gallium-67"
        Outputstring = "F"
        Isotope = "Ga-67"
    Case "Indium-111"
        Outputstring = "G"
        Isotope = "In-111"
    Case "Iodine-131"
        Outputstring = "H"
        Isotope = "I-131"
    Case "Chromium-51"
        Outputstring = "K"
        Isotope = "#2"
    'Case "Caesium-137"
    '    Exit Function ' there shouldn't be anything dispensed with Cs-137!
    '    Outputstring = "I"
   ' Case "Co-57"
    '    Exit Function ' there shouldn't be anything dispensed with cobalt-57!
    '    Outputstring = "J"
    Case Else
        MsgBox "This dose calibrator does not support this isotope. Seek help.", vbCritical, "Warning."
        Exit Function
    End Select

'Sets the dose calibrator isotope setting to the correct isotope
Close #1
Open "COM1:4800,N8,1" For Output As #1
        Write #1, "3"
        Write #1, Outputstring
Close #1

If Isotope = "Mo-99" Then 'it takes 30 seconds for moly calbration
    MsgBox "Hotlab will now wait 35 seconds for the calibrator.", , "Hotlab."
    Dim PauseTime, start

    PauseTime = 35   ' Set duration.
    start = Timer   ' Set start time.
    Do While Timer < start + PauseTime
        DoEvents    ' Yield to other processes.
    Loop
    Beep 'signals the end of the loop
End If
    
Fetchreading:
    'Open "Testfile" For Input As #1

'Theo Change

Open "COM1:4800,N8,1" For Input As #1 Len = 27
    inputstring = Input(27, #1)
    'Input #1, inputstring

    Debug.Print inputstring
Close #1

Checkstring = Left(inputstring, 1)
    'the initial character of the atomlab 200 string is the tilde.
    'If the string has been intercepted midway or there is an error it will try another 5 times to get a valid string.
    'If no valid string it will give an error message and exit.
    If Not Checkstring = "~" Then
        If Counter = 5 Then
            MsgBox "There is an error in the calibrator reading.  Please check the calibrator or seek assistance.  If no assistance is available change the Calibrator setting on the 'Options' form to 'None' as this will allow manual entry of the dose. The options form is on the 'Administration Switchboard' form.", vbCritical, "Error encountered in calibrator reading."
            Exit Function
        End If
        
        Counter = Counter + 1
        GoTo Fetchreading
    End If
        
'check isotope string to ensure it is the correct isotope on the calibrator's setting
Isotopestring = Left(inputstring, 9)
Isotopestring = Right(Isotopestring, 6) 'removes the tilde
Isotopestring = Trim(Isotopestring) 'removes the blanks
    If IsNull(Isotope) Then
        'Need to add code for case where isotope is looked up.  Perhpas "Isotope" could then be set manually after the seek operation at the start.  Then one set of code would handle all.
        
    ElseIf Not Isotopestring = Isotope Then
            MsgBox "There is an error in the isotope type.  Please check the calibrator, seek assistance or retry.", vbCritical, "Error in isotope type."
            Exit Function
    End If
    
'Check units are SI
Unitstring = Right(inputstring, 3)
Unitstring = Trim(Unitstring)
    If Unitstring = "GBq" Or Unitstring = "MBq" Then
        '.....  do nothing as this is the correct string/units
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


'Return value to function
Atomlab100_Read = Convertedactivitystring

'Reset calibrator to Technetium.
'Close #1
'Open "COM1:" For Output As #1
'Open "COM1:4800,N8,1" For ouptut As #1
'Write #1, "A"
'Close #1

End Function
Public Function CapintecCRC25R_Read(Optional RPID_control As Control, Optional Isotope As String)
'The input arguments give the option of either specifying the Isotope manually - which case the full isotope designation
'should be used (eg "technetium-99m") or specifying the control that has the Radiopharmaceutical ID on the original form
'in which case the code will look up the isotope itself.
'NOTE have to test for presence of optional Isotope first as if it is present a dummy value will be entered for the
'optional RPID_control and should be ignored.  This is because calling a function straight from a form bombs out if there
'are two commas such ", ," with nothing in between.

'************************************************************************************
'This code is being debugged. The original has been copied to same module in backup.
'*************************************************************************************

'This code is called to return dose calibrator readings from the Biodex Atomlab 200.
'Isotope is used to set the correct calibrator isotope button and then verify the string read has the correct isotope
'Isotope should be in the form of the standard abbreviation, eg "Mo-99".
Dim Counter As Integer
    Counter = 0
Dim Outputstring As String, Checkstring As String, Isotopestring As String, Activitystring As String
Dim Unitstring As String, inputstring As String
'Dim Convertedactivitystring As Single 'this is used to store the converted Activitystring (which is a string) when it is converted to a single precision number for math manipulation (units correction for GBq to MBq).
Dim Convertedactivitystring As Double 'this is used to store the converted Activitystring (which is a string) when it is converted to a single precision number for math manipulation (units correction for GBq to MBq).

    If Isotope = "" Or Isotope = "x" Then
        Dim db As Database
        Dim qd As QueryDef
        Dim RS As Recordset
        Set db = CurrentDb()
        Set qd = db.QueryDefs("Find reconstituting isotope (Calibrator comms module) Q")    'where xxx is a paramater query
        qd![RPID] = RPID_control      'where [ppp] is a paramater defined in the query
                            'and yyy is the paramater value to set in code (may be variable)(not in quotes).
        Set RS = qd.OpenRecordset()
            RS.MoveFirst
                Isotope = RS![Reconstituting isotope]
        RS.Close
        qd.Close
        db.Close
    End If

Select Case Isotope
    Case "Technetium-99m"
        Outputstring = "A"
        Isotope = "Tc-99m"
    Case "Molybdenum-99"
    '    Exit Function ' there shouldn't be anything dispensed with moly 99!
        Outputstring = "B"
        Isotope = "Mo-99"
    Case "Thallium-201"
        Outputstring = "C"
        Isotope = "Tl-201"
    Case "Iodine-123"
        Outputstring = "D"
        Isotope = "I-123"
    Case "Xenon-133"
        Outputstring = "E"
        Isotope = "Xe-133"
    Case "Gallium-67"
        Outputstring = "F"
        Isotope = "Ga-67"
    Case "Indium-111"
        Outputstring = "G"
        Isotope = "In-111"
    Case "Iodine-131"
        Outputstring = "H"
        Isotope = "I-131"
    Case "Chromium-51"
        Outputstring = "K"
        Isotope = "#2"
    'Case "Caesium-137"
    '    Exit Function ' there shouldn't be anything dispensed with Cs-137!
    '    Outputstring = "I"
   ' Case "Co-57"
    '    Exit Function ' there shouldn't be anything dispensed with cobalt-57!
    '    Outputstring = "J"
    Case Else
        MsgBox "This dose calibrator does not support this isotope. Seek help.", vbCritical, "Warning."
        Exit Function
    End Select

'Sets the dose calibrator isotope setting to the correct isotope
Close #1
Open "COM1:4800,N8,1" For Output As #1
        Write #1, "3"
        Write #1, Outputstring
Close #1

If Isotope = "Mo-99" Then 'it takes 30 seconds for moly calbration
    MsgBox "Hotlab will now wait 35 seconds for the calibrator.", , "Hotlab."
    Dim PauseTime, start

    PauseTime = 35   ' Set duration.
    start = Timer   ' Set start time.
    Do While Timer < start + PauseTime
        DoEvents    ' Yield to other processes.
    Loop
    Beep 'signals the end of the loop
End If
    
Fetchreading:
    'Open "Testfile" For Input As #1

'Theo Change

Open "COM1:4800,N8,1" For Input As #1 Len = 27
    inputstring = Input(27, #1)
    'Input #1, inputstring

    Debug.Print inputstring
Close #1

Checkstring = Left(inputstring, 1)
    'the initial character of the atomlab 200 string is the tilde.
    'If the string has been intercepted midway or there is an error it will try another 5 times to get a valid string.
    'If no valid string it will give an error message and exit.
    If Not Checkstring = "~" Then
        If Counter = 5 Then
            MsgBox "There is an error in the calibrator reading.  Please check the calibrator or seek assistance.  If no assistance is available change the Calibrator setting on the 'Options' form to 'None' as this will allow manual entry of the dose. The options form is on the 'Administration Switchboard' form.", vbCritical, "Error encountered in calibrator reading."
            Exit Function
        End If
        
        Counter = Counter + 1
        GoTo Fetchreading
    End If
        
'check isotope string to ensure it is the correct isotope on the calibrator's setting
Isotopestring = Left(inputstring, 9)
Isotopestring = Right(Isotopestring, 6) 'removes the tilde
Isotopestring = Trim(Isotopestring) 'removes the blanks
    If IsNull(Isotope) Then
        'Need to add code for case where isotope is looked up.  Perhpas "Isotope" could then be set manually after the seek operation at the start.  Then one set of code would handle all.
        
    ElseIf Not Isotopestring = Isotope Then
            MsgBox "There is an error in the isotope type.  Please check the calibrator, seek assistance or retry.", vbCritical, "Error in isotope type."
            Exit Function
    End If
    
'Check units are SI
Unitstring = Right(inputstring, 3)
Unitstring = Trim(Unitstring)
    If Unitstring = "GBq" Or Unitstring = "MBq" Then
        '.....  do nothing as this is the correct string/units
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


'Return value to function
Atomlab100_Read = Convertedactivitystring

'Reset calibrator to Technetium.
'Close #1
'Open "COM1:" For Output As #1
'Open "COM1:4800,N8,1" For ouptut As #1
'Write #1, "A"
'Close #1

End Function
Public Function Formsetup_for_calibrator_reading_option(Calibrator_reading_destination As Control, Fetchreading_button As Control, Extralabel As Boolean, Optional Label As Control)
'This function is used to determine which buttons to show on form
'determined by the the automatic calibrator interface option setting

Dim Calibrator_option As String
Dim Iodine_bypass_option As String

'check if isotope is I-131 - if so it is used to bypass the auto calibrator interface if this option is set.
'there was a bug here that was corrected, where on the reconstruct kit form there was an eluate scan after the kit scan and therefore the strippedbarcode applied to the eluate not the kit and a null error was generated
Dim abbrev As String, kitID As Long
    If prefix = "e" Then  'this stops the error generated because Callingform is an optional argument called from the Reconstitue Kit 2 on open property only. All other forms don't set this variable and so an error is generated trying to evaluate the next statement with an unassigned variable.
        
        If Calibrator_reading_destination.Name = "Actualactivity" Then
            abbrev = "irrelevant"  'it can't be iodine
        End If
    
    ElseIf prefix = "g" Then  'inserted to stop bug that stops the Else line below when a generator ID is scanned.
        abbrev = "generator"  'doesn't matter what it is called- only used for iodine trap below
    Else
       abbrev = DLookup("[Radiopharmaceutical]", "HL GetRPname Q", "[Radiopharmaceutical ID] = " & Strippedbarcode)
    End If

'check options table for the appropriate options
Dim dbx As Database, rst As Recordset
Set dbx = CurrentDb()
Set rst = dbx.OpenRecordset("Options", dbOpenDynaset)

    rst.MoveFirst
        Calibrator_option = rst.[Automatic Calibrator Interface]
        Iodine_bypass_option = rst.[Bypass auto calibrator interface for iodine-131]
        
rst.Close
dbx.Close

    If Calibrator_option = "None" Then
        GoTo NoAutointerface
    ElseIf Iodine_bypass_option = "True" And abbrev = "Iodine-131" Then
        GoTo NoAutointerface
    Else
        Calibrator_reading_destination.Visible = False
        Fetchreading_button.Visible = True
            If Extralabel = True Then
                Label.Visible = False
            End If
            Exit Function
    End If
            
NoAutointerface:
        Calibrator_reading_destination.Visible = True
        Fetchreading_button.Visible = False
            If Extralabel = True Then
                Label.Visible = True
            End If
End Function

Public Function fCapChecksum(strData As String)
Dim intLength As Integer
Dim i As Integer
 
Dim intChar As Integer
Dim intSum As Integer
 

intLength = Len(strData)
intChar = 0
For i = 1 To intLength
intChar = intChar + Asc(Mid(strData, i, 1))
Next
 

intChar = intChar - ((intChar \ 256) * 256)
If intChar > CDec(&H7E) Then
    intChar = intChar - CDec(&H7E)
ElseIf intChar < CDec(&H26) Then
    intChar = intChar + CDec(&H26)
End If
 

fCapChecksum = Chr(intChar)
End Function
 
Public Function fCapPacketSend(strData As String)
Dim strLen As String
Dim strLenData As String
 
strLen = Chr(CDec(&H41) + Len(strData))
strLenData = strLen & strData
fCapPacketSend = "$" & strLen & strData & fCapChecksum(strLenData) & "#"
 
End Function
Public Sub SendCapintec()

End Sub

Public Function fCapCheckPacket(strData As String)
Dim strStripedData As String
Dim strLength As String
Dim intLength As Integer
Dim strLenData As String
Dim strChecksum As String
Dim strPacketData As String
Dim strCommand As String
On Error GoTo Err_fCapCheckPacket

If Left(strData, 1) <> "$" Then
    GoTo Exit_fCapCheckPacketBad
ElseIf Right(strData, 1) <> "#" Then
    GoTo Exit_fCapCheckPacketBad
End If



strStripedData = Left(strData, InStr(strData, "#") - 1)
strStripedData = Right(strStripedData, InStr(strStripedData, "$") + (Len(strStripedData) - 2))

If strStripedData = "O" Then
    GoTo Exit_fCapCheckPacketGood
End If

If strStripedData = "e0" Or strStripedData = "e1" Or strStripedData = "e2" Or strStripedData = "e3" Or strStripedData = "e4" Or strStripedData = "e5" Then
    GoTo Exit_fCapCheckPacketError
End If

'Get Length
strLength = Left(strStripedData, 1)
intLength = Asc(strLength) - CDec(&H41)
'Get Checksum
strChecksum = Right(strStripedData, 1)
'Get packet Data
strPacketData = Left(strStripedData, intLength + 1)

If strChecksum <> fCapChecksum(strPacketData) Then
    GoTo Exit_fCapCheckPacketBad
End If
    
    GoTo Exit_fCapCheckPacketGood

Exit_fCapCheckPacketGood:
    fCapCheckPacket = "GOOD"
    Exit Function

'fCapCheckPacket = "GOOD"
'GoTo Exit_fCapCheckPacket

Exit_fCapCheckPacketError:
    fCapCheckPacket = "ERROR"
    Exit Function

Exit_fCapCheckPacketBad:
    fCapCheckPacket = "BAD"
    Exit Function

Exit_fCapCheckPacket:
    Exit Function

Err_fCapCheckPacket:
    MsgBox Error$
    Resume Exit_fCapCheckPacket
    
End Function

Public Function fStripedPacket(strData)
Dim strCurrentChar As String
Dim strCurrentString As String
Dim j As Integer
If InStr(strData, "$") = 0 Or InStr(strData, "#") = 0 Then
    GoTo Exit_fStripedPacket
End If

If InStr(strData, "$") > InStr(strData, "#") Then
    GoTo Exit_fStripedPacket
End If
j = InStr(strData, "$")
Do Until j = InStr(strData, "#") + 1

strCurrentChar = Mid(strData, j, 1)
strCurrentString = strCurrentString + strCurrentChar
j = j + 1
Loop

fStripedPacket = strCurrentString
Exit Function
Exit_fStripedPacket:
    fStripedPacket = "BAD"
    Exit Function
End Function

