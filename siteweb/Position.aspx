<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Position.aspx.cs" Inherits="Position" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <%--<script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>--%>


    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/heatmap.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/data.js"></script>
    <script src="https://code.highcharts.com/modules/boost-canvas.js"></script>
    <script src="https://code.highcharts.com/modules/boost.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>
    <%--<script src="Scripts/bootstrap-datepicker.js"></script>--%>


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

    <asp:HiddenField ID = "b_histo_hd" ClientIdMode="Static" Runat="Server"/>



    <script type="text/javascript">
        var l_maintitle = document.getElementById('<%=page_name.ClientID%>').value;
        var l_hour = document.getElementById('<%=hour.ID%>').value;

        document.write('<h2>');
        document.write('<%=ConfigurationManager.AppSettings["SiteName"] %>'); document.write(" - ");
        document.write(l_maintitle);
        document.write('</h2><p>');
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
                            //document.write('<span class="input-group-addon">');
                            //document.write('<span class="glyphicon glyphicon-calendar"></span>');
                            //document.write('</span>');
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
        
    <%--<script type="text/javascript">
            
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-body">');
        document.write('<div id="poscontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
    </script>--%>

    <script>
        var l_chart_label = document.getElementById('<%=chart_label.ClientID%>').value;
        var l_d_ns = document.getElementById('<%=d_NS.ClientID%>').value;
        var l_d_ew = document.getElementById('<%=d_EW.ClientID%>').value;
        var l_map_label = document.getElementById('<%=map_label.ClientID%>').value;
        var info_0 = document.getElementById('<%=info_0.ClientID%>').value;



        document.write('<div class="row">');

        document.write('<div class="col-md-5"><div class="panel panel-default">');
        //document.write('<div class="panel-heading"><b>' + l_chart_label + '</b></div>');
        //document.write('<div class="panel-heading"><b>');document.write(l_paneltitle); document.write(' </b> <label class="indent" id="Meteohour">X</label> </div>');
        document.write('<div class="panel-heading"><b>'); document.write(l_chart_label); document.write(' </b> <label class="indent" id="Positionhour">X</label> </div>');
                        document.write('<div class="panel-body">');
        document.write('<div id="poscontainer" style="width:100%; height:300px;"></div>');
        //document.write('<div id="poscontainer" style="width:100%; height:300px;"></div>');
        //document.write('<div id="poscontainer" style="min-width:500px; width:100%; height:300px;"></div>');
        //document.write('<div id="poscontainer" style="min-width:300px; width:400px; height:300px;"></div>');

        document.write('<table class="table" style="font - size: 20px">');
        document.write('<tr><td>GPS installation -- Lat: ' + '<%=ConfigurationManager.AppSettings["Lat"] %> °' + ' - Lng: ' + '<%=ConfigurationManager.AppSettings["Lng"] %> °');
        document.write('<tr><td>' + l_d_ns + '</td><td><label id="DISTNS">X</label></td><td>m</td></tr>');
        document.write('<tr><td>' + l_d_ew + '</td><td><label id="DISTWE">X</label></td><td>m</td></tr>');
        document.write('</tbody></table>');
        document.write('</div></div></div>');

        document.write('<div class="col-md-7"><div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + l_map_label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="map-canvas" class ="img-responsive" style="height:375px; width:100%"></div>');
        document.write('<p>' + info_0 + '</p>');
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
        var buoy_ref_LatLng = { lat: 36.19125, lng: -61.53088 };
     
        // Hide/Show history controls
        $('#d_realtime').on("click", function () {
            $("#history").addClass('hidden');
            //alert('hide:');
            b_histo_hd.value = "False";
            //Switchhisto();
            initData();
        });
        $('#d_history').on("click", function () {
            $("#history").removeClass('hidden');
            //alert('remove hide');
            b_histo_hd.value = "True";
            //Switchhisto();
            //initData();
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

            if (data.P_lat.length != 0 && data.P_lng.length != 0)
                buoy_LatLng = { lat: data.P_lat[data.P_lat.length - 1], lng: data.P_lng[data.P_lng.length - 1] };
            else
                buoy_LatLng = { lat: 43.14367, lng: 6.039166 };

            buoy_ref_LatLng.lat = data.lat_o;
            buoy_ref_LatLng.lng = data.lng_o;

            $('#Positionhour').text("      " + YYYYMMDDtoDDMMYYY(data.P_time[data.P_time.length - 1]));
            

            var chartPos = $('#poscontainer').highcharts();

            var b_histo = document.getElementById('<%=b_histo_hd.ClientID%>').value;
            //alert('histo:' + b_histo)

            var P_pos = [];
            var min_lng = 100;
            var max_lng = -100;
            var min_lat = 0;
            var max_lat = 0;
            var max_dist_lng = -100000;
            var max_dist_lat = -100000;
            var min_dist_lng = 100000;
            var min_dist_lat = 100000;
            //for (var i = data.P_time.length - 3; i < data.P_time.length; i++) {
            var nb_to_display = 0;
            if (data.P_time.length > 0) { 
                if (data.P_time.length > 48 && !b_histo)
                    nb_to_display = 48;
                else
                    nb_to_display = data.P_time.length;

                

                //var delta_pos = 0;
                for (var i = data.P_time.length - 1; i >= data.P_time.length - nb_to_display; i--) {    // display only 48 last position

                    if (min_lng > data.P_lng[i])
                        min_lng = data.P_lng[i];
                    //if (min_lat > data.P_lat[i])
                    //    min_lat = data.P_lat[i];

                    if (max_lng < data.P_lng[i])
                        max_lng = data.P_lng[i];
                    //if (max_lat < data.P_lat[i])
                    //    max_lat = data.P_lat[i];

                    if (max_dist_lng < data.P_dist_west_est[i])
                        max_dist_lng = data.P_dist_west_est[i];
                    if (max_dist_lat < data.P_dist_north_south[i])
                        max_dist_lat = data.P_dist_north_south[i];

                    if (min_dist_lng > data.P_dist_west_est[i])
                        min_dist_lng = data.P_dist_west_est[i];
                    if (min_dist_lat > data.P_dist_north_south[i])
                        min_dist_lat = data.P_dist_north_south[i];



                    var delta_pos = Math.sqrt(Math.pow(data.P_dist_north_south[i], 2) + Math.pow(data.P_dist_west_est[i], 2));
                    P_pos.push(
                        {
                            x: data.P_lng[i],
                            y: data.P_lat[i],
                            d: delta_pos.toFixed(0),
                            name: YYYYMMDDtoDDMMYYY(data.P_time[i]),
                            //color: blue
                        }
                    );
                }
            }

            //alert(min_lng.toString());
            //alert(max_lng.toString());
            //var data_name = data.map(function(a) {return a.name;});

            $('#DISTNS').text(Math.abs(data.P_dist_north_south[data.P_time.length - nb_to_display]).toFixed(0))
            $('#DISTWE').text(Math.abs(data.P_dist_west_est[data.P_time.length - nb_to_display]).toFixed(0))


                //if (min_lng > data.lng_o)
                //    min_lng = data.lng_o;
                //if (max_lng < data.lng_o)
                //    max_lng = data.lng_o;

                //alert("max_dist_x: " + max_dist_lng);
                //alert("max_dist_y: " + max_dist_lat);

                //alert("min_dist_x: " + min_dist_lng);
                //alert("min_dist_y: " + min_dist_lat);

                //if (max_dist_lng > max_dist_lat) {
                //    chartPos.xAxis[0].update({ min: min_lat - 0.3125, max: max_lat + 0.3125 });
                //}
                //else {
                //    chartPos.yAxis[0].update({ min: min_lng-0.3125,max: max_lng+0.3125 });
                //}

                //alert(min_lng.toString());
                //alert(max_lng.toString());


                //chartPos.yAxis[0].update({ max: 50 });
                //chartPos.xAxis[0].update({ min: min_lng-0.3125,max: max_lng+0.3125 });

            var max_dist = 0;
            var axis_to_modifie = 0;
            if (max_dist_lng > max_dist_lat) {
                max_dist = max_dist_lng;
                axis_to_modifie = 1;
            }
            else {
                max_dist = max_dist_lat;
                axis_to_modifie = 2;
            }

            
            //alert("coeff: " + coeff);

            var coeff = 0;
            if (axis_to_modifie == 1) {
                var coeff = (max_dist / 11.1037625) * 0.0001;
                chartPos.yAxis[0].update({ min: data.lat_o - coeff, max: data.lat_o + coeff });
            }
            else if (axis_to_modifie == 2) {
                var coeff = (max_dist / 7.5978073) * 0.0001;
                chartPos.xAxis[0].update({ min: min_lng - coeff, max: max_lng + coeff });
            }


            
            //chartPos.yAxis[0].update({ min: data.lat_o - 0.0006, max: data.lat_o + 0.0006 });

            chartPos.series[0].setData(P_pos);


            
            var P_pos_init = [];
            P_pos_init.push(
                {
                    x: data.lng_o,
                    y: data.lat_o,
                    d: 0,
                    name: 'reference'
                });
            chartPos.series[1].setData(P_pos_init)

            initialize();
        };

        function initialize() {	

            

            var mapOptions = {
                center: buoy_LatLng,
                zoom: 9,
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

            //marker.setIcon('http://google-maps-icons.googlecode.com/files/sailboat-tourism.png');
            marker.setIcon('http://maps.google.com/mapfiles/marker_yellow.png');

            marker.addListener('click', function () {
                    infowindow.open(map, marker);
            });



            <%--var marker_ref = new google.maps.Marker({
                position: buoy_ref_LatLng,
                map: map,
                title:  '<%=ConfigurationManager.AppSettings["SiteName"] %>' + ' - ref'
            });

            //marker.setIcon('http://google-maps-icons.googlecode.com/files/sailboat-tourism.png');
            marker_ref.setIcon('http://maps.google.com/mapfiles/marker.png');

            marker_ref.addListener('click', function () {
                    infowindow.open(map, marker_ref);
            });--%>

            var infowindow = new google.maps.InfoWindow({
                content: ' <%=ConfigurationManager.AppSettings["SiteName"] %>'
            });
        }

        google.maps.event.addDomListener(window, 'load', initialize);

        //initData();

    </script>

    <script type="text/javascript">

    $(function () {
        $('#poscontainer').highcharts({
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
            xAxis: {
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
                animation: false,
                lineWidth: 0,
                marker: {
                    enabled: true,
                    symbol: 'diamond'
                },
                tooltip: {
                    pointFormat: 'Lat: {point.y}° Lng: {point.x}° Delta: {point.d}m'
                }
            },
            {
                name: 'Reference',
                data: [],
                color: 'red',
                animation: false,
                lineWidth: 0,
                marker: {
                    enabled: true,
                    symbol: 'diamond'
                },
                tooltip: {
                    pointFormat: 'Lat: {point.y}° Lng: {point.x}° Delta: {point.d}m'
                }
            }],
        });
        

    //initData();

    });
</script>

    <script type="text/javascript">
        $(function () {

            // Init charts with last 24hours values
            initData();
        });

    </script>

    

</asp:Content>

