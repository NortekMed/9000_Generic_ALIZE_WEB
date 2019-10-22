<%@ Page Title="Se connecter" Language="C#" MasterPageFile="~/SiteLogin.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" Async="true" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <script type="text/javascript">
        document.write('<div class="jumbotron" id="banner">');
        document.write('<div class="row">');
        document.write('<span><a href="<%=ConfigurationManager.AppSettings["WebSiteNortekMed"] %>">');
        document.write('<img style="float: right" src="..\\<%=ConfigurationManager.AppSettings["LogoNortek"] %>" height="130" /></a>');
        <%--document.write('<img style="float: right" src="<%=ConfigurationManager.AppSettings["ImgDir"] %>/Nortekmed.jpg" height="130" /></a>');--%>
        document.write('<img style="float: left" src="..\\<%=ConfigurationManager.AppSettings["Logo_0"] %>" height="100" />');
        <%--document.write('<img style="float: left" src="<%=ConfigurationManager.AppSettings["ImgDir"] %>/LOGO-SNA.jpg" height="100" />');--%>
        document.write('</span>');
        document.write('</div>');
        document.write('<h2>bvfbvfc<%=ConfigurationManager.AppSettings["SiteName"] %> </h2>');
        document.write('<p class="lead"><%=ConfigurationManager.AppSettings["SiteInfo"] %></p>');
        document.write('</div > ');

    </script>

    <%--<div class="jumbotron">
        <div class="row">
            <span>
                <a href="<%=ConfigurationManager.AppSettings["WebSiteNortekMed"] %>">
                    <img style="float: right" src="<%=ConfigurationManager.AppSettings["Logo_Nortek"] %>" height="130" />
                </a>
                <img style="float: left" src="<%=ConfigurationManager.AppSettings["Logo_0"] %>"/>
            </span>
        </div>
        <h2><%=ConfigurationManager.AppSettings["SiteName"] %> </h2>
        <p class="lead"><%=ConfigurationManager.AppSettings["SiteInfo"] %></p>
    </div>--%>

    <div class="row">
        <div class="col-md-8">
            <section id="loginForm">
                <div class="form-horizontal">
                    <asp:Login ID="Login1" runat="server" DestinationPageUrl="~/Tempsreel.aspx" Height="139px" meta:resourcekey="Login1Resource1" onauthenticate="LoginUser_Authenticate" Width="314px">
                    </asp:Login>
                    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                        <p class="text-danger">
                            <asp:Literal runat="server" ID="FailureText" />
                        </p>
                    </asp:PlaceHolder>
                </div>
            </section>
        </div>

    </div>


</asp:Content>

