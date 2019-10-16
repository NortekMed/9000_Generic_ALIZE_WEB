<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Wave_AHRS.aspx.cs" Inherits="WaveAHRS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <!--script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script-->

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

    
    <asp:HiddenField ID = "page_name" Value="<%$ Resources:Site.master, waveahrs %>" Runat="Server" />

    <asp:HiddenField ID = "start" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "end" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "refresh" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_data" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "last" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "historical" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "hour" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "d_avg_label"  value="<%$ Resources:WaveAHRS, d_avg_label %>" Runat="Server" />
	<asp:HiddenField ID = "d_peak_label"  value="<%$ Resources:WaveAHRS, d_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "d_unit"  value="<%$ Resources:WaveAHRS, d_unit %>" Runat="Server" />
	<asp:HiddenField ID = "equip_name"  value="<%$ Resources:WaveAHRS, equip_name %>" Runat="Server" />
	<asp:HiddenField ID = "h_label"  value="<%$ Resources:WaveAHRS, h_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_max_label"  value="<%$ Resources:WaveAHRS, h_max_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_sig_label"  value="<%$ Resources:WaveAHRS, h_sig_label %>" Runat="Server" />
	<asp:HiddenField ID = "h_unit"  value="<%$ Resources:WaveAHRS, h_unit %>" Runat="Server" />
	<asp:HiddenField ID = "t_avg_label"  value="<%$ Resources:WaveAHRS, t_avg_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_peak_label"  value="<%$ Resources:WaveAHRS, t_peak_label %>" Runat="Server" />
	<asp:HiddenField ID = "t_unit"  value="<%$ Resources:WaveAHRS, t_unit %>" Runat="Server" />
    <asp:HiddenField ID = "t_label"  value="<%$ Resources:WaveAHRS, t_label %>" Runat="Server" />
    <asp:HiddenField ID = "d_label"  value="<%$ Resources:WaveAHRS, d_label %>" Runat="Server" />

    <script type="text/javascript">
        var l_maintitle = document.getElementById('<%=page_name.ClientID%>').value;
        var l_hour = document.getElementById('<%=hour.ID%>').value;

        document.write('<h2>' + l_maintitle + '</h2><p>');
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

        document.write('<asp:Button runat="server" ID="downloadBouton" Text="" class="btn btn-default" OnClick="DownloadWave" />');

        document.write('</div><br><br>')
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=h_label.ClientID%>').value;
            
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

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="Dcontainer" style="min-width:500px; width:100%; height:300px;"></div>');
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
                url: "Wave_AHRS.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateCharts(data.d);
                },
                error : function() {
                    alert('WAVE_AHRS : erreur de chargement ou pas de données');
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
                name: 'Height max',
                data: [],
                color: 'green',
                animation: true,
                tooltip: {
                    valueSuffix: ' m'
                }
            },{
                name: 'Significative height',
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
                name: 'Peak period',
                data: [],
                color: 'gray',
                animation: false,
                tooltip: {
                    valueSuffix: ' s'
                }
            },{
                name: 'Mean period',
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
                name: 'Peak direction',
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
                name: 'Mean direction',
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

