<%@ Page Title="Courant" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CTD.aspx.cs" Inherits="CTD" %>

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

    <asp:HiddenField ID = "tempname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "tempunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "templabel" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "salname"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "salunit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "sallabel" ClientIdMode="Static" Runat="Server" />

    
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
    </script>

    <script type="text/javascript">
        var label = "water " + document.getElementById('<%=templabel.ClientID%>').value.toLowerCase() + ' / ' + document.getElementById('<%=sallabel.ClientID%>').value.toLowerCase() + ' (' + "<%=ConfigurationManager.AppSettings["Looking"] %>" + ')';
        
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
                    url: "CTD.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                        updateLimit(data.d);
                    },
                    error : function() {
                        alert('CTD: erreur de chargement ou pas de données');
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
                    url: "CTD.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateLimit(data.d);
                    },
                    error : function() {
                        alert('CTD: erreur de chargement ou pas de données');
                    }
                });
        }

        //// Update charts with wave data
        //function updateLimit(data) {

        //    var speed = +document.getElementById('speed').value;
        //    //alert(speed);

        //    var chartSpd = $('#Spdcontainer').highcharts();
        //    //chartAmp.series[0].remove();
            

        //    //making serie for limit line
        //    var v_limit = [];
        //    for (var i = 0; i < data.C_time.length; i++) {
        //        var time = Date.parse(data.C_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
        //        v_limit.push([time, speed]);
        //    }
        //    chartSpd.series[chartSpd.series.length - 1].remove();
            
        //    chartSpd.addSeries({
        //            name: "Limit=" + speed + "m/s",
        //            data: v_limit,
        //            visible: true,
        //            tooltip: {
        //                valueSuffix: "m/s"
        //            }
        //        });
        //}

        // Update charts with wave data
        function updateCharts(data) {
            
            var mtchart = $('#MTcontainer').highcharts();
            var maree = [];
            var tempeau = [];
            var sal = [];


            for (var i = 0; i < data.SBE_time.length; i++) {
                var time = Date.parse(data.SBE_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0'));
                tempeau.push([time, Math.round(data.SBE_temp[i] * 1000)/1000]);
                sal.push([time, Math.round(data.SBE_sal[i] * 1000) / 1000]);
            }

            mtchart.series[0].setData(tempeau);
            mtchart.series[1].setData(sal);

        };

    </script>

<script type="text/javascript">
    $(function () {

        var hour = document.getElementById('<%=hour.ClientID%>').value;

        var par2_label = document.getElementById('<%=templabel.ClientID%>').value;
        var par2_name = document.getElementById('<%=tempname.ClientID%>').value;
        var par2_unit = " " + document.getElementById('<%=tempunit.ClientID%>').value;

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
            },
                {
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

