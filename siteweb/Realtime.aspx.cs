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
    static bool b_knots = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Register/Login.aspx");

        b_knots_hd.Value = b_knots.ToString();

    }

    protected void SwitchKnots(object Source, EventArgs e)
    {
        if (b_knots == true)
        {
            b_knots = false;
        }
        else
        {
            b_knots = true;
        }
        

        //Response.Redirect(Request.RawUrl);
        Page.Response.Redirect(Page.Request.Url.ToString(), false);
        //Context.ApplicationInstance.CompleteRequest();
    }
}

