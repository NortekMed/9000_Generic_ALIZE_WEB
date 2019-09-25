<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Position.aspx.cs" Inherits="Position" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/heatmap.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/data.js"></script>
    <script src="https://code.highcharts.com/modules/boost-canvas.js"></script>
    <script src="https://code.highcharts.com/modules/boost.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>


    <asp:HiddenField ID = "page_name"  value="<%$ Resources:Site.master, position %>" Runat="Server" />


    <asp:HiddenField ID = "start" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "end" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "refresh" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_data" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "last" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "historical" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "hour" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "equipname" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "chart_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "map_label" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "info_0" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "d_NS" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "d_EW" ClientIdMode="Static" Runat="Server" />


    <script type="text/javascript">
        var l_maintitle = document.getElementById('<%=page_name.ClientID%>').value;
        var l_hour = document.getElementById('<%=hour.ID%>').value;

        document.write('<h2>' + l_maintitle + '</h2>');
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

                document.write('<asp:Button runat="server" ID="downloadBouton" Text="" class="btn btn-default" OnClick="DownloadPosition" />');

            document.write('</div><br><br>')
        document.write('</div>');
    </script>
        

    <script>
        var l_chart_label = document.getElementById('<%=chart_label.ClientID%>').value;
        var l_d_ns = document.getElementById('<%=d_NS.ClientID%>').value;
        var l_d_ew = document.getElementById('<%=d_EW.ClientID%>').value;
        var l_map_label = document.getElementById('<%=map_label.ClientID%>').value;

        document.write('<div class="row">');

            document.write('<div class="col-md-8"><div class="panel panel-default">');
                    document.write('<div class="panel-heading"><b>' + l_chart_label + '</b></div>');
                        document.write('<div class="panel-body">');
                        document.write('<div id="PosContainer" style="min-width:500px; width:100%; height:300px;"></div>');
                        document.write('<table class="table" style="font - size: 20px">');
                        document.write('<tbody>');
                        document.write('<tr><td>' + l_d_ns + '</td><td><label id="DISTNS">X</label></td><td>m</td></tr>');
                        document.write('<tr><td>' + l_d_ew + '</td><td><label id="DISTWE">X</label></td><td>m</td></tr>');
                        document.write('</tbody></table>');
            document.write('</div></div></div>');

            document.write('<div class="col-md-4"><div class="panel panel-default">');
                    document.write('<div class="panel-heading"><b>' + l_map_label + '</b></div>');
                    document.write('<div class="panel-body">');
                        document.write('<div id="map-canvas" class ="img-responsive" style="height:375px; width:100%"></div>');
                        document.write('<p>' + l_info_0 + '</p>');
            document.write('</div></div></div>');

        document.write('</div>');

    </script>

    <%--<div class="row"></div>--%>
    <script src="http://maps.google.com/maps/api/js?key=AIzaSyBZ526IA3sDUKsG-UCTpMCm5dSzR9FEofg&language=fr" type="text/javascript"></script>

    <script type="text/javascript">
        document.write('</div></div>');
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

        var buoy_LatLng = { lat: 36.19125, lng: -61.53088 };
     
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
                    url: "Position.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                    },
                    error : function() {
                        alert('Position : erreur de chargement ou pas de données');
                    }
                });
        }

        function YYYYMMDDtoDDMMYYY(str) {
            s = str.replace('T', ' ').split(/[\s,:-]+/)
            newStr = s[2] + '/' + s[1] + '/' + s[0] + '  ' + s[3] + ':' + s[4];
            return newStr;
        }

        // Update charts with wave data
        function updateCharts(data) {

            buoy_LatLng = { lat: data.P_lat[data.P_lat.length - 1], lng: data.P_lng[data.P_lng.length - 1] };

            alert('position : ' + buoy_LatLng.lat + ' , ' + buoy_LatLng.lng);

            var chartPos = $('#PosContainer').highcharts();
            var P_pos = [];

            for (var i = 0; i < data.P_time.length; i++) {
                P_pos.push(
                    {
                        x: data.P_lng[i],
                        y: data.P_lat[i],
                        name : YYYYMMDDtoDDMMYYY(data.P_time[i])
                    });
            }

            chartPos.series[0].setData(P_pos);

            $('#DISTNS').text(data.P_dist_north_south.toFixed(0))
            $('#DISTWE').text(data.P_dist_west_est.toFixed(0))

            initialize();
        };

        function initialize() {	

            var mapOptions = {
                center: buoy_LatLng,
                zoom: 12,
                mapTypeId: google.maps.MapTypeId.TERRAIN,
                scrollwheel: false,
                draggable: false,
                panControl: true,
                zoomControl: true,
                mapTypeControl: true,
                scaleControl: true,
                streetViewControl: false,
                overviewMapControl: true,
                rotateControl: true,
            };

            var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

            var marker = new google.maps.Marker({
                position: buoy_LatLng,
                map: map,
                title:  '<%=ConfigurationManager.AppSettings["SiteName"] %>'
            });

            marker.addListener('click', function () {
                    infowindow.open(map, marker);
            });

            var infowindow = new google.maps.InfoWindow({
                content: " <%=ConfigurationManager.AppSettings["SiteName"] %>"
            });
        }

        google.maps.event.addDomListener(window, 'load', initialize);

        initData();

    </script>

    <script type="text/javascript">

        $(function () {
            $('#PosContainer').highcharts({
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
                    //type: 'datetime',
                    title: {
                        text: 'Longitude',
                    },
                    gridLineWidth: 1,
                    labels: {
                    format: '{value} °',
                    },
                },
                yAxis: [{
                    title: {
                        text: 'Latitude',
                    },
                    labels: {
                        format: '{value} °',
                    },
                }],

                series: [{
                    name: 'Position',
                    data: [],
                    color: 'blue',
                    animation: true,
                    lineWidth: 0,
                    marker: {
                        enabled: true,
                        symbol: 'diamond'
                    },
                    tooltip: {
                        pointFormat: 'Lat:{point.y}° Lng:{point.x}°'
                    }
                }
                ]
            });
        

        //initData();

        });
    </script>

</asp:Content>

