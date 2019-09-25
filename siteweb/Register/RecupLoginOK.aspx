<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/SiteLogin.Master" enableEventValidation="false" AutoEventWireup="true" CodeFile="RecupLoginOK.aspx.cs" Inherits="_RecupLoginOK" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
    

        </div>
    
    <hr />

    <div class="row">
        <div class="col-md-8">
            <h4>Vous allez recevoir un email contenant vos informations de connexion.</h4>
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
