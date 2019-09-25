<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="pyrano.aspx.cs" Inherits="Pyrano"%>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        
                                 

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

    
    <asp:HiddenField ID = "page_name"  value="<%$ Resources:Site.master, pyrano %>" Runat="Server" />


    <asp:HiddenField ID = "start" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "end" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "refresh" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "download_data" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "last" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "historical" ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "hour" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "equipname" ClientIdMode="Static" Runat="Server"/>
    <asp:HiddenField ID = "param0name"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param0unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param0label" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "param1name"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param1unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param1label" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "param2name"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param2unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param2label" ClientIdMode="Static" Runat="Server" />

    <asp:HiddenField ID = "param3name"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param3unit"  ClientIdMode="Static" Runat="Server" />
    <asp:HiddenField ID = "param3label" ClientIdMode="Static" Runat="Server" />

        
        <%-- only for syntax memory
            <asp:HiddenField ID = "start" Value="<%$ Resources:Site.master, start %>" Runat="Server" />
            <asp:HiddenField ID = "HiddenField1"  Value="<%$ Resources:Aquapro_C4E, param3unit %>" Runat="Server" />
            <asp:HiddenField ID = "HiddenField2" Value="<%$ Resources:Aquapro_C4E, param3label %>" Runat="Server" />--%>

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
        var label = document.getElementById('<%=param0label.ClientID%>').value;
            
        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param0container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=param1label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param1container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=param2label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param2container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

    <script type="text/javascript">
        var label = document.getElementById('<%=param3label.ClientID%>').value;

        document.write('<div class="panel panel-default">');
        document.write('<div class="panel-heading"><b>' + label + '</b></div>');
        document.write('<div class="panel-body">');
        document.write('<div id="param3container" style="min-width:500px; width:100%; height:300px;"></div>');
        document.write('</div>');
        document.write('</div>');
    </script>

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
                url: "pyrano.aspx/GetValues",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    updateCharts(data.d);
                },
                error : function() {
                    alert('Pyrano : erreur de chargement ou pas de données');
                }
            });
        }

        // Update charts with meteo data
        function updateCharts(data) {

            // Param0 chart -- Temp
            var chartpar0 = $('#param0container').highcharts();
            var chartpar1 = $('#param1container').highcharts();
            var chartpar2 = $('#param2container').highcharts();
            var chartpar3 = $('#param3container').highcharts();

            var par0 = [];
            var par1 = [];
            var par2 = [];
            var par3 = [];

            chartpar0.yAxis[0].update({ min: 0 });
            chartpar1.yAxis[0].update({ min: 0 });
            chartpar2.yAxis[0].update({ min: 0 });
            chartpar3.yAxis[0].update({ min: 0 });


            for (var i = 0; i < data.str_time.length; i++) {
                par0.push([Date.parse(data.str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param0[i]]);
                par1.push([Date.parse(data.str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param1[i]]);
                par2.push([Date.parse(data.str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param2[i]]);
                par3.push([Date.parse(data.str_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.param3[i]]);
            }
                       
            chartpar0.series[0].setData(par0);
            chartpar1.series[0].setData(par1);
            chartpar2.series[0].setData(par2);
            chartpar3.series[0].setData(par3);

        };

    </script>

    
    <script type="text/javascript">
        $(function () {

            var hour = document.getElementById('<%=hour.ClientID%>').value;

            var par0_label = document.getElementById('<%=param0label.ClientID%>').value;
            var par0_name = document.getElementById('<%=param0name.ClientID%>').value;
            var par0_unit = " " + document.getElementById('<%=param0unit.ClientID%>').value;

            var par1_label = document.getElementById('<%=param1label.ClientID%>').value;
            var par1_name = document.getElementById('<%=param1name.ClientID%>').value;
            var par1_unit = " " + document.getElementById('<%=param1unit.ClientID%>').value;

            var par2_label = document.getElementById('<%=param2label.ClientID%>').innerText;
            var par2_name = document.getElementById('<%=param2name.ClientID%>').value;
            var par2_unit = " " + document.getElementById('<%=param2unit.ClientID%>').value;

            var par3_label = document.getElementById('<%=param3label.ClientID%>').value;
            var par3_name = document.getElementById('<%=param3name.ClientID%>').value;
            var par3_unit = " " + document.getElementById('<%=param3unit.ClientID%>').value;

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
                yAxis: [{
                    min: 0,
                    //tickInterval: 2,
                    title: {
                        text: par0_label.toString()
                    }
                }],
                series: [{
                    name: par0_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: par0_unit.toString()
                    }
                }]
            });
        
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
                yAxis: [{
                    min: 0,
                    //tickInterval: 2,
                    title: {
                        text: par1_label.toString()
                    }
                }],
                series: [{
                    name: par1_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: par1_unit.toString()
                    }
                }]
            });

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
                yAxis: [{
                    min: 0,
                    //tickInterval: 2,
                    title: {
                        text: par2_label.toString()
                    }
                }],
                series: [{
                    name: par2_label.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: par2_unit.toString()
                    }
                }]
            });
        
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
                yAxis: [{
                    min: 0,
                    //tickInterval: 2,
                    title: {
                        text: par3_name.toString()
                    }
                }],
                series: [{
                    name: par3_name.toString(),
                    data: [],
                    color: '#FF3333',
                    animation: true,
                    tooltip: {
                        valueSuffix: par3_unit.toString()
                    }
                }]
            });

            // Init charts with last 24hours values
            initData();
        });

    </script>
</asp:Content>



<%--<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="pyrano.aspx.cs" Inherits="SPM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <!--script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script-->

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="Scripts/bootstrap-datepicker.js"></script>
    <script src="Scripts/nortekmed/Highcharts_cfg.js"></script>

     <h2>Pyranomètre</h2>
    <p>Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)</p>
    
    <div id="Top" style="width:100%; ">

        <div id="q_opt" class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" id="d_realtime" > <input id="q_op_1" name="op" type="radio" value="1" checked>Dernières 24h</label>
            <label class="btn btn-default" id="d_history"> <input id="q_op_2" name="op" type="radio" value="2">Historique</label>
        </div>

         <br/>       

        <div class="hidden" id="history">
        
            <br/>
            <div class='input-group date'>
                <div class='col-md-4'>
                    <div class="form-group">
                        <input type='text' class="form-control" id='datetimepicker1' value="début"/>
                    </div>
                </div>
                <div class='col-md-4'>
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
            <asp:Button runat="server" ID="downloadBouton" Text="Télécharger data (csv)" class="btn btn-default" OnClick="DownloadWave" />
            
            </div>

        <br />
        <br />

        <div class="panel panel-default">
              <div class="panel-heading"><b>Température</b></div>
              <div class="panel-body">
                <div id="tempcontainer" style="min-width:500px; width:100%; height:300px;"></div>
              </div>
        </div>

        <div class="panel panel-default">
            <div class="panel-heading"><b>Radiation</b></div>
              <div class="panel-body">
                <div id="radiationcontainer" style="min-width:500px;width:100%; height:300px;"></div>
              </div>
        </div>

        <div class="panel panel-default" >
            <div class="panel-heading"><b>Tension</b></div>
              <div class="panel-body">
                <div id="batcontainer" style="min-width:500px;width:100%; height:300px; "></div>
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
                    url: "SPM.aspx/GetValues",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        updateCharts(data.d);
                    },
                    error : function() {
                        alert('SPM : erreur de chargement ou pas de données');
                    }
                });
        }

        // Update charts with meteo data
        function updateCharts(data) {


            // Temperature chart
            var chartTemp = $('#tempcontainer').highcharts();
            var temp = [];
            chartTemp.yAxis[0].update({ min: 0 });


            for (var i = 0; i < data.spm_time.length; i++) {
                temp.push([Date.parse(data.spm_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.spm_temp[i]]);
            }
                       
            chartTemp.series[0].setData(temp);

            // Radiation chart
            var chartRadiation = $('#radiationcontainer').highcharts();
            var rad = [];
            var rad_raw = [];
            //chartBat.yAxis[0].update({ min: 0 });
            //chartBat.yAxis[1].update({ min: 0 });

            //var stick = 1;
            //chartWind.yAxis[0].update({ tickInterval: stick });

            for (var i = 0; i < data.spm_time.length; i++) {
                rad.push([Date.parse(data.spm_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.spm_rad[i]]);
                rad_raw.push([Date.parse(data.spm_time[i].replace(/\-/g,'\/').replace(/T/,' ').replace(/Z/,' -0')), data.spm_rad_raw[i]]);
            }

            chartRadiation.yAxis[0].update({ min: 0 });
            chartRadiation.yAxis[0].update({ max: 1000 });
            chartRadiation.yAxis[1].update({ min: 0 });
            chartRadiation.yAxis[1].update({ max: 1000 });
            chartRadiation.yAxis[1].labels

            chartRadiation.series[0].setData(rad);
            chartRadiation.series[1].setData(rad_raw);

            // Baterie chart
            var chartBat = $('#batcontainer').highcharts();
            var temp2 = [];
            chartBat.yAxis[0].update({ min: 0 });
            chartBat.yAxis[0].update({ max: 20 });


            for (var i = 0; i < data.spm_time.length; i++) {
                temp2.push([Date.parse(data.spm_time[i].replace(/\-/g, '\/').replace(/T/, ' ').replace(/Z/, ' -0')), data.spm_bat[i]]);
            }

            chartBat.series[0].setData(temp2);

        };

    </script>


<script type="text/javascript">
    $(function () {

        $('#tempcontainer').highcharts({
            
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: 'Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                //tickInterval: 2,
                title: {
                    text: 'Température ( °C)'
                }
            }],
            series: [{
                name: 'Température °C',
                data: [],
                color: '#FF3333',
                animation: true,
                tooltip: {
                    valueSuffix: ' °C'
                }
            }]
        });

        $('#radiationcontainer').highcharts({
            
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
                title: {
                    text: 'Radiation (W/m2)',
                    style: {
                        color: 'black'
                    }
                },
                labels: {
                    format: '{value} W/m2',
                    style: {
                        color: 'black'
                    }
                },
            }, {
                title: {
                    text: 'Radiation raw (W/m2)',
                    style: {
                        color: '#FCA000'
                    }
                },
                labels: {
                    }
            }],
            series: [{
                name: 'Radiation',
                data: [],
                color: 'black',
                yAxis: 0,
                animation: false,
                tooltip: {
                    valueSuffix: ' W/m2'
                }
            }, {
                name: 'Radiation raw',
                data: [],
                color: '#FCA000',
                yAxis: 1,
                animation: false,
                tooltip: {
                    valueSuffix: ' W/m2'
                }
            }]
        });

        $('#batcontainer').highcharts({
            
            xAxis: {
                type: 'datetime',
                minTickInterval: 30,
                title: {
                    text: 'Heure (UTC<%=ConfigurationManager.AppSettings["UTCdataOffset"] %>)',
                },
                tickPixelInterval: 80,
                gridLineWidth: 1
            },
            yAxis: [{
                min: 0,
                //tickInterval: 2,
                title: {
                    text: 'Tension alimentation  ( V)'
                },
            }],
            series: [{
                name: 'Tension alimentation V',
                data: [],
                color: '#FF3333',
                animation: true,
                tooltip: {
                    valueSuffix: ' V'
                }
            }]
        });

        

        // Init charts with last 24hours values
        initData();
    });

</script>
</asp:Content>--%>

