using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;
using System.Data;

public partial class Acoustic1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");
    }


    [System.Web.Services.WebMethod]
    public static Acoustic.dataAcoustic1 GetValues(string database, string begin, string end, int Xlength)
    {
        return Acoustic.GetValues(database, begin, end, Xlength);
    }
}

