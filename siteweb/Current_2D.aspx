<%@ Page Title="Courant" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Current_2D.aspx.cs" Inherits="Current" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script src="https://code.highcharts.com/8.0.4/highcharts.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/heatmap.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/data.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/boost-canvas.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/boost.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>


    <script src="Scripts/bootstrap-datepicker.js"></script>

    <h2>Courant</h2>

    <p>Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)</p>

    <p>Les longueurs de segment de mesures sont référencées par rapport à l'AWAC</p>

    <div id="Top" style="width:100%; ">

<%--        <div id="q_opt" class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" id="d_realtime" > <input id="q_op_1" name="op" type="radio" value="1" checked>Dernières 24h</label>
            <label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2">Historique</label>
        </div>

         <br/>         --%>

        <%--<div class="hidden" id="history">
            <br/>
            <div class='input-group date'>
                <div class='col-md-1'>
                    <p>Du</p>
                </div>
                <div class='col-md-3'>
                    <div class="form-group">
                        <input type='text' class="form-control" id='datetimepicker1' value="début"/>
                    </div>
                </div>
                <div class='col-md-1'>
                    <p>au</p>
                </div>
                <div class='col-md-3'>
                    <div class="form-group">
                        <input type='text' class="form-control" id='datetimepicker2' value="fin"/>
                    </div>
                </div>
                <div class='col-md-4'>
                    <div class="form-group">
                        <a class="btn btn-default" onclick="updateData()">Actualiser &raquo;</a>
                    </div>
                </div>
            </div>
        </div>--%>
        <br />
        <p>Téléchargement des mesures affichées</p>
        <div>
            <asp:Button runat="server" ID="downloadBouton" Text="Télécharger (csv)" class="btn btn-default" OnClick="DownloadCurrent" />
        </div>    
        <br />
        <br />

        <div class="row">   
                <div class="col-md-8">
                    <div class="panel panel-default">
                        <div class="panel-heading"><b>Profil de courant 2D: </b> <label id="current_Date_caronte">X</label> </div>     
                        <div class="panel-body">
                            <p>Mesures moyennées sur 1 minute</p>
                            <div class="row">
                                <div class="col-md-6">
                                    <div id="Current2D_Vitesse" style="min-width:100px;width:350px; height:320px;"></div>
                                </div>
                            <div class="col-md-6">
                                <div id="Current2D_Direction" style="min-width:100px;width:350px; height:320px;"></div>
                            </div>
                        </div>
                    </div>
                </div>
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

        $(document).ready(function () {
            var dp = $("#datetimepicker2");
            dp.datepicker({
                changeMonth: true,
                changeYear: true,
                format: "dd/mm/yyyy",
                language: "fr"
            });
        });

    </script>


    <script type="text/javascript">
     
        // Hide/Show history controls
        $('#d_realtime').on("click", function () {
            $("#history").addClass('hidden');
            initData();
        });
        $('#d_history').on("click", function () {
            $("#history").removeClass('hidden');
        });

        //initData();
        

        // Get timestamped data with webservice
        function updateData() {
            getData($("#datetimepicker1").val(), $("#datetimepicker2").val());
        }

        // Get last 24h with webservice
        function initData() {
            getData("", "");
        }

        // Call webservice with ajax!
        function getData(start, stop) {

            var obj = { begin: start, end: stop};

            $.ajax({
                type: "POST",
                url: "Current_CARONTE.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateCharts(data.d);
                },
                error : function() {
                    alert('Courant CARONTE: erreur de chargement ou pas de données');
                }
            });
        }

        // Update charts with data
        function updateCharts(data) {

            // 2D Profile charts
            var last = data.C_time.length - 1;

            var Amplitude = [];
            var Direction = []; 

            if (last >= 0) {

                //$('#Current_Date').text("      " + YYYYMMDDtoDDMMYYY(data.C_time[last]));
                //$('#current_Date_caronte').text(YYYYMMDDtoDDMMYYY(data.C_time[0]))

                var NB_couche_utile = 15;
                for (var j = 0; j < NB_couche_utile; j++) {
                    //Amplitude.push([data.C_amp[last][j], (j + 1) * data.C_cellsize + data.C_blancking]);
                    //Direction.push([data.C_dir[last][j], (j + 1) * data.C_cellsize + data.C_blancking]);
                    Amplitude.push([(j + 1) * data.C_cellsize + data.C_blancking, data.C_amp[last][j]]);
                    Direction.push([(j + 1) * data.C_cellsize + data.C_blancking, data.C_dir[last][j]]);
                }

                var chart = $('#Current2D_Vitesse').highcharts();
                chart.series[0].setData(Amplitude);

                var chart = $('#Current2D_Direction').highcharts();
                chart.series[0].setData(Direction);
            }
        };

    </script>

<script type="text/javascript">
    $(function () {

        Highcharts.setOptions({                                            
            global: {
                useUTC: false   // Dont apply client local time
            }
        });

        $('#Current2D_Vitesse').highcharts({
            chart: {
                inverted: false
            },
            title: {
                visible: false,
                text: '',
                x: -20 //center
            },
            subtitle: {
                text: '',
                x: -20
            },
            exporting: {
                enabled: false
            },
            plotOptions: {
                series: {
                    marker: {
                        enabled: false
                    }
                },
            },
            yAxis: {
                title: {
                    text: 'Vitesse Courant(nd)'
                },
                labels: {
                    format: '{value}'
                },
                //minTickInterval: 2,
                startOnTick: false,
                endOnTick: false,
                reversed: false,
                min: 0,
                opposite: true,
                //reversed: true,
                //tickPixelInterval: 50,
                gridLineWidth: 1
            },
            xAxis: {
                title: {
                    text: 'Distance',
                },
                labels: {
                    format: '{value} m'
                },
                
                startOnTick: true,
                endOnTick: true,
                reversed: true,
                //min: 0,
                minTickInterval: 2,
                tickPixelInterval: 50,
                gridLineWidth: 1
            },
            plotLines: [{
                value: 0,
                width: 1,
            }],

            tooltip: {
                headerFormat: '',
                pointFormat: 'Distance={point.x}m V={point.y}nd',
                valueDecimals: 2
            },
            legend: {
                enabled: false,
            },
            series: [{
                name: 'Vitesse (nd)',
                data: [],
                animation: true,
            }]
        });

        $('#Current2D_Direction').highcharts({
            chart: {
                inverted: false
            },
            title: {
                visible: false,
                text: '',
                x: -20 //center
            },
            subtitle: {
                text: '',
                x: -20
            },
            exporting: {
                enabled: false
            },
            plotOptions: {
                series: {
                    marker: {
                        enabled: false
                    }
                },
            },
            yAxis: {
                title: {
                    text: 'Direction(°)'
                },
                labels: {
                    format: '{value}'
                },
                //minTickInterval: 2,
                startOnTick: false,
                endOnTick: false,
                reversed: false,
                min: 0,
                opposite: true,
                //reversed: true,
                //tickPixelInterval: 50,
                gridLineWidth: 1
            },
            xAxis: {
                title: {
                    text: 'Distance',
                },
                labels: {
                    format: '{value} m'
                },
                
                startOnTick: true,
                endOnTick: true,
                reversed: true,
                //min: 0,
                minTickInterval: 2,
                tickPixelInterval: 50,
                gridLineWidth: 1
            },
            plotLines: [{
                value: 0,
                width: 1,
            }],

            tooltip: {
                headerFormat: '',
                pointFormat: 'Distance={point.x}m Direction={point.y}nd',
                valueDecimals: 2
            },
            legend: {
                enabled: false,
            },
            series: [{
                name: 'Direction (°)',
                data: [],
                animation: true,
            }]
        });

        initData();

    });
</script>

</asp:Content>

