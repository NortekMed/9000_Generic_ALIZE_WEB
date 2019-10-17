<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    
    
    <h2><%: Title %></h2>
    
    <br />

    <p>Ce service est fourni par :</p>
    
    <br />

    <img src="<%=ConfigurationManager.AppSettings["Logo_Nortek"] %>" height="130" />
    <%--<img src="<%=ConfigurationManager.AppSettings["ImgDir"] %>/Nortekmed.jpg" height="130" />--%>

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
