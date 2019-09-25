<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/SiteLogin.Master" enableEventValidation="false" AutoEventWireup="true" CodeFile="RecupLogin.aspx.cs" Inherits="_RecupLogin" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">

        </div>
    
    <hr />

    <div class="row">
        <p>Pour récupérer vos informations de connexion, veuillez entrer l'adresse e-mail liée au compte utilisateur.</p>
        <div class="col-md-8">
            <form>
              <div class="form-group">
                <label for="userEmail">Email :</label>
                <input  runat="server" type="email"  ID="userEmail" class="form-control" required="required">
              </div>
            
                <asp:label id="LabelWarning" runat="server" />
                <hr />
                <asp:Button runat="server" ID="Button1" Text="Valider" class="" OnClick="Register_OnClick" />
            </form>
        </div>
    </div>
</asp:Content>
