﻿<%@ Page Title="Courant" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Current_Sig.aspx.cs" Inherits="SIG_Current" %>

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

    <asp:HiddenField ID = "page_name" Value="<%$ Resources:Site.master, signature %>" Runat="Server" />


    <asp:HiddenField ID = "start" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "end" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "refresh" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_data" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "last" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "historical" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "hour" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "equipname" ClientIdMode="Static" Runat="Server"/>

    <asp:HiddenField ID = "pitchname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "pitchunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "pitchlabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "rollname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rollunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rolllabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "tempname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "tempunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "templabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "pressname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "pressunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "presslabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "speedname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "speedunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "speedlabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "ampname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "ampunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "amplabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "corname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "corunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "corlabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "voltname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "voltunit"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "msg_info_0" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "high_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "direction_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "direction_unit" ClientIdMode="Static" Runat="Server" />
    <%--<asp:HiddenField ID = "speed_label" ClientIdMode="Static" Runat="Server" />--%>
    <asp:HiddenField ID = "profdir_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "profspeed_label" ClientIdMode="Static" Runat="Server" />


    <script type="text/javascript">
        
        var l_maintitle = document.getElementById('<%=page_name.ClientID%>').value;
        var l_hour = document.getElementById('<%=hour.ID%>').value;

        document.write('<h2>');
        document.write('<%=ConfigurationManager.AppSettings["SiteName"] %>'); document.write(" - ");
        document.write(l_maintitle + '</h2><p>');
        document.write(l_hour + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)');
    </script>   

    <script type="text/javascript">
        var l_start = document.getElementById('<%=start.ClientID%>').value;
        var l_end = document.getElementById('<%=end.ClientID%>').value;
        var l_refresh = document.getElementById('<%=refresh.ClientID%>').value;
        var l_download = document.getElementById('<%=download.ClientID%>').value;
        var l_download_data = document.getElementById('<%=download_data.ClientID%>').value;
        var l_last = document.getElementById('<%=last.ClientID%>').value;
        var l_historical = document.getElementById('<%=historical.ClientID%>').value;

        document.write('<div id="Top" style="width: 100 %; ">');
        document.write('<div id="q_opt" class="btn-group" data-toggle="buttons">');
        document.write('<label class="btn btn-default active" id="d_realtime" > <input id="q_op_1" name="op" type="radio" value="1" checked>' + l_last + ' 24h</label > ');
        document.write('<label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2" >' + l_historical + '</label>');
        document.write('</div><br>');

        document.write('<div class="hidden" id="history"> <br>');
        document.write('<div class="input-group date">');

        //var myDate = new Date();
        //var month = myDate.getMonth() + 1;
        //var date = ('0' + myDate.getDate()).slice(-2) + '/' + month + '/' + myDate.getFullYear();
        //alert(date);

        document.write('<div class="col-md-4">');
        document.write('<div class="form - group">');
        //document.write('<input type="text" class="form - control" id="datetimepicker1" value="' + date + '"/>');
        //document.write('<div class="col-md-4">');
        //document.write('<div class="form - group">');
        document.write('<input type="text" class="form - control" id="datetimepicker1" value="' + l_start + '"/>');
        document.write('</div></div>');

        document.write("<div class='col-md-4'>");
        document.write('<div class="form - group">');
        //document.write('<input type="text" class="form - control" id="datetimepicker2" value="' + date + '"/>');
        document.write('<input type="text" class="form - control" id="datetimepicker2" value="' + l_end + '"/>');
        document.write('</div></div>');

        document.write('<div class="col-md-4">');
        document.write('<div class="form - group">');
        document.write('<a class="btn btn-default" onclick="updateData()">' + l_refresh + ' </a>');
        document.write('</div></div>');

        document.write('</div></div>');

        document.write('<br><p>' + l_download + '</p>');
        document.write('<div>');

        document.write('<asp:Button runat="server" ID="downloadBouton" Text="" class="btn btn-default" OnClick="DownloadCurrent" />');

        document.write('</div><br><br>')
    </script>

    <form>
    <div class="speedInputGroup">
        <label for="speed">Enter speed limit — in m/s :</label>
        <input id="speed" type="number" name="speed" step="0.1" min="0" max="20" value="0" required>
        <span class="validity"></span>
        <a class="btn btn-default" onclick="updateDataLimit()">Trace</a>
    </div>
    <div>


    <script type="text/javascript">
        var label = document.getElementById('<%=speedlabel.ClientID%>').value;
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
         document.write('<div class="panel-body">');
        document.write('<div id="Ampcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=direction_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="Dircontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=profspeed_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="ProfileAmpcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=profdir_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="ProfileDircontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = "water " + document.getElementById('<%=templabel.ClientID%>').value.toLowerCase() + ' (' + "<%=ConfigurationManager.AppSettings["Looking"] %>" + ')';
        
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="MTcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>
    

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
            $('#datetimepicker1').val("").datepicker("update");
            $('#datetimepicker2').val("").datepicker("update");
            //var dp1 = $("#datetimepicker1");
            //dp1.value = "";
            //var dp2 = $("#datetimepicker2");
            //dp1.value = "";
            //$("#datetimepicker1").value = "";
            //$("#datetimepicker2").value = "";
            initData();
        });
        $('#d_history').on("click", function () {
            $("#history").removeClass('hidden');
        });

        // Get timestamped data with webservice
        function updateData() {
            getData($("#datetimepicker1").val(), $("#datetimepicker2").val());
        }

        function updateDataLimit() {
            //alert($("#datetimepicker1").val());
            getDataLimit($("#datetimepicker1").val(), $("#datetimepicker2").val());
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
                    url: "Current_Sig.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                        updateLimit(data.d);
                    },
                    error : function() {
                        alert('SIG: erreur de chargement ou pas de données');
                    }
                });
        }

        //// Get last 24h with webservice
        //function initData() {
        //    getData("", "");
        //}

        // Call webservice with ajax!
        function getDataLimit(start, stop) {

        var obj = { begin: start, end: stop};

                $.ajax({
                    type: "POST",
                    url: "Current_Sig.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateLimit(data.d);
                    },
                    error : function() {
                        alert('SIG: erreur de chargement ou pas de données');
                    }
                });
        }

        // Update charts with wave data
        function updateLimit(data) {

            var speed = +document.getElementById('speed').value;
            //alert(speed);

            var chartAmp = $('#Ampcontainer').highcharts();
            //chartAmp.series[0].remove();
            

            //making serie for limit line
            var v_limit = [];
            for (var i = 0; i < data.C_time.length; i++) {
                var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                v_limit.push([time, speed]);
            }
            chartAmp.series[chartAmp.series.length - 1].remove();
            
            chartAmp.addSeries({
                    name: "Limit=" + speed + "m/s",
                    data: v_limit,
                    visible: true,
                    tooltip: {
                        valueSuffix: "m/s"
                    }
                });
        }

        // Update charts with wave data
        function updateCharts(data) {
            
            var mtchart = $('#MTcontainer').highcharts();
            var maree = [];
            var tempeau = [];
            var sal = [];


            for (var i = 0; i < data.SBE_time.length; i++) {
                var time = Date.parse(data.SBE_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                //maree.push([time, data.C_press[i]]);
                tempeau.push([time, data.SBE_temp[i]]);
                sal.push([time, data.SBE_sal[i]]);
            }
            //for (var i = 0; i < data.C_time.length; i++) {
            //    var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
            //    maree.push([time, data.C_press[i]]);
            //    tempeau.push([time, data.C_temp[i]]);
            //}

            mtchart.series[0].setData(tempeau);
            mtchart.series[1].setData(sal);
            //mtchart.series[1].setData(maree);

            
            var chart = $('#ProfileAmpcontainer').highcharts();
            var charProftDir = $('#ProfileDircontainer').highcharts();
            var Amplitude = [];
            var AmplitudeGrouped = [];
            var Direction = [];
			
            var maxAmp = 0.0;
            for (var i = 0; i < data.C_time.length; i++) {
                for (var j = 0; j < data.C_amp[0].length; j++) {
                    var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                    Amplitude.push([time, (j+1) * data.C_cellsize + data.C_blancking, data.C_amp[i][j]]);
                    Direction.push([time, (j+1) * data.C_cellsize + data.C_blancking, data.C_dir[i][j]]);
                    maxAmp = Math.max(maxAmp, data.C_amp[i][j]);
                }
            }



            //if(data.C_time.length>1000)
            //{
            //    var factor = data.C_time.length / 500;
            //    data.C_time.length
            //}

            
            chart.colorAxis[0].update({ min: 0, max: maxAmp });
            
            charProftDir.colorAxis[0].update({ min: 0, max: 360 });
            charProftDir.yAxis[0].update({ max: data.C_amp[0].length * data.C_cellsize + data.C_blancking });

            chart.series[0].update({
                data: Amplitude,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, false); //true / false to redraw


            charProftDir.series[0].update({
                data: Direction,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, false); //true / false to redraw
            

            var speed = +document.getElementById('speed').value;
            //alert(speed)

            var Amp_unit = ' ' + document.getElementById('<%=speedunit.ClientID%>').value;
            var direction_unit = ' °';
            // Chart immersion  fixe"
            var chartAmp = $('#Ampcontainer').highcharts();
            //for (var i = chartAmp.series.length - 1; i > 0; i--) {  //0 to keep first serie that is limit value
            for (var i = chartAmp.series.length - 1; i > -1; i--) {
                chartAmp.series[i].remove();
            }
            
            //while (chartAmp.series.length>0){
            //    chartAmp.series[0].remove();
            //}

            var chartDir = $('#Dircontainer').highcharts();
            for (var i = chartDir.series.length - 1; i > -1; i--) {
                chartDir.series[i].remove();
            }
            //while (chartDir.series.length > 0) {
            //    chartDir.series[0].remove();
            //}

            

            for (var j = 0; j < data.C_amp[0].length; j++) {

                var amp = [];
                var dir = [];

                for (var i = 0; i < data.C_time.length; i++) {
                    var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                    amp.push([time, data.C_amp[i][j]]);
                    //console.log( 'amp[][] = ' + data.C_amp[i][j].toString() )
                    dir.push([time, data.C_dir[i][j]]);
                    //amp.push([Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.C_amp[i][j]]);
                    //console.log( 'amp[][] = ' + data.C_amp[i][j].toString() )
                    //dir.push([Date.parse(data.C_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.C_dir[i][j]]);

                    
                }

                chartAmp.addSeries({
                    name: "H=" + ((j + 1) * data.C_cellsize + data.C_blancking) + "m",
                    data: amp,
                    visible: false,
                    tooltip: {
                        valueSuffix: Amp_unit.toString()
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
                        valueSuffix: ' ' + direction_unit.toString()
                        }    
                });
                
                ////chartDir.series[j].update({ lineWidth: 0 });
                
                
            }

            //making serie for limit line
            var v_limit = [];
            for (var i = 0; i < data.C_time.length; i++) {
                var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                v_limit.push([time, speed]);
            }
            chartAmp.addSeries({
                    name: "Limit=" + speed + "m/s",
                    data: v_limit,
                    visible: true,
                    tooltip: {
                        valueSuffix: "m/s"
                    }
                });

            //for (var i = 0; i < data.C_time.length; i++) {
            //    var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
            //    v_limit.push([time, speed]);
            //}
            //chartAmp.addSeries({
            //        name: "Limit=" + speed + "m/s",
            //        data: v_limit,
            //        visible: false,
            //        tooltip: {
            //            valueSuffix: Amp_unit.toString()
            //        }
            //});


            //chartAmp.series[1].setData(v_limit);
            
            chartDir.yAxis[0].update({ min: 0, max: 360 });
            chartAmp.series[0].update({ visible: true });
            //chartAmp.series[1].update({ visible: true });
            chartDir.series[0].update({ visible: true });

            chart.redraw();
            charProftDir.redraw();

        };

    </script>

<script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var profdir_label = document.getElementById('<%=profdir_label.ClientID%>').value;
        var profspeed_label = document.getElementById('<%=profspeed_label.ClientID%>').value;

        var dir_unit = document.getElementById('<%=direction_unit.ClientID%>').value;
        var dir_label = document.getElementById('<%=direction_label.ClientID%>').value;


        var par2_label = document.getElementById('<%=templabel.ClientID%>').value;
        var par2_name = document.getElementById('<%=tempname.ClientID%>').value;
        var par2_unit = " " + document.getElementById('<%=tempunit.ClientID%>').value;

        var par4_label = document.getElementById('<%=speedlabel.ClientID%>').value;
        var par4_name = document.getElementById('<%=speedname.ClientID%>').value;
        var par4_unit = " " + document.getElementById('<%=speedunit.ClientID%>').value;

        var s_high_label = document.getElementById('<%=high_label.ClientID%>').value;

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
                text: profspeed_label.toString(),
                align: 'left',
                x: 40
            },
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                uniqueNames: false
            },

            yAxis: {
                title: {
                    text: s_high_label.toString() + ' '
                },
                tickInterval: 2,
                labels: {
                    format: '{value} m'
                },
                startOnTick: false,
                endOnTick: false,
                reversed: true
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
                    format: '{value} m/s'
                }
            },

            series: [{
                name: par4_label.toString(),
                //borderWidth: 0,
                data: [],
                colsize: 1000, // one second
                    tooltip: {
                        pointFormat: '{point.x:%d/%m/%Y, %Hh%M} {point.y}m <b>{point.value} m/s</b>'
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
            text: profdir_label.toString(),
            align: 'left',
            x: 40
        },
        xAxis: {
            type: 'datetime',
            minTickInterval: 30,
            uniqueNames: false
        },

        yAxis: {
            title: {
                text: s_high_label.toString()
            },
            min: 0,
            tickInterval: 2,
            reversed: false,
            labels: {
                format: '{value} m'
            },
            startOnTick: false,
            endOnTick: false,
            reversed: true
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
                format: '{value} ' + dir_unit.toString()
            }
        },
        series: [{
            name: dir_label.toString(),
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
                text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
            },
            tickPixelInterval: 80,
            gridLineWidth: 1,
            uniqueNames: false
        },
        yAxis: [{
            min: 0,
           
            startOnTick: true,
            title: {
                min: 0,
                text: par4_label.toString()
            },
            labels: {
                format: '{value} m/s'
            },
            gridLineWidth: 1
        }],
        legend: {
            layout: 'horizontal',
            align: 'left',
            verticalAlign: 'top',
            floating: false
        }
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
                text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
            },
            tickPixelInterval: 80,
            gridLineWidth: 1,
            uniqueNames: false
        },
        yAxis: [{
            min: 0,
            max: 360,
           
            tickInterval: 45,
            title: {
                min: 0,
                text: dir_label.toString(),
            },
            labels: {
                format: '{value} ' + '°'
            },
            gridLineWidth: 1
        }],
        legend: {
            layout: 'horizontal',
            align: 'left',
            verticalAlign: 'top',
            floating: false,
        }
    });

        $('#MTcontainer').highcharts({

            xAxis: {
                type: 'datetime',
                title: {
                    text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                title: {
                    text: par2_label.toString(),
                    style: {
                        color: 'black'
                    }
                },
                labels: {
                    format: '{value} ' + par2_unit.toString(),
                    style: {
                        color: 'black'
                    }
                }
                ,
            }
                , {
                title: {
                    text: "Salinity ",
                    style: {
                        color: '#FCA000'
                    }
                },
                labels: {
                    format: '{value} ' + "g/kg",
                    style: {
                        color: '#FCA000'
                    }
                },
                opposite: true
            }],
            series: [
                {
                    name: par2_label.toString(),
                    data: [],
                    color: 'black',
                    animation: false,
                    tooltip: {
                        valueSuffix: ' ' + par2_unit.toString()
                        }
                }
                ,
                {
                    name: 'salinity',
                    data: [],
                    color: '#FCA000',
                    yAxis: 1,
                    animation: false,
                    tooltip: {
                        valueSuffix: ' ' + "g/kg"
                    }
                }
            ]
        });

    initData();

    });
</script>

</asp:Content>

