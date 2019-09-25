<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="SPM.aspx.cs" Inherits="SPM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <!--script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script-->

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

     <h2>Pyranomètre</h2>
    <p>Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)</p>
    
    <div id="Top" style="width:100%; ">

        <div id="q_opt" class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" id="d_realtime" > <input id="q_op_1" name="op" type="radio" value="1" checked>Dernières 24h</label>
            <label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2">Historique</label>
        </div>

         <br/>       

        <div class="hidden" id="history">
        
            <br/>
            <div class='input-group date'>
                <div class='col-md-4'>
                    <div class="form-group">
                        <input type='text' class="form-control" id='datetimepicker1' value="début"/>
                    </div>
                </div>
                <div class='col-md-4'>
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
        </div>
        
        <br />

            <p>Téléchargement des mesures affichées</p>
            <div>
            <asp:Button runat="server" ID="downloadBouton" Text="Télécharger data (csv)" class="btn btn-default" OnClick="DownloadWave" />
            
            </div>

        <br />
        <br />

        <div class="panel panel-default">
              <div class="panel-heading"><b>Température</b></div>
              <div class="panel-body">
                <div id="tempcontainer" style="min-width:500px; width:100%; height:300px;"></div>
              </div>
        </div>

        <div class="panel panel-default">
            <div class="panel-heading"><b>Radiation</b></div>
              <div class="panel-body">
                <div id="radiationcontainer" style="min-width:500px;width:100%; height:300px;"></div>
              </div>
        </div>

        <div class="panel panel-default" >
            <div class="panel-heading"><b>Tension</b></div>
              <div class="panel-body">
                <div id="batcontainer" style="min-width:500px;width:100%; height:300px; "></div>
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
                    url: "SPM.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                    },
                    error : function() {
                        alert('SPM : erreur de chargement ou pas de données');
                    }
                });
        }

        // Update charts with meteo data
        function updateCharts(data) {


            // Temperature chart
            var chartTemp = $('#tempcontainer').highcharts();
            var temp = [];
            chartTemp.yAxis[0].update({ min: 0 });


            for (var i = 0; i < data.spm_time.length; i++) {
                temp.push([Date.parse(data.spm_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.spm_temp[i]]);
            }
                       
            chartTemp.series[0].setData(temp);

            // Radiation chart
            var chartRadiation = $('#radiationcontainer').highcharts();
            var rad = [];
            var rad_raw = [];
            //chartBat.yAxis[0].update({ min: 0 });
            //chartBat.yAxis[1].update({ min: 0 });

            //var stick = 1;
            //chartWind.yAxis[0].update({ tickInterval: stick });

            for (var i = 0; i < data.spm_time.length; i++) {
                rad.push([Date.parse(data.spm_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.spm_rad[i]]);
                rad_raw.push([Date.parse(data.spm_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.spm_rad_raw[i]]);
            }

            chartRadiation.yAxis[0].update({ min: 0 });
            chartRadiation.yAxis[0].update({ max: 1000 });
            chartRadiation.yAxis[1].update({ min: 0 });
            chartRadiation.yAxis[1].update({ max: 1000 });
            chartRadiation.yAxis[1].labels

            chartRadiation.series[0].setData(rad);
            chartRadiation.series[1].setData(rad_raw);

            // Baterie chart
            var chartBat = $('#batcontainer').highcharts();
            var temp2 = [];
            chartBat.yAxis[0].update({ min: 0 });
            chartBat.yAxis[0].update({ max: 20 });


            for (var i = 0; i < data.spm_time.length; i++) {
                temp2.push([Date.parse(data.spm_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.spm_bat[i]]);
            }

            chartBat.series[0].setData(temp2);

        };

    </script>


<script type="text/javascript">
    $(function () {

        $('#tempcontainer').highcharts({
            
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: 'Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                //tickInterval: 2,
                title: {
                    text: 'Température ( °C)'
                }
            }],
            series: [{
                name: 'Température °C',
                data: [],
                color: '#FF3333',
                animation: true,
                tooltip: {
                    valueSuffix: ' °C'
                }
            }]
        });

        $('#radiationcontainer').highcharts({
            
            xAxis: {
                type: 'datetime',
                title: {
                    text: 'Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                title: {
                    text: 'Radiation (W/m2)',
                    style: {
                        color: 'black'
                    }
                },
                labels: {
                    format: '{value} W/m2',
                    style: {
                        color: 'black'
                    }
                },
            }, {
                title: {
                    text: 'Radiation raw (W/m2)',
                    style: {
                        color: '#FCA000'
                    }
                },
                labels: {
                    }
            }],
            series: [{
                name: 'Radiation',
                data: [],
                color: 'black',
                yAxis: 0,
                animation: false,
                tooltip: {
                    valueSuffix: ' W/m2'
                }
            }, {
                name: 'Radiation raw',
                data: [],
                color: '#FCA000',
                yAxis: 1,
                animation: false,
                tooltip: {
                    valueSuffix: ' W/m2'
                }
            }]
        });

        $('#batcontainer').highcharts({
            
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: 'Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                //tickInterval: 2,
                title: {
                    text: 'Tension alimentation  ( V)'
                },
            }],
            series: [{
                name: 'Tension alimentation V',
                data: [],
                color: '#FF3333',
                animation: true,
                tooltip: {
                    valueSuffix: ' V'
                }
            }]
        });

        

        // Init charts with last 24hours values
        initData();
    });

</script>
</asp:Content>

