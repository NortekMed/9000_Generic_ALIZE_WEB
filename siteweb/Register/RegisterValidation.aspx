<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/SiteLogin.Master" enableEventValidation="false" AutoEventWireup="true" CodeFile="RegisterValidation.aspx.cs" Inherits="_Register" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Activation du compte</h2>
    <hr />
    <div class="row">
        <div class="col-md-8">
            <form>
              <div class="form-group">
                <label for="userEmail">Email :</label>
                <input  runat="server" type="email"  ID="userEmail" class="form-control" required="required">
              </div>
              <div class="form-group">
                <label for="userCode">Code de vérification à 4 chiffres :</label>
                <input  runat="server" ID="userCode" class="form-control" required="required">
              </div>
                <asp:label id="LabelWarning" runat="server" />
                <hr />
                <asp:Button runat="server" ID="Button1" Text="Valider" class="" OnClick="Register_OnClick" />
            </form>
        </div>
    </div>
</asp:Content>
