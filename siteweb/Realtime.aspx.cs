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
    static bool b_ahrs_bfhf = false;
    static bool b_ahrs = false;
    static bool b_spm = false;
    static bool b_c4e = false;
    static bool b_optod = false;
    static bool b_turbi = false;
    static bool b_ctd = false;
    static bool b_decl = false;

    static bool b_currant = false;
    static bool b_weather = false;
    static bool b_include_hum = false;
    static bool b_position = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Register/Login.aspx");

        b_knots_hd.Value = b_knots.ToString();

        //
        if (WebConfigurationManager.AppSettings["PAGE_WAVESAHRS"] == "true")
            b_ahrs = true;

        if (WebConfigurationManager.AppSettings["PAGE_WAVESAHRS_BFHF"] == "true")
            b_ahrs_bfhf = true;

        if (WebConfigurationManager.AppSettings["PAGE_SPM"] == "true")
            b_spm = true;

        if (WebConfigurationManager.AppSettings["PAGE_C4E"] == "true")
            b_c4e = true;

        if (WebConfigurationManager.AppSettings["PAGE_OPTOD"] == "true")
            b_optod = true;

        if (WebConfigurationManager.AppSettings["PAGE_TURBI"] == "true")
            b_turbi = true;

        if (WebConfigurationManager.AppSettings["PAGE_CTD"] == "true")
            b_ctd = true;

        if (WebConfigurationManager.AppSettings["DECLINATION"] == "true")
            b_decl = true;

        if (WebConfigurationManager.AppSettings["PAGE_SIGCURRENT"] == "true")
            b_currant = true;

        if (WebConfigurationManager.AppSettings["PAGE_WEATHER"] == "true")
            b_weather = true;

        if (WebConfigurationManager.AppSettings["PAGE_POSITION"] == "true")
            b_position = true;

        if (WebConfigurationManager.AppSettings["INCLUDE_HUM"] == "true")
            b_include_hum = true;

        b_ctd_hd.Value = b_ctd.ToString();
        b_ahrs_hd.Value = b_ahrs.ToString();
        b_ahrs_bfhf_hd.Value = b_ahrs_bfhf.ToString();
        b_spm_hd.Value = b_spm.ToString();
        b_c4e_hd.Value = b_c4e.ToString();
        b_optod_hd.Value = b_optod.ToString();
        b_turbi_hd.Value = b_turbi.ToString();
        b_decl_hd.Value = b_decl.ToString();

        b_currant_hd.Value = b_currant.ToString();
        b_weather_hd.Value = b_weather.ToString();
        b_include_hum_hd.Value = b_include_hum.ToString();
        b_position_hd.Value = b_position.ToString();

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

