<%@ Page Title="Courant" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Current.aspx.cs" Inherits="Current" %>

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

    <p>Les hauteurs de couches de mesures sont référencées par rapport à l'AWAC</p>

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
                <asp:Button runat="server" ID="downloadBouton" Text="Télécharger (csv)" class="btn btn-default" OnClick="DownloadCurrent" />
            </div>    

        <br />
        <br />

    

    <div class="panel panel-default">
        <div class="panel-heading"><b>Vitesse courant</b></div>
        <div class="panel-body">
            <p>Cliquer sur la hauteur de la couche de mesure en légende pour afficher la courbe correspondante</p>
            <div id="Ampcontainer" style="min-width:500px; width:100%; height:300px;"></div>
        </div>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading"><b>Direction courant (Nv)</b></div>
        <div class="panel-body">
            <p>Cliquer sur la hauteur de la couche de mesure en légende pour afficher la courbe correspondante</p>
            <div id="Dircontainer" style="min-width:500px; width:100%; height:300px;"></div>
        </div>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading"><b>Profil de courant 3D</b></div>
        <div class="panel-body">
            <div id="ProfileAmpcontainer" style="min-width:500px; width:100%; height:400px;"></div>

            <div id="ProfileDircontainer" style="min-width:500px; width:100%; height:400px;"></div>
        </div>
    </div>

    <div class="panel panel-default">
            <div class="panel-heading"><b>Marée / Température eau</b></div>
              <div class="panel-body">
                <div id="MTcontainer" style="min-width:500px;width:100%; height:300px;"></div>
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
                    url: "Current_BFI_11.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                    },
                    error : function() {
                        alert('Courant BFI 11: erreur de chargement ou pas de données');
                    }
                });
        }

        // Update charts with wave data
        function updateCharts(data) {
            
            var mtchart = $('#MTcontainer').highcharts();
            var maree = [];
            var tempeau = [];

            for (var i = 0; i < data.C_time.length; i++) {
                maree.push([Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.C_press[i]]);
                tempeau.push([Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.C_temp[i]]);
            }

            mtchart.series[0].setData(tempeau);
            mtchart.series[1].setData(maree);

            // Wave Height chart
            var chart = $('#ProfileAmpcontainer').highcharts();
            var chartDir = $('#ProfileDircontainer').highcharts();
            var Amplitude = [];
            var AmplitudeGrouped = [];
            var Direction = [];
			
            var maxAmp = 0.0;
            for (var i = 0; i < data.C_time.length; i++) {
                for (var j = 0; j < data.C_amp[0].length; j++) {
                    Amplitude.push([Date.parse(data.C_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), (j+1) * data.C_cellsize + data.C_blancking, data.C_amp[i][j]]);
                    Direction.push([Date.parse(data.C_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), (j+1) * data.C_cellsize + data.C_blancking, data.C_dir[i][j]]);
                    maxAmp = Math.max(maxAmp, data.C_amp[i][j]);
                }
            }

            if(data.C_time.length>1000)
            {
                var factor = data.C_time.length / 500;

                data.C_time.length
            }

            
            chart.colorAxis[0].update( { min: 0,max: maxAmp }),

            chart.series[0].update({
                data: Amplitude,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, true); //true / false to redraw


            chartDir.series[0].update({
                data: Direction,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, true); //true / false to redraw
            
            chartDir.colorAxis[0].update({ min: 0, max: 360 });

            chartDir.yAxis[0].update({ max: data.C_amp[0].length * data.C_cellsize + data.C_blancking });




            // Chart immersion  fixe"
            var chartAmp = $('#Ampcontainer').highcharts();
            while (chartAmp.series.length>0){
                chartAmp.series[0].remove();
            }

            var chartDir = $('#Dircontainer').highcharts();
            while (chartDir.series.length > 0) {
                chartDir.series[0].remove();
            }
            
            for (var j = 0; j < data.C_amp[0].length; j++) {

                var amp = [];
                var dir = [];

                for (var i = 0; i < data.C_time.length; i++) {
                    amp.push([Date.parse(data.C_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.C_amp[i][j]]);
                    dir.push([Date.parse(data.C_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.C_dir[i][j]]);
                }

                chartAmp.addSeries({
                    name: "H=" + ((j + 1) * data.C_cellsize + data.C_blancking) + "m",
                    data: amp,
                    visible: false,
                    tooltip: {
                        valueSuffix: ' nd'
                    }
                });

                

                chartDir.addSeries({
                    
                        name: "H=" + ((j + 1) * data.C_cellsize + data.C_blancking) + "m",
                        data: dir,
                        lineWidth: 0,
                        animation: true,
                        visible: false,
                        marker: {
                            //enabled: true,
                            //enabled: false,
                            symbol: 'diamond'
                        },
                        tooltip: {
                            valueSuffix: ' °'
                        }    
                });
                
                //chartDir.series[j].update({ lineWidth: 0 });

                chartDir.yAxis[0].update({ min: 0, max: 360 });
            }

            chartAmp.series[0].update({ visible: true });
            chartDir.series[0].update({ visible: true });
        };

    </script>

<script type="text/javascript">
    $(function () {
        $('#ProfileAmpcontainer').highcharts({
            chart: {
                type: 'heatmap',
            },
            exporting: {
		        enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
                sourceWidth: 1200,
                sourceHeight: 500,
            },

            title: {
                text: 'Vitesse',
                align: 'left',
                x: 40
            },
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
            },

            yAxis: {
                title: {
                    text: 'hauteur '
                },
                tickInterval: 2,
                labels: {
                    format: '{value} m'
                },
                startOnTick: false,
                endOnTick: false,
                reversed: false
            },

            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                floating: false,
            },

            colorAxis: {
                stops: [
                    [0, '#3060cf'],
                    [0.3, '#00FFA2'],
                    [0.8, '#FFC400'],
                    [1, '#FF0000']
                ],
                min: 0,
                max: 1,
                startOnTick: true,
                endOnTick: true,
                tickPixelInterval: 150,
                labels: {
                    format: '{value} nd'
                }
            },

            series: [{
                name: 'Vitesse',
                //borderWidth: 0,
                data: [],
                colsize: 1000, // one second
                    tooltip: {
                        pointFormat: '{point.x:%d/%m/%Y, %Hh%M} {point.y}m <b>{point.value} nd</b>'
                    },
            }]
        });

    $('#ProfileDircontainer').highcharts({
        chart: {
            type: 'heatmap',
        },
        exporting: {
            enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
            sourceWidth: 1200,
            sourceHeight: 500,
        },

        title: {
            text: 'Direction',
            align: 'left',
            x: 40
        },
        xAxis: {
            type: 'datetime',
            minTickInterval: 30
        },

        yAxis: {
            title: {
                text: 'hauteur'
            },
            min: 0,
            tickInterval: 2,
            labels: {
                format: '{value} m'
            },
            startOnTick: false,
            endOnTick: false,
            reversed: false
        },
        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom',
            floating: false,
        },
        colorAxis: {
            stops: [
                [0, '#FFFB00'],
                [0.3, '#3060cf'],
                [0.80, '#FF9D00'],
                [1, '#FFFB00']
            ],
            min: 0,
            max: 360,
            startOnTick: false,
            endOnTick: false,
            labels: {
                format: '{value} °'
            }
        },
        series: [{
            name: 'Direction',
            //borderWidth: 0,
            data: [],
            colsize: 1000, // one second
            tooltip: {
                pointFormat: '{point.x:%d/%m/%Y, %Hh%M} hauteur={point.y}m <b>{point.value}°</b>'
            },
        }]
    });


    $('#Ampcontainer').highcharts({
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
           
            startOnTick: true,
            title: {
                min: 0,
                text: 'Vitesse',
            },
            labels: {
                format: '{value} nd',
            },
            gridLineWidth: 1
        }],
        legend: {
            layout: 'horizontal',
            align: 'left',
            verticalAlign: 'top',
            floating: false,
        },
    });

    $('#Dircontainer').highcharts({
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
                    enabled: true
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
            max: 360,
           
            tickInterval: 45,
            title: {
                min: 0,
                text: 'Direction',
            },
            labels: {
                format: '{value} °',
            },
            gridLineWidth: 1
        }],
        legend: {
            layout: 'horizontal',
            align: 'left',
            verticalAlign: 'top',
            floating: false,
        },
    });

    $('#MTcontainer').highcharts({

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
                    text: 'Température (°C)',
                    style: {
                        color: 'black'
                    }
                },
                labels: {
                    format: '{value} °C',
                    style: {
                        color: 'black'
                    }
                },
            }, {
                title: {
                    text: 'Pression (dBar)',
                    style: {
                        color: '#FCA000'
                    }
                },
                labels: {
                    format: '{value} dBar',
                    style: {
                        color: '#FCA000'
                    }
                },
                opposite: true
            }],
            series: [{
                name: 'Température eau',
                data: [],
                color: 'black',
                animation: false,
                tooltip: {
                    valueSuffix: ' °C'
                }
            }, {
                name: 'marée',
                data: [],
                color: '#FCA000',
                yAxis: 1,
                animation: false,
                tooltip: {
                    valueSuffix: ' dBar'
                }
            }
            ]
        });

    initData();

    });
</script>

</asp:Content>

