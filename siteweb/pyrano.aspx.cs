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

public partial class Pyrano : System.Web.UI.Page
{
    static public data_type_SPM downloaddata;

    static string equip_name = "";

    static string param0_name = "";
    static string param0_unit = "";
    static string param0_label = "";
    static string param1_name = "";
    static string param1_label = "";
    static string param1_unit = "";
    static string param2_name = "";
    static string param2_unit = "";
    static string param2_label = "";
    static string param3_name = "";
    static string param3_unit = "";
    static string param3_label = "";
    static string param4_name = "";
    static string param4_unit = "";
    static string param4_label = "";

    protected void Page_Init(object sender, EventArgs e)
    {
        InitField();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");


        downloadBouton.Text = download_data.Value;

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // TELECHARGEMENTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    protected void DownloadWave(object Source, EventArgs e)
    {
        string data0 = " " + param0_name + "( " + param0_unit + ");";
        string data1 = " " + param1_name + "( " + param1_unit + ");";
        string data2 = " " + param2_name + "( " + param2_unit + ");";
        string data3 = " " + param3_name + "( " + param3_unit + ");";
        string data4 = " " + param4_name + "( " + param4_unit + ");";

        string[] output = new string[downloaddata.str_time.Length + 1];
        output[0] = "UTC datetime;" + data0 + data1 + data2 + data3;

        if (downloaddata.str_time.Length > 0)
        {
            // mise en forme
            for (int i = 0; i < downloaddata.str_time.Length; i++)
            {
                output[i + 1] += downloaddata.str_time[i].Replace("T", ", ");
                output[i + 1] += ";";
                output[i + 1] += downloaddata.param0[i].ToString("0.00", NumberFormatInfo.InvariantInfo);
                output[i + 1] += ";";
                output[i + 1] += downloaddata.param1[i].ToString("0.00", NumberFormatInfo.InvariantInfo);
                output[i + 1] += ";";
                output[i + 1] += downloaddata.param2[i].ToString("0.00", NumberFormatInfo.InvariantInfo);
                output[i + 1] += ";";
                output[i + 1] += downloaddata.param3[i].ToString("0.00", NumberFormatInfo.InvariantInfo);
                output[i + 1] += ";";

            }

            string interval = downloaddata.str_time[0].Split('T')[0] + "_to_" + downloaddata.str_time[downloaddata.str_time.Length - 1].Split('T')[0];

            DownloadCsv(equip_name + "_" + interval + ".csv", output);
        }
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
        Page.Response.ContentType = "text/csv";
        Page.Response.WriteFile(file.FullName);
        Page.Response.End();
    }

    [System.Web.Services.WebMethod]

    //Only create field if page is not displayed
    protected void CreateField()
    {
        equipname = new HiddenField();

        param0name = new HiddenField();
        param0label = new HiddenField();
        param0unit = new HiddenField();

        param1name = new HiddenField();
        param1label = new HiddenField();
        param1unit = new HiddenField();

        param2name = new HiddenField();
        param2label = new HiddenField();
        param2unit = new HiddenField();

        param3name = new HiddenField();
        param3label = new HiddenField();
        param3unit = new HiddenField();

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
        equipname.Value = Resources.pyrano.equip_name.ToString();

        param0name.Value = Resources.pyrano.param0name.ToString();
        param0label.Value = Resources.pyrano.param0label.ToString();
        param0unit.Value = Resources.pyrano.param0unit.ToString();

        param1name.Value = Resources.pyrano.param1name.ToString();
        param1label.Value = Resources.pyrano.param1label.ToString();
        param1unit.Value = Resources.pyrano.param1unit.ToString();

        param2name.Value = Resources.pyrano.param2name.ToString();
        param2label.Value = Resources.pyrano.param2label.ToString();
        param2unit.Value = Resources.pyrano.param2unit.ToString();

        param3name.Value = Resources.pyrano.param3name.ToString();
        param3label.Value = Resources.pyrano.param3label.ToString();
        param3unit.Value = Resources.pyrano.param3unit.ToString();


        //Assigning string value
        equip_name = equipname.Value;
        param0_name = param0name.Value;
        param0_unit = param0unit.Value;
        param0_label = param0label.Value;


        param1_name = param1name.Value;
        param1_unit = param1unit.Value;
        param1_label = param1label.Value;

        param2_name = param2name.Value;
        param2_unit = param2unit.Value;
        param2_label = param2label.Value;

        param3_name = param3name.Value;
        param3_unit = param3unit.Value;
        param3_label = param3label.Value;

    }

    [System.Web.Services.WebMethod]
    public static data_type_SPM GetValuesFrom(string begin, string end)
    {
        Pyrano test = new Pyrano();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    //public static data_Aquapro GetValues(string begin, string end)
    public static data_type_SPM GetValues(string begin, string end)
    {
        //C4E test = new C4E();
        //test.InitField();

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


        DataSet ds = new DataSet();
        string str_connect = "SELECT a.TIME_REC, a." + param0_name + ",a." + param1_name + ", a." + param2_name + ", a." + param3_name + " FROM " + equip_name + " a" + timestampsrequest + " order by a.TIME_REC";
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];

        List<double> list_par0 = new List<double>();
        List<double> list_par1 = new List<double>();
        List<double> list_par2 = new List<double>();
        List<double> list_par3 = new List<double>();
        List<double> list_par4 = new List<double>();
        List<string> list_str_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

            list_str_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_par0.Add(Math.Round(double.Parse(dRow[param0_name].ToString()), 2));
            list_par1.Add(double.Parse(dRow[param1_name].ToString()));
            list_par2.Add(double.Parse(dRow[param2_name].ToString()));
            list_par3.Add(double.Parse(dRow[param3_name].ToString()));
        }


        // Build meteo data object
        data_type_SPM data = new data_type_SPM();

        data.set_param(list_par0, list_par1, list_par2, list_par3, list_par4, list_str_time);

        //telechargement

        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }


}

public class data_type_SPM
{
    public double[] param0;
    public double[] param1;
    public double[] param2;
    public double[] param3;
    public double[] param4;
    public string[] str_time;


    public void set_param(List<double> w_par0, List<double> w_par1, List<double> w_par2, List<double> w_par3, List<double> w_par4, List<string> w_time)
    {
        param0 = w_par0.ToArray();
        param1 = w_par1.ToArray();
        param2 = w_par2.ToArray();
        param3 = w_par3.ToArray();
        param4 = w_par4.ToArray();
        str_time = w_time.ToArray();
    }
}


//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.Configuration;
//using System.Configuration;
//using FirebirdSql.Data.FirebirdClient;
//using System.Data;
//using System.Text;
//using System.IO;
//using System.Globalization;

//public partial class SPM : System.Web.UI.Page
//{
//    static public dataSPM downloaddata;

//    protected void Page_Load(object sender, EventArgs e)
//    {
//        // Check if user is connected
//        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
//            Response.Redirect("~/Login.aspx");
//    }

//    /////////////////////////////////////////////////////////////////////////////////////////////////////
//    // TELECHARGEMENTS
//    /////////////////////////////////////////////////////////////////////////////////////////////////////

//    protected void DownloadWave(object Source, EventArgs e)
//    {

//        string[] output = new string[downloaddata.spm_time.Length + 1];
//        output[0] = "UTC datetime;temp(°C); bat(V); radiation(W/m2);radiation_raw(W/m2);";


//        // mise en forme
//        for (int i = 0; i < downloaddata.spm_time.Length; i++)
//        {
//            output[i + 1] += downloaddata.spm_time[i].Replace("T", ", ");
//            output[i + 1] += ";";
//            output[i + 1] += downloaddata.spm_temp[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
//            output[i + 1] += ";";
//            output[i + 1] += downloaddata.spm_bat[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
//            output[i + 1] += ";";
//            output[i + 1] += downloaddata.spm_rad[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
//            output[i + 1] += ";";
//            output[i + 1] += downloaddata.spm_rad_raw[i].ToString("0.0", NumberFormatInfo.InvariantInfo);
//            output[i + 1] += ";";

//        }

//        string interval = downloaddata.spm_time[0].Split('T')[0] + "_to_" + downloaddata.spm_time[downloaddata.spm_time.Length - 1].Split('T')[0];

//        DownloadCsv("spm_" + interval + ".csv", output);



//    }


//    protected void DownloadCsv(string filename, string[] data)
//    {

//        string filePath = WebConfigurationManager.AppSettings["TempDir"] + "\\" + filename;
//        string delimiter = ";";
//        int length = data.GetLength(0);
//        StringBuilder sb = new StringBuilder();

//        // Autorisation de télécharger les données !
//        if (WebConfigurationManager.AppSettings["DownloadEnabled"] != "true")
//            length = 0;

//        for (int index = 0; index < length; index++)
//            sb.AppendLine(string.Join(delimiter, data[index]));

//        File.WriteAllText(filePath, sb.ToString());

//        System.IO.FileInfo file = new System.IO.FileInfo(filePath);
//        Page.Response.Clear();
//        Page.Response.AppendHeader("Content-Disposition", "attachment; FileName=" + file.Name);
//        Page.Response.AppendHeader("Content-Length", file.Length.ToString());
//        //Page.Response.AppendHeader("Content-Encoding","UTF-8");
//        //Page.Response.AppendHeader("charset", "UTF-8");
//        Page.Response.ContentType = "text/csv";
//        Page.Response.WriteFile(file.FullName);
//        Page.Response.End();
//    }
//    [System.Web.Services.WebMethod]

//    public static dataSPM GetValues(string begin, string end)
//    {
//        DateTime stdate;
//        DateTime endate;

//        // last 24 hours !
//        if (begin == "" && end == "")
//        {
//            //endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
//            endate = DateTime.Now.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"]));
//            stdate = endate.AddDays(-1.0);
//        }
//        else
//        {
//            // begin and end are value in local time (user expected!)
//            // TIME_REC in database is UTC
//            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
//            endate = Convert.ToDateTime(end).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;

//            endate = endate.AddDays(1);
//        }

//        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

//        // Get wind from database
//        DataSet ds = new DataSet();
//        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.TEMP,a.BAT, a.RADIATION, a.RADIATION_RAW  FROM SPM a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
//        dataadapter.Fill(ds);
//        DataTable myDataTable = ds.Tables[0];

//        List<double> list_temp = new List<double>();
//        List<double> list_bat = new List<double>();
//        List<double> list_rad = new List<double>();
//        List<double> list_rad_raw = new List<double>();
//        List<string> list_spm_time = new List<string>();

//        foreach (DataRow dRow in myDataTable.Rows)
//        {
//            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

//            // UTC to Local Time
//            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
//            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
//            list_spm_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

//            list_temp.Add(Math.Round(double.Parse(dRow["TEMP"].ToString()), 2));
//            //list_wind_avg.Add(Math.Round(double.Parse(dRow["WSMOY"].ToString()), 2));
//            list_bat.Add((double.Parse(dRow["BAT"].ToString())));
//            list_rad.Add((double.Parse(dRow["RADIATION"].ToString())));
//            list_rad_raw.Add((double.Parse(dRow["RADIATION_RAW"].ToString())));
//        }


//        // Build meteo data object
//        dataSPM data = new dataSPM();

//        data.setSPM_param(list_temp,list_bat, list_rad, list_rad_raw, list_spm_time);

//        //telechargement

//        downloaddata = data;

//        // return meteo data to javascript !
//        return data;
//    }
//}

//public class dataSPM
//{
//    public double[] spm_temp;
//    public double[] spm_rad;
//    public double[] spm_rad_raw;
//    public double[] spm_bat;
//    public string[] spm_time;


//    public void setSPM_param(List<double> w_temp, List<double> w_bat, List<double> w_rad, List<double> w_rad_raw, List<string> w_time)
//    {
//        spm_temp = w_temp.ToArray();
//        spm_bat = w_bat.ToArray();
//        spm_rad = w_rad.ToArray();
//        spm_rad_raw = w_rad_raw.ToArray();
//        spm_time = w_time.ToArray();
//    }
//}