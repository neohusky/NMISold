<?php

require_once('./codebase/thirdparty/mpdf60/mpdf.php');

$mpdf=new mPDF('utf-8', array(80,40));



$html = '
<html>
<head>

</head>
<body>



<table width="100%" style="font-family: serif;" cellpadding="0">
<tr height="20"></tr>
    <td width="285" align="middle"><span style="font-size: 8pt; color: #555555; font-family: sans;">CAUTION - RADIOISOTOPE</span></td>
<tr height="20"></tr>
    <td width="285" align="middle"><span style="font-size: 8pt; color: #555555; font-family: sans;">KITSOS, THEO</span></td>
<tr height="14"></tr>
    <td width="30" align="middle"><span style="font-size: 8pt; color: #555555; font-family: sans;">DOB: 09/05/2008</span></td>
    <td width="100" align="middle"><span style="font-size: 8pt; color: #555555; font-family: sans;">MRN: 1026917</span></td>
<tr height="17"></tr>
    <td width="285" align="middle"><span style="font-size: 10pt; color: #555555; font-family: sans;">Renal Scan (MAG3)</span></td>
<tr height="12"></tr>
    <td width="155" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">Dispensed: 13/06/2008 11:42:30</span></td>
    <td width="41" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">SyrID: d</span></td>
    <td width="92" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">2222</span></td>
<tr height="14"></tr>
    <td width="65" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">Tech Draw:</span></td>
    <td width="34" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">TKITS</span></td>
    <td width="73" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">Tech Inj:</span></td>
    <td width="114" align="left"><span style="font-size: 7pt; color: #555555; font-family: sans;">Site:</span></td>
</table>

</body>
</html>
';

$mpdf->WriteHTML($html);

$mpdf->Output(); exit;

exit;

?>