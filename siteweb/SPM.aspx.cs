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

public partial class SPM : System.Web.UI.Page
{
    static public dataSPM downloaddata;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // TELECHARGEMENTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    protected void DownloadWave(object Source, EventArgs e)
    {

        string[] output = new string[downloaddata.spm_time.Length + 1];
        output[0] = "UTC datetime;temp(°C); bat(V); radiation(W/m2);radiation_raw(W/m2);";


        // mise en forme
        for (int i = 0; i < downloaddata.spm_time.Length; i++)
        {
            output[i + 1] += downloaddata.spm_time[i].Replace("T", ", ");
            output[i + 1] += ";";
            output[i + 1] += downloaddata.spm_temp[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
            output[i + 1] += ";";
            output[i + 1] += downloaddata.spm_bat[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
            output[i + 1] += ";";
            output[i + 1] += downloaddata.spm_rad[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
            output[i + 1] += ";";
            output[i + 1] += downloaddata.spm_rad_raw[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
            output[i + 1] += ";";

        }

        string interval = downloaddata.spm_time[0].Split('T')[0] + "_to_" + downloaddata.spm_time[downloaddata.spm_time.Length - 1].Split('T')[0];

        DownloadCsv("spm_" + interval + ".csv", output);



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
        //Page.Response.AppendHeader("Content-Encoding","UTF-8");
        //Page.Response.AppendHeader("charset", "UTF-8");
        Page.Response.ContentType = "text/csv";
        Page.Response.WriteFile(file.FullName);
        Page.Response.End();
    }
    [System.Web.Services.WebMethod]

    public static dataSPM GetValues(string begin, string end)
    {
        DateTime stdate;
        DateTime endate;

        // last 24 hours !
        if (begin == "" && end == "")
        {
            //endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
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

        // Get wind from database
        DataSet ds = new DataSet();
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.TEMP,a.BAT, a.RADIATION, a.RADIATION_RAW  FROM SPM a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];

        List<double> list_temp = new List<double>();
        List<double> list_bat = new List<double>();
        List<double> list_rad = new List<double>();
        List<double> list_rad_raw = new List<double>();
        List<string> list_spm_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_spm_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_temp.Add(Math.Round(double.Parse(dRow["TEMP"].ToString()), 2));
            //list_wind_avg.Add(Math.Round(double.Parse(dRow["WSMOY"].ToString()), 2));
            list_bat.Add((double.Parse(dRow["BAT"].ToString())));
            list_rad.Add((double.Parse(dRow["RADIATION"].ToString())));
            list_rad_raw.Add((double.Parse(dRow["RADIATION_RAW"].ToString())));
        }

        
        // Build meteo data object
        dataSPM data = new dataSPM();

        data.setSPM_param(list_temp,list_bat, list_rad, list_rad_raw, list_spm_time);

        //telechargement

        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }
}

public class dataSPM
{
    public double[] spm_temp;
    public double[] spm_rad;
    public double[] spm_rad_raw;
    public double[] spm_bat;
    public string[] spm_time;


    public void setSPM_param(List<double> w_temp, List<double> w_bat, List<double> w_rad, List<double> w_rad_raw, List<string> w_time)
    {
        spm_temp = w_temp.ToArray();
        spm_bat = w_bat.ToArray();
        spm_rad = w_rad.ToArray();
        spm_rad_raw = w_rad_raw.ToArray();
        spm_time = w_time.ToArray();
    }
}