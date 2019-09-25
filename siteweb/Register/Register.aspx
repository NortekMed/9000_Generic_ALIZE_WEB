<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/SiteLogin.Master" enableEventValidation="false" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="_Register" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
    
        </div>
    
    <hr />

    <div class="row">
        <div class="col-md-8">
            <form>
              <div class="form-group">
                <label for="userEmail">Email :</label>
                <input  runat="server" type="email"  ID="userEmail" class="form-control" required="required">
              </div>
              <div class="form-group">
                <label for="userName">Identifiant :</label>
                <input runat="server" ID="userName" class="form-control" required="required"/>
                 <span> demandé pour la connexion (6 caractères minimum)</span>
              </div>
              <div class="form-group">
                <label for="userPwd">Mot de passe :</label>
                <input  runat="server" type="password" ID="userPwd" class="form-control"  required="required">
                <label for="userPwdConfirum">Confirmer mdp :</label>
                <input  runat="server" type="password" ID="userPwdConfirm" class="form-control"  required="required">
                <span>(6 caractères minimum)</span>
              </div>
            
                <asp:label id="LabelWarning" runat="server" />
                <hr />
                <asp:Button runat="server" ID="Button1" Text="S'inscrire" class="" OnClick="Register_OnClick" />
            </form>
        </div>
    </div>
</asp:Content>
