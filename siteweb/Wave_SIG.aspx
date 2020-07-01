<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Wave_SIG.aspx.cs" Inherits="Wave" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <!--script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script-->

    <script src="https://code.highcharts.com/8.0.4/highcharts.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

    <h2>Vagues</h2>
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
        </div>
        
        <br />

            <p>Téléchargement des mesures affichées</p>
            <div>
            <asp:Button runat="server" ID="downloadBouton" Text="Télécharger (csv)" class="btn btn-default" OnClick="DownloadWave" />
            </div>

        <br />
        <br />

        <div class="panel panel-default">
              <div class="panel-heading"><b>Hauteur vagues</b></div>
              <div class="panel-body">
                <div id="Hcontainer" style="min-width:500px; width:100%; height:300px;"></div>
              </div>
        </div>

        <div class="panel panel-default">
            <div class="panel-heading"><b>Période vagues</b></div>
              <div class="panel-body">
                <div id="Tcontainer" style="min-width:500px;width:100%; height:300px;"></div>
              </div>
        </div>

        <div class="panel panel-default">
            <div class="panel-heading"><b>Direction vagues (Nv)</b></div>
              <div class="panel-body">
                <div id="Dcontainer" style="min-width:500px;width:100%; height:300px;"></div>
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
                url: "Wave_BFI_11.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateCharts(data.d);
                },
                error : function() {
                    alert('Vagues BFI11 : erreur de chargement ou pas de données');
                }
            });
        }

        // Update charts with wave data
        function updateCharts(data) {


            // Wave Height chart
            var chartH = $('#Hcontainer').highcharts();
            var H_sig = [];
            var H_max = [];

            for (var i = 0; i < data.H_time.length; i++) {
                H_sig.push([Date.parse(data.H_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.H_sig[i]*100)/100]);
                H_max.push([Date.parse(data.H_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.H_max[i]*100)/100]);
            }

            chartH.series[0].setData(H_max);
            chartH.series[1].setData(H_sig);


            // Wave Period chart
            var chartT = $('#Tcontainer').highcharts();
            var T_mean = [];
            var T_peak = [];

            for (var i = 0; i < data.T_time.length; i++) {
                T_mean.push([Date.parse(data.T_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.T_mean[i]*10)/10]);
                T_peak.push([Date.parse(data.T_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.T_peak[i]*10)/10]);
            }

            chartT.series[0].setData(T_peak);
            chartT.series[1].setData(T_mean);



            // Wave Direction chart
            var chartD = $('#Dcontainer').highcharts();
            var D_mean = [];
            var D_peak = [];
            
            chartD.yAxis[0].update({ min: 0 });
            chartD.yAxis[0].update({ max: 360 });


            for (var i = 0; i < data.D_time.length; i++) {
                D_mean.push([Date.parse(data.D_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.D_mean[i]*10)/10]);
                D_peak.push([Date.parse(data.D_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.D_peak[i]*10)/10]);
            }

            chartD.series[0].setData(D_peak);
            chartD.series[1].setData(D_mean);
            
        };

    </script>


<script type="text/javascript">

    $(function () {
        $('#Hcontainer').highcharts({
            exporting: {
                enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
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
            plotOptions: {
                series: {
                    marker: {
                        enabled: false
                    }
                },
            },
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
                    text: 'Hauteur',
                },
                //tickInterval: 0.5,
                labels: {
                    format: '{value} m',
                },
            }],
            legend: {
                layout: 'horizontal',
                align: 'left',
                verticalAlign: 'top',
                floating: false,
            },
            series: [{
                name: 'Hauteur max',
                data: [],
                color: 'green',
                animation: true,
                tooltip: {
                    valueSuffix: ' m'
                }
            },{
                name: 'Hauteur significative',
                data: [],
                color: 'blue',
                animation: true,
                tooltip: {
                    valueSuffix: ' m'
                }
            }
            ]
        });

        $('#Tcontainer').highcharts({
            exporting: {
                enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
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
            plotOptions: {
                series: {
                    marker: {
                        enabled: false
                    }
                },
            },
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
                    text: 'Période',
                },
                labels: {
                    format: '{value} s',
                    style: {
                        color: 'black'
                    }
                },
            }],
            legend: {
                layout: 'horizontal',
                align: 'left',
                verticalAlign: 'top',
                floating: false,
            },
            series: [{
                name: 'Période peak',
                data: [],
                color: 'gray',
                animation: false,
                tooltip: {
                    valueSuffix: ' s'
                }
            },{
                name: 'Période moyenne',
                data: [],
                color: 'red',
                animation: false,
                tooltip: {
                    valueSuffix: ' s'
                }
            }
            ]
        });

        $('#Dcontainer').highcharts({
            exporting: {
                enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
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
            plotOptions: {
                series: {
                    marker: {
                        enabled: false
                    }
                },
            },
            xAxis: {
                type: 'datetime',
                title: {
                    text: 'Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                title: {
                    text: 'Direction',
                },
                min: 0,
                max: 360,
                tickInterval: 45,
                labels: {
                    format: '{value} °',
                },
            }],
            legend: {
                layout: 'horizontal',
                align: 'left',
                verticalAlign: 'top',
                floating: false,
            },
            series: [{
                name: 'Direction peak',
                data: [],
                color: '#0282AD',
                animation: false,
                lineWidth: 0,
                tooltip: {
                    valueSuffix: ' °'
                },
                marker: {
                    enabled: true,
                    symbol: 'diamond'
                },
            },{
                name: 'Direction moyenne',
                data: [],
                color: '#FCA000',
                lineWidth: 0,
                animation: false,
                tooltip: {
                    valueSuffix: ' °'
                },
                marker: {
                    enabled: true,
                    symbol: 'diamond'
                },
            }
            ]
        });

        // Programmatically-defined buttons
        $(".chart-export").each(function() {
            var jThis = $(this),
                chartSelector = jThis.data("chartSelector"),
                chart = $(chartSelector).highcharts();

            $("*[data-type]", this).each(function() {
                var jThis = $(this),
                    type = jThis.data("type");
                if(Highcharts.exporting.supports(type)) {
                    jThis.click(function() {
                        chart.exportChartLocal({ type: type });
                    });
                }
                else {
                    jThis.attr("disabled", "disabled");
                }
            });
        });         

        // Disable download
        //str = '<%=ConfigurationManager.AppSettings["DownloadEnabled"] %>';
        //if( str.localeCompare("false") == 0 )
        //    document.getElementById('downloadBouton').disabled='disabled';

        // Init charts with last 24hours values
        initData();
    });

    


</script>

</asp:Content>

