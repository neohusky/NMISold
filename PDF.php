<?php

require_once('./codebase/thirdparty/mpdf60/mpdf.php');

$mpdf = new mPDF();






$mpdf->WriteHTML('<body>
                    <style type="text/css">
                      .tg  {border-collapse:collapse;border-spacing:0;}
                      .tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
                      .tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
                      .tg .tg-0ord{text-align:right}
                      .tg .tg-s6z2{text-align:center}
                      .tg .tg-6iqf{font-size:16px;font-family:Arial, Helvetica, sans-serif !important;;text-align:center}
                      .tg .tg-huh2{font-size:14px;text-align:center}
                  </style>
                  <table class="tg">
                      <tr>
                          <th class="tg-031e" rowspan="5">Barc</th>
                          <th class="tg-6iqf" colspan="4">CAUTION - RADIOISOTOPE</th>
                      </tr>
                      <tr>
                          <td class="tg-huh2" colspan="4">Technetium Generator</td>
                      </tr>
                      <tr>
                          <td class="tg-0ord" colspan="2">Arrival Date:</td>
                          <td class="tg-s6z2" colspan="2">25/05/2015</td>
                      </tr>
                      <tr>
                          <td class="tg-0ord" colspan="2">Batch Number:</td>
                          <td class="tg-031e" colspan="2">1234565</td>
                      </tr>
                      <tr>
                          <td class="tg-031e"></td>
                          <td class="tg-031e"></td>
                          <td class="tg-031e"></td>
                          <td class="tg-031e"></td>
                      </tr>
                  </table>
                  </body>'
                  );


$mpdf->Output();
exit;
?>