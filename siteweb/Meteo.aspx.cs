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

public partial class Meteo : System.Web.UI.Page
{
    static public data_type_Meteo_0 downloaddata;

    static string _0_equip_name = "";
    static string _0_equip_name_alias = "";
    static string _1_equip_name = "";
    static string _2_equip_name = "";
    static string _2_equip_name_alias = "";
    static string _3_equip_name = "";
    static string _4_equip_name = "";

    static string s_temperature;
    static string s_pressure;

    static string s_humidity;
    static string s_rain_acc;

    static string s_rain_duration;
    static string s_rain_intensity;

    static string s_wind_speed_avg;
    static string s_wind_dir_avg;
    static string s_wind_speed_max;
    static string s_wind_dir_max;
    static string s_wind_speed_min;
    static string s_wind_dir_min;

    static string s_temp_airmar;
    static string s_press_airmar;
    static string s_wind_speed_avg_airmar;
    static string s_wind_speed_max_airmar;
    static string s_wind_dir_airmar;
    static string s_voltage_airmar;
    static string s_lat_airmar;
    static string s_lng_airmar;
    static string s_gps_quality_airmar;
    static string s_nb_satelite_airmar;


    static string s_temperature_unit;
    static string s_pressure_unit;

    static string s_humidity_unit;
    static string s_rain_acc_unit;

    static string s_rain_duration_unit;
    static string s_rain_intensity_unit;


    static string s_wind_speed_avg_unit;
    static string s_wind_dir_avg_unit;

    static string s_wind_speed_max_unit;
    static string s_wind_dir_max_unit;
    static string s_temp_airmar_unit;
    static string s_press_airmar_unit;
    static string s_wind_speed_avg_airmar_unit;
    static string s_wind_speed_max_airmar_unit;
    static string s_wind_dir_airmar_unit;
    static string s_voltage_airmar_unit;
    static string s_lat_airmar_unit;
    static string s_lng_airmar_unit;
    static string s_gps_quality_airmar_unit;
    static string s_nb_satelite_airmar_unit;

    static string prj_name = "";
    static string device_name = "";
    static string location;
    static string timeref;
    static string timestamp;
    static string direction;
    static string direction_M;
    static string orientation;

    //static string l_prj_name = "PROJECT NAME : ";
    //static string l_device_name = "DEVICE NAME : ";
    //static string l_location = "MEASUREMENT LOCATION :";
    //static string l_timeref = "TIMEREF : ";
    //static string l_timestamp = "TIMESTAMP : ";
    //static string l_direction = "DIRECTION : ";
    //static string l_orientation = "NORTH : ";


    protected void Page_Init(object sender, EventArgs e)
    {
        InitField();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");


        DownloadWindButton.Text = _2_equipname_alias.Value + ' ' + download_data.Value;
        DownloadMeteoButton.Text = _0_equipname_alias.Value + ' ' + download_data.Value;

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // TELECHARGEMENTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    private List<string> MakeHeader( string device)
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

    private List<string> MakeHeader2(string device)
    {


        List<string> output = new List<string>();
        output.Add(Global.l_prj_name + prj_name);
        output.Add(Global.l_device_name + device);
        output.Add(Global.l_location + location);
        output.Add(Global.l_timeref + timeref);
        output.Add(Global.l_timestamp + timestamp);
        output.Add(Global.l_direction + "none");
        output.Add(Global.l_orientation + orientation);


        return output;
    }


    protected void DownloadWind(object Source, EventArgs e)
    {
        string start_date = "";
        string end_date = "";

        string speed_unit = s_wind_speed_avg_unit;
        string dir_unit = s_wind_dir_avg_unit;

        device_name = Resources.meteo._2_equip_name_alias;
        List<string> output = MakeHeader( device_name);

        output.Add("UTC datetime;"  + wind_speed_avg_label.Value + '(' + speed_unit + ')' + ';'
                                    + wind_speed_max_label.Value + '(' + speed_unit + ')' + ';'
                                    + wind_speed_min_label.Value + '(' + speed_unit + ')' + ';'
                                    + wind_dir_avg_label.Value + '(' + dir_unit + ')' + ';'
                                    + wind_dir_max_label.Value + '(' + dir_unit + ')' + ';'
                                    + wind_dir_min_label.Value + '(' + dir_unit + ')' + ';');

        // mise en forme
        for (int i = 0; i < downloaddata.wxt_wind_str_time.Length; i++)
        {
            DateTime date = Convert.ToDateTime(downloaddata.wxt_wind_str_time[i]).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            string s_date = date.ToString("yyyy-MM-ddTHH:mm");

            output.Add(   s_date.Replace("T", ", ") + ';'
                        + downloaddata.wxt_wind_speed_avg[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.wxt_wind_speed_max[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.wxt_wind_speed_min[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.wxt_wind_dir_avg[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.wxt_wind_dir_max[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.wxt_wind_dir_min[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        );

            if (i == 0)
                start_date = s_date;
            if (i == downloaddata.wxt_wind_str_time.Length - 1)
                end_date = s_date;

        }

        string interval = start_date.Split('T')[0] + "_to_" + end_date.Split('T')[0];

        DownloadCsv(prj_name + '-' + device_name + '-' + WebConfigurationManager.AppSettings["Location"] + '-' + interval + ".csv", output.ToArray());
    }


    protected void DownloadMeteo(object Source, EventArgs e)
    {
        string start_date = "";
        string end_date = "";

        device_name = Resources.meteo._0_equip_name;
        List<string> output = MakeHeader2(device_name);

        output.Add("UTC datetime;" + temperature_label.Value + '(' + temperature_unit.Value + ')' + ';'
                                   + pressure_label.Value + '(' + pressure_unit.Value + ')' + ';'
                                    );

        // mise en forme
        for (int i = 0; i < downloaddata.wxt_str_time.Length; i++)
        {
            DateTime date = Convert.ToDateTime(downloaddata.wxt_str_time[i]).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            string s_date = date.ToString("yyyy-MM-ddTHH:mm");

            output.Add(downloaddata.wxt_str_time[i].Replace("T", ", ") + ';'
                        + downloaddata.wxt_temp[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.wxt_press[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        );

            if (i == 0)
                start_date = s_date;
            if (i == downloaddata.wxt_str_time.Length - 1)
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
        Page.Response.ContentType = "text/csv";
        Page.Response.WriteFile(file.FullName);
        Page.Response.End();
    }

    [System.Web.Services.WebMethod]

    //Only create field if page is not displayed
    protected void CreateField()
    {
        _0_equipname = new HiddenField();
        _0_equipname_alias = new HiddenField();
        _1_equipname = new HiddenField();
        _2_equipname = new HiddenField();
        _2_equipname_alias = new HiddenField();
        _3_equipname = new HiddenField();
        _4_equipname = new HiddenField();

        temperature = new HiddenField();
        pressure = new HiddenField();
        humidity = new HiddenField();
        rain_acc = new HiddenField();
        rain_duration = new HiddenField();
        rain_intensity = new HiddenField();
        wind_speed_avg = new HiddenField();
        wind_dir_avg = new HiddenField();
        wind_speed_max = new HiddenField();
        wind_dir_max = new HiddenField();

        wind_speed_min = new HiddenField();
        wind_dir_min = new HiddenField();

        temp_airmar = new HiddenField();
        press_airmar = new HiddenField();
        wind_speed_avg_airmar = new HiddenField();
        wind_speed_max_airmar = new HiddenField();
        wind_dir_airmar = new HiddenField();
        voltage_airmar = new HiddenField();
        lat_airmar = new HiddenField();
        lng_airmar = new HiddenField();
        gps_quality_airmar = new HiddenField();
        nb_satelite_airmar = new HiddenField();

        temperature_unit = new HiddenField();
        pressure_unit = new HiddenField();
        humidity_unit = new HiddenField();
        rain_acc_unit = new HiddenField();
        rain_duration_unit = new HiddenField();
        rain_intensity_unit = new HiddenField();
        wind_speed_avg_unit = new HiddenField();
        wind_dir_avg_unit = new HiddenField();
        wind_speed_max_unit = new HiddenField();
        wind_dir_max_unit = new HiddenField();
        temp_airmar_unit = new HiddenField();
        press_airmar_unit = new HiddenField();
        wind_speed_avg_airmar_unit = new HiddenField();
        wind_speed_max_airmar_unit = new HiddenField();
        wind_dir_airmar_unit = new HiddenField();
        voltage_airmar_unit = new HiddenField();
        lat_airmar_unit = new HiddenField();
        lng_airmar_unit = new HiddenField();
        gps_quality_airmar_unit = new HiddenField();
        nb_satelite_airmar_unit = new HiddenField();

        temperature_label = new HiddenField();
        pressure_label = new HiddenField();
        humidity_label = new HiddenField();
        rain_acc_label = new HiddenField();
        rain_duration_label = new HiddenField();
        rain_intensity_label = new HiddenField();
        wind_speed_avg_label = new HiddenField();
        wind_dir_avg_label = new HiddenField();
        wind_speed_max_label = new HiddenField();
        wind_speed_max_label_alias = new HiddenField();
        wind_dir_max_label = new HiddenField();

        wind_speed_min_label    = new HiddenField();
        wind_dir_min_label      = new HiddenField();

        temp_airmar_label = new HiddenField();
        press_airmar_label = new HiddenField();
        wind_speed_avg_airmar_label = new HiddenField();
        wind_speed_max_airmar_label = new HiddenField();
        wind_dir_airmar_label = new HiddenField();
        voltage_airmar_label = new HiddenField();
        lat_airmar_label = new HiddenField();
        lng_airmar_label = new HiddenField();
        gps_quality_airmar_label = new HiddenField();
        nb_satelite_airmar_label = new HiddenField();

        

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
        timeref = Resources.meteo.TIMEREF;
        timestamp = Resources.meteo.TIMESTAMP;
        direction = Resources.meteo.DIRECTION;
        direction_M = Resources.meteo.DIRECTION_M;
        orientation = Resources.meteo.ORIENTATION;

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
        _0_equipname.Value = Resources.meteo._0_equip_name.ToString();
        _0_equipname_alias.Value = Resources.meteo._0_equip_name_alias.ToString();
        _1_equipname.Value = Resources.meteo._1_equip_name.ToString();
        _2_equipname.Value = Resources.meteo._2_equip_name.ToString();
        _2_equipname_alias.Value = Resources.meteo._2_equip_name_alias.ToString();
        _3_equipname.Value = Resources.meteo._3_equip_name.ToString();
        _4_equipname.Value = Resources.meteo._4_equip_name.ToString();
        //_5_equipname.Value = Resources.meteo._5_equip_name.ToString();

        temperature.Value = Resources.meteo._0_param0name.ToString();
        pressure.Value = Resources.meteo._0_param1name.ToString();
        humidity.Value = Resources.meteo._0_param2name.ToString();
        rain_acc.Value = Resources.meteo._1_param0name.ToString();
        rain_duration.Value =           Resources.meteo._1_param1name.ToString();
        rain_intensity.Value =          Resources.meteo._1_param2name.ToString();
        wind_speed_avg.Value =          Resources.meteo._2_param0name.ToString();
        wind_dir_avg.Value =            Resources.meteo._2_param1name.ToString();
        wind_speed_max.Value =          Resources.meteo._2_param2name.ToString();
        wind_dir_max.Value =            Resources.meteo._2_param3name.ToString();

        wind_speed_min.Value = Resources.meteo._2_param5name.ToString();
        wind_dir_min.Value = Resources.meteo._2_param4name.ToString();

        temp_airmar.Value =             Resources.meteo._3_param0name.ToString();
        press_airmar.Value =            Resources.meteo._3_param1name.ToString();
        wind_speed_avg_airmar.Value =   Resources.meteo._3_param2name.ToString();
        wind_speed_max_airmar.Value =   Resources.meteo._3_param3name.ToString();
        wind_dir_airmar.Value =         Resources.meteo._3_param4name.ToString();
        voltage_airmar.Value =          Resources.meteo._3_param5name.ToString();
        lat_airmar.Value =              Resources.meteo._4_param0name.ToString();
        lng_airmar.Value =              Resources.meteo._4_param1name.ToString();
        gps_quality_airmar.Value =      Resources.meteo._4_param2name.ToString();
        nb_satelite_airmar.Value =      Resources.meteo._4_param3name.ToString();

        temperature_unit.Value = Resources.meteo._0_param0unit.ToString();
        pressure_unit.Value = Resources.meteo._0_param1unit.ToString();
        humidity_unit.Value = Resources.meteo._0_param2unit.ToString();
        rain_acc_unit.Value = Resources.meteo._1_param0unit.ToString();
        rain_duration_unit.Value = Resources.meteo._1_param1unit.ToString();
        rain_intensity_unit.Value = Resources.meteo._1_param2unit.ToString();
        wind_speed_avg_unit.Value = Resources.meteo._2_param0unit.ToString();
        wind_dir_avg_unit.Value = Resources.meteo._2_param1unit.ToString();
        wind_speed_max_unit.Value = Resources.meteo._2_param2unit.ToString();
        wind_dir_max_unit.Value = Resources.meteo._2_param3unit.ToString();
        temp_airmar_unit.Value = Resources.meteo._3_param0unit.ToString();
        press_airmar_unit.Value = Resources.meteo._3_param1unit.ToString();
        wind_speed_avg_airmar_unit.Value = Resources.meteo._3_param2unit.ToString();
        wind_speed_max_airmar_unit.Value = Resources.meteo._3_param3unit.ToString();
        wind_dir_airmar_unit.Value = Resources.meteo._3_param4unit.ToString();
        voltage_airmar_unit.Value = Resources.meteo._3_param5unit.ToString();
        lat_airmar_unit.Value = Resources.meteo._4_param0unit.ToString();
        lng_airmar_unit.Value = Resources.meteo._4_param1unit.ToString();
        gps_quality_airmar_unit.Value = Resources.meteo._4_param2unit.ToString();
        nb_satelite_airmar_unit.Value = Resources.meteo._4_param3unit.ToString();

        temperature_label.Value = Resources.meteo._0_param0label.ToString();
        pressure_label.Value = Resources.meteo._0_param1label.ToString();
        humidity_label.Value = Resources.meteo._0_param2label.ToString();
        rain_acc_label.Value = Resources.meteo._1_param0label.ToString();
        rain_duration_label.Value = Resources.meteo._1_param1label.ToString();
        rain_intensity_label.Value = Resources.meteo._1_param2label.ToString();
        wind_speed_avg_label.Value = Resources.meteo._2_param0label.ToString();
        wind_dir_avg_label.Value = Resources.meteo._2_param1label.ToString();
        wind_speed_max_label.Value = Resources.meteo._2_param2label.ToString();
        wind_speed_max_label_alias.Value = Resources.meteo._2_param2label_alias.ToString();
        wind_dir_max_label.Value = Resources.meteo._2_param3label.ToString();
        wind_speed_min_label.Value = Resources.meteo._2_param5label.ToString();
        wind_dir_min_label.Value = Resources.meteo._2_param4label.ToString();

        temp_airmar_label.Value = Resources.meteo._3_param0label.ToString();
        press_airmar_label.Value = Resources.meteo._3_param1label.ToString();
        wind_speed_avg_airmar_label.Value = Resources.meteo._3_param2label.ToString();
        wind_speed_max_airmar_label.Value = Resources.meteo._3_param3label.ToString();
        wind_dir_airmar_label.Value = Resources.meteo._3_param4label.ToString();
        voltage_airmar_label.Value = Resources.meteo._3_param5label.ToString();
        lat_airmar_label.Value = Resources.meteo._4_param0label.ToString();
        lng_airmar_label.Value = Resources.meteo._4_param1label.ToString();
        gps_quality_airmar_label.Value = Resources.meteo._4_param2label.ToString();
        nb_satelite_airmar_label.Value = Resources.meteo._4_param3label.ToString();



        //Assigning string value
        s_temperature = temperature.Value;
        s_pressure = pressure.Value;

        s_humidity = humidity.Value;
        s_rain_acc = rain_acc.Value;

        s_rain_duration = rain_duration.Value;
        s_rain_intensity = rain_intensity.Value;

        s_wind_speed_avg = wind_speed_avg.Value;
        s_wind_dir_avg = wind_dir_avg.Value;

        s_wind_speed_max = wind_speed_max.Value;
        s_wind_dir_max = wind_dir_max.Value;

        s_wind_speed_min = wind_speed_min.Value;
        s_wind_dir_min = wind_dir_min.Value;

        s_temp_airmar = temp_airmar.Value;
        s_press_airmar = press_airmar.Value;
        s_wind_speed_avg_airmar = wind_speed_avg_airmar.Value;
        s_wind_speed_max_airmar = wind_speed_max_airmar.Value;
        s_wind_dir_airmar = wind_dir_airmar.Value;
        s_voltage_airmar = voltage_airmar.Value;
        s_lat_airmar = lat_airmar.Value;
        s_lng_airmar = lng_airmar.Value;
        s_gps_quality_airmar = gps_quality_airmar.Value;
        s_nb_satelite_airmar = nb_satelite_airmar.Value;

        s_temperature_unit = temperature_unit.Value;
        s_pressure_unit = pressure_unit.Value;

        s_humidity_unit = humidity_unit.Value;
        s_rain_acc_unit = rain_acc_unit.Value;

        s_rain_duration_unit = rain_duration_unit.Value;
        s_rain_intensity_unit = rain_intensity_unit.Value;

        s_wind_speed_avg_unit = wind_speed_avg_unit.Value;
        s_wind_dir_avg_unit = wind_dir_avg_unit.Value;

        s_wind_speed_max_unit = wind_speed_max_unit.Value;
        s_wind_dir_max_unit = wind_dir_max_unit.Value;

        s_temp_airmar_unit = temp_airmar_unit.Value;
        s_press_airmar_unit = press_airmar_unit.Value;
        s_wind_speed_avg_airmar_unit = wind_speed_avg_airmar_unit.Value;
        s_wind_speed_max_airmar_unit = wind_speed_max_airmar_unit.Value;
        s_wind_dir_airmar_unit = wind_dir_airmar_unit.Value;
        s_voltage_airmar_unit = voltage_airmar_unit.Value;
        s_lat_airmar_unit = lat_airmar_unit.Value;
        s_lng_airmar_unit = lng_airmar_unit.Value;
        s_gps_quality_airmar_unit = gps_quality_airmar_unit.Value;
        s_nb_satelite_airmar_unit = nb_satelite_airmar_unit.Value;


        _0_equip_name = _0_equipname.Value;
        _0_equip_name_alias = _0_equipname_alias.Value;
        _1_equip_name = _1_equipname.Value;
        _2_equip_name = _2_equipname.Value;
        _2_equip_name_alias = _2_equipname_alias.Value;
        _3_equip_name = _3_equipname.Value;
        _4_equip_name = _4_equipname.Value;

        
    }

    [System.Web.Services.WebMethod]
    public static data_type_Meteo_0 GetValuesFrom(string begin, string end)
    {
        Meteo test = new Meteo();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    //public static data_Aquapro GetValues(string begin, string end)
    public static data_type_Meteo_0 GetValues(string begin, string end)
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


        List<double> list_par0 = new List<double>();
        List<double> list_par1 = new List<double>();
        List<double> list_par2 = new List<double>();
        List<double> list_par3 = new List<double>();
        List<double> list_par4 = new List<double>();
        List<double> list_par5 = new List<double>();
        List<double> list_par6 = new List<double>();
        List<double> list_par7 = new List<double>();
        List<double> list_par8 = new List<double>();
        List<double> list_par9 = new List<double>();
        List<double> list_par10 = new List<double>();
        List<double> list_par11 = new List<double>();
        List<double> list_par12 = new List<double>();
        List<double> list_par13 = new List<double>();
        List<double> list_par14 = new List<double>();
        List<double> list_par15 = new List<double>();
        List<double> list_par16 = new List<double>();
        List<double> list_par17 = new List<double>();
        List<double> list_par18 = new List<double>();
        List<double> list_par19 = new List<double>();
        List<string> list_str_time0 = new List<string>();
        List<string> list_str_time1 = new List<string>();
        List<string> list_str_time2 = new List<string>();
        List<string> list_str_time3 = new List<string>();
        List<string> list_str_time4 = new List<string>();

        List<double> list_par20 = new List<double>();
        List<double> list_par21 = new List<double>();


        data_type_Meteo_0 data = new data_type_Meteo_0();

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// Read data for equipment 0 -- look in resx table to know how many parameter to read
        DataSet ds = new DataSet();
        string str_connect = "SELECT a.TIME_REC, a." + s_temperature + ",a." + s_pressure + ", a." + s_humidity + " FROM " + _0_equip_name + " a" + timestampsrequest + " order by a.TIME_REC";
        
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

            list_str_time0.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_par0.Add(Math.Round(double.Parse(dRow[s_temperature].ToString()), 2));
            list_par1.Add(double.Parse(dRow[s_pressure].ToString()));
            list_par2.Add(double.Parse(dRow[s_humidity].ToString()));
        }

        data.set_param_equip_0(list_par0, list_par1, list_par2, list_str_time0);

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// Read data for equipment 1 -- look in resx table to know how many parameter to read
        //ds = new DataSet();
        //str_connect = "SELECT a.TIME_REC, a." + s_rain_acc + ",a." + s_rain_duration + ", a." + s_rain_intensity + " FROM " + _1_equip_name + " a" + timestampsrequest + " order by a.TIME_REC";
        
        //dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        //dataadapter.Fill(ds);
        //myDataTable = ds.Tables[0];

        //foreach (DataRow dRow in myDataTable.Rows)
        //{
        //    DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

        //    // UTC to Local Time
        //    date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

        //    list_str_time1.Add(date.ToString("yyyy-MM-ddTHH:mm"));

        //    list_par3.Add(double.Parse(dRow[s_rain_acc].ToString()));
        //    list_par4.Add(double.Parse(dRow[s_rain_duration].ToString()));
        //    list_par5.Add(double.Parse(dRow[s_rain_intensity].ToString()));
        //}

        //data.set_param_equip_1(list_par3, list_par4, list_par5, list_str_time1);

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// Read data for equipment 2 -- look in resx table to know how many parameter to read
        ds = new DataSet();
        str_connect = "SELECT a.TIME_REC, a." + s_wind_speed_avg + ",a." + s_wind_dir_avg + ", a." + s_wind_speed_max + ", a." + s_wind_dir_max + ", a." + s_wind_speed_min + ", a." + s_wind_dir_min + " FROM " + _2_equip_name + " a" + timestampsrequest + " order by a.TIME_REC";
        
        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

            list_str_time2.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_par6.Add(double.Parse(dRow[s_wind_speed_avg].ToString()));
            list_par7.Add(double.Parse(dRow[s_wind_dir_avg].ToString()));
            list_par8.Add(double.Parse(dRow[s_wind_speed_max].ToString()));
            list_par9.Add(double.Parse(dRow[s_wind_dir_max].ToString()));
            list_par20.Add(double.Parse(dRow[s_wind_speed_min].ToString()));
            list_par21.Add(double.Parse(dRow[s_wind_dir_min].ToString()));
        }

        data.set_param_equip_2(list_par6, list_par7, list_par8, list_par9, list_par20, list_par21, list_str_time2);

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// Read data for equipment 3 -- look in resx table to know how many parameter to read
        ds = new DataSet();
        str_connect = "SELECT a.TIME_REC, a." + s_temp_airmar + ",a." + s_press_airmar + ", a." + s_wind_speed_avg_airmar + ", a." + s_wind_speed_max_airmar + ", a." 
                                            + s_wind_dir_airmar + ", a." + s_voltage_airmar + " FROM " + _3_equip_name + " a" + 
                        timestampsrequest + " order by a.TIME_REC";

        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

            list_str_time3.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_par10.Add(double.Parse(dRow[s_temp_airmar].ToString()));
            list_par11.Add(double.Parse(dRow[s_press_airmar].ToString()));
            list_par12.Add(double.Parse(dRow[s_wind_speed_avg_airmar].ToString()));
            list_par13.Add(double.Parse(dRow[s_wind_speed_max_airmar].ToString()));
            list_par14.Add(double.Parse(dRow[s_wind_dir_airmar].ToString()));
            list_par15.Add(double.Parse(dRow[s_voltage_airmar].ToString()));
        }

        data.set_param_equip_3(list_par10, list_par11, list_par12, list_par13, list_par14, list_par15, list_str_time3);

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// Read data for equipment 4 -- look in resx table to know how many parameter to read
        ds = new DataSet();
        str_connect = "SELECT a.TIME_REC, a." + s_lat_airmar + ",a." + s_lng_airmar + ", a." + s_gps_quality_airmar + ", a." + s_nb_satelite_airmar + " FROM " + _4_equip_name + " a" +
                        timestampsrequest + " order by a.TIME_REC";

        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

            list_str_time4.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_par16.Add(double.Parse(dRow[s_lat_airmar].ToString()));
            list_par17.Add(double.Parse(dRow[s_lng_airmar].ToString()));
            list_par18.Add(double.Parse(dRow[s_gps_quality_airmar].ToString()));
            list_par19.Add(double.Parse(dRow[s_nb_satelite_airmar].ToString()));
        }

        data.set_param_equip_4(list_par10, list_par11, list_par12, list_par13, list_str_time4);

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        //DataSet ds = new DataSet();
        //string str_connect = "SELECT a.TIME_REC, a." + param0_name + ",a." + param1_name + ", a." + param2_name + ", a." + param3_name + " FROM " + equip_name + " a" + timestampsrequest + " order by a.TIME_REC";
        ////string str_connect = "SELECT a.TIME_REC FROM C4E " + timestampsrequest + " order by a.TIME_REC";
        //FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(str_connect, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        //dataadapter.Fill(ds);
        //DataTable myDataTable = ds.Tables[0];

        //List<double> list_par0 = new List<double>();
        //List<double> list_par1 = new List<double>();
        //List<double> list_par2 = new List<double>();
        //List<double> list_par3 = new List<double>();
        //List<double> list_par4 = new List<double>();
        //List<string> list_str_time = new List<string>();

        //foreach (DataRow dRow in myDataTable.Rows)
        //{
        //    DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

        //    // UTC to Local Time
        //    date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

        //    list_str_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

        //    list_par0.Add(Math.Round(double.Parse(dRow[param0_name].ToString()), 2));
        //    list_par1.Add(double.Parse(dRow[param1_name].ToString()));
        //    list_par2.Add(double.Parse(dRow[param2_name].ToString()));
        //    list_par3.Add(double.Parse(dRow[param3_name].ToString()));
        //}


        // Build meteo data object


        //data.set_param(list_par0, list_par1, list_par2, list_par3, list_par4, list_str_time);

        //telechargement

        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }


}

    public class data_type_Meteo_0
    {
    //public double[] param0;     // temperature
    //public double[] param1;     // pressure
    //public double[] param2;     // humidity
    public double[] wxt_temp;     // temperature
    public double[] wxt_press;     // pressure
    public double[] wxt_hum;     // humidity
        public double[] wxt_rain_acc;     // rain_acc
        public double[] wxt_rain_d;     // rain_duration
        public double[] wxt_rain_i;     // rain_intensity
        public double[] wxt_wind_speed_avg;     // wind_speed_avg
        public double[] wxt_wind_dir_avg;     // wind_dir_avg
        public double[] wxt_wind_speed_max;     // wind_speed_max
        public double[] wxt_wind_dir_max;     // wind_dir_max

    public double[] wxt_wind_speed_min;     // wind_speed_max
    public double[] wxt_wind_dir_min;     // wind_dir_max

        public double[] wx_temp;    // temp_airmar
        public double[] wx_press;    // press_airmar
        public double[] wx_wind_speed_avg;    // wind_speed_avg_airmar
        public double[] wx_wind_speed_max;    // wind_speed_max_airmar
        public double[] wx_wind_dir;    // wind_dir_airmar
        public double[] wx_volt;    // voltage_airmar
        public double[] wx_lat;    // lat_airmar
        public double[] wx_lng;    // lng_airmar
        public double[] wx_gps_q;    // gps_quality_airmar
        public double[] wx_gps_nb;    // nb_satelite_airmar
        public string[] wxt_str_time;  // temperature pressure humidity
        public string[] wxt_rain_str_time;  // rain
        public string[] wxt_wind_str_time;  //wind_speed_avg / wind_dir_avg / wind_speed_max / wind_dir_max
        public string[] wx_str_time;  //temp_airmar / press_airmar / wind_speed_avg_airmar / wind_speed_max_airmar / wind_dir_airmar / voltage_airmar
        public string[] wx_gps_str_time;  //lat_airmar / lng_airmar / gps_quality_airmar / nb_satelite_airmar


    // temperature pressure humidity
    public void set_param_equip_0(List<double> w_par0, List<double> w_par1, List<double> w_par2, List<string> w_time)
    {
        //param0 = w_par0.ToArray();
        //param1 = w_par1.ToArray();
        //param2 = w_par2.ToArray();
        wxt_temp = w_par0.ToArray();
        wxt_press = w_par1.ToArray();
        wxt_hum = w_par2.ToArray();
        wxt_str_time = w_time.ToArray();
    }

        public void set_param_equip_1(List<double> w_par0, List<double> w_par1, List<double> w_par2, List<string> w_time)
        {
            wxt_rain_acc = w_par0.ToArray();
            wxt_rain_d = w_par1.ToArray();
            wxt_rain_i = w_par2.ToArray();
        wxt_rain_str_time = w_time.ToArray();
        }

    //wind_speed_avg / wind_dir_avg / wind_speed_max / wind_dir_max
        public void set_param_equip_2(List<double> w_par0, List<double> w_par1, List<double> w_par2, List<double> w_par3, List<double> w_par4, List<double> w_par5, List<string> w_time)
        {
            wxt_wind_speed_avg = w_par0.ToArray();
            wxt_wind_dir_avg = w_par1.ToArray();
            wxt_wind_speed_max = w_par2.ToArray();
            wxt_wind_dir_max = w_par3.ToArray();
        wxt_wind_speed_min = w_par4.ToArray();
        wxt_wind_dir_min = w_par5.ToArray();
        wxt_wind_str_time = w_time.ToArray();
        

    }

    //AIRMAR
    //temp_airmar / press_airmar / wind_speed_avg_airmar / wind_speed_max_airmar / wind_dir_airmar / voltage_airmar
        public void set_param_equip_3(List<double> w_par0, List<double> w_par1, List<double> w_par2, List<double> w_par3, List<double> w_par4, List<double> w_par5, List<string> w_time)
        {
            wx_temp = w_par0.ToArray();
            wx_press = w_par1.ToArray();
            wx_wind_speed_avg = w_par2.ToArray();
            wx_wind_speed_max = w_par3.ToArray();
            wx_wind_dir = w_par4.ToArray();
            wx_volt = w_par5.ToArray();
        wx_str_time = w_time.ToArray();
        }

    //AIRMAR
    //lat_airmar / lng_airmar / gps_quality_airmar / nb_satelite_airmar
        public void set_param_equip_4(List<double> w_par0, List<double> w_par1, List<double> w_par2, List<double> w_par3, List<string> w_time)
        {
            wx_lat = w_par0.ToArray();
            wx_lng = w_par1.ToArray();
            wx_gps_q = w_par2.ToArray();
            wx_gps_nb = w_par3.ToArray();
        wx_gps_str_time = w_time.ToArray();
        }
    }
