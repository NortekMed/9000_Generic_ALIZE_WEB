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
using System.Text;
using System.IO;
using System.Globalization;

using GlobalVariables;
using Microsoft.Ajax.Utilities;

//public static class MessageBox
//{
//    public static void Show( String Message)
//    {
//        Page.ClientScript.RegisterStartupScript(
//           Page.GetType(),
//           "MessageBox",
//           "<script language='javascript'>alert('" + Message + "');</script>"
//        );
//    }

//}

public partial class CTD : System.Web.UI.Page
{

    public static data_CTD downloaddata;

    static string prj_name = "";
    static string device_name = "";
    static string location;
    static string timeref;
    static string timestamp;
    static string direction;
    static string orientation;


    static string equip_name = "";

    static string temp_name = "";
    static string temp_unit = "";
    static string temp_label = "";

    static string sal_name = "";
    static string sal_unit = "";
    static string sal_label = "";

    protected void Page_Init(object sender, EventArgs e)
    {
        InitField();
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");

        if (WebConfigurationManager.AppSettings["DownloadEnabled"] != "true")
        {
            downloadBouton.Enabled = false;
        }

        downloadBouton.Text = download_data.Value;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // TELECHARGEMENTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    private List<string> MakeHeader(string device)
    {


        List<string> output = new List<string>();
        output.Add(Global.l_prj_name + prj_name);
        output.Add(Global.l_device_name + device);
        output.Add(Global.l_location + location);
        output.Add(Global.l_timeref + timeref);
        output.Add(Global.l_timestamp + timestamp);
        output.Add(Global.l_direction + direction);
        output.Add(Global.l_orientation + orientation);


        return output;
    }


    protected void DownloadCurrent(object Source, EventArgs e)
    {
        device_name = Resources.CTD.DEVICE_0;
        List<string> output = MakeHeader(device_name);

        output.Add("UTC datetime;"  + templabel.Value + '(' + tempunit.Value + ");"
                                    + "Salinity (g/kg);"
                                    );


        // mise en forme
        string start_date = "";
        string end_date = "";
        for (int i = 0; i < downloaddata.SBE_time.Length; i++)
        {
            
            DateTime date = Convert.ToDateTime(downloaddata.SBE_time[i]).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            string s_date = date.ToString("yyyy-MM-ddTHH:mm");

            output.Add(s_date.Replace("T", ", ") + ';'
                        + downloaddata.SBE_temp[i].ToString("0.000", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.SBE_sal[i].ToString("0.000", NumberFormatInfo.InvariantInfo) + ';'
                        );

            if (i == 0)
                start_date = s_date;
            if (i == downloaddata.SBE_time.Length - 1)
                end_date = s_date;

        }

        string interval = start_date.Split('T')[0] + "_to_" + end_date.Split('T')[0];

        DownloadCsv(prj_name + '-' + device_name + '-' + WebConfigurationManager.AppSettings["Location"] + '-' + interval + ".csv", output.ToArray());
    }

    

        protected void DownloadCsv(string filename, string[] data)
        {

            string filePath = WebConfigurationManager.AppSettings["TempDir"] + "\\" + filename;
            string delimiter = ";";
            int length = data.GetLength(0);
            StringBuilder sb = new StringBuilder();

            // Autorisation de télécharger les données !
            if (WebConfigurationManager.AppSettings["DownloadEnabled"] != "true")
                length = 0;

            for (int index = 0; index < length; index++)
                sb.AppendLine(string.Join(delimiter, data[index]));

            File.WriteAllText(filePath, sb.ToString());

            System.IO.FileInfo file = new System.IO.FileInfo(filePath);
            Page.Response.Clear();
            Page.Response.AppendHeader("Content-Disposition", "attachment; FileName=" + file.Name);
            Page.Response.AppendHeader("Content-Length", file.Length.ToString());
            Page.Response.ContentType = "application/vnd.ms-excel";
            Page.Response.WriteFile(file.FullName);
            Page.Response.End();
        }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    [System.Web.Services.WebMethod]

    //Only create field if page is not displayed
    protected void CreateField()
    {
        equipname = new HiddenField();

        download = new HiddenField();
        download_data = new HiddenField();
        start = new HiddenField();
        end = new HiddenField();
        refresh = new HiddenField();
        last = new HiddenField();
        historical = new HiddenField();
        hour = new HiddenField();
    }

    protected void InitField()
    {

        prj_name = (WebConfigurationManager.AppSettings["PRJ_NAME"]).ToString();
        location = WebConfigurationManager.AppSettings["SiteName"];
        timeref = Resources.CTD.TIMEREF;
        timestamp = Resources.CTD.TIMESTAMP;
        direction = Resources.CTD.DIRECTION;
        orientation = "none";


        //Retrieving data from master resx files
        start.Value = Resources.Site.Master.start.ToString();
        end.Value = Resources.Site.Master.end.ToString();
        download.Value = Resources.Site.Master.download.ToString();
        download_data.Value = Resources.Site.Master.download_data.ToString();
        refresh.Value = Resources.Site.Master.refresh.ToString();
        last.Value = Resources.Site.Master.last.ToString();
        historical.Value = Resources.Site.Master.historical.ToString();
        hour.Value = Resources.Site.Master.hour.ToString();


        //Retrieving data from curennt object resx files
        equipname.Value = Resources.CTD.equip_name.ToString();


        tempname.Value = Resources.CTD.tempname.ToString();
        templabel.Value = Resources.CTD.templabel.ToString();
        tempunit.Value = Resources.CTD.tempunit.ToString();

        salname.Value = Resources.CTD.salname.ToString();
        sallabel.Value = Resources.CTD.sallabel.ToString();
        salunit.Value = Resources.CTD.salunit.ToString();




        //Assigning string value
        equip_name = equipname.Value;

        temp_name = tempname.Value;
        temp_unit = templabel.Value;
        temp_label = tempunit.Value;

        sal_name = salname.Value;
        sal_unit = salunit.Value;
        sal_label = sallabel.Value;

    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // WEB SERVICE
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    [System.Web.Services.WebMethod]
    public static data_CTD GetValuesFrom(string begin, string end)
    {
        CTD test = new CTD();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    public static data_CTD GetValues(string begin, string end)
    {
        DateTime stdate;
        DateTime endate;

        // last 24 hours !
        if (begin == "" && end == "")
        {
            endate = DateTime.Now.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"]));
            stdate = endate.AddDays(-1.0);
        }
        else
        {
            // begin and end are value in local time (user expected!)
            // TIME_REC in database is UTC
            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            endate = Convert.ToDateTime(end).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;

            endate = endate.AddDays(1);
        }

        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

        DataSet ds = new DataSet();
        string DbRequest = "SELECT a.TIME_REC, a.TEMP" + ", a.SAL"  + " FROM " + "SBE" + " a" +
                        timestampsrequest + " order by a.TIME_REC";

        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(DbRequest, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];

        List<double> list_sbe_temp = new List<double>();
        List<double> list_sbe_sal = new List<double>();
        List<string> list_str_sbe = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

            list_str_sbe.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_sbe_temp.Add(double.Parse(dRow["TEMP"].ToString()));
            list_sbe_sal.Add(double.Parse(dRow["SAL"].ToString()));
        }

        // Build current data object
        data_CTD data = new data_CTD();
        data.set(list_sbe_temp, list_sbe_sal, list_str_sbe);

        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }
}

public class data_CTD
{
    public double[] SBE_temp;
    public double[] SBE_sal;
    public string[] SBE_time;

    public void set( 
        List<double> l_sbe_temp,
        List<double> l_sbe_sal,
        List<string> l_sbe_time)
    {
        SBE_temp = l_sbe_temp.ToArray();
        SBE_sal = l_sbe_sal.ToArray();
        SBE_time = l_sbe_time.ToArray();

    }
}