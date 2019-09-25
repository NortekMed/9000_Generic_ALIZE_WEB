<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OpenAuthProviders.ascx.cs" Inherits="OpenAuthProviders" %>

<div id="socialLoginList">
    <h4>Utilisez un autre service pour vous connecter.</h4>
    <hr />
    <asp:ListView runat="server" ID="providerDetails" ItemType="System.String"
        SelectMethod="GetProviderNames" ViewStateMode="Disabled">
        <ItemTemplate>
            <p>
                <button type="submit" class="btn btn-default" name="provider" value="<%#: Item %>"
                    title="Connectez-vous avec votre<%#: Item %> compte.">
                    <%#: Item %>
                </button>
            </p>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div>
                <p>Aucun service d'authentification n'est configuré. Voir <a href="http://go.microsoft.com/fwlink/?LinkId=252803">cet article</a> pour des détails sur la configuration de cette application ASP.NET en vue de la prise en charge de la connexion via des services externes.</p>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>
</div>