<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Acoustic1.aspx.cs" Inherits="Acoustic1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

 <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <script src="https://code.highcharts.com/8.0.4/highcharts.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

   <%-- <script type="text/javascript" src="Scripts/Highcharts-4.0.1/js/highcharts.js"></script>
    <script src="Scripts/Highcharts-4.0.1/js/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>--%>



    <!--script src="Scripts/export-csv.js"></!--script-->
    <%--<script src="Scripts/nortekmed/Highcharts_cfg.js"></script>--%>




    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/themes/blitzer/jquery-ui.css" rel="stylesheet" type="text/css"/>

    <h2>Niveaux acoustiques</h2>
    <p>Heure locale (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)</p>

    <div id="q_opt" class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" id="d_realtime" > <input id="q_op_1" name="op" type="radio" value="1" checked>Dernières 24h</label>
            <label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2">Historique</label>
        </div>

        <br/>       

        <div class="hidden" id="history">
        
            <br/>
            <div class='input-group date'>
                 <div class='col-md-2'>
                    <h4>Date</h4>
                </div>
                <div class='col-md-4'>
                    <div class="form-group">
                        <input type='text' class="form-control" id='datetimepicker1' value="JJ/MM/AAAA"/>
                    </div>
                </div>
                <div class='col-md-3'>
                <div class="form-group">
                    <a class="btn btn-default" onclick="updateData()">Actualiser &raquo;</a>
                    </div>
                </div>
            </div>
        </div>
        
        <br />

        <button type="button" id="b" class="btn btn-default">Export CSV</button>

        <br />
        <br />

        <div class="panel panel-default">
              <div class="panel-heading"><b>Niveaux acoustique SEL</b></div>
              <div class="panel-body">
                <div id="Acousticcontainer" style="min-width:400px; width:100%; height=300px";"></div>
              </div>
            </div>
        <div class="panel panel-default">
            <div class="panel-heading"><b>Niveaux acoustique Peak-to-peak</b></div>
              <div class="panel-body">
                <div id="Acousticcontainer2" style="min-width:400px; width:100%; height=300px";></div>
              </div>
        </div>

    

    <script type="text/javascript">

        $(document).ready(function () {
            var dp = $("#datetimepicker1");
            dp.datepicker({
                changeMonth: true,
                changeYear: true,
                format: "dd/mm/yyyy",
                language: "fr"
            });
        });

     

        </script>


    <script type="text/javascript">
     
        var START;
        var STOP;

        // Hide/Show history controls
        $('#d_realtime').on("click", function () {
            $("#history").addClass('hidden');
            initData();
        });
        $('#d_history').on("click", function () {
            $("#history").removeClass('hidden');
        });

        // Get timestamped data with webservice
        function updateData() {
            getData($("#datetimepicker1").val(), "");
        }



        // Get last 24h with webservice
        function initData() {
            getData("lastday", "");
        }

        // Call webservice with ajax!
        function getData(start, stop) {

            // Set start/stop for export csv function (to ensure to export the plotted data time interval)
            START = start;
            STOP = stop;

            var obj = { database: "hydro_db", begin: start, end: stop, Xlength: 5000};

                $.ajax({
                    type: "POST",
                    url: "Acoustic1.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                    },
                    error : function() {
                        alert('getData: Erreur de chargement ou pas de données. Verifier l\'entrée "Date".');
                    }
                });
        }

        // Call webservice with ajax!
        function getDataToExport() {


            var obj = { database: "hydro_db", begin: START, end: STOP, Xlength: 5000 };

            $.ajax({
                type: "POST",
                url: "Acoustic1.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    exportToCsv(data.d);
                },
                error: function () {
                    alert('getDataToExport: Erreur de chargement ou pas de données. Verifier l\'entrée "Date".');
                }
            });
        }
        

        // Update charts with acoustic data
        function updateCharts(data) {

            // chart
            var chart1 = $('#Acousticcontainer').highcharts();
            var chart2 = $('#Acousticcontainer2').highcharts();
            var sel = [];
            var ptp = [];

            
            for (var i = 0; i < data.acoustic_time.length; i++) {
                sel.push([Date.parse(data.acoustic_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.acoustic_sel[i]]);
                ptp.push([Date.parse(data.acoustic_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.acoustic_ptp[i]]);
            }
          

            chart1.series[0].setData(sel);
            chart2.series[0].setData(ptp);
            
        };

        function exportToCsv(data) {

            var myCsv = "Datetime;SEL;PTP\n";

            for (var i = 0; i < data.acoustic_time.length; i++)
                myCsv = myCsv + data.acoustic_time[i] + ";" + data.acoustic_sel[i] + ";" + data.acoustic_ptp[i] + "\n";

            window.open('data:text/csv;charset=utf-8,' + escape(myCsv));
        }

        var button = document.getElementById('b');
        button.addEventListener('click', getDataToExport);

    </script>


<script type="text/javascript">
    $(function () {

        $('#Acousticcontainer').highcharts({
            xAxis: {
                type: 'datetime',
                minTickInterval: 1000,
                title: {
                    text: 'Heure locale (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                minTickInterval: 0.5,
                title: {
                    text: 'dB ref 1µPa²/s'
                },
            }],
            legend: {
                enabled: false
            },
            series: [{
                name: 'SEL',
                data: [],
                //color: '#224BD4'
                tooltip: {
                    valueSuffix: ' dB'
                },
                enableMouseTracking: false,
                animation: false,
            }
            ]
        });

        $('#Acousticcontainer2').highcharts({
            
            xAxis: {
                type: 'datetime',
                //minTickInterval: 30,
                title: {
                    text: 'Heure locale (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                minTickInterval: 0.5,
                title: {
                    text: 'dB ref 1µPa²/s'
                },
                enableMouseTracking: false,
                animation: false
            }],
            legend: {
                enabled: false
            },
            series: [{
                name: 'PTP',
                data: [],
                color: '#FF8000',
                tooltip: {
                    valueSuffix: ' dB'
                },
                enableMouseTracking: false,
                animation: false,
            } 
            ]
        });

        // Init charts with last 24hours values
        initData();
    });

</script>


</asp:Content>

