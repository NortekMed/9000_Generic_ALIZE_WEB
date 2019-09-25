using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Web;
using System.Web.UI;
using Nortekmed2015;
using System.Web.Security;
using System.Web.Configuration;
using System.Configuration;

using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

public partial class Account_Login : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("~/Register/Login");
    }

    protected void LoginUser_Authenticate(object sender, System.Web.UI.WebControls.AuthenticateEventArgs e)
    {
        e.Authenticated = false;

        if (Login1.UserName.Equals(WebConfigurationManager.AppSettings["user"]) && (Login1.Password.Equals(WebConfigurationManager.AppSettings["pass"])))
        {
            e.Authenticated = true;
            Session["user"] = true;
            FormsAuthentication.SetAuthCookie(Login1.UserName, false);
            Response.Redirect("~/Realtime");
        }
    }
}