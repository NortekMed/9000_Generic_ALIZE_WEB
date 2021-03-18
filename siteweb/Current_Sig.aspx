<%@ Page Title="Courant" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Current_Sig.aspx.cs" Inherits="SIG_Current" %>

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

    <asp:HiddenField ID = "headingname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "headingunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "headinglabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "voltname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "voltunit"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "msg_info_0" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "high_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "direction_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "direction_unit" ClientIdMode="Static" Runat="Server" />
    <%--<asp:HiddenField ID = "speed_label" ClientIdMode="Static" Runat="Server" />--%>
    <asp:HiddenField ID = "profdir_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "profspeed_label" ClientIdMode="Static" Runat="Server" />

     <asp:HiddenField ID = "profamp_label" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "declination_label" Value="<%$ Resources:Site.master, declination %>" Runat="Server" />


    <asp:HiddenField ID = "light_site" ClientIdMode="Static" Runat="Server"/>
    <asp:HiddenField ID = "b_decl_hd" ClientIdMode="Static" Runat="Server"/>

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

        var site_light = light_site.value;


        if (site_light == "false") {        

            document.write('<div id="Top" style="width: 100 %; ">');
            document.write('<div id="q_opt" class="btn-group" data-toggle="buttons">');
            document.write('<label class="btn btn-default active" id="d_realtime" > <input id="q_op_1" name="op" type="radio" value="1" checked>' + l_last + ' 24h</label > ');
            document.write('<label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2" >' + l_historical + '</label>');
            document.write('</div><br>');

            document.write('<div class="hidden" id="history"> <br>');
            document.write('<div class="input-group date">');



            document.write('<div class="col-md-4">');
            document.write('<div class="form - group">');
            document.write('<input type="text" class="form - control" id="datetimepicker1" value="' + l_start + '"/>');
            document.write('</div></div>');

            document.write("<div class='col-md-4'>");
            document.write('<div class="form - group">');
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
        }

    </script>

    
    <div class="speedInputGroup">
        <label for="speed">Enter speed limit — in m/s :</label>
        <input id="speed" type="number" name="speed" step="0.1" min="0" max="20" value="0" required>
        <span class="validity"></span>
        <a class="btn btn-default" onclick="updateDataLimit()">Trace</a>
    </div>

    <div>
    </div>

    <script type="text/javascript">
        var label = document.getElementById('<%=speedlabel.ClientID%>').value;
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
         document.write('<div class="panel-body">');
        document.write('<div id="Spdcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=direction_label.ClientID%>').value;
        var l_decl = document.getElementById('<%=declination_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');

        var b_decl = b_decl_hd.value;
        if (b_decl == "true")
            document.write('<div class="panel-heading"><b>' + label + ' - ' + l_decl + ' : ' + '</b> <label class="indent" id="ldecl">X</label>' + '</b></div>');
        else
            document.write('<div class="panel-heading"><b>' + label + '</b> </div>');

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
        document.write('<div id="ProfileSpdcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=profdir_label.ClientID%>').value;
        var label_decl = document.getElementById('<%=declination_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + ' - ' + label_decl + ' : ' + '</b> <label class="indent" id="ldecl2">X</label>' + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="ProfileDircontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

          
    <script type="text/javascript">
        var label = document.getElementById('<%=profamp_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="ProfileSnrcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <%--<script type="text/javascript">
        var label = "water " + document.getElementById('<%=templabel.ClientID%>').value.toLowerCase() + ' (' + "<%=ConfigurationManager.AppSettings["Looking"] %>" + ')';
        
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="MTcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>--%>
    

      

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

            alert('getDataLimit');

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

            var chartSpd = $('#Spdcontainer').highcharts();
            //chartAmp.series[0].remove();
            

            //making serie for limit line
            var v_limit = [];
            for (var i = 0; i < data.C_time.length; i++) {
                var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                v_limit.push([time, speed]);
            }
            chartSpd.series[chartSpd.series.length - 1].remove();
            
            chartSpd.addSeries({
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

            //var mtchart = $('#MTcontainer').highcharts();
            //var maree = [];
            //var tempeau = [];
            //var sal = [];


            //for (var i = 0; i < data.SBE_time.length; i++) {
            //    var time = Date.parse(data.SBE_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
            //    //maree.push([time, data.C_press[i]]);
            //    tempeau.push([time, data.SBE_temp[i]]);
            //    sal.push([time, data.SBE_sal[i]]);
            //}
            //mtchart.series[0].setData(tempeau);
            //mtchart.series[1].setData(sal);

            //$('#l_decl').text(data.declination.toFixed(2));
            //$('#l_decl2').text(data.declination.toFixed(2));
            $('#ldecl').text(data.declination.toFixed(2));
            $('#ldecl2').text(data.declination.toFixed(2));
            
            var chart = $('#ProfileSpdcontainer').highcharts();
            var charProftDir = $('#ProfileDircontainer').highcharts();
            var charProfSnr = $('#ProfileSnrcontainer').highcharts();
            var Speed = [];
            var AmplitudeGrouped = [];
            var Direction = [];
            var Snr = [];
			
            var maxSpd = 0.0;
            for (var i = 0; i < data.C_time.length; i++) {
                for (var j = 0; j < data.C_spd[0].length; j++) {
                    var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                    Speed.push([time, (j+1) * data.C_cellsize + data.C_blancking, data.C_spd[i][j]]);
                    Direction.push([time, (j+1) * data.C_cellsize + data.C_blancking, data.C_dir[i][j]]);
                    Snr.push([time, (j+1) * data.C_cellsize + data.C_blancking, data.C_snr[i][j]]);
                    maxSpd = Math.max(maxSpd, data.C_spd[i][j]);
                }
            }
            
            chart.colorAxis[0].update({ min: 0, max: maxSpd });
            chart.series[0].update({
                data: Speed,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, false); //true / false to redraw


            charProftDir.colorAxis[0].update({ min: 0, max: 360 });
            charProftDir.yAxis[0].update({ max: data.C_spd[0].length * data.C_cellsize + data.C_blancking });
            charProftDir.series[0].update({
                data: Direction,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, false); //true / false to redraw


            //charProfSnr.colorAxis[0].update({ min: 0, max: 255 });
            charProfSnr.colorAxis[0].update({ min: 0, max: 130 });      // in db
            charProfSnr.yAxis[0].update({ max: data.C_snr[0].length * data.C_cellsize + data.C_blancking });
            charProfSnr.series[0].update({
                data: Snr,
                colsize: data.meanTimeInterval,
                rowsize: data.C_cellsize
            }, false); //true / false to redraw
            

            var v_speed = +document.getElementById('speed').value;
            //alert(speed)

            var Spd_unit = ' ' + document.getElementById('<%=speedunit.ClientID%>').value;
            var direction_unit = ' °';
            // Chart immersion  fixe"
            var chartSpd = $('#Spdcontainer').highcharts();
            while (chartSpd.series.length > 0)
                chartSpd.series[0].remove();
            //for (var i = chartSpd.series.length - 1; i > -1; i--) {
            //    chartSpd.series[i].remove();
            //}


            var chartDir = $('#Dircontainer').highcharts();
            while (chartDir.series.length > 0)
                chartDir.series[0].remove();

            //for (var i = chartDir.series.length - 1; i > -1; i--) {
            //    chartDir.series[i].remove();
            //}

            for (var j = 0; j < data.C_spd[0].length; j++) {

                var spd = [];
                var dir = [];

                var add_layer = false;

                for (var i = 0; i < data.Layers.length; i++) {
                    if (data.Layers[i] == (j + 1)) {
                        add_layer = true;
                        break;
                    }
                }
                

                if ((data.Layers.Count == 0) || (add_layer == true))
                {
                    for (var i = 0; i < data.C_time.length; i++) {
                        var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                        spd.push([time, data.C_spd[i][j]]);
                        //console.log( 'amp[][] = ' + data.C_amp[i][j].toString() )
                        dir.push([time, data.C_dir[i][j]]);
                        //dir.series[i].setData([time, data.C_dir[i][j]]);
                        //chartH.series[0].setData(H_max);
                    }

                    chartSpd.addSeries({
                        name: "H=" + ((j + 1) * data.C_cellsize + data.C_blancking) + "m",
                        data: spd,
                        visible: false,
                        tooltip: {
                            valueSuffix: Spd_unit.toString()
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
                }
            }


            //making serie for limit line
            var v_limit = [];
            for (var i = 0; i < data.C_time.length; i++) {
                var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                v_limit.push([time, v_speed]);
            }


            chartSpd.addSeries({
                    name: "Limit=" + v_speed + "m/s",
                    data: v_limit,
                    visible: true,
                    tooltip: {
                        valueSuffix: "m/s"
                    }
                });
            
            chartDir.yAxis[0].update({ min: 0, max: 360 });
            chartSpd.series[0].update({ visible: true });
            chartDir.series[0].update({ visible: true });
            charProfSnr.series[0].update({ visible: true });

            chart.redraw();
            charProftDir.redraw();
            charProfSnr.redraw();

        };

    </script>

<script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var profdir_label = document.getElementById('<%=profdir_label.ClientID%>').value;
        var profspeed_label = document.getElementById('<%=profspeed_label.ClientID%>').value;
        //var profsnr_label = "Amplitude";

        var dir_unit = document.getElementById('<%=direction_unit.ClientID%>').value;
        var dir_label = document.getElementById('<%=direction_label.ClientID%>').value;


        var par2_label = document.getElementById('<%=templabel.ClientID%>').value;
        var par2_name = document.getElementById('<%=tempname.ClientID%>').value;
        var par2_unit = " " + document.getElementById('<%=tempunit.ClientID%>').value;

        var speed_label = document.getElementById('<%=speedlabel.ClientID%>').value;
        var speed_name = document.getElementById('<%=speedname.ClientID%>').value;
        var speed_unit = " " + document.getElementById('<%=speedunit.ClientID%>').value;

        var s_high_label = document.getElementById('<%=high_label.ClientID%>').value;

        $('#ProfileSpdcontainer').highcharts({
            chart: {
                type: 'heatmap',
            },
            exporting: {
		        enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
                sourceWidth: 1200,
                sourceHeight: 500,
            },

            title: {
                //text: profspeed_label.toString(),
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
                name: speed_label.toString(),
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
                //text: profdir_label.toString(),
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


        $('#Spdcontainer').highcharts({
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
                    text: speed_label.toString()
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

        <%--$('#MTcontainer').highcharts({

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
        });--%>



        $('#ProfileSnrcontainer').highcharts({
            chart: {
                type: 'heatmap',
            },
            exporting: {
                enabled: <%=ConfigurationManager.AppSettings["DownloadEnabled"] %>,
                sourceWidth: 1200,
                sourceHeight: 500,
            },

            title: {
                //text: '',
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
                    [0.3, '#00FF00'],
                    [0.8, '#FF0000'],
                    [1, '#FF0000']
                ],
                min: 0,
                max: 255,
                startOnTick: false,
                endOnTick: false,
                //tickPixelInterval: 150,
                labels: {
                    format: '{value} db'
                }
            },

            series: [{
                name: "Magnitude",
                //borderWidth: 0,
                data: [],
                colsize: 1000, // one second
                tooltip: {
                    pointFormat: '{point.x:%d/%m/%Y, %Hh%M} {point.y}m <b>{point.value} db</b>'
                },
            }]
        });

        initData();

    });
</script>

</asp:Content>

