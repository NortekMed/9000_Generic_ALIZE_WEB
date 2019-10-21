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

public partial class Position : System.Web.UI.Page
{

    public static dataPosition downloaddata;

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

    protected void DownloadPosition(object Source, EventArgs e)
    {
        try
        {
            string[] output = new string[downloaddata.P_time.Length + 1];
            output[0] = "date/time;lat;long";

            // mise en forme
            for (int i = 0; i < downloaddata.P_time.Length; i++)
            {
                output[i + 1] += downloaddata.P_time[i].Replace("T", ", ");

                output[i + 1] += ";";
                output[i + 1] += downloaddata.P_lat[i];
                output[i + 1] += ";";
                output[i + 1] += downloaddata.P_lng[i];

            }

            string interval = downloaddata.P_time[0].Split('T')[0] + "_to_" + downloaddata.P_time[downloaddata.P_time.Length - 1].Split('T')[0];

            // Créer fichier csv et Télécharger
            DownloadCsv("position_" + interval + ".csv", output);
        }
        catch (Exception) { }

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




    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // WEB SERVICE
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //Only create field if page is not displayed
    protected void CreateField()
    {
        

        download = new HiddenField();
        download_data = new HiddenField();
        start = new HiddenField();
        end = new HiddenField();
        refresh = new HiddenField();
        last = new HiddenField();
        historical = new HiddenField();
        hour = new HiddenField();

        equipname = new HiddenField();
        chart_label = new HiddenField();
        map_label = new HiddenField();
        info_0 = new HiddenField();
        d_NS = new HiddenField();
        d_EW = new HiddenField();
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


        equipname.Value = Resources.Position.equip_name.ToString();
        chart_label.Value = Resources.Position.chart_label.ToString();
        map_label.Value = Resources.Position.map_label.ToString();
        info_0.Value = Resources.Position.info_0.ToString();
        d_NS.Value = Resources.Position.d_NS.ToString();
        d_EW.Value = Resources.Position.d_EW.ToString();


        //Retrieving data from curennt object resx files


        //Assigning string value

    }

    [System.Web.Services.WebMethod]
    public static dataPosition GetValuesFrom(string begin, string end)
    {
        Position test = new Position();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    public static dataPosition GetValues(string begin, string end)
    {

        DateTime stdate;
        DateTime endate;

        // last 24 hours !
        if (begin == "" && end == "")
        {
            //endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
            endate = DateTime.Now.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            stdate = endate.AddDays(-1.0);
        }
        else
        {
            // begin and end are value in local time (user expected!)
            // TIME_REC in database is UTC
            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])); ;
            endate = Convert.ToDateTime(end).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])); ;
        }

        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";


        // Get wind from database
        DataSet ds = new DataSet();
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC,a.LAT ,a.LNG FROM GPS a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];



        List<double> list_lat = new List<double>();
        List<double> list_lng = new List<double>();
        List<string> list_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));
            list_lat.Add(double.Parse(dRow["LAT"].ToString()));
            list_lng.Add(double.Parse(dRow["LNG"].ToString()));
        }


        double xmin = double.MaxValue;
        double xmax = double.MinValue;
        double ymin = double.MaxValue;
        double ymax = double.MinValue;


        foreach (double d in list_lng)
        {
            xmin = Math.Min(xmin, d);
            xmax = Math.Max(xmax, d);
        }
        foreach (double d in list_lat)
        {
            ymin = Math.Min(ymin, d);
            ymax = Math.Max(ymax, d);
        }

        Class1 convertutm = new Class1();
        convertutm.Init_Datum();
        //double[] XY_UTM_max = new double[2];
        //double[] XY_UTM_min = new double[2];
        //XY_UTM_max = convertutm.XY(ymax, xmax);
        //XY_UTM_min = convertutm.XY(ymin, xmin);
        //double distance_nord = Math.Abs(XY_UTM_max[1] - XY_UTM_min[1]);
        //double distance_est = Math.Abs(XY_UTM_max[0] - XY_UTM_min[0]);

        double lat_o = double.Parse(WebConfigurationManager.AppSettings["Lat"]);
        double lng_o = double.Parse(WebConfigurationManager.AppSettings["Lng"]);
        double[] XY_UTM_o = new double[2];
        double[] XY_UTM_last = new double[2];
        double distance_nord = 0;
        double distance_est = 0;
        XY_UTM_o = convertutm.XY(lat_o, lng_o);
        if (list_lat.Count > 0 && list_lng.Count > 0) { 
            XY_UTM_last = convertutm.XY(list_lat.Last(), list_lng.Last());

            distance_nord = Math.Abs(XY_UTM_last[1] - XY_UTM_o[1]);
            distance_est = Math.Abs(XY_UTM_last[0] - XY_UTM_o[0]);
        }

        // Build current data object
        dataPosition data = new dataPosition();
        data.set(list_lat,
            list_lng,
            list_time,
            distance_nord,
            distance_est);

        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }
}

public class dataPosition
{
    public double[] P_lat;
    public double[] P_lng;
    public string[] P_time;
    public double P_dist_north_south;
    public double P_dist_west_est;

    public void set(List<double> l_lat,
        List<double> l_lng,
        List<string> l_time,
        double north_south,
        double west_est)
    {

        P_lat = l_lat.ToArray();
        P_lng = l_lng.ToArray();
        P_time = l_time.ToArray();

        P_dist_north_south = north_south;
        P_dist_west_est = west_est;
    }
}