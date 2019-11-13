<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    
    
    <h2>Info</h2>

    <p>
        Current page:<br />
        Current direction are defined as 'Going to'.<br />
        Acquisition period is 10 minutes.<br />
    </p>
    
    <p>
        Waves page:<br />
        Waves directions are defined as 'Going from'.<br />
        Acquisition period is 30 minutes, calculation is performed during 17 minutes.<br />
    </p>
    
    <p>
        WEATHER page:<br />
        Sensor is at 3.5m.
        Gusts are averaged over 3s.
        Wind direction are defined as 'Going from'.<br />
        Acquisition period is 10 minutes.<br />
        Maximum wind direction is associated to maximum wind speed.<br />
        Minimum wind direction is associated to minimum wind speed.<br />
    </p>
    
    
    <br />

    <h2><%: Title %></h2>

    <p>This service is provided by :</p>
    
    <br />

    <img src="<%=ConfigurationManager.AppSettings["LogoNortek"] %>" height="130" />

    <br />
    <br />
    <address>
        Z.I Toulon Est<br />
        290, Avenue Frédéric Joliot-Curie<br />
        BP 520, 83078 Toulon Cedex 09<br />
    </address>

    <address>
        <strong>Tel:</strong>+ 33 (0) 4 94 31 70 30
    </address>

    <address>
        <strong>Info:</strong> <a href="mailto:info@NortekMed.com">info@NortekMed.com</a>
        <br />

    <strong>Project Manager PBG : Maud Lamaze +33 6 16 80 38 97 </strong><br />
    <strong>Marine safety PBG : Hervé Monin +33 6 14 11 83 15</strong><br />
    <strong>Project Manager NortekMed : André DOLLE + 33 6 37 48 21 77 </strong><br />
    </address>
</asp:Content>
