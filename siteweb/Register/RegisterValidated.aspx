<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/SiteLogin.Master" enableEventValidation="false" AutoEventWireup="true" CodeFile="RegisterValidated.aspx.cs" Inherits="_RegisterOK" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-md-8">
            <h4>Votre compte est maintenant activé !</h4>
        </div>
    </div>
    <div class="row">
        <div class="col-md-8">
        <asp:HyperLink id="hyperlink1" 
                  NavigateUrl="~/Register/Login.aspx"
                  Text="Retour à la page de connexion"
                  runat="server"/> 
            </div>
    </div>

</asp:Content>
