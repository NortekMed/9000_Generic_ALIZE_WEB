using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Configuration;
using System.Data;
using FirebirdSql.Data.FirebirdClient;

public partial class Realtime : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"]=="true" && !Request.IsAuthenticated)
            Response.Redirect("~/Register/Login.aspx");
    }
}

