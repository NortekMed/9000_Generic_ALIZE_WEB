<%@ Page Title="Se connecter" Language="C#" MasterPageFile="~/SiteLogin.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" Async="true" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <div class="row">
        <span>
            <a href="<%=ConfigurationManager.AppSettings["WebSiteNortekMed"] %>">
                <img style="float: right" src="..\\<%=ConfigurationManager.AppSettings["LogoNortek"] %>" height=130/>
                <%--<img style="float: right" src="..\img\Nortekmed.jpg" height=130/>--%>
            </a>
            <%--<img style="float: left" src="..\img\LOGO-SNA.jpg" height=100/>--%>
            <img style="float: left" src="..\\<%=ConfigurationManager.AppSettings["Logo_0"] %>" height=100/>
            <%--<img style="float: left" src="..\\<%=ConfigurationManager.AppSettings["Logo_1"] %>" height=100/>
            <img style="float: left" src="..\\<%=ConfigurationManager.AppSettings["Logo_2"] %>" height=100/>--%>
            <%--<img style="float: left" src="..\img\malawi_flag.png" height=100/>--%>
            
        </span>
    </div>

    <div class="jumbotron">
        <h2><%=ConfigurationManager.AppSettings["SiteName"] %></h2>
        <p class="lead"><%=ConfigurationManager.AppSettings["SiteInfo"] %></p>
    </div>

    
    <div class="row">
        <div class="col-md-2">
            <section id="loginForm">
                <div class="form-horizontal">
                    <asp:Login ID="Login1" runat="server" DestinationPageUrl="~/Tempsreel.aspx" Height="139px" meta:resourcekey="Login1Resource1" onauthenticate="LoginUser_Authenticate" Width="314px" LoginButtonText="Sign in" PasswordLabelText="password:" RememberMeText="Remember password." TitleText="" UserNameLabelText="Login: " PasswordRequiredErrorMessage="enter password." RememberMeSet="false" DisplayRememberMe="False">
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
    <!--div class="row">
        <asp:HyperLink id="hyperlink2" 
                  NavigateUrl="~/Register/RecupLogin.aspx"
                  Text="Nom utilisateur ou mot de passe perdu"
                  runat="server"/> 
    </!--div>
    
    <hr />
    <div class="row">
        <p>Si vous n'êtes pas inscrit, vous devez vous enregistrer (gratuit)</p>
        <asp:HyperLink id="hyperlink1" 
                  NavigateUrl="~/Register/Register.aspx"
                  Text="S'enregistrer"
                  runat="server"/> 
    </div-->
        

</asp:Content>

