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
    </address>
</asp:Content>
