<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Spectrum1.aspx.cs" Inherits="Spectrum1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <script src="https://code.highcharts.com/8.0.4/highcharts.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/exporting.js"></script>

    <script src="https://code.highcharts.com/8.0.4/modules/heatmap.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>


    <%--<script type="text/javascript" src="Scripts/Highcharts-4.0.1/js/highcharts.js"></script>
    <script src="Scripts/Highcharts-4.0.1/js/modules/exporting.js"></script>
    <script src="Scripts/Highcharts-4.0.1/js/modules/data.js"></script>
    <script src="Scripts/Highcharts-4.0.1/js/modules/heatmap.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <!--script src="Scripts/export-csv.js"></!--script-->
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>--%>


    <%--<script src="Scripts/bootstrap-datepicker.js"></script>--%>

    <h2>Spectre</h2>
    <p>Heure locale (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)</p>


    <div id="Top" style="width:100%; ">

        <div id="q_opt" class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" id="d_lasthour" > <input id="q_op_0" name="op" type="radio" value="0" checked>Dernière heure</label>
            <label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2">Historique</label>
        </div>
        
        <div class="hidden" id="history">
            <br />
            <p>Selectionner la date et l'heure puis cliquez sur "Actualiser"</p>
            <div class='input-group date'>
                <div class='col-md-2'>
                    <h4>Date</h4>
                </div>
                <div class='col-md-6'>
                    <div class="form-group">
                        <input type='text' class="form-control" id='datetimepicker1' value="JJ/MM/AAAA"/>
                    </div>
                </div>
                
            </div>
            <br/> 
            <div class='input-group date'>
                <div class='col-md-12'>
                    <div id="hourradio" class="btn-group" data-toggle="buttons">
                        <label class="btn btn-default active" id="h0" > <input name="hour" type="radio" value="1" checked>0h</label>
                        <label class="btn btn-default" id="h01"> <input name="hour" type="radio" value="2">1h</label>
                        <label class="btn btn-default" id="h02"> <input name="hour" type="radio" value="1">2h</label>
                        <label class="btn btn-default" id="h03"> <input name="hour" type="radio" value="2">3h</label>
                        <label class="btn btn-default" id="h04"> <input name="hour" type="radio" value="1">4h</label>
                        <label class="btn btn-default" id="h05"> <input name="hour" type="radio" value="2">5h</label>
                        <label class="btn btn-default" id="h06"> <input name="hour" type="radio" value="1">6h</label>
                        <label class="btn btn-default" id="h07"> <input name="hour" type="radio" value="2">7h</label>
                        <label class="btn btn-default" id="h08"> <input name="hour" type="radio" value="2">8h</label>
                        <label class="btn btn-default" id="h09"> <input name="hour" type="radio" value="1">9h</label>
                        <label class="btn btn-default" id="h10"> <input name="hour" type="radio" value="2">10h</label>
                        <label class="btn btn-default" id="h11"> <input name="hour" type="radio" value="2">11h</label>
                        <label class="btn btn-default" id="h12"> <input name="hour" type="radio" value="1">12h</label>
                        <label class="btn btn-default" id="h13"> <input name="hour" type="radio" value="2">13h</label>
                        <label class="btn btn-default" id="h14"> <input name="hour" type="radio" value="1">14h</label>
                        <label class="btn btn-default" id="h15"> <input name="hour" type="radio" value="2">15h</label>
                        <label class="btn btn-default" id="h16"> <input name="hour" type="radio" value="1">16h</label>
                        <label class="btn btn-default" id="h17"> <input name="hour" type="radio" value="2">17h</label>
                        <label class="btn btn-default" id="h18"> <input name="hour" type="radio" value="2">18h</label>
                        <label class="btn btn-default" id="h19"> <input name="hour" type="radio" value="1">19h</label>
                        <label class="btn btn-default" id="h20"> <input name="hour" type="radio" value="2">20h</label>
                        <label class="btn btn-default" id="h21"> <input name="hour" type="radio" value="1">21h</label>
                        <label class="btn btn-default" id="h22"> <input name="hour" type="radio" value="2">22h</label>
                        <label class="btn btn-default" id="h23"> <input name="hour" type="radio" value="1">23h</label>
                    </div>
                   
                </div>
            </div>
            <div class="row">
            </div>
            <br/>
            <div class="row">
                <div class='col-md-6'>
                <a class="btn btn-default" onclick="updateData()">Actualiser &raquo;</a>
                </div>
            </div>

        </div>
        
        <div class="row">
            </div>
        <br/>
        <div class="row">
            <div class='col-md-6'>
                <a class="btn btn-default" id="b">Export CSV</a>
            </div>
        </div>
        <div class="row">
            </div>
        <br/>

    <div class="panel panel-default">
        <div class="panel-heading"><b>Spectre de l'energie acoustique en tiers d'octave</b></div>
        <div class="panel-body">
            <div id="Spectrumcontainer" style="min-width:500px; width:100%; height:500px; min-height:300px;"></div>
        </div>
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

        var freq = ['12', '16', '20', '25', '31', '39', '50', '62', '79', '99', '125', '157', '198', '250', '315', '397', '500', '630', '794', '1000', '1260', '1587', '2000', '2520', '3175', '4000', '5040', '6350', '8000', '10079', '12699', '16000', '20159'];
        var START;
        var STOP;
        var hour = 0;

        $('#h00').on("click", function () { hour = 0; });
        $('#h01').on("click", function () { hour = 1; });
        $('#h02').on("click", function () { hour = 2; });
        $('#h03').on("click", function () { hour = 3; });
        $('#h04').on("click", function () { hour = 4; });
        $('#h05').on("click", function () { hour = 5; });
        $('#h06').on("click", function () { hour = 6; });
        $('#h07').on("click", function () { hour = 7; });
        $('#h08').on("click", function () { hour = 8; });
        $('#h09').on("click", function () { hour = 9; });
        $('#h10').on("click", function () { hour = 10; });
        $('#h11').on("click", function () { hour = 11; });
        $('#h12').on("click", function () { hour = 12; });
        $('#h13').on("click", function () { hour = 13; });
        $('#h14').on("click", function () { hour = 14; });
        $('#h15').on("click", function () { hour = 15; });
        $('#h16').on("click", function () { hour = 16; });
        $('#h17').on("click", function () { hour = 17; });
        $('#h18').on("click", function () { hour = 18; });
        $('#h19').on("click", function () { hour = 19; });
        $('#h20').on("click", function () { hour = 20; });
        $('#h21').on("click", function () { hour = 21; });
        $('#h22').on("click", function () { hour = 22; });
        $('#h23').on("click", function () { hour = 23; });

        // Hide/Show history controls
        $('#d_lasthour').on("click", function () {
            $("#history").addClass('hidden');
            initData();
        });
        $('#d_history').on("click", function () {
            $("#history").removeClass('hidden');
            clearCharts();
        });

        // Get timestamped data with webservice
        function updateData() {
            getData($("#datetimepicker1").val(), '', hour);
        }

        // Get last hour with webservice
        function initData() {
            getData("lasthour", "", "");
        }

        // Get last hour with webservice
        function clearCharts() {
            var chart = $('#Spectrumcontainer').highcharts();
            chart.series[0].setData([]);
        }

        

        // Call webservice with ajax!
        function getData(start, stop, h) {

            // Set start/stop for export csv function (to ensure to export the plotted data time interval)
            START = start;
            STOP = stop;
            HOUR = h;

            var obj = { begin: start, end: stop, hour: h, Xlength: 600 };

                $.ajax({
                    type: "POST",
                    url: "Spectrum1.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                    },
                    error : function() {
                        alert('Erreur de chargement ou pas de données. Verifier l\'entrée "Date".');
                    }
                });
        }

        // Call webservice with ajax!
        function getDataToExport() {

            // Set start/stop for export csv function (to ensure to export the plotted data time interval)
            //var obj = { database: "database1_data", begin: START, end: STOP, Xlength: 5000 };
            var obj = { begin: START, end: STOP, hour: HOUR, Xlength: -1 };

            $.ajax({
                type: "POST",
                url: "Spectrum1.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    exportToCsv(data.d);
                },
                error: function () {
                    alert('Erreur de chargement ou pas de données. Verifier l\'entrée "Date".');
                }
            });
        }

        // Update charts with wave data
        function updateCharts(data) {


            // Wave Height chart
            var chart = $('#Spectrumcontainer').highcharts();
            var Amplitude = [];
            var sel = [];

            var maxAmp = 0.0;
            var minAmp = 9999999.0;

 
            for (var i = 0; i < data.tieroct_time.length; i++) {
                for (var j = 0; j < data.tieroct_value[0].length; j++) {
                    Amplitude.push([Date.parse(data.tieroct_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), j, data.tieroct_value[i][j]]);
                    maxAmp = Math.max(maxAmp, data.tieroct_value[i][j]);
                    minAmp = Math.min(minAmp, data.tieroct_value[i][j]);
                }
                sel.push([Date.parse(data.tieroct_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.acoustic_sel[i]]);
            }


            
            //chart.yAxis.update({ min: data.tieroct_freq[0], max: data.tieroct_freq[data.tieroct_value[0].length - 1] });

            chart.colorAxis[0].update({ min: minAmp, max: maxAmp }),

            chart.series[0].update({
                data: Amplitude,
                colsize: data.meanTimeInterval,
                //rowsize: 1
                }, true); //true / false to redraw

            //chart.series[1].update({
            //    data: sel,
            //    colsize: data.meanTimeInterval,
            //    //rowsize: 1
            //}, true);

            chart.yAxis[0].update({ max: 32 });
            //chart.yAxis[1].update({ max: 32 });
        };

        function exportToCsv(data) {
            var myCsv = "Datetime;";

            for (var j = 0; j < data.tieroct_value[0].length; j++)
                myCsv = myCsv + freq[j] + ";";

            myCsv = myCsv + "\n"

            for (var i = 0; i < data.tieroct_time.length; i++) {
                myCsv = myCsv + data.tieroct_time[i] + ";";
                for (var j = 0; j < data.tieroct_value[0].length; j++) {
                    myCsv = myCsv + data.tieroct_value[i][j] + ";";
                }
                myCsv = myCsv + "\n"
            }


            window.open('data:text/csv;charset=utf-8,' + escape(myCsv));
        }

        var button = document.getElementById('b');
        button.addEventListener('click', getDataToExport);

    </script>

<script type="text/javascript">
    $(function () {
        $('#Spectrumcontainer').highcharts({
            chart: {
                type: 'heatmap',
            },
            exporting: {
                sourceWidth: 1200,
                sourceHeight: 500,
            },

            title: {
                text: '',
                align: 'left',
                x: 40
            },
            xAxis: {
                type: 'datetime',
                //startOnTick: true,
                //endOnTick: true
                //minTickInterval: 30
            },

            yAxis: {
                title: {
                    text: 'tiers d\'octave Hz'
                },
                categories: freq,


                minTickInterval: 1,

                labels: {
                    format: '{value} Hz',
                    step: 1
                },
                startOnTick: false,
                endOnTick: false,
                reversed: false
            },

            colorAxis: {
                stops: [
                    [0, '#0033FF'],
                    [0.2, '#0051FF'],
                    [0.3, '#3BD448'],
                    [0.8, '#FFFF00'],
                    [1, '#FF0000']
                ],
                min: 0,
                max: 1,
                startOnTick: true,
                endOnTick: true,
                labels: {
                    format: '{value} dB'
                }
            },
            legend: {
                title: {
                    text: ''
                },
                enabled: true,
                layout: "horizontal",
                reversed: true,
                align: "center",
                verticalAlign: "bottom",
                width: 650,
                symbolWidth: 650,
            },
            series: [{
                name: 'Niveau acoustique',
                //borderWidth: 0,
                data: [],
                colsize: 1000, // one second
                tooltip: {
                    pointFormat: '{point.x:%d/%m/%Y, %H:%M:%S} {point.y}Hz <b>{point.value} dB</b>'
                },
                enableMouseTracking: false,
                animation: false
            }
            ]
        });

    // Init charts with last values
    initData();

    });
</script>

</asp:Content>

