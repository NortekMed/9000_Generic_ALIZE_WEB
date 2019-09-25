<%@ Page Title="Se connecter" Language="C#" MasterPageFile="~/SiteLogin.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" Async="true" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <div class="jumbotron">
        <div class="row">
            <span>
                <a href="<%=ConfigurationManager.AppSettings["WebSiteNortekMed"] %>">
                    <img style="float: right" src="<%=ConfigurationManager.AppSettings["ImgDir"] %>Nortekmed.jpg"/>
                </a>
                <%--<img style="float: right" src="<%=ConfigurationManager.AppSettings["ImgDir"] %>malawi_flag.png"/>--%>
                <img style="float: left" src="<%=ConfigurationManager.AppSettings["ImgDir"] %>LOGO-SNA.jpg"/>
            </span>
        </div>
        <h2><%=ConfigurationManager.AppSettings["SiteName"] %> </h2>
        <p class="lead"><%=ConfigurationManager.AppSettings["SiteInfo"] %></p>
    </div>

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

