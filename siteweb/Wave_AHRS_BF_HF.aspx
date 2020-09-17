<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Wave_AHRS_BF_HF.aspx.cs" Inherits="WaveAHRS_BFHF" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <!--script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script-->

    <script src="https://code.highcharts.com/8.0.4/highcharts.js"></script>
    <script src="https://code.highcharts.com/8.0.4/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

    
    <asp:HiddenField ID = "page_name" Value="<%$ Resources:Site.master, waveahrs_bfhf %>" Runat="Server" />

    <asp:HiddenField ID = "start" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "end" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "refresh" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_dataBF" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_dataHF" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "last" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "historical" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "hour" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "d_avg_label"  value="<%$ Resources:WaveAHRS, d_avg_label %>" Runat="Server" />
	<asp:HiddenField ID = "d_peak_label"  value="<%$ Resources:WaveAHRS, d_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "d_spread_label"  value="<%$ Resources:WaveAHRS, d_spread_label %>" Runat="Server" />
	<asp:HiddenField ID = "n_waves"  value="<%$ Resources:WaveAHRS, n_waves %>" Runat="Server" />
	<asp:HiddenField ID = "d_unit"  value="<%$ Resources:WaveAHRS, d_unit %>" Runat="Server" />
	<asp:HiddenField ID = "equip_name"  value="<%$ Resources:WaveAHRS, equip_name %>" Runat="Server" />
	<asp:HiddenField ID = "h_label"  value="<%$ Resources:WaveAHRS, h_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_max_label"  value="<%$ Resources:WaveAHRS, h_max_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_3_label"  value="<%$ Resources:WaveAHRS, h_3_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_sig_label"  value="<%$ Resources:WaveAHRS, h_sig_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_unit"  value="<%$ Resources:WaveAHRS, h_unit %>" Runat="Server" />
	<asp:HiddenField ID = "t_avg_label"  value="<%$ Resources:WaveAHRS, t_avg_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_max_label"  value="<%$ Resources:WaveAHRS, t_max_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_peak_label"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_m01_label"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_m02_label"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_3_label"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_z_label"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_unit"  value="<%$ Resources:WaveAHRS, t_unit %>" Runat="Server" />
    <asp:HiddenField ID = "t_label"  value="<%$ Resources:WaveAHRS, t_label %>" Runat="Server" />
    <asp:HiddenField ID = "d_label"  value="<%$ Resources:WaveAHRS, d_label %>" Runat="Server" />


    <asp:HiddenField ID = "h_sig_label_alias"  value="<%$ Resources:WaveAHRS, h_sig_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "h_3_label_alias"  value="<%$ Resources:WaveAHRS, h_3_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "h_max_label_alias"  value="<%$ Resources:WaveAHRS, h_max_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_peak_label_alias"  value="<%$ Resources:WaveAHRS, t_peak_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_z_label_alias"  value="<%$ Resources:WaveAHRS, t_z_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_m01_label_alias"  value="<%$ Resources:WaveAHRS, t_m01_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_max_label_alias"  value="<%$ Resources:WaveAHRS, t_max_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_m02_label_alias"  value="<%$ Resources:WaveAHRS, t_m02_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_3_label_alias"  value="<%$ Resources:WaveAHRS, t_3_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_avg_label_alias"  value="<%$ Resources:WaveAHRS, d_avg_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_peak_label_alias"  value="<%$ Resources:WaveAHRS, d_peak_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_spread_label_alias"  value="<%$ Resources:WaveAHRS, d_spread_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "n_waves_alias"  value="<%$ Resources:WaveAHRS, n_waves_alias %>" Runat="Server" />

    <asp:HiddenField ID = "h_sig_bf_label_alias"  value="<%$ Resources:WaveAHRS, h_sig_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "h_sig_hf_label_alias"  value="<%$ Resources:WaveAHRS, h_sig_hf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_peak_bf_label_alias"  value="<%$ Resources:WaveAHRS, t_peak_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_peak_hf_label_alias"  value="<%$ Resources:WaveAHRS, t_peak_hf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_z_bf_label_alias"  value="<%$ Resources:WaveAHRS, t_z_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_z_hf_label_alias"  value="<%$ Resources:WaveAHRS, t_z_hf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_m02_bf_label_alias"  value="<%$ Resources:WaveAHRS, t_m02_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_m02_hf_label_alias"  value="<%$ Resources:WaveAHRS, t_m02_hf_label_alias %>" Runat="Server" />

    <asp:HiddenField ID = "d_avg_bf_label_alias"  value="<%$ Resources:WaveAHRS, d_avg_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_avg_hf_label_alias"  value="<%$ Resources:WaveAHRS, d_avg_hf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_peak_bf_label_alias"  value="<%$ Resources:WaveAHRS, d_peak_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_peak_hf_label_alias"  value="<%$ Resources:WaveAHRS, d_peak_hf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_m02_bf_label_alias"  value="<%$ Resources:WaveAHRS, d_m02_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "d_m02_hf_label_alias"  value="<%$ Resources:WaveAHRS, d_m02_hf_label_alias %>" Runat="Server" />

    <asp:HiddenField ID = "t_e_label_alias"  value="<%$ Resources:WaveAHRS, t_e_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_e_bf_label_alias"  value="<%$ Resources:WaveAHRS, t_e_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "t_e_hf_label_alias"  value="<%$ Resources:WaveAHRS, t_e_hf_label_alias %>" Runat="Server" />

    <asp:HiddenField ID = "etamax_label_alias"  value="<%$ Resources:WaveAHRS, t_e_bf_label_alias %>" Runat="Server" />
    <asp:HiddenField ID = "etamin_label_alias"  value="<%$ Resources:WaveAHRS, t_e_hf_label_alias %>" Runat="Server" />

    <asp:HiddenField ID = "declination_label" Value="<%$ Resources:Site.master, declination %>" Runat="Server" />

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
        var l_download_databf = document.getElementById('<%=download_dataBF.ClientID%>').value;
        var l_download_datahf = document.getElementById('<%=download_dataHF.ClientID%>').value;
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

        document.write('<div class="col-md-4">');
        document.write('<div class="form - group">');
        //document.write('<input type="text" class="form - control" id="datetimepicker1" value="' + date + '"/>');
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

        document.write('<asp:Button runat="server" ID="downloadBoutonBF" Text="" class="btn btn-default" OnClick="DownloadWaveBF" />');
        document.write('<asp:Button runat="server" ID="downloadBoutonHF" Text="" class="btn btn-default" OnClick="DownloadWaveHF" />');

        document.write('</div><br><br>')
    </script>

    <%--<form>
        <div class="metersInputGroup">
            <label for="meters">Enter height limit — in meters :</label>
            <input id="meters" type="number" name="meters" step="0.1" min="0" max="20" value="0" required>
            <span class="validity"></span>
            <a class="btn btn-default" onclick="updateData()">Trace</a>
        </div>
        <div>
        
        </div>
    </form>--%>


    <script type="text/javascript">
        var label = document.getElementById('<%=h_label.ClientID%>').value;

        //document.write('<input type="number" placeholder="0.0" step="0.01" min="0" max="10">');

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="Hcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=t_label.ClientID%>').value;
        

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="Tcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=d_label.ClientID%>').value;
        var label_decl = document.getElementById('<%=declination_label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + ' - ' + label_decl + ' : ' + '</b> <label class="indent" id="l_decl">X</label>' + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="Dcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>


    <script type="text/javascript">

        $(document).ready(function () {

            //var myDate = new Date();
            //var date = ('0'+ myDate.getDate()).slice(-2) + '/' + ('0'+ myDate.getMonth()+1).slice(-2) + '/' + myDate.getFullYear();
            ////$("#datepicker1").val(date);

            //alert(date);

            var dp = $("#datetimepicker1");
            dp.datepicker({
                changeMonth: true,
                changeYear: true,
                format: "dd/mm/yyyy",
                //defaultdate: '01/01/2020',
                language: "fr"
            });
        });

        $(document).ready(function () {

            var dp = $("#datetimepicker2");
            dp.datepicker({
                changeMonth: true,
                changeYear: true,
                format: "dd/mm/yyyy",
                //defaultdate: date,
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
                url: "Wave_AHRS_BF_HF.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateCharts(data.d);
                },
                error : function() {
                    alert('WAVE_AHRS_BF_HF : erreur de chargement ou pas de données');
                }
            });
        }

        // Update charts with wave data
        function updateCharts(data) {

            //var height = document.getElementById('meters').value;
            $('#l_decl').text(data.declination.toFixed(2));
            
            // Wave Height chart
            var chartH = $('#Hcontainer').highcharts();
            var H_sig = [];
            var H_max = [];
            var H_limit = [];

            var H_m0_bf = [];
            var H_m0_hf = [];

            for (var i = 0; i < data.H_time.length; i++) {
                var time = Date.parse(data.H_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                //H_sig.push([time, Math.round(data.H_m0[i] * 100) / 100]);
                //H_max.push([time, Math.round(data.H_max[i] * 100) / 100]);
                //H_limit.push([time, height]);

                H_m0_bf.push([time, Math.round(data.H_m0_bf[i] * 100) / 100]);
                H_m0_hf.push([time, Math.round(data.H_m0_hf[i] * 100) / 100]);
                //H_sig.push([Date.parse(data.H_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.H_m0[i] * 100) / 100]);
                //H_max.push([Date.parse(data.H_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.H_max[i] * 100) / 100]);
                //H_limit.push([Date.parse(data.H_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), height]);
                
            }

            chartH.series[0].setData(H_m0_bf);
            chartH.series[1].setData(H_m0_hf);
            //chartH.series[0].setData(H_max);
            //chartH.series[1].setData(H_sig);
            //chartH.series[2].setData(H_limit);


            // Wave Period chart
            var chartT = $('#Tcontainer').highcharts();
            //var T_mean = [];
            //var T_peak = [];

            var T_M02_BF = [];
            var T_M02_HF = [];
            var T_Peak_BF = [];
            var T_Peak_HF = [];
            //var T_E = [];
            //var T_E_BF = [];
            //var T_E_HF = [];

            for (var i = 0; i < data.T_time_bfhf.length; i++) {
                //T_mean.push([Date.parse(data.T_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.T_m02[i]*10)/10]);
                //T_peak.push([Date.parse(data.T_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.T_p[i]*10)/10]);
                T_M02_BF.push([Date.parse(data.T_time_bfhf[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.T_m02_bf[i] * 10) / 10]);
                T_M02_HF.push([Date.parse(data.T_time_bfhf[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.T_m02_hf[i] * 10) / 10]);

                T_Peak_BF.push([Date.parse(data.T_time_bfhf[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.T_p_bf[i] * 10) / 10]);
                T_Peak_HF.push([Date.parse(data.T_time_bfhf[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.T_p_hf[i] * 10) / 10]);
            }

            chartT.series[0].setData(T_M02_BF);
            chartT.series[1].setData(T_M02_HF);

            chartT.series[2].setData(T_Peak_BF);
            chartT.series[3].setData(T_Peak_HF);



            // Wave Direction chart

            


            var chartD = $('#Dcontainer').highcharts();
            //var D_mean = [];
            //var D_peak = [];

            var D_T02_bf = [];
            var D_T02_hf = [];
            var D_peak_bf = [];
            var D_peak_hf = [];
            
            chartD.yAxis[0].update({ min: 0 });
            chartD.yAxis[0].update({ max: 360 });


            for (var i = 0; i < data.D_time.length; i++) {
                //D_mean.push([Date.parse(data.D_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.D_mean[i]*10)/10]);
                //D_peak.push([Date.parse(data.D_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), Math.round(data.D_peak[i]*10)/10]);
                D_T02_bf.push([Date.parse(data.D_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.D_t02_bf[i] * 10) / 10]);
                D_T02_hf.push([Date.parse(data.D_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.D_t02_hf[i] * 10) / 10]);

                D_peak_bf.push([Date.parse(data.D_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.D_peak_bf[i] * 10) / 10]);
                D_peak_hf.push([Date.parse(data.D_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), Math.round(data.D_peak_hf[i] * 10) / 10]);
            }

            //chartD.series[0].setData(D_peak);
            //chartD.series[1].setData(D_mean);

            chartD.series[0].setData(D_T02_bf);
            chartD.series[1].setData(D_T02_hf);
            chartD.series[2].setData(D_peak_bf);
            chartD.series[3].setData(D_peak_hf);
            
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
                    text: 'Hour (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                title: {
                    text: 'Height',
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
                name: 'Height BF',
                data: [],
                color: 'green',
                animation: true,
                tooltip: {
                    valueSuffix: ' m'
                }
            },{
                name: 'Height HF',
                data: [],
                color: 'blue',
                animation: true,
                tooltip: {
                    valueSuffix: ' m'
                }
            }
                //, {
                //name: 'Limit height',
                //data: [],
                //color: 'red',
                //animation: true,
                //tooltip: {
                //    valueSuffix: ' m'
                //}
            //}
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
                    text: 'Hour (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                title: {
                    text: 'Period',
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
                name: 'TM02 BF',
                data: [],
                color: 'gray',
                animation: false,
                tooltip: {
                    valueSuffix: ' s'
                }
            },{
                name: 'TM02 HF',
                data: [],
                color: 'red',
                animation: false,
                tooltip: {
                    valueSuffix: ' s'
                }
            }, {
                name: 'TPeak BF',
                data: [],
                color: 'blue',
                animation: false,
                tooltip: {
                    valueSuffix: ' s'
                }
            }, {
                name: 'TPeak HF',
                data: [],
                color: 'yellow',
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
                    text: 'Hour (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
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
                name: 'MeanWaveDir BF',
                data: [],
                color: '#FCF000',
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
                    name: 'MeanWaveDir HF',
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
            }, {
                    name: 'PeakWaveDir BF',
                data: [],
                color: '#00A000',
                lineWidth: 0,
                animation: false,
                tooltip: {
                    valueSuffix: ' °'
                },
                marker: {
                    enabled: true,
                    symbol: 'diamond'
                },
            }, {
                    name: 'PeakWaveDir HF',
                data: [],
                color: '#00F000',
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

