<%@ Page Title="Mesures temps réels" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Realtime.aspx.cs" Inherits="Realtime" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/highcharts-more.js"></script>
    <script src="https://code.highcharts.com/modules/heatmap.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/data.js"></script>
    <script src="https://code.highcharts.com/modules/boost-canvas.js"></script>
    <script src="https://code.highcharts.com/modules/boost.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

    
    <asp:HiddenField ID = "maintitle"  value="<%$ Resources:Site.master, rt_measure %>" Runat="Server" />
    <asp:HiddenField ID = "hour"  value="<%$ Resources:Site.master, hour %>" Runat="Server" />
    <asp:HiddenField ID = "avg_10"  value="<%$ Resources:Site.master, avg_10min %>" Runat="Server" />
    <asp:HiddenField ID = "avg_17"  value="<%$ Resources:Site.master, avg_17min %>" Runat="Server" />

    <asp:HiddenField ID = "meteo_panel"  value="<%$ Resources:Site.master, weather %>" Runat="Server" />
    <asp:HiddenField ID = "w_s_avg"  value="<%$ Resources:Site.master, weather_wind_avg %>" Runat="Server" />
    <asp:HiddenField ID = "w_s_max"  value="<%$ Resources:Site.master, weather_wind_max %>" Runat="Server" />
    <asp:HiddenField ID = "w_dir_avg"  value="<%$ Resources:Site.master, weather_dir_avg %>" Runat="Server" />
    <asp:HiddenField ID = "w_temp"  value="<%$ Resources:Site.master, weather_temp %>" Runat="Server" />
    <asp:HiddenField ID = "w_press"  value="<%$ Resources:Site.master, weather_press %>" Runat="Server" />
    <asp:HiddenField ID = "w_rain_d"  value="<%$ Resources:Site.master, weather_rain_d %>" Runat="Server" />
    <asp:HiddenField ID = "w_rain_acc"  value="<%$ Resources:Site.master, weather_rain_acc %>" Runat="Server" />

    <asp:HiddenField ID = "pyrano_panel"  value="<%$ Resources:pyrano, equip_name %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param0"  value="<%$ Resources:pyrano, param0label %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param1"  value="<%$ Resources:pyrano, param1label %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param2"  value="<%$ Resources:pyrano, param2label %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param3"  value="<%$ Resources:pyrano, param3label %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param0unit"  value="<%$ Resources:pyrano, param0unit %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param1unit"  value="<%$ Resources:pyrano, param1unit %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param2unit"  value="<%$ Resources:pyrano, param2unit %>" Runat="Server" />
    <asp:HiddenField ID = "pyrano_param3unit"  value="<%$ Resources:pyrano, param3unit %>" Runat="Server" />

    <asp:HiddenField ID = "c4e_panel"  value="<%$ Resources:Aquapro_C4E, equip_name %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param0"  value="<%$ Resources:Aquapro_C4E, param0label %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param1"  value="<%$ Resources:Aquapro_C4E, param1label %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param2"  value="<%$ Resources:Aquapro_C4E, param2label %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param3"  value="<%$ Resources:Aquapro_C4E, param3label %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param0unit"  value="<%$ Resources:Aquapro_C4E, param0unit %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param1unit"  value="<%$ Resources:Aquapro_C4E, param1unit %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param2unit"  value="<%$ Resources:Aquapro_C4E, param2unit %>" Runat="Server" />
    <asp:HiddenField ID = "c4e_param3unit"  value="<%$ Resources:Aquapro_C4E, param3unit %>" Runat="Server" />

    <asp:HiddenField ID = "optod_panel"  value="<%$ Resources:Aquapro_Optod, equip_name %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param0"  value="<%$ Resources:Aquapro_Optod, param0label %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param1"  value="<%$ Resources:Aquapro_Optod, param1label %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param2"  value="<%$ Resources:Aquapro_Optod, param2label %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param3"  value="<%$ Resources:Aquapro_Optod, param3label %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param0unit"  value="<%$ Resources:Aquapro_Optod, param0unit %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param1unit"  value="<%$ Resources:Aquapro_Optod, param1unit %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param2unit"  value="<%$ Resources:Aquapro_Optod, param2unit %>" Runat="Server" />
    <asp:HiddenField ID = "optod_param3unit"  value="<%$ Resources:Aquapro_Optod, param3unit %>" Runat="Server" />

    <asp:HiddenField ID = "turbi_panel"  value="<%$ Resources:Aquapro_Turbi, equip_name %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param0"  value="<%$ Resources:Aquapro_Turbi, param0label %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param1"  value="<%$ Resources:Aquapro_Turbi, param1label %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param2"  value="<%$ Resources:Aquapro_Turbi, param2label %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param3"  value="<%$ Resources:Aquapro_Turbi, param3label %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param0unit"  value="<%$ Resources:Aquapro_Turbi, param0unit %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param1unit"  value="<%$ Resources:Aquapro_Turbi, param1unit %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param2unit"  value="<%$ Resources:Aquapro_Turbi, param2unit %>" Runat="Server" />
    <asp:HiddenField ID = "turbi_param3unit"  value="<%$ Resources:Aquapro_Turbi, param3unit %>" Runat="Server" />

    <asp:HiddenField ID = "sig_panel"  value="<%$ Resources:Site.master, prof_current_label %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param0"  value="<%$ Resources:CurrentSIG, param0label %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param1"  value="<%$ Resources:CurrentSIG, param1label %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param2"  value="<%$ Resources:CurrentSIG, param2label %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param3"  value="<%$ Resources:CurrentSIG, param3label %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param4"  value="<%$ Resources:CurrentSIG, param4label %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param0unit"  value="<%$ Resources:CurrentSIG, param0unit %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param1unit"  value="<%$ Resources:CurrentSIG, param1unit %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param2unit"  value="<%$ Resources:CurrentSIG, param2unit %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param3unit"  value="<%$ Resources:CurrentSIG, param3unit %>" Runat="Server" />
    <asp:HiddenField ID = "sig_param4unit"  value="<%$ Resources:CurrentSIG, param4unit %>" Runat="Server" />

    <asp:HiddenField ID = "wave_panel"  value="<%$ Resources:WaveAHRS, equip_name %>" Runat="Server" />
	<asp:HiddenField ID = "wave_param0"  value="<%$ Resources:WaveAHRS, d_avg_label %>" Runat="Server" />
	<asp:HiddenField ID = "wave_param1"  value="<%$ Resources:WaveAHRS, d_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "wave_d_unit"  value="<%$ Resources:WaveAHRS, d_unit %>" Runat="Server" />
	<asp:HiddenField ID = "wave_param2"  value="<%$ Resources:WaveAHRS, h_max_label %>" Runat="Server" />
	<asp:HiddenField ID = "wave_param3"  value="<%$ Resources:WaveAHRS, h_sig_label %>" Runat="Server" />
	<asp:HiddenField ID = "wave_h_unit"  value="<%$ Resources:WaveAHRS, h_unit %>" Runat="Server" />
	<asp:HiddenField ID = "wave_param4"  value="<%$ Resources:WaveAHRS, t_m02_label %>" Runat="Server" />
	<asp:HiddenField ID = "wave_param5"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "wave_t_unit"  value="<%$ Resources:WaveAHRS, t_unit %>" Runat="Server" />


    <asp:HiddenField ID = "b_knots_hd" ClientIdMode="Static" Runat="Server"/>

    <script>
         var time = new Date().getTime();
         //$(document.body).bind("mousemove keypress", function(e) {
         //    time = new Date().getTime();
         //});

        function refresh() {
                //time = new Date().getTime();
                //alert('refresh ask');
            if (new Date().getTime() - time >= 60000)
                window.location.reload(true);
            else {
                time = new Date().getTime();
                setTimeout(refresh, 60000);
            }
                 
         }

         setTimeout(refresh, 10000);
    </script>

    <script type="text/javascript">
        var l_maintitle = document.getElementById('<%=maintitle.ClientID%>').value;
        var l_hour = document.getElementById('<%=hour.ClientID%>').value;

        document.write('<h2>'); document.write(l_maintitle); document.write('</h2><p>');
        document.write(l_hour); document.write(' (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)');
        document.write('&nbsp&nbsp&nbsp');
        document.write('<asp:Button runat="server" ID="SwitchKnotsButton" Text="m/s <-> nd" class="btn btn-default" OnClick="SwitchKnots" />');
        document.write('</p><br>');
        
        
    </script>

    <div class="row">
        <script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=wave_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_17.ClientID%>').value;
            var l_param0 = document.getElementById('<%=wave_param0.ClientID%>').value;
            var l_param1 = document.getElementById('<%=wave_param1.ClientID%>').value;
            var l_param2 = document.getElementById('<%=wave_param2.ClientID%>').value;
            var l_param3 = document.getElementById('<%=wave_param3.ClientID%>').value;
            var l_param4 = document.getElementById('<%=wave_param4.ClientID%>').value;
            var l_param5 = document.getElementById('<%=wave_param5.ClientID%>').value;
            var l_param0unit = document.getElementById('<%=wave_d_unit.ClientID%>').value;
            var l_param1unit = document.getElementById('<%=wave_d_unit.ClientID%>').value;
            var l_param2unit = document.getElementById('<%=wave_h_unit.ClientID%>').value;
            var l_param3unit = document.getElementById('<%=wave_h_unit.ClientID%>').value;
            var l_param4unit = document.getElementById('<%=wave_t_unit.ClientID%>').value;
            var l_param5unit = document.getElementById('<%=wave_t_unit.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>'); document.write(l_paneltitle); document.write(' </b> <label class="indent" id="ahrshour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            //document.write('<tr><td>' + l_desc + '</td></tr>');
            document.write('<tr><td>' + l_param3 + '</td><td><label id="ahrs_par3">X</label></td><td>' + l_param3unit + '</td>');
            document.write('<tr><td>' + l_param5 + '</td><td><label id="ahrs_par5">X</label></td><td>' + l_param5unit + '</td>');
            document.write('<tr><td>' + l_param0 + '</td><td><label id="ahrs_par0">X</label></td><td>' + l_param0unit + '</td>');
            document.write('<tr><td>' + l_param1 + '</td><td><label id="ahrs_par1">X</label></td><td>' + l_param1unit + '</td>');
            document.write('<tr><td>' + l_param2 + '</td><td><label id="ahrs_par2">X</label></td><td>' + l_param2unit + '</td>');
            document.write('<tr><td>' + l_param4 + '</td><td><label id="ahrs_par4">X</label></td><td>' + l_param4unit + '</td>');

            document.write('</body></table></div>');
            document.write('</div></div>');

        </script>

        <script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=meteo_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=w_s_avg.ClientID%>').value;
            var l_param1 = document.getElementById('<%=w_s_max.ClientID%>').value;
            var l_param2 = document.getElementById('<%=w_dir_avg.ClientID%>').value;
            var l_param3 = document.getElementById('<%=w_temp.ClientID%>').value;
            var l_param4 = document.getElementById('<%=w_press.ClientID%>').value;
            var l_param5 = document.getElementById('<%=w_rain_d.ClientID%>').value;
            var l_param6 = document.getElementById('<%=w_rain_acc.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>'); document.write(l_paneltitle); document.write(' </b> <label class="indent" id="Meteohour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            //document.write('<tr><td>'); document.write(l_desc); document.write('</td></tr>');
            //var b_knot = true;
            var b_knot = document.getElementById('<%=b_knots_hd.ClientID%>').value;
            if (b_knot == "False") {
                document.write('<tr><td>'); document.write(l_param0); document.write('</td><td><label id="wsmoy">X</label></td><td>m/s</td>');
            }
            else {
                document.write('<tr><td>'); document.write(l_param0); document.write('</td><td><label id="wsmoy">X</label></td><td>nd</td>');
            }

            if (b_knot == "False") {
                document.write('<tr><td>'); document.write(l_param1); document.write('</td><td><label id="wsmax">X</label></td><td>m/s</td>');
            }
            else {
                    document.write('<tr><td>'); document.write(l_param1); document.write('</td><td><label id="wsmax">X</label></td><td>nd</td>');
            }
            document.write('<tr><td>'); document.write(l_param2); document.write('</td><td><label id="wdmoy">X</label></td><td>°</td>');
            document.write('<tr><td> Air '); document.write(l_param3); document.write('</td><td><label id="wtemp">X</label></td><td>°C</td>');
            document.write('<tr><td>'); document.write(l_param4); document.write('</td><td><label id="press">X</label></td><td>hPa</td>');
            //document.write('<tr><td>'); document.write(l_param5); document.write('</td><td><label id="rain_d">X</label></td><td>mm</td>');
            //document.write('<tr><td>'); document.write(l_param6); document.write('</td><td><label id="rain_acc">X</label></td><td>°</td>');

            document.write('</body></table></div>');
            document.write('</div></div>');
        </script>

        <script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=meteo_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=w_s_avg.ClientID%>').value;
            var l_param1 = document.getElementById('<%=w_s_max.ClientID%>').value;
            var l_param2 = document.getElementById('<%=w_dir_avg.ClientID%>').value;
            var l_param3 = document.getElementById('<%=w_temp.ClientID%>').value;
            var l_param4 = document.getElementById('<%=w_press.ClientID%>').value;
            var l_param5 = document.getElementById('<%=w_rain_d.ClientID%>').value;
            var l_param6 = document.getElementById('<%=w_rain_acc.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>'); document.write("Position"); document.write(' </b> <label class="indent" id="Positionhour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            document.write('<tr><td>'); document.write("Lat: "); document.write('</td><td><label id="lat">X</label></td><td>°</td>');
            document.write('<td>'); document.write("Lon: "); document.write('</td><td><label id="lon">X</label></td><td>°</td></tr>');

            document.write('</body></table></div>');
            document.write('</div></div>');
        </script>

    <div class="row">
        <script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=sig_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=sig_param0.ClientID%>').value;
            var l_param1 = document.getElementById('<%=sig_param1.ClientID%>').value;
            var l_param2 = document.getElementById('<%=sig_param2.ClientID%>').value;
            var l_param3 = document.getElementById('<%=sig_param3.ClientID%>').value;
            var l_param0unit = document.getElementById('<%=sig_param0unit.ClientID%>').value;
            var l_param1unit = document.getElementById('<%=sig_param1unit.ClientID%>').value;
            var l_param2unit = document.getElementById('<%=sig_param2unit.ClientID%>').value;
            var l_param3unit = document.getElementById('<%=sig_param3unit.ClientID%>').value;


            document.write('<div class="col-md-8">');
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>'); document.write(l_paneltitle); document.write(' </b> <label class="indent" id="Current_Date">X</label> </div>');
            document.write('<div class="panel-body">');//<p>Mesures moyennées sur 1 minute</p>');
            //document.write('<tr><td>'+ l_desc + '</td></tr>');
            document.write('<div class="row">');
            document.write('<div class="col-md-6"><div id="SpeedSIGcontainer" style="min-width:100px;width:350px; height:320px;"></div>');
            document.write('</div>');
            document.write('<div class="col-md-6"><div id="DirSIGcontainer" style="min-width:100px;width:350px; height:320px;"></div>');
            document.write('</div></div></div></div>');

        </script>
    </div>

    <%--<div class="row">--%>
        


        <%--<script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=pyrano_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=pyrano_param0.ClientID%>').value;
            var l_param1 = document.getElementById('<%=pyrano_param1.ClientID%>').value;
            var l_param2 = document.getElementById('<%=pyrano_param2.ClientID%>').value;
            var l_param3 = document.getElementById('<%=pyrano_param3.ClientID%>').value;
            var l_param0unit = document.getElementById('<%=pyrano_param0unit.ClientID%>').value;
            var l_param1unit = document.getElementById('<%=pyrano_param1unit.ClientID%>').value;
            var l_param2unit = document.getElementById('<%=pyrano_param2unit.ClientID%>').value;
            var l_param3unit = document.getElementById('<%=pyrano_param3unit.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>'); document.write(l_paneltitle); document.write(' </b> <label class="indent" id="pyranohour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            document.write('<tr><td>' + l_desc + '</td></tr>');
            document.write('<tr><td>' + l_param0 + '</td><td><label id="pyrano_par0">X</label></td><td>' + l_param0unit + '</td>');
            document.write('<tr><td>' + l_param1 + '</td><td><label id="pyrano_par1">X</label></td><td>' + l_param1unit + '</td>');
            document.write('<tr><td>' + l_param2 + '</td><td><label id="pyrano_par2">X</label></td><td>' + l_param2unit + '</td>');
            document.write('<tr><td>' + l_param3 + '</td><td><label id="pyrano_par3">X</label></td><td>' + l_param3unit + '</td>');

            document.write('</body></table></div>');
            document.write('</div></div>');
        </script>--%>

        <%--<script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=c4e_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=c4e_param0.ClientID%>').value;
            var l_param1 = document.getElementById('<%=c4e_param1.ClientID%>').value;
            var l_param2 = document.getElementById('<%=c4e_param2.ClientID%>').value;
            var l_param3 = document.getElementById('<%=c4e_param3.ClientID%>').value;
            var l_param0unit = document.getElementById('<%=c4e_param0unit.ClientID%>').value;
            var l_param1unit = document.getElementById('<%=c4e_param1unit.ClientID%>').value;
            var l_param2unit = document.getElementById('<%=c4e_param2unit.ClientID%>').value;
            var l_param3unit = document.getElementById('<%=c4e_param3unit.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>' + l_paneltitle + ' </b> <label class="indent" id="c4ehour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            document.write('<tr><td>' + l_desc + '</td></tr>');
            document.write('<tr><td>' + l_param0 + '</td><td><label id="c4e_par0">X</label></td><td>' + l_param0unit + '</td>');
            document.write('<tr><td>' + l_param1 + '</td><td><label id="c4e_par1">X</label></td><td>' + l_param1unit + '</td>');
            document.write('<tr><td>' + l_param2 + '</td><td><label id="c4e_par2">X</label></td><td>' + l_param2unit + '</td>');
            document.write('<tr><td>' + l_param3 + '</td><td><label id="c4e_par3">X</label></td><td>' + l_param3unit + '</td>');

            document.write('</body></table></div>');
            document.write('</div></div>');
        </script>--%>

        <%--<script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=optod_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=optod_param0.ClientID%>').value;
            var l_param1 = document.getElementById('<%=optod_param1.ClientID%>').value;
            var l_param2 = document.getElementById('<%=optod_param2.ClientID%>').value;
            var l_param3 = document.getElementById('<%=optod_param3.ClientID%>').value;
            var l_param0unit = document.getElementById('<%=optod_param0unit.ClientID%>').value;
            var l_param1unit = document.getElementById('<%=optod_param1unit.ClientID%>').value;
            var l_param2unit = document.getElementById('<%=optod_param2unit.ClientID%>').value;
            var l_param3unit = document.getElementById('<%=optod_param3unit.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>' + l_paneltitle + ' </b> <label class="indent" id="optodhour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            document.write('<tr><td>' + l_desc + '</td></tr>');
            document.write('<tr><td>' + l_param0 + '</td><td><label id="optod_par0">X</label></td><td>' + l_param0unit + '</td>');
            document.write('<tr><td>' + l_param1 + '</td><td><label id="optod_par1">X</label></td><td>' + l_param1unit + '</td>');
            document.write('<tr><td>' + l_param2 + '</td><td><label id="optod_par2">X</label></td><td>' + l_param2unit + '</td>');
            document.write('<tr><td>' + l_param3 + '</td><td><label id="optod_par3">X</label></td><td>' + l_param3unit + '</td>');

            document.write('</body></table></div>');
            document.write('</div></div>');
        </script>--%>

        <%--<script type="text/javascript">
            var l_paneltitle = document.getElementById('<%=turbi_panel.ClientID%>').value;
            var l_desc = document.getElementById('<%=avg_10.ClientID%>').value;
            var l_param0 = document.getElementById('<%=turbi_param0.ClientID%>').value;
            var l_param1 = document.getElementById('<%=turbi_param1.ClientID%>').value;
            var l_param2 = document.getElementById('<%=turbi_param2.ClientID%>').value;
            var l_param3 = document.getElementById('<%=turbi_param3.ClientID%>').value;
            var l_param0unit = document.getElementById('<%=turbi_param0unit.ClientID%>').value;
            var l_param1unit = document.getElementById('<%=turbi_param1unit.ClientID%>').value;
            var l_param2unit = document.getElementById('<%=turbi_param2unit.ClientID%>').value;
            var l_param3unit = document.getElementById('<%=turbi_param3unit.ClientID%>').value;

            document.write('<div class="col-md-4">')
            document.write('<div class="panel panel-default">');
            document.write('<div class="panel-heading"><b>' + l_paneltitle + ' </b> <label class="indent" id="turbihour">X</label> </div>');
            document.write('<div class="panel-body">');
            document.write('<table class="table"><tbody>');

            document.write('<tr><td>' + l_desc + '</td></tr>');
            document.write('<tr><td>' + l_param0 + '</td><td><label id="turbi_par0">X</label></td><td>' + l_param0unit + '</td>');
            document.write('<tr><td>' + l_param1 + '</td><td><label id="turbi_par1">X</label></td><td>' + l_param1unit + '</td>');
            document.write('<tr><td>' + l_param2 + '</td><td><label id="turbi_par2">X</label></td><td>' + l_param2unit + '</td>');
            document.write('<tr><td>' + l_param3 + '</td><td><label id="turbi_par3">X</label></td><td>' + l_param3unit + '</td>');

            document.write('</body></table></div>');
            document.write('</div></div>');
        </script>--%>

        
     </div>

    <%--<script type="text/javascript">
        $(function () {
            Highcharts.setOptions({
                global: {
                    useUTC: false   // Dont apply client local time
                }
            });


            initMeteo();
            //initPyrano();
            //initC4E();
            //initOPTOD();
            //initTurbi();
            initSIG();
            initWAVEAHRS();
        });
    </script>--%>


    <script type="text/javascript">
        $(function () {
            Highcharts.setOptions({
                global: {
                    useUTC: false   // Dont apply client local time
                }
            });

            var courant_label = document.getElementById('<%=sig_param4.ClientID%>').value;
            var courant_unit  = document.getElementById('<%=sig_param4unit.ClientID%>').value;

            var b_knot = document.getElementById('<%=b_knots_hd.ClientID%>').value;
            if (b_knot == "True")
                courant_unit = "nd";

            $('#SpeedSIGcontainer').highcharts({
                chart: {
                    //inverted: true
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
                    minTickInterval: 2,
                    startOnTick: true,
                    endOnTick: true,
                    title: {
                        text: 'Distance',
                    },
                    labels: {
                        format: '{value} m'
                    },
                    reversed: true,
                    tickPixelInterval: 50,
                    gridLineWidth: 1
                },
                xAxis: {
                    title: {
                        text: 'Speed (' + courant_unit + ')' //courant_label.ToString() + ' ' + courant_unit.ToString()
                        //text: 'Speed (m/s)' //courant_label.ToString() + ' ' + courant_unit.ToString()
                    },
                    labels: {
                        format: '{value}'
                    },
                    startOnTick: false,
                    endOnTick: false,
                    reversed: false,
                    min: 0,
                    gridLineWidth: 1
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                }],

                tooltip: {
                    headerFormat: '',
                    pointFormat: 'V={point.x}m/s Distance={point.y}m',
                    valueDecimals: 2
                },
                legend: {
                    enabled: false,
                },
                series: [{
                    name: 'Speed (' + courant_unit +')', //Vitesse (m/s)',
                    //name: 'Speed (m/s)', //Vitesse (m/s)',
                    data: [],
                    animation: true,
                }]
            });


            $('#DirSIGcontainer').highcharts({
                chart: {
                    //inverted: true
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
                    minTickInterval: 2,
                    startOnTick: true,
                    endOnTick: true,
                    title: {
                        text: 'Distance',
                    },
                    labels: {
                        format: '{value} m'
                    },
                    reversed: true,
                    tickPixelInterval: 40,
                    gridLineWidth: 1,

                },
                xAxis: {
                    title: {
                        text: 'Direction (°)'
                    },
                    min: 0,
                    max: 360,
                    tickInterval: 90,
                    labels: {
                        format: '{value}'
                    },
                    startOnTick: false,
                    endOnTick: false,
                    reversed: false,
                    gridLineWidth: 1,
                    min: 0,
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                }],

                tooltip: {
                    headerFormat: '',
                    pointFormat: 'D={point.x}° Distance={point.y}m',
                    valueDecimals: 1
                },
                legend: {
                    enabled: false,
                    layout: 'horizontal',
                    align: 'middle',
                    verticalAlign: 'bottom',
                    borderWidth: 0
                },
                series: [{
                    name: 'Direction',
                    color: '#FCA000',
                    data: [],
                    animation: true,
                }]
            });
        });
    </script>

    <script type="text/javascript">
    $(function () {
        Highcharts.setOptions({                                            
            global: {
                useUTC: false   // Dont apply client local time
            }
        });

        
        //Call webservice with ajax!
        function initPosition() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Position.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updatePosition(data.d);
                },
                error: function () {
                    alert('position : erreur de chargement ou pas de données');
                }
            });
        }



        //Call webservice with ajax!
        function initMeteo() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Meteo.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateMeteo(data.d);
                },
                error: function () {
                    alert('meteo : erreur de chargement ou pas de données');
                }
            });
        }

        //Call webservice with ajax!
        function initPyrano() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "pyrano.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updatePyrano(data.d);
                },
                error: function () {
                    alert('Pyranometre : erreur de chargement ou pas de données');
                }
            });
        }

        //Call webservice with ajax!
        function initC4E() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Aquapro_C4E.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateC4E(data.d);
                },
                error: function () {
                    alert('C4E : erreur de chargement ou pas de données');
                }
            });
        }

        //Call webservice with ajax!
        function initOPTOD() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Aquapro_Optod.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateOptod(data.d);
                },
                error: function () {
                    alert('OPTOD : erreur de chargement ou pas de données');
                }
            });
        }

        //Call webservice with ajax!
        function initTurbi() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Aquapro_Turbi.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateTurbi(data.d);
                },
                error: function () {
                    alert('TURBI : erreur de chargement ou pas de données');
                }
            });
        }

        //Call webservice with ajax!
        function initSIG() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Current_Sig.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateSIG(data.d);
                },
                error: function () {
                    alert('SIGNATURE : erreur de chargement ou pas de données');
                }
            });
        }

        //Call webservice with ajax!
        function initWAVEAHRS() {

            var obj = { begin: "", end: "" };

            $.ajax({
                type: "POST",
                url: "Wave_AHRS.aspx/GetValuesFrom",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateWAVEAHRS(data.d);
                },
                error: function () {
                    alert('WAVEAHRS : erreur de chargement ou pas de données');
                }
            });
        }
     

        function YYYYMMDDtoDDMMYYY(str) {
            s = str.replace('T', ' ').split(/[\s,:-]+/)
            newStr = s[2] + '/' + s[1] + '/' + s[0] + '  ' + s[3] + ':' + s[4];
            return newStr;
        }

        // Update charts with meteo data
        function updatePosition(data) {

            var last = data.P_time.length - 1;
            
            if (last >= 0) {

                //YYYYMMDDtoDDMMYYY(data.list_time[last]);

                $('#Positionhour').text("      " + YYYYMMDDtoDDMMYYY(data.P_time[last]))
                $('#lat').text(data.P_lat[last])
                $('#lon').text(data.P_lng[last])
            }
        }

        // Update charts with meteo data
        function updateMeteo(data) {

            var last = data.wxt_wind_str_time.length - 1;
            
            if (last >= 0) {

                //YYYYMMDDtoDDMMYYY(data.str_time2[last]);
                var convert_nd = 1;
                var b_knot = document.getElementById('<%=b_knots_hd.ClientID%>').value;
                if (b_knot == "True")
                    convert_nd = 1.943844;

                $('#Meteohour').text("      " + YYYYMMDDtoDDMMYYY(data.wxt_wind_str_time[last]))
                $('#wsmoy').text(data.wxt_wind_speed_avg[last] / convert_nd)
                $('#wsmax').text(data.wxt_wind_speed_max[last] / convert_nd)
                $('#wdmoy').text(data.wxt_wind_dir_avg[last])

                last = data.wxt_str_time.length - 1;
                $('#wtemp').text(data.wxt_temp[last])
                $('#press').text(data.wxt_press[last])

                //last = data.rain_time.length - 1;
                //$('#rain_acc').text(data.rain_acc[last])
                //$('#rain_d').text(data.rain_dur[last])
            }
        }

        // Update charts with pyrano data
        function updatePyrano(data) {

            var last = data.spm_time.length - 1;

            if (last >= 0) {

                //YYYYMMDDtoDDMMYYY(data.spm_time[last]);

                $('#pyranohour').text("      " + YYYYMMDDtoDDMMYYY(data.spm_time[last]))
                $('#pyrano_par0').text(data.param0[last])
                $('#pyrano_par1').text(data.param1[last])
                $('#pyrano_par2').text(data.param2[last])
                $('#pyrano_par3').text(data.param3[last])

            }
        }

        // Update charts with pyrano data
        function updateC4E(data) {

            var last = data.spm_time.length - 1;

            if (last >= 0) {

                //YYYYMMDDtoDDMMYYY(data.spm_time[last]);

                $('#c4ehour').text("      " + YYYYMMDDtoDDMMYYY(data.spm_time[last]))
                $('#c4e_par0').text(data.param0[last])
                $('#c4e_par1').text(data.param1[last])
                $('#c4e_par2').text(data.param2[last])
                $('#c4e_par3').text(data.param3[last])

            }
        }

        // Update charts with pyrano data
        function updateOptod(data) {

            var last = data.spm_time.length - 1;

            if (last >= 0) {

                //YYYYMMDDtoDDMMYYY(data.spm_time[last]);

                $('#pyranohour').text("      " + YYYYMMDDtoDDMMYYY(data.spm_time[last]))
                $('#optod_par0').text(data.param0[last])
                $('#optod_par1').text(data.param1[last])
                $('#optod_par2').text(data.param2[last])
                $('#optod_par3').text(data.param3[last])

            }
        }

        // Update charts with pyrano data
        function updateTurbi(data) {

            var last = data.data_type_TURBI.length - 1;

            if (last >= 0) {

                //YYYYMMDDtoDDMMYYY(data.spm_time[last]);

                $('#pyranohour').text("      " + YYYYMMDDtoDDMMYYY(data.spm_time[last]))
                $('#turbi_par0').text(data.param0[last])
                $('#turbi_par1').text(data.param1[last])
                $('#turbi_par2').text(data.param2[last])
                $('#turbi_par3').text(data.param3[last])

            }
        }

        // Update charts with data
        function updateSIG(data) {
           
            var last = data.C_time.length - 1;
            var Amplitude = [];
            var Direction = [];

            $('#Current_Date').text(YYYYMMDDtoDDMMYYY(data.C_time[last]));

            if (last >= 0) {

                var convert_nd = 1;
                var b_knot = document.getElementById('<%=b_knots_hd.ClientID%>').value;
                if (b_knot == "True")
                    convert_nd = 1.943844;

                // on coupe a la bonne hauteur
               // var NB_couche_utile = Math.round(data.C_press[last]) - 3; 
                var NB_couche_utile = <%=ConfigurationManager.AppSettings["nb_couche_SIG"] %>;
                //for (var j = 0; j < data.C_amp[0].length; j++) {
                for (var j = 0; j < NB_couche_utile; j++) {
                    Amplitude.push([data.C_amp[last][j] / convert_nd, (j + 1) * data.C_cellsize + data.C_blancking]);
                    Direction.push([data.C_dir[last][j], (j + 1) * data.C_cellsize + data.C_blancking]);
                }

                var chart0 = $('#SpeedSIGcontainer').highcharts();
                chart0.series[0].setData(Amplitude);

                var chart1 = $('#DirSIGcontainer').highcharts();
                chart1.series[0].setData(Direction);
            }
        }


        // Update charts with pyrano data
        function updateWAVEAHRS(data) {

            var last = data.H_time.length - 1;

            if (last >= 0) {

                YYYYMMDDtoDDMMYYY(data.H_time[last]);

                $('#ahrshour').text("      " + YYYYMMDDtoDDMMYYY(data.H_time[last]))
                $('#ahrs_par0').text(data.D_mean[last])
                $('#ahrs_par1').text(data.D_peak[last])
                $('#ahrs_par2').text(data.H_max[last])
                $('#ahrs_par3').text(data.H_m0[last])
                $('#ahrs_par4').text(data.T_m02[last])
                $('#ahrs_par5').text(data.T_p[last])

            }
        }

        initMeteo();
        //initPyrano();
        //initC4E();
        //initOPTOD();
        //initTurbi();
        initSIG();
        initWAVEAHRS();
        initPosition();

    });

    </script>

    

</asp:Content>

<%--// Update with wave data
        function updateWave_SIG(data) {

            var last = data.H_time.length - 1;

            if (last >= 0) {

                $('#Wave_Date_SIG').text("      " + YYYYMMDDtoDDMMYYY(data.H_time[last]))
                $('#Wave_Hsig_SIG').text(data.H_sig[last].toFixed(2))
            }
        }

        function updateWave_courant(data) {

            var last = data.H_time.length - 1;

            if (last >= 0) {

                $('#Wave_Date_BFI_11').text("      " + YYYYMMDDtoDDMMYYY(data.H_time[last]))
                $('#Wave_Hsig_BFI_11').text(data.H_sig[last].toFixed(2))
            }
        }


        // Update charts with data
        function updateCurrent_SIG(data) {
           
            var last = data.C_time.length - 1;
            var Amplitude = [];
            var AmplitudeMoy_x   = 0;
            var AmplitudeMoy_y   = 0;
            var AmplitudeMoy     = 0;
            var Direction = []; 
            var DirectionMoy = 0;

            if (last >= 0) {

                var offset = ( <%=ConfigurationManager.AppSettings["nb_couche_SIG"] %> * <%=ConfigurationManager.AppSettings["cell_size_SIG"] %> + <%=ConfigurationManager.AppSettings["blancking_SIG"] %> ) / 100;
                // on coupe a la bonne hauteur
               // var NB_couche_utile = Math.round(data.C_press[last]) - 3; 
                var NB_couche_utile = 15;
                //for (var j = 0; j < data.C_amp[0].length; j++) {
                for (var j = 0; j < NB_couche_utile; j++) {
                    Amplitude.push([data.C_amp[last][j], (j + 1) * data.C_cellsize + data.C_blancking ]);
                    Direction.push([data.C_dir[last][j], (j + 1) * data.C_cellsize + data.C_blancking]);

                    if (j >= NB_couche_utile - 10) {
                        AmplitudeMoy_x += (data.C_amp[last][j] * Math.cos(data.C_dir[last][j] * Math.PI / 180.00));
                        AmplitudeMoy_y += (data.C_amp[last][j] * Math.sin(data.C_dir[last][j] * Math.PI / 180.00));
                        
                        DirectionMoy += data.C_dir[last][j];
                        if (DirectionMoy > 360) DirectionMoy -= 360;
                    }
                    
                }

                AmplitudeMoy = Math.sqrt( Math.pow(AmplitudeMoy_x, 2) + Math.pow(AmplitudeMoy_x, 2) ) / 10;
                DirectionMoy = DirectionMoy / 10;

                $('#Current_mean_10m_BFI_2').text( ((AmplitudeMoy*100)/100).toFixed(2));
                $('#Current_Dmean_BFI_2').text( DirectionMoy.toFixed(2) );

                //var chart = $('#Current1container').highcharts();
                //chart.series[0].setData(Amplitude);

                //var chart = $('#Current2container').highcharts();
                //chart.series[0].setData(Direction);
            }

            
        }

        // Update charts with data
        function updateCurrent_courant(data) {
           
            var last = data.C_time.length - 1;
            var Amplitude = [];
            var AmplitudeMoy_x   = 0;
            var AmplitudeMoy_y   = 0;
            var AmplitudeMoy     = 0;
            var Direction = []; 
            var DirectionMoy = 0;

            if (last >= 0) {
                
                var offset = ( <%=ConfigurationManager.AppSettings["nb_couche_BFI11"] %> * <%=ConfigurationManager.AppSettings["cell_size_courant"] %> + <%=ConfigurationManager.AppSettings["blancking_courant"] %> ) / 100;
                // on coupe a la bonne hauteur
               // var NB_couche_utile = Math.round(data.C_press[last]) - 3; 
                var NB_couche_utile = 15;
                //for (var j = 0; j < data.C_amp[0].length; j++) {
                for (var j = 0; j < NB_couche_utile; j++) {
                    Amplitude.push([data.C_amp[last][j], (j + 1) * data.C_cellsize + data.C_blancking ]);
                    Direction.push([data.C_dir[last][j], (j + 1) * data.C_cellsize + data.C_blancking]);

                    if (j >= NB_couche_utile - 10) {
                        AmplitudeMoy_x += (data.C_amp[last][j] * Math.cos(data.C_dir[last][j] * Math.PI / 180));
                        AmplitudeMoy_y += (data.C_amp[last][j] * Math.sin(data.C_dir[last][j] * Math.PI / 180));
                        
                        DirectionMoy += data.C_dir[last][j];
                        if (DirectionMoy > 360) DirectionMoy -= 360;
                    }
                }

                AmplitudeMoy = Math.sqrt( Math.pow(AmplitudeMoy_x, 2) + Math.pow(AmplitudeMoy_x, 2) ) / 10;
                DirectionMoy = DirectionMoy / 10;

                
                $('#Current_mean_10m_BFI_11').text( ((AmplitudeMoy*100)/100).toFixed(2) ) ;
                $('#Current_Dmean_BFI_11').text( DirectionMoy.toFixed(2));

                //var chart = $('#Current1container').highcharts();
                //chart.series[0].setData(Amplitude);

                //var chart = $('#Current2container').highcharts();
                //chart.series[0].setData(Direction);
            }
        }

        // Update charts with data
        function updateCurrent_2D(data) {
           
            var last = data.C_time.length - 1;

            if (last >= 0) {

                $('#Current_Date_CARONTE').text(YYYYMMDDtoDDMMYYY(data.C_time[last]));

                var Amplitude = [];
                var Direction = [];  

                //$('#Current_Temp').text(data.C_temp[last])

                var offset = ( <%=ConfigurationManager.AppSettings["nb_couche_2D"] %> * <%=ConfigurationManager.AppSettings["cell_size_2D"] %> + <%=ConfigurationManager.AppSettings["blancking_2D"] %> ) / 100;
                // on coupe a la bonne hauteur
               // var NB_couche_utile = Math.round(data.C_press[last]) - 3; 
                var NB_couche_utile = 15;
                //for (var j = 0; j < data.C_amp[0].length; j++) {
                for (var j = 0; j < NB_couche_utile; j++) {
                    Amplitude.push([data.C_amp[last][j], (j + 1) * data.C_cellsize + data.C_blancking ]);
                    Direction.push([data.C_dir[last][j], (j + 1) * data.C_cellsize + data.C_blancking ]);
                }

                var segment_central = 10;
                $('#Current_central_2D').text(Math.round(data.C_amp[last][segment_central]*100)/100);
                $('#Current_Dmean_2D').text(data.C_dir[last][segment_central]);

                //var chart = $('#Current1container').highcharts();
                //chart.series[0].setData(Amplitude);

                //var chart = $('#Current2container').highcharts();
                //chart.series[0].setData(Direction);
            }
        }

        }--%>