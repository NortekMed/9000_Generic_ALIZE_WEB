<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Meteo.aspx.cs" Inherits="Meteo"%>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        
                                 

    <script src="https://code.highcharts.com/8.0.4/highcharts.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

    <asp:HiddenField ID = "page_name" Value="<%$ Resources:Site.master, weather %>" Runat="Server" />


    <asp:HiddenField ID = "start" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "end" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "refresh" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_data" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "last" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "historical" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "hour" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "_0_equipname" ClientIdMode="Static" Runat="Server"/>
    <asp:HiddenField ID = "_0_equipname_alias" ClientIdMode="Static" Runat="Server"/>
	<asp:HiddenField ID = "_1_equipname" ClientIdMode="Static" Runat="Server"/>
	<asp:HiddenField ID = "_2_equipname" ClientIdMode="Static" Runat="Server"/>
    <asp:HiddenField ID = "_2_equipname_alias" ClientIdMode="Static" Runat="Server"/>
	<asp:HiddenField ID = "_3_equipname" ClientIdMode="Static" Runat="Server"/>
	<asp:HiddenField ID = "_4_equipname" ClientIdMode="Static" Runat="Server"/>

    <asp:HiddenField ID = "temperature"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "pressure"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "humidity"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_acc"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_duration"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_intensity"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_avg"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_avg"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_max"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "wind_speed_min"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_min"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "temp_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "press_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_avg_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "voltage_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "lat_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "lng_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "gps_quality_airmar"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "nb_satelite_airmar"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "temperature_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "pressure_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "humidity_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_acc_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_duration_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_intensity_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_avg_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_avg_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_max_unit"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "temp_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "press_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_avg_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "voltage_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "lat_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "lng_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "gps_quality_airmar_unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "nb_satelite_airmar_unit"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "temperature_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "pressure_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "humidity_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_acc_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_duration_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "rain_intensity_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_avg_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_avg_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max_label_alias"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_min_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_max_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_min_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "temp_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "press_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_avg_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_speed_max_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "wind_dir_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "voltage_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "lat_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "lng_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "gps_quality_airmar_label"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "nb_satelite_airmar_label"  ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "declination_label" Value="<%$ Resources:Site.master, declination %>" Runat="Server" />

    <asp:HiddenField ID = "light_site" ClientIdMode="Static" Runat="Server"/>
		
    
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


            document.write('<asp:Button runat="server" ID="DownloadWindButton" Text="" class="btn btn-default" OnClick="DownloadWind" />');
            document.write('<asp:Button runat="server" ID="DownloadMeteoButton" Text="" class="btn btn-default" OnClick="DownloadMeteo" />');

            document.write('</div><br><br>')
        }

    </script>


    <div class="speedInputGroup">
        <label for="speed">Enter speed limit — in m/s :</label>
        <input id="speed" type="number" name="speed" step="0.1" min="0" max="20" value="0" required>
        <span class="validity"></span>
        <a class="btn btn-default" onclick="updateData()">Trace</a>
    </div>

    <script type="text/javascript">
        var label = document.getElementById('<%=_2_equipname_alias.ClientID%>').value;
        var label_decl = document.getElementById('<%=declination_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + ' - ' + label_decl + ' : ' + '</b> <label class="indent" id="l_decl">X</label>' + '</b></div>');
        document.write('  wind at 3.3m above sea level');
        //document.write('<div class="panel-heading"><b>' + label + '</b></div>');document.write('  wind at 3.5m above sea level');
        document.write('<div class="panel-body">');
        document.write('<div id="param2container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=_0_equipname_alias.ClientID%>').value;
            
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param0container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=humidity_label.ClientID%>').value;


        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label.toUpperCase() + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="humcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <%--<script type="text/javascript">
        var label = document.getElementById('<%=_1_equipname.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param1container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>--%>

    

    <%--<script type="text/javascript">
        var label = document.getElementById('<%=_3_equipname.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param3container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=_3_equipname.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + 'Vent ' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param4container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>--%>

    <%--<script type="text/javascript">
        var label = document.getElementById('<%=voltage_airmar_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param5container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>--%>

    

    <script type="text/javascript">
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
                url: "Meteo.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateCharts(data.d);
                },
                error : function() {
                    alert('Meteo : erreur de chargement ou pas de données');
                }
            });
        }

        // Update charts with meteo data
        function updateCharts(data) {

            $('#l_decl').text(data.declination.toFixed(2));

            // Param0 chart -- Temp
            var chartpar0 = $('#param0container').highcharts();
            var chartpar1 = $('#param1container').highcharts();
            var chartpar2 = $('#param2container').highcharts();
            //var chartpar3 = $('#param3container').highcharts();
            //var chartpar4 = $('#param4container').highcharts();
            var chartpar5 = $('#param5container').highcharts();

            var charthum = $('#humcontainer').highcharts();
            
            var par0 = [];
            var par1 = [];
            var par2 = [];
            var par3 = [];
            var par4 = [];
            var par5 = [];
            var par6 = [];
            var par7 = [];
            var par8 = [];
            var par9 = [];
            var par10 = [];
            var par11 = [];
            var par12 = [];
            var par13 = [];
            var par14 = [];
            var par15 = [];
            var par16 = [];
            var par17 = [];
            var par18 = [];
            var par19 = [];

            

            //METEO Vaissala
            for (var i = 0; i < data.wxt_str_time.length; i++) {
                par0.push([Date.parse(data.wxt_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wxt_temp[i]]);
                par1.push([Date.parse(data.wxt_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wxt_press[i]]);
                par2.push([Date.parse(data.wxt_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wxt_hum[i]]);
            }

            //PLUIE Vaissala
            //for (var i = 0; i < data.str_time1.length; i++) {
            //    par3.push([Date.parse(data.str_time1[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param3[i]]);
            //    par4.push([Date.parse(data.str_time1[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param4[i]]);
            //    par5.push([Date.parse(data.str_time1[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param5[i]]);
            //}


            var speed = +document.getElementById('speed').value;
            var l_speed = [];
            //VENT Vaissala
            for (var i = 0; i < data.wxt_wind_str_time.length; i++) {
                var time = Date.parse(data.wxt_wind_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                par6.push([time, data.wxt_wind_speed_avg[i]]);
                par7.push([time, data.wxt_wind_dir_avg[i]]);
                par8.push([time, data.wxt_wind_speed_max[i]]);
                par9.push([time, data.wxt_wind_dir_max[i]]);
                l_speed.push([time, speed]);
            }

            //METEO_AIRMAR
            for (var i = 0; i < data.wx_str_time.length; i++) {
                par10.push([Date.parse(data.wx_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_temp[i]]);
                par11.push([Date.parse(data.wx_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_press[i]]);
                par12.push([Date.parse(data.wx_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_wind_speed_avg[i]]);
                par13.push([Date.parse(data.wx_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_wind_speed_max[i]]);
                par14.push([Date.parse(data.wx_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_wind_dir[i]]);
                par15.push([Date.parse(data.wx_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_volt[i]]);
            }


            //GPS Airmar
            for (var i = 0; i < data.wx_gps_str_time.length; i++) {
                par16.push([Date.parse(data.wx_gps_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_lat[i]]);
                par17.push([Date.parse(data.wx_gps_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_lng[i]]);
                par18.push([Date.parse(data.wx_gps_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_gps_q[i]]);
                par19.push([Date.parse(data.wx_gps_str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.wx_gps_nb[i]]);
            }

            
            //chart meteo vaissala temp / press / hum
            chartpar0.series[0].setData(par0);
            chartpar0.series[1].setData(par1);
            //chartpar0.series[2].setData(par2);    // not display humidity

            charthum.series[0].setData(par2);

            //chart pluie ( vaissala ) rd / rc / ri
            //chartpar1.series[0].setData(par3);
            //chartpar1.series[1].setData(par4);
            //chartpar1.series[2].setData(par5);    // no display ri

            //chart vent vaissala vmoy / dirmoy / vmax / dirmax
            chartpar2.series[0].setData(par6);
            chartpar2.series[1].setData(par7);
            chartpar2.series[2].setData(par8);
            chartpar2.series[3].setData(l_speed);
            //chartpar2.series[3].setData(par9);    //not display dirmax
            


            ////chart meteo airmar - temp / pression
            //chartpar3.series[0].setData(par10);
            //chartpar3.series[1].setData(par11);

            ////Chart vent ( airmare ) wsmoy / wsmax / wd
            //chartpar4.series[0].setData(par12);
            //chartpar4.series[1].setData(par13);
            //chartpar4.series[2].setData(par14);

            //chart voltage airmare
            chartpar5.series[0].setData(par15);


        };

    </script>

    
    <script type="text/javascript">
        $(function () {

            var hour = document.getElementById('<%=hour.ClientID%>').value;

            var par0_label = document.getElementById('<%=temperature_label.ClientID%>').value;
            var par0_name = document.getElementById('<%=temperature.ClientID%>').value;
            var par0_unit = " " + document.getElementById('<%=temperature_unit.ClientID%>').value;

            var par1_label = document.getElementById('<%=pressure_label.ClientID%>').value;
            var par1_name = document.getElementById('<%=pressure.ClientID%>').value;
            var par1_unit = " " + document.getElementById('<%=pressure_unit.ClientID%>').value;

            <%--var par2_label = document.getElementById('<%=humidity_label.ClientID%>').value;
            var par2_name = document.getElementById('<%=humidity.ClientID%>').value;
            var par2_unit = " " + document.getElementById('<%=humidity_unit.ClientID%>').value;--%>

            $('#param0container').highcharts({
            
                xAxis: {
                    type: 'datetime',
                    minTickInterval: 30,
                    title: {
                        text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                    },
                    tickPixelInterval: 80,
                    gridLineWidth: 1
                },
                yAxis: [
                    {
                        min: -5,
                        //max: 60,
                        //tickInterval: 1,
                        title: {
                            text: par0_label.toString(),
                            style: {
                                color: '#FF3333'
                            }
                        },
                        labels: {
                            enabled: true,
                            format: '{value}' + par0_unit.toString(),
                            style: {
                                color: '#FF3333'
                            }
                        }
                    },
                    {
                        min: 1000,
                        opposite: true,
                        max: 1060,
                        //tickInterval: 45,
                        title: {
                            text: par1_label.toString(),
                            style: {
                                color: '#FCA000'
                            }
                        },
                        labels: {
                            enabled: true,
                            format: '{value}' + par1_unit.toString(),
                            style: {
                                color: '#FCA000'
                            }
                        }
                    }
                ],
                series: [
                    {
                        name: par0_label.toString(),
                        data: [],
                        color: '#FF3333',
                        animation: true,
                        tooltip: {
                            valueSuffix: ' ' + par0_unit.toString()
                        }
                    }, {
                        name: par1_label.toString(),
                        data: [],
                        yAxis: 1,
                        color: '#FCA000',
                        animation: true,
                        tooltip: {
                            valueSuffix: ' ' + par1_unit.toString()
                        }
                    }
                ]
            });
        });
    </script>


    <script type="text/javascript">
        $(function () {

            var hour = document.getElementById('<%=hour.ClientID%>').value;

            var par2_label = document.getElementById('<%=humidity_label.ClientID%>').value;
            var par2_name = document.getElementById('<%=humidity.ClientID%>').value;
            var par2_unit = " " + document.getElementById('<%=humidity_unit.ClientID%>').value;

            $('#humcontainer').highcharts({
            
                xAxis: {
                    type: 'datetime',
                    minTickInterval: 30,
                    title: {
                        text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                    },
                    tickPixelInterval: 80,
                    gridLineWidth: 1
                },
                yAxis: [
                    {
                        min: 0,
                        opposite: true,
                        max: 100,
                        //tickInterval: 45,
                        title: {
                            text: par2_label.toString(),
                            style: {
                                color: '#FCAAF0'
                            }
                        },
                        labels: {
                            enabled: true,
                            format: '{value}' + par2_unit.toString(),
                            style: {
                                color: '#FCAAF0'
                            }
                        }
                    }
                ],
                series: [
                    {
                        name: par2_label.toString(),
                        data: [],
                        color: '#FCAAF0',
                        animation: true,
                        tooltip: {
                            valueSuffix: ' ' + par2_unit.toString()
                        }
                    }

                ]
            });
        });
    </script>

    <script type="text/javascript">
        $(function () {

            var hour = document.getElementById('<%=hour.ClientID%>').value;

            var par3_label = document.getElementById('<%=rain_acc_label.ClientID%>').value;
            var par3_name = document.getElementById('<%=rain_acc.ClientID%>').value;
            var par3_unit = " " + document.getElementById('<%=rain_acc_unit.ClientID%>').value;

            var par4_label = document.getElementById('<%=rain_duration_label.ClientID%>').value;
            var par4_name = document.getElementById('<%=rain_duration.ClientID%>').value;
            var par4_unit = " " + document.getElementById('<%=rain_duration_unit.ClientID%>').value;

            <%--var par5_label = document.getElementById('<%=rain_intensity_label.ClientID%>').value;
            var par5_name = document.getElementById('<%=rain_intensity.ClientID%>').value;
            var par5_unit = " " + document.getElementById('<%=rain_intensity_unit.ClientID%>').value;--%>


            $('#param1container').highcharts({
                xAxis: {
                    type: 'datetime',
                    minTickInterval: 30,
                    title: {
                        text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                    },
                    tickPixelInterval: 80,
                    gridLineWidth: 1
                },
                yAxis: [
                    {
                        min: 0,
                        max: 50,
                        //tickInterval: 1,
                        title: {
                            text: par3_label.toString(),
                            style: {
                                color: '#FF3333'
                            }
                        }
                        ,
                        labels: {
                            enabled: true,
                            format: '{value}' + par3_unit.toString(),
                            style: {
                                color: '#FF3333'
                            }
                        }
                    },
                    {
                        min: 0,
                        opposite: true,
                        //max: 360,
                        //tickInterval: 45,
                        title: {
                            text: par4_label.toString(),
                            style: {
                                color: '#FCA000'
                            }
                        },
                        labels: {
                            enabled: true,
                            format: '{value}' + par4_unit.toString(),
                            style: {
                                color: '#FCA000'
                            }
                        }
                    }
                ],
                series: [
                    {
                        name: par3_label.toString(),
                        data: [],
                        color: '#FF3333',
                        animation: true,
                        tooltip: {
                            valueSuffix: ' ' + par3_unit.toString()
                        }
                    }, {
                        name: par4_label.toString(),
                        data: [],
                        yAxis: 1,
                        color: '#FCA000',
                        animation: true,
                        tooltip: {
                            valueSuffix: ' ' + par4_unit.toString()
                        }
                    }

                ]
            });
        });
    </script>

    <script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var par6_label = document.getElementById('<%=wind_speed_avg_label.ClientID%>').value;
        var par6_name = document.getElementById('<%=wind_speed_avg.ClientID%>').value;
        var par6_unit = " " + document.getElementById('<%=wind_speed_avg_unit.ClientID%>').value;

        var par7_label = document.getElementById('<%=wind_dir_avg_label.ClientID%>').value;
        var par7_name = document.getElementById('<%=wind_dir_avg.ClientID%>').value;
        var par7_unit = " " + document.getElementById('<%=wind_dir_avg_unit.ClientID%>').value;

        var par8_label = document.getElementById('<%=wind_speed_max_label_alias.ClientID%>').value;
        var par8_name = document.getElementById('<%=wind_speed_max.ClientID%>').value;
        var par8_unit = " " + document.getElementById('<%=wind_speed_max_unit.ClientID%>').value;

        var par9_label = document.getElementById('<%=wind_dir_max_label.ClientID%>').value;
        var par9_name = document.getElementById('<%=wind_dir_max.ClientID%>').value;
        var par9_unit = " " + document.getElementById('<%=wind_dir_max_unit.ClientID%>').value;

        <%--var par3_label = document.getElementById('<%=param3label.ClientID%>').value;
        var par3_name = document.getElementById('<%=param3name.ClientID%>').value;
        var par3_unit = " " + document.getElementById('<%=param3unit.ClientID%>').value;--%>

        $('#param2container').highcharts({
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [
                {
                    min: 0,
                    //tickInterval: 1,
                    title: {
                        text: par6_label.toString(),
                        style: {
                            color: '#FF3333'
                        }
                    }
                    ,
                    labels: {
                        enabled: true,
                        format: '{value}' + par6_unit.toString(),
                        style: {
                            color: 'black' //'#FF3333'
                        }
                    }
                },
                {
                    min: 0,
                    max: 360,
                    opposite: true,
                    //tickInterval: 1,
                    title: {
                        text: par7_label.toString(),
                        style: {
                            color: '#0282AD'
                        }
                    }
                    ,
                    labels: {
                        enabled: true,
                        format: '{value}' + par7_unit.toString(),
                        style: {
                            color: '#0282AD'
                        }
                    }
                },
                {
                    min: 0,
                    //max: 360,
                    //tickInterval: 45,
                    title: {
                        text: par8_label.toString(),
                        style: {
                            color: '#FCA000'
                        }
                    }
                    //,
                    //labels: {
                    //    enabled: true,
                    //    format: '{value}' + par8_unit.toString(),
                    //    style: {
                    //        color: '#FCA000'
                    //    }
                    //}
                }
            ],
            series: [
                {
                    name: par6_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par6_unit.toString()
                    }
                },{
                    name: par7_label.toString(),
                    data: [],
                     yAxis: 1,
                    color: '#0282AD',
                    lineWidth: 0,
                    marker: {
                        enabled: true,
                        symbol: 'diamond'
                    },
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par7_unit.toString()
                    }
                },{
                    name: par8_label.toString(),
                    data: [],
                    color: '#FCA000',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par8_unit.toString()
                    }
                },{
                    name: 'Speed limit',
                    data: [],
                    color: 'red',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' m/s'
                    }
                }
            ]
        });
    });
    </script>

    <script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var par10_label = document.getElementById('<%=temp_airmar_label.ClientID%>').value;
        var par10_name = document.getElementById('<%=temp_airmar.ClientID%>').value;
        var par10_unit = " " + document.getElementById('<%=temp_airmar_unit.ClientID%>').value;

        var par11_label = document.getElementById('<%=press_airmar_label.ClientID%>').value;
        var par11_name = document.getElementById('<%=press_airmar.ClientID%>').value;
        var par11_unit = " " + document.getElementById('<%=press_airmar_unit.ClientID%>').value;

        $('#param3container').highcharts({
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [
                {
                    min: 0,
                    //tickInterval: 1,
                    title: {
                        text: par10_label.toString(),
                        style: {
                            color: '#FF3333'
                        }
                    }
                    ,
                    labels: {
                        enabled: true,
                        format: '{value}' + par10_unit.toString(),
                        style: {
                            color: '#FF3333'
                        }
                    }
                },
                {
                    min: 1000,
                    opposite: true,
                    max: 1060,
                    //tickInterval: 45,
                    title: {
                        text: par11_label.toString(),
                        style: {
                            color: '#FCA000'
                        }
                    },
                    labels: {
                        enabled: true,
                        format: '{value}' + par11_unit.toString(),
                        style: {
                            color: '#FCA000'
                        }
                    }
                }
            ],
            series: [
                {
                    name: par10_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par10_unit.toString()
                    }
                }, {
                    name: par11_label.toString(),
                    data: [],
                    yAxis: 1,
                    color: '#FCA000',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par11_unit.toString()
                    }
                }

            ]
        });
    });
    </script>

    <script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var par12_label = document.getElementById('<%=wind_speed_avg_airmar_label.ClientID%>').value;
        var par12_name = document.getElementById('<%=wind_speed_avg_airmar.ClientID%>').value;
        var par12_unit = " " + document.getElementById('<%=wind_speed_avg_airmar_unit.ClientID%>').value;

        var par13_label = document.getElementById('<%=wind_speed_max_airmar_label.ClientID%>').value;
        var par13_name = document.getElementById('<%=wind_speed_max_airmar.ClientID%>').value;
        var par13_unit = " " + document.getElementById('<%=wind_speed_max_airmar_unit.ClientID%>').value;

        var par14_label = document.getElementById('<%=wind_dir_airmar_label.ClientID%>').value;
        var par14_name = document.getElementById('<%=wind_dir_airmar.ClientID%>').value;
        var par14_unit = " " + document.getElementById('<%=wind_dir_airmar_unit.ClientID%>').value;


        $('#param4container').highcharts({
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [
                {
                    min: 0,
                    //tickInterval: 1,
                    title: {
                        text: par12_label.toString(),
                        style: {
                            color: '#FF3333'
                        }
                    }
                    ,
                    labels: {
                        enabled: true,
                        format: '{value}' + par12_unit.toString(),
                        style: {
                            color: 'black'
                        }
                    }
                },
                {
                    min: 0,
                    //max: 360,
                    //tickInterval: 45,
                    title: {
                        text: par13_label.toString(),
                        style: {
                            color: '#0282AD'
                        }
                    }
                    //,
                    //labels: {
                    //    enabled: true,
                    //    format: '{value}' + par13_unit.toString(),
                    //    style: {
                    //        color: '#0282AD'
                    //    }
                    //}
                },
                {
                    min: 0,
                    opposite: true,
                    max: 360,
                    //tickInterval: 45,
                    title: {
                        text: par14_label.toString(),
                        style: {
                            color: '#FCA000'
                        }
                    },
                    labels: {
                        enabled: true,
                        format: '{value}' + par14_unit.toString(),
                        style: {
                            color: '#FCA000'
                        }
                    }
                }
            ],
            series: [
                {
                    name: par12_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par12_unit.toString()
                    }
                }, {
                    name: par13_label.toString(),
                    data: [],
                    color: '#0282AD',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par13_unit.toString()
                    }
                }, {
                    name: par14_label.toString(),
                    data: [],
                    yAxis: 2,
                    color: '#FCA000',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par14_unit.toString()
                    }
                }

            ]
        });
    });
    </script>

    <script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var par15_label = document.getElementById('<%=voltage_airmar_label.ClientID%>').value;
        var par15_name = document.getElementById('<%=voltage_airmar.ClientID%>').value;
        var par15_unit = " " + document.getElementById('<%=voltage_airmar_unit.ClientID%>').value;


        $('#param5container').highcharts({
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: hour.toString() + ' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)'
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [
                {
                    min: 0,
                    //tickInterval: 1,
                    title: {
                        text: par15_label.toString(),
                        style: {
                            color: '#FF3333'
                        }
                    }
                    ,
                    labels: {
                        enabled: true,
                        format: '{value}' + par15_unit.toString(),
                        style: {
                            color: '#FF3333'
                        }
                    }
                }
            ],
            series: [
                {
                    name: par15_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: ' ' + par15_unit.toString()
                    }
                }
            ]
        });
    });
    </script>

    <script type="text/javascript">
        $(function () {
            // Init charts with last 24hours values
            initData();
        });

    </script>
</asp:Content>