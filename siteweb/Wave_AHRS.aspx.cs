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

using System.Web.Security;

using GlobalVariables;

public partial class WaveAHRS : System.Web.UI.Page
{
    static public dataWaveAHRS downloaddata;

    static string prj_name = "";
    static string device_name = "";
    static string location;
    static string timeref;
    static string timestamp;
    static string direction;
    static string orientation;


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

        
        output.Add(Global.l_orientation + orientation + ' ' + downloaddata.declination.ToString("0.00", NumberFormatInfo.InvariantInfo));
        //output.Add(Global.l_orientation + orientation);


        return output;
    }


    protected void DownloadWave(object Source, EventArgs e)
    {
        string start_date = "";
        string end_date = "";

        device_name = Resources.WaveAHRS.DEVICE_0;
        List<string> output = MakeHeader(device_name);

        output.Add("UTC datetime;"  + h_sig_label_alias.Value + '(' + h_unit.Value + ')' + ';'
                                    + h_3_label_alias.Value + '(' + h_unit.Value + ')' + ';'
                                    + h_max_label_alias.Value + '(' + h_unit.Value + ')' + ';'
                                    + t_peak_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + t_z_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + t_m01_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + t_hmax_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + t_m02_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    //+ t_avg_label.Value + '(' + t_unit + ')' + ';'
                                    + t_3_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + d_avg_label_alias.Value + '(' + d_unit.Value + ')' + ';'
                                    + d_peak_label_alias.Value + '(' + d_unit.Value + ')' + ';'
                                    + d_spread_label_alias.Value + '(' + d_unit.Value + ')' + ';'
                                    + n_waves_alias.Value + ';'
                                    + t_e_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + etamax_label_alias.Value + '(' + h_unit.Value + ')' + ';'
                                    + etamin_label_alias.Value + '(' + h_unit.Value + ')' + ';'
                                    + t_max_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + "nbr_system;"
                                    );

        // mise en forme
        for (int i = 0; i < downloaddata.H_time.Length; i++)
        {
            DateTime date = Convert.ToDateTime(downloaddata.H_time[i]).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            string s_date = date.ToString("yyyy-MM-ddTHH:mm");

            output.Add(s_date.Replace("T", ", ") + ';'
                        + downloaddata.H_m0[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.H_tier[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.H_max[i].ToString("0.00", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_p[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_z[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_m01[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_hmax[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_m02[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_3[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.D_mean[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.D_peak[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.D_sd[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.N_waves[i].ToString("0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_e[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.ETAmax[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.ETAmin[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_max[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + '2'
                        );

            if (i == 0)
                start_date = s_date;
            if (i == downloaddata.H_time.Length - 1)
                end_date = s_date;

        }

        

        string interval =start_date.Split('T')[0] + "_to_" + end_date.Split('T')[0];

        DownloadCsv(prj_name + '-' + device_name + '-' + WebConfigurationManager.AppSettings["Location"] + '-' + interval + ".csv", output.ToArray());
    }

    //protected void DownloadWave(object Source, EventArgs e)
    //{

    //    string[] output = new string[downloaddata.H_time.Length + 1];
    //    output[0] = "local datetime;Hsig;Hmax;Tmean;Tpeak;DirTpeak;DirMean";
  

    //    // mise en forme
    //    for (int i = 0; i < downloaddata.H_time.Length; i++)
    //    {
    //        output[i + 1] += downloaddata.H_time[i].Replace("T", ", ");
    //        output[i + 1] += ";";
    //        output[i + 1] += downloaddata.H_sig[i].ToString("0.00", NumberFormatInfo.InvariantInfo); 
    //        output[i + 1] += ";";
    //        output[i + 1] += downloaddata.H_max[i].ToString("0.00", NumberFormatInfo.InvariantInfo); ;
    //        output[i + 1] += ";";
    //        output[i + 1] += downloaddata.T_mean[i].ToString("0.00", NumberFormatInfo.InvariantInfo); ;
    //        output[i + 1] += ";";
    //        output[i + 1] += downloaddata.T_peak[i].ToString("0.00", NumberFormatInfo.InvariantInfo); ;
    //        output[i + 1] += ";";
    //        output[i + 1] += downloaddata.D_peak[i].ToString("0.0", NumberFormatInfo.InvariantInfo); ;
    //        output[i + 1] += ";";
    //        output[i + 1] += downloaddata.D_mean[i].ToString("0.0", NumberFormatInfo.InvariantInfo); ;
    //        output[i + 1] += ";";
    //    }

    //    string interval = downloaddata.H_time[0].Split('T')[0] + "_to_" + downloaddata.H_time[downloaddata.H_time.Length - 1].Split('T')[0];

    //    // Créer fichier csv et Télécharger
    //    DownloadCsv("wave_" + interval + ".csv", output);
    //}

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

    //Only create field if page is not displayed
    protected void CreateField()
    {
        d_avg_label = new HiddenField();
        d_peak_label = new HiddenField();
        d_spread_label = new HiddenField();
        n_waves = new HiddenField();
        d_unit = new HiddenField();
        equip_name = new HiddenField();
        h_label = new HiddenField();
        h_max_label = new HiddenField();
        h_3_label = new HiddenField();
        h_sig_label = new HiddenField();
        h_unit = new HiddenField();
        t_avg_label = new HiddenField();
        t_max_label = new HiddenField();
        t_peak_label = new HiddenField();
        t_m01_label = new HiddenField();
        t_m02_label = new HiddenField();
        t_3_label = new HiddenField();
        t_z_label = new HiddenField();
        t_unit = new HiddenField();
        t_label = new HiddenField();
        d_label = new HiddenField();

        h_sig_label_alias = new HiddenField();
        h_3_label_alias = new HiddenField();
        h_max_label_alias = new HiddenField();
        t_peak_label_alias = new HiddenField();
        t_z_label_alias = new HiddenField();
        t_m01_label_alias = new HiddenField();
        t_hmax_label_alias = new HiddenField();
        t_max_label_alias = new HiddenField();
        t_m02_label_alias = new HiddenField();
        t_3_label_alias = new HiddenField();
        d_avg_label_alias = new HiddenField();
        d_peak_label_alias = new HiddenField();
        d_spread_label_alias = new HiddenField();
        n_waves_alias = new HiddenField();


        t_e_label_alias = new HiddenField();

        etamax_label_alias = new HiddenField();
        etamin_label_alias = new HiddenField();

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
        timeref = Resources.WaveAHRS.TIMEREF;
        timestamp = Resources.WaveAHRS.TIMESTAMP;
        direction = Resources.WaveAHRS.DIRECTION;

        if (WebConfigurationManager.AppSettings["DECLINATION"] == "true")
            orientation = Resources.Site.Master.orientationG + ", " + Resources.Site.Master.declination;
        else
            orientation = Resources.Site.Master.orientationM;
        //orientation = Resources.WaveAHRS.ORIENTATION;


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
        d_avg_label.Value = Resources.WaveAHRS.d_avg_label.ToString();
        d_peak_label.Value = Resources.WaveAHRS.d_peak_label.ToString();
        d_spread_label.Value = Resources.WaveAHRS.d_spread_label.ToString();
        n_waves.Value = Resources.WaveAHRS.n_waves.ToString();
        d_unit.Value = Resources.WaveAHRS.d_unit.ToString();
        equip_name.Value = Resources.WaveAHRS.equip_name.ToString();
        h_label.Value = Resources.WaveAHRS.h_label.ToString();
        h_max_label.Value = Resources.WaveAHRS.h_max_label.ToString();
        h_3_label.Value = Resources.WaveAHRS.h_3_label.ToString();
        h_sig_label.Value = Resources.WaveAHRS.h_sig_label.ToString();
        h_unit.Value = Resources.WaveAHRS.h_unit.ToString();
        t_avg_label.Value = Resources.WaveAHRS.t_avg_label.ToString();
        t_max_label.Value = Resources.WaveAHRS.t_max_label.ToString();
        t_peak_label.Value = Resources.WaveAHRS.t_peak_label.ToString();
        t_m01_label.Value = Resources.WaveAHRS.t_m01_label.ToString();
        t_m02_label.Value = Resources.WaveAHRS.t_m02_label.ToString();
        t_3_label.Value = Resources.WaveAHRS.t_3_label.ToString();
        t_z_label.Value = Resources.WaveAHRS.t_z_label.ToString();
        t_unit.Value = Resources.WaveAHRS.t_unit.ToString();
        t_label.Value = Resources.WaveAHRS.t_label.ToString();
        d_label.Value = Resources.WaveAHRS.d_label.ToString();


        h_sig_label_alias.Value = Resources.WaveAHRS.h_sig_label_alias.ToString();
        h_3_label_alias.Value = Resources.WaveAHRS.h_3_label_alias.ToString();
        h_max_label_alias.Value = Resources.WaveAHRS.h_max_label_alias.ToString();
        t_peak_label_alias.Value = Resources.WaveAHRS.t_peak_label_alias.ToString();
        t_z_label_alias.Value = Resources.WaveAHRS.t_z_label_alias.ToString();
        t_m01_label_alias.Value = Resources.WaveAHRS.t_m01_label_alias.ToString();
        t_max_label_alias.Value = Resources.WaveAHRS.t_max_label_alias.ToString();
        t_m02_label_alias.Value = Resources.WaveAHRS.t_m02_label_alias.ToString();
        t_3_label_alias.Value = Resources.WaveAHRS.t_3_label_alias.ToString();
        d_avg_label_alias.Value = Resources.WaveAHRS.d_avg_label_alias.ToString();
        d_peak_label_alias.Value = Resources.WaveAHRS.d_peak_label_alias.ToString();
        d_spread_label_alias.Value = Resources.WaveAHRS.d_spread_label_alias.ToString();
        n_waves_alias.Value = Resources.WaveAHRS.n_waves_alias.ToString();





        //Assigning string value

    }

    [System.Web.Services.WebMethod]
    public static dataWaveAHRS GetValuesFrom(string begin, string end)
    {
        WaveAHRS test = new WaveAHRS();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    public static dataWaveAHRS GetValues(string begin, string end)
    {

        DateTime stdate;
        DateTime endate;

        string timestampsrequest;
        //string DbRequest;

        DataSet ds;
        FbDataAdapter dataadapter;
        DataTable myDataTable;

        double decl = 0;

        ///////////////////////////////////////////////////////////////////////////
        /// Reading declination
        /// 
        endate = DateTime.Now;  // using local time ( declination time registering should be in local time )

        timestampsrequest = " WHERE a.TIME_LOG<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";


        ds = new DataSet();
        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_LOG, a.DECLINATION FROM DECLINATION a " + timestampsrequest + " order by a.TIME_LOG", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];

        List<double> list_decl = new List<double>();
        List<DateTime> list_time_decl = new List<DateTime>();

        // to be sure to have at least one element
        list_decl.Add(0);
        list_time_decl.Add(DateTime.MinValue);

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_LOG"].ToString());

            list_time_decl.Add(date);

            double tmp = double.Parse(dRow["DECLINATION"].ToString());
            list_decl.Add(tmp);
        }

        ///////////////////////////////////////////////////////////////////////////

        //double wave_compute_duration = double.Parse(WebConfigurationManager.AppSettings["Wave_Tps_acq"]);

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


        for (int i = 0; i < list_time_decl.Count; i++)
        {

            if (list_time_decl[i] < endate)
            {
                decl = list_decl[i];
            }
            else
                break;  // sql request sort list_time_decl in ascending form, so when if comparaison is false we can stop the loop 'for'
        }


        timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

        // Get wind from database
        ds = new DataSet();
        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.HM0,a.HMAX,a.H3,a.HM0_BF, a.HM0_HF, a.ETAMAX, a.ETAMIN FROM WAVES a "
                                                                        + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];



        List<double> list_h_sig = new List<double>();
        List<double> list_h_max = new List<double>();
        List<double> list_h_3 = new List<double>();
        List<double> list_etamax = new List<double>();
        List<double> list_etamin = new List<double>();
        List<string> list_h_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // converting start date in DB in end date !
            //date = date.AddSeconds(wave_compute_duration); 

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"]));
            

            list_h_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));
            list_h_sig.Add(double.Parse(dRow["HM0"].ToString()));
            list_h_max.Add(double.Parse(dRow["HMAX"].ToString()));
            list_h_3.Add(double.Parse(dRow["H3"].ToString()));
            list_etamax.Add(double.Parse(dRow["ETAMAX"].ToString()));
            list_etamin.Add(double.Parse(dRow["ETAMIN"].ToString()));
        }


        // Get Pressure and temperature from database
        ds = new DataSet();
        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.TP, a.TZ, a.TM01, a.THMAX, a.T02, a.T3, a.TE, a.TMAX FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];

        List<double> list_t_tp = new List<double>();
        List<double> list_t_tz = new List<double>();
        List<double> list_t_tm01 = new List<double>();
        List<double> list_t_thmax = new List<double>();
        List<double> list_t_tm02 = new List<double>();
        List<double> list_t_t3 = new List<double>();
        List<double> list_te = new List<double>();
        List<double> list_tmax = new List<double>();
        List<string> list_t_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // converting start date in DB in end date !
            //date = date.AddSeconds(wave_compute_duration);

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE;
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_t_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            double tmp;

            double tp = double.Parse(dRow["TP"].ToString());
            if (double.IsNaN(tp) || tp > 31)
            {
                if (list_t_tp.Count > 0)
                    tp = list_t_tp[list_t_tp.Count - 1];
                else
                    tp = 0;
            }
            list_t_tp.Add(tp);

            double tz = double.Parse(dRow["TZ"].ToString());
            if (double.IsNaN(tz) || tz > 31)
            {
                if (list_t_tz.Count > 0)
                    tz = list_t_tm02[list_t_tz.Count - 1];
                else
                    tz = 0;
            }
            list_t_tz.Add(tz);

            double tm01 = double.Parse(dRow["TM01"].ToString());
            if (double.IsNaN(tm01) || tm01 > 31)
            {
                if (list_t_tm01.Count > 0)
                    tm01 = list_t_tm02[list_t_tm01.Count - 1];
                else
                    tm01 = 0;
            }
            list_t_tm01.Add(tm01);

            double thmax = double.Parse(dRow["THMAX"].ToString());
            if (double.IsNaN(thmax) || thmax > 31)
            {
                if (list_t_thmax.Count > 0)
                    thmax = list_t_thmax[list_t_thmax.Count - 1];
                else
                    thmax = 0;
            }
            list_t_thmax.Add(thmax);

            double tm02 = double.Parse(dRow["T02"].ToString());
            if (double.IsNaN(tm02) || tm02 > 31)
            {
                if (list_t_tm02.Count > 0)
                    tm02 = list_t_tm02[list_t_tm02.Count - 1];
                else
                    tm02 = 0;
            }
            list_t_tm02.Add(tm02);

            double t3 = double.Parse(dRow["T3"].ToString());
            if (double.IsNaN(t3) || t3 > 31)
            {
                if (list_t_t3.Count > 0)
                    t3 = list_t_t3[list_t_t3.Count - 1];
                else
                    t3 = 0;
            }
            list_t_t3.Add(t3);

            double.TryParse(dRow["TE"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_te.Count > 0)
                    tmp = list_te[list_te.Count - 1];
                else
                    tmp = 0;
            }
            list_te.Add(tmp);

            double.TryParse(dRow["TMAX"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_te.Count > 0)
                    tmp = list_te[list_tmax.Count - 1];
                else
                    tmp = 0;
            }
            list_tmax.Add(tmp);


        }


        ds = new DataSet();
        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.DIRTP, a.DIRT02, a.SPRD, a.NUMW FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];

        List<double> list_d_mean = new List<double>();
        List<double> list_d_max = new List<double>();
        List<double> list_d_sd = new List<double>();
        List<double> list_n_waves = new List<double>();
        List<string> list_d_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // converting start date in DB in end date !
            //date = date.AddSeconds(wave_compute_duration);

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_d_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_d_mean.Add(double.Parse(dRow["DIRT02"].ToString()));
            list_d_max.Add(double.Parse(dRow["DIRTP"].ToString()));
            list_d_sd.Add(double.Parse(dRow["SPRD"].ToString()));
            list_n_waves.Add(double.Parse(dRow["NUMW"].ToString()));

            list_d_mean[list_d_mean.Count-1] += decl;
            list_d_max[list_d_max.Count-1] += decl;
            list_d_sd[list_d_sd.Count-1] += decl;

            //dir_cor = double.Parse(dRow["MAINDIR"].ToString()) - 14.8;
            //if (dir_cor < 0) dir_cor += 360;
            //list_d_mean.Add(dir_cor); //correction declinaison magnetique 14.8°

            //dir_cor = double.Parse(dRow["DIRTP"].ToString()) - 14.8;
            //if (dir_cor < 0) dir_cor += 360;
            //list_d_max.Add(dir_cor); //correction declinaison magnetique 14.8°
        }

        dataWaveAHRS data = new dataWaveAHRS();

        data.setHeight(list_h_sig, list_h_max, list_h_3, list_etamax, list_etamin, list_h_time);
        data.SetPeriod(list_t_tp, list_t_tz, list_t_tm02, list_t_tm01, list_t_thmax, list_t_t3, list_te, list_tmax, list_t_time);
        data.setDirection(list_d_mean, list_d_max, list_d_sd, list_n_waves, list_d_time);

        data.setDeclination(decl);


        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;


        // return data to javascript !
        return data;
    }
}

public class dataWaveAHRS
{
    public double[] H_m0;
    public double[] H_max;
    public double[] H_tier;
    public double[] ETAmax;
    public double[] ETAmin;
    public string[] H_time;

    
    public double[] T_p;
    public double[] T_z;
    public double[] T_m01;
    public double[] T_hmax;
    public double[] T_m02;
    public double[] T_3;
    public double[] T_e;
    public double[] T_max;
    public string[] T_time;

    public double[] D_mean;
    public double[] D_peak;
    public double[] D_sd;
    public double[] N_waves;
    public string[] D_time;

    public double declination;

    public void setHeight(List<double> sig, List<double> max, List<double> tier, List<double> list_ETAmax, List<double> list_ETAmin, List<string> time)
    {
        H_m0 = sig.ToArray();
        H_max = max.ToArray();
        H_tier = tier.ToArray();

        ETAmax = list_ETAmax.ToArray();
        ETAmin = list_ETAmin.ToArray();

        H_time = time.ToArray();
    }

    //data.SetPeriod(list_t_tp, list_t_tz, list_t_tm02, list_t_tm01, list_t_thmax, list_t_t3, list_t_time);
    public void SetPeriod(List<double> list_t_tp, List<double> list_t_tz, List<double> list_t_tm02, List<double> list_t_tm01, List<double> list_t_thmax, List<double> list_t_t3,
                            List<double> list_t_te, List<double> list_t_tmax, List<string> time)
    {
        
        T_p = list_t_tp.ToArray();
        T_z = list_t_tz.ToArray();
        T_m01 = list_t_tm01.ToArray();
        T_hmax = list_t_thmax.ToArray();
        T_m02 = list_t_tm02.ToArray();
        T_3 = list_t_t3.ToArray();
        T_e = list_t_te.ToArray();
        T_max = list_t_tmax.ToArray();

        T_time = time.ToArray();
    }

    public void setDirection(List<double> mean, List<double> peak, List<double> sd, List<double> nwave, List<string> time)
    {
        D_mean = mean.ToArray();
        D_peak = peak.ToArray();
        D_sd = sd.ToArray();
        N_waves = nwave.ToArray();
        D_time = time.ToArray();
    }

    public void setDeclination( double decl)
    {
        declination = decl;
    }
}