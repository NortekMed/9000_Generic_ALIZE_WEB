<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script src="http://steema.us/files/jscript/src/teechart.js" type="text/javascript"></script>


    <div class="jumbotron">
        <div class="row">
        
        <div class="col-md-4">
            <h2>Mesures temps réels</h2>
            <!--img id="realtimeImg" src="img/buoy.jpg" height="200"-->           

            <p>Aperçu des mesures en temps réels (Méteo, Pyranomètre)</p>
            <p><a class="btn btn-default" href="Realtime">Voir &raquo;</a></p>
        </div>  

        <div class="col-md-8">
            <div id="map-canvas" class ='img-responsive'></div>
        </div>
    </div>


    <div id="map-container"></div>

    <div class="row">
        <div class="col-md-4">
            <h2>Météo</h2>
            <!--img id="nortekLogImg" src="img/wind.png" height="150"-->           
            <p>Vent, température, pression atmosphérique et précipitation (historique et temps réel)</p>
            <p><a class="btn btn-default" href="Météo">Voir &raquo;</a></p>
        </div>
        
        <div class="col-md-4">
            <h2>Courants</h2>
            <p>Profil de courant (historique et temps réel)</p>
            <p><a class="btn btn-default" href="Current">Voir &raquo;</a></p>
        </div>

        <div class="col-md-4">
            <h2>Vagues</h2>
            <p>Hauteur, période et direction (historique et temps réel)</p>
            <p><a class="btn btn-default" href="Wave">Voir &raquo;</a></p>
        </div>

    </div>

    </div>

    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
            
    
    
    <!--Google Maps API-->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDnycWatbGyK6ldFqErjFtko1yeMclNUOA&amp;sensor=true"></script>


    <script>	
 
        function initialize() {

            var myLatLng = { lat: 43.078090, lng: 6.071481 };

            var mapOptions = {
                center: myLatLng,
                zoom: 9,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
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
                position: myLatLng,
                map: map,
                title: 'Bouée NortekMed'
            });

            marker.addListener('click', function () {
                infowindow.open(map, marker);
            });

            var infowindow = new google.maps.InfoWindow({
                content: "Bouée Nortekmed"
            });

        }
        google.maps.event.addDomListener(window, 'load', initialize);
 
    </script>
    
</asp:Content>
