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
    static public dataWaveAHRS_BFHF downloaddata;

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
        output.Add(Global.l_orientation + orientation);


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
                                    + t_max_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + t_m02_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    //+ t_avg_label.Value + '(' + t_unit + ')' + ';'
                                    + t_3_label_alias.Value + '(' + t_unit.Value + ')' + ';'
                                    + d_avg_label_alias.Value + '(' + d_unit.Value + ')' + ';'
                                    + d_peak_label_alias.Value + '(' + d_unit.Value + ')' + ';'
                                    + d_spread_label_alias.Value + '(' + d_unit.Value + ')' + ';'
                                    + n_waves_alias.Value + ';'

                                    
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
                        + downloaddata.T_max[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_m02[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.T_3[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.D_mean[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.D_peak[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.D_sd[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.N_waves[i].ToString("0", NumberFormatInfo.InvariantInfo) + ';'
                        );

            if (i == 0)
                start_date = s_date;
            if (i == downloaddata.H_time.Length - 1)
                end_date = s_date;

        }

        

        string interval =start_date.Split('T')[0] + "_to_" + end_date.Split('T')[0];

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
        t_max_label_alias = new HiddenField();
        t_m02_label_alias = new HiddenField();
        t_3_label_alias = new HiddenField();
        d_avg_label_alias = new HiddenField();
        d_peak_label_alias = new HiddenField();
        d_spread_label_alias = new HiddenField();
        n_waves_alias = new HiddenField();

        h_sig_bf_label_alias = new HiddenField();
        h_sig_hf_label_alias = new HiddenField();
        t_peak_bf_label_alias = new HiddenField();
        t_peak_hf_label_alias = new HiddenField();
        t_z_bf_label_alias = new HiddenField();
        t_z_hf_label_alias = new HiddenField();
        t_m02_bf_label_alias = new HiddenField();
        t_m02_hf_label_alias = new HiddenField();
        d_avg_bf_label_alias = new HiddenField();
        d_avg_hf_label_alias = new HiddenField();
        d_peak_bf_label_alias = new HiddenField();
        d_peak_hf_label_alias = new HiddenField();
        d_m02_bf_label_alias = new HiddenField();
        d_m02_hf_label_alias = new HiddenField();


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
        orientation = Resources.WaveAHRS.ORIENTATION;


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

        h_sig_bf_label_alias.Value = Resources.WaveAHRS.h_sig_bf_label_alias.ToString();
        h_sig_hf_label_alias.Value = Resources.WaveAHRS.h_sig_hf_label_alias.ToString();
        t_peak_bf_label_alias.Value = Resources.WaveAHRS.t_peak_bf_label_alias.ToString();
        t_peak_hf_label_alias.Value = Resources.WaveAHRS.t_peak_hf_label_alias.ToString();
        t_z_bf_label_alias.Value = Resources.WaveAHRS.t_z_bf_label_alias.ToString();
        t_z_hf_label_alias.Value = Resources.WaveAHRS.t_z_hf_label_alias.ToString();
        t_m02_bf_label_alias.Value = Resources.WaveAHRS.t_m02_bf_label_alias.ToString();
        t_m02_hf_label_alias.Value = Resources.WaveAHRS.t_m02_hf_label_alias.ToString();
        d_avg_bf_label_alias.Value = Resources.WaveAHRS.d_avg_bf_label_alias.ToString();
        d_avg_hf_label_alias.Value = Resources.WaveAHRS.d_avg_hf_label_alias.ToString();
        d_peak_bf_label_alias.Value = Resources.WaveAHRS.d_peak_bf_label_alias.ToString();
        d_peak_hf_label_alias.Value = Resources.WaveAHRS.d_peak_hf_label_alias.ToString();



        //Assigning string value

    }

    [System.Web.Services.WebMethod]
    public static dataWaveAHRS_BFHF GetValuesFrom(string begin, string end)
    {
        WaveAHRS test = new WaveAHRS();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    public static dataWaveAHRS_BFHF GetValues(string begin, string end)
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
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.HM0,a.HMAX,a.H3,a.HM0_BF, a.HM0_HF FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];



        List<double> list_h_sig = new List<double>();
        List<double> list_h_max = new List<double>();
        List<double> list_h_3 = new List<double>();
        List<double> list_hm0_bf = new List<double>();
        List<double> list_hm0_hf = new List<double>();

        List<string> list_h_time = new List<string>();

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE;
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_h_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_h_sig.Add(double.Parse(dRow["HM0"].ToString()));
            list_h_max.Add(double.Parse(dRow["HMAX"].ToString()));
            list_h_3.Add(double.Parse(dRow["H3"].ToString()));
            list_hm0_bf.Add(double.Parse(dRow["HM0_BF"].ToString()));
            list_hm0_hf.Add(double.Parse(dRow["HM0_HF"].ToString()));
        }


        // 
        DataSet ds2 = new DataSet();
        FbDataAdapter dataadapter2 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.TP, a.TZ, a.TM01, a.TMAX, a.T02, a.T3 FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter2.Fill(ds2);
        DataTable myDataTable2 = ds2.Tables[0];

        List<double> list_t_tp = new List<double>();
        List<double> list_t_tz = new List<double>();
        List<double> list_t_tm01 = new List<double>();
        List<double> list_t_thmax = new List<double>();
        List<double> list_t_tm02 = new List<double>();
        List<double> list_t_t3 = new List<double>();
        List<string> list_t_time = new List<string>();

        foreach (DataRow dRow in myDataTable2.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE;
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_t_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            

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

            double thmax = double.Parse(dRow["TMAX"].ToString());
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


        }


        DataSet ds3 = new DataSet();
        FbDataAdapter dataadapter3 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(
                        "SELECT a.TIME_REC, a.DIRTP, a.DIRT02, a.SPRD, a.NUMW, a.DIRTP_BF, a.DIRTP_HF, a.DIRT02_BF, a.DIRT02_HF " +
                        "FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter3.Fill(ds3);
        DataTable myDataTable3 = ds3.Tables[0];

        List<double> list_d_mean = new List<double>();
        List<double> list_d_max = new List<double>();
        List<double> list_d_sd = new List<double>();
        List<double> list_n_waves = new List<double>();
        List<string> list_d_time = new List<string>();

        List<double> list_d_tp_bf = new List<double>();
        List<double> list_d_tp_hf = new List<double>();
        List<double> list_d_t02_bf = new List<double>();
        List<double> list_d_t02_hf = new List<double>();

        foreach (DataRow dRow in myDataTable3.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());
            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_d_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_d_mean.Add(double.Parse(dRow["DIRT02"].ToString()));
            list_d_max.Add(double.Parse(dRow["DIRTP"].ToString()));

            double tmp = -1;
            double.TryParse(dRow["DIRT02_BF"].ToString(), out tmp);
            list_d_t02_bf.Add(tmp);

            double.TryParse(dRow["DIRT02_HF"].ToString(), out tmp);
            list_d_t02_hf.Add(tmp);

            double.TryParse(dRow["DIRTP_BF"].ToString(), out tmp);
            list_d_tp_bf.Add(tmp);

            double.TryParse(dRow["DIRTP_HF"].ToString(), out tmp);
            list_d_tp_hf.Add(tmp);

            //list_d_t02_bf.Add(double.Parse(dRow["DIRT02_BF"].ToString()));
            //list_d_t02_hf.Add(double.Parse(dRow["DIRT02_HF"].ToString()));
            //list_d_tp_bf.Add(double.Parse(dRow["DIRTP_BF"].ToString()));
            //list_d_tp_hf.Add(double.Parse(dRow["DIRTP_HF"].ToString()));
            
            list_d_sd.Add(double.Parse(dRow["SPRD"].ToString()));
            list_n_waves.Add(double.Parse(dRow["NUMW"].ToString()));

            //dir_cor = double.Parse(dRow["MAINDIR"].ToString()) - 14.8;
            //if (dir_cor < 0) dir_cor += 360;
            //list_d_mean.Add(dir_cor); //correction declinaison magnetique 14.8°

            //dir_cor = double.Parse(dRow["DIRTP"].ToString()) - 14.8;
            //if (dir_cor < 0) dir_cor += 360;
            //list_d_max.Add(dir_cor); //correction declinaison magnetique 14.8°
        }


        // 
        DataSet ds4 = new DataSet();
        FbDataAdapter dataadapter4 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.TP_BF, a.TP_HF, a.TZ_BF, a.TZ_HF, a.T02_BF, a.T02_HF, a.TE, a.TE_BF, a.TE_HF" +
                                                                                        " FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", 
                                                                                        ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter4.Fill(ds4);
        DataTable myDataTable4 = ds4.Tables[0];

        List<double> list_tp_bf = new List<double>();
        List<double> list_tp_hf = new List<double>();
        List<double> list_tz_bf = new List<double>();
        List<double> list_tz_hf = new List<double>();
        List<double> list_t02_bf = new List<double>();
        List<double> list_t02_hf = new List<double>();
        List<double> list_te = new List<double>();
        List<double> list_te_bf = new List<double>();
        List<double> list_te_hf = new List<double>();


        foreach (DataRow dRow in myDataTable4.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE;
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_t_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));


            /////////////////////////////////////////////////////////////////
            double tmp = -1;
            double.TryParse(dRow["TP_BF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_tp_bf.Count > 0)
                    tmp = list_tp_bf[list_tp_bf.Count - 1];
                else
                    tmp = 0;
            }
            list_tp_bf.Add(tmp);

            double.TryParse(dRow["TP_HF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_tp_hf.Count > 0)
                    tmp = list_tp_hf[list_tp_hf.Count - 1];
                else
                    tmp = 0;
            }
            list_tp_hf.Add(tmp);

            ////////////////////////////////////////////////////////////////
            double.TryParse(dRow["TZ_BF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_tz_bf.Count > 0)
                    tmp = list_tz_bf[list_tz_bf.Count - 1];
                else
                    tmp = 0;
            }
            list_tz_bf.Add(tmp);

            double.TryParse(dRow["TZ_HF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_tz_hf.Count > 0)
                    tmp = list_tz_hf[list_tz_hf.Count - 1];
                else
                    tmp = 0;
            }
            list_tz_hf.Add(tmp);


            ////////////////////////////////////////////////////////////////
            double.TryParse(dRow["T02_BF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_t02_bf.Count > 0)
                    tmp = list_t02_bf[list_t02_bf.Count - 1];
                else
                    tmp = 0;
            }
            list_t02_bf.Add(tmp);

            double.TryParse(dRow["T02_HF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_t02_hf.Count > 0)
                    tmp = list_t02_hf[list_t02_hf.Count - 1];
                else
                    tmp = 0;
            }
            list_t02_hf.Add(tmp);

            ////////////////////////////////////////////////////////////////
            ///
            double.TryParse(dRow["TE"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_te.Count > 0)
                    tmp = list_te[list_te.Count - 1];
                else
                    tmp = 0;
            }
            list_te.Add(tmp);

            double.TryParse(dRow["TE_BF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_te_bf.Count > 0)
                    tmp = list_te_bf[list_te_bf.Count - 1];
                else
                    tmp = 0;
            }
            list_te_bf.Add(tmp);

            double.TryParse(dRow["TE_HF"].ToString(), out tmp);
            if (double.IsNaN(tmp) || tmp > 31)
            {
                if (list_te_hf.Count > 0)
                    tmp = list_te_hf[list_te_hf.Count - 1];
                else
                    tmp = 0;
            }
            list_te_hf.Add(tmp);




        }


        dataWaveAHRS_BFHF data = new dataWaveAHRS_BFHF();

        data.setHeight(list_h_sig, list_h_max, list_h_3, list_hm0_bf, list_hm0_hf, list_h_time);
        data.SetPeriod(list_t_tp, list_t_tz, list_t_tm02, list_t_tm01, list_t_thmax, list_t_t3, list_t_time);
        data.SetPeriod_bfhf(list_tp_bf, list_tp_hf, list_tz_bf, list_tz_hf, list_t02_bf, list_t02_hf, list_te, list_te_bf, list_te_hf, list_t_time);
        data.setDirection(list_d_mean, list_d_max, list_d_sd, list_n_waves, list_d_t02_bf, list_d_t02_hf, list_d_tp_bf, list_d_tp_hf, list_d_time);


        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;


        // return data to javascript !
        return data;
    }
}

public class dataWaveAHRS_BFHF
{
    public double[] H_m0;
    public double[] H_max;
    public double[] H_tier;
    public string[] H_time;



    public double[] T_p;
    public double[] T_z;
    public double[] T_m01;
    public double[] T_max;
    public double[] T_m02;
    public double[] T_3;
    public string[] T_time;

    public double[] H_m0_bf;
    public double[] H_m0_hf;
    public double[] T_p_bf;
    public double[] T_p_hf;
    public double[] T_z_bf;
    public double[] T_z_hf;
    public double[] T_m02_bf;
    public double[] T_m02_hf;
    public double[] T_e;
    public double[] T_e_bf;
    public double[] T_e_hf;
    public string[] T_time_bfhf;

    public double[] D_t02_bf;
    public double[] D_t02_hf;
    public double[] D_peak_bf;
    public double[] D_peak_hf;


    public double[] D_mean;
    public double[] D_peak;
    public double[] D_sd;
    public double[] N_waves;
    public string[] D_time;

    public void setHeight(List<double> sig, List<double> max, List<double> tier, List<double> list_Hm0_bf, List<double> list_Hm0_hf, List<string> time)
    {
        H_m0 = sig.ToArray();
        H_max = max.ToArray();
        H_tier = tier.ToArray();
        H_m0_bf = list_Hm0_bf.ToArray();
        H_m0_hf = list_Hm0_hf.ToArray();

        H_time = time.ToArray();
    }


        //data.SetPeriod(list_t_tp, list_t_tz, list_t_tm02, list_t_tm01, list_t_thmax, list_t_t3, list_t_time);
        public void SetPeriod(List<double> list_t_tp, List<double> list_t_tz, List<double> list_t_tm02, List<double> list_t_tm01, List<double> list_t_thmax, List<double> list_t_t3, List<string> time)
    {
        
        T_p = list_t_tp.ToArray();
        T_z = list_t_tz.ToArray();
        T_m01 = list_t_tm01.ToArray();
        T_max = list_t_thmax.ToArray();
        T_m02 = list_t_tm02.ToArray();
        T_3 = list_t_t3.ToArray();

        T_time = time.ToArray();
    }

    public void SetPeriod_bfhf( List<double> list_t_tp_bf, List<double> list_t_tp_hf, List<double> list_t_z_bf, List<double> list_t_z_hf, List<double> list_t_t02_bf, List<double> list_t_t02_hf, 
                                List<double> list_te, List<double> list_te_bf, List<double> list_te_hf, List<string> time)
    {
        T_p_bf = list_t_tp_bf.ToArray();
        T_p_hf = list_t_tp_hf.ToArray();
        T_z_bf = list_t_z_bf.ToArray();
        T_z_hf = list_t_z_hf.ToArray();
        T_m02_bf = list_t_t02_bf.ToArray();
        T_m02_hf = list_t_t02_hf.ToArray();
        T_e = list_te.ToArray();
        T_e_bf = list_te_bf.ToArray();
        T_e_hf = list_te_hf.ToArray();
        T_time_bfhf = time.ToArray();
    }

        public void setDirection(List<double> mean, List<double> peak, List<double> sd, List<double> nwave, List<double> t02_bf, List<double> t02_hf, List<double> p_bf, List<double> p_hf, List<string> time)
    {
        D_mean = mean.ToArray();
        D_peak = peak.ToArray();
        D_sd = sd.ToArray();
        N_waves = nwave.ToArray();

        D_t02_bf = t02_bf.ToArray();
        D_t02_hf = t02_hf.ToArray();
        D_peak_bf = p_bf.ToArray();
        D_peak_hf = p_hf.ToArray();

        D_time = time.ToArray();
    }
}