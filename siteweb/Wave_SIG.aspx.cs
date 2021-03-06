﻿using System;
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

public partial class Wave : System.Web.UI.Page
{
    static public dataWave downloaddata;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");

        if (WebConfigurationManager.AppSettings["DownloadEnabled"] != "true")
        {
            downloadBouton.Enabled = false;
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // TELECHARGEMENTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    protected void DownloadWave(object Source, EventArgs e)
    {

        string[] output = new string[downloaddata.H_time.Length + 1];
        output[0] = "local datetime;Hsig;Hmax;Tmean;Tpeak;DirTpeak;DirMean";
  

        // mise en forme
        for (int i = 0; i < downloaddata.H_time.Length; i++)
        {
            output[i + 1] += downloaddata.H_time[i].Replace("T", ", ");
            output[i + 1] += ";";
            output[i + 1] += downloaddata.H_sig[i].ToString("0.00", NumberFormatInfo.InvariantInfo); 
            output[i + 1] += ";";
            output[i + 1] += downloaddata.H_max[i].ToString("0.00", NumberFormatInfo.InvariantInfo); ;
            output[i + 1] += ";";
            output[i + 1] += downloaddata.T_mean[i].ToString("0.00", NumberFormatInfo.InvariantInfo); ;
            output[i + 1] += ";";
            output[i + 1] += downloaddata.T_peak[i].ToString("0.00", NumberFormatInfo.InvariantInfo); ;
            output[i + 1] += ";";
            output[i + 1] += downloaddata.D_peak[i].ToString("0.0", NumberFormatInfo.InvariantInfo); ;
            output[i + 1] += ";";
            output[i + 1] += downloaddata.D_mean[i].ToString("0.0", NumberFormatInfo.InvariantInfo); ;
            output[i + 1] += ";";
        }

        string interval = downloaddata.H_time[0].Split('T')[0] + "_to_" + downloaddata.H_time[downloaddata.H_time.Length - 1].Split('T')[0];

        // Créer fichier csv et Télécharger
        DownloadCsv("wave_" + interval + ".csv", output);
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
    public static dataWave GetValues(string begin, string end)
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
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.HM0,a.HMAX  FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database2"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];



        List<double> list_h_sig = new List<double>();
        List<double> list_h_max = new List<double>();
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
        }


        // Get Pressure and temperature from database
        DataSet ds2 = new DataSet();
        FbDataAdapter dataadapter2 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.TP, a.T02  FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database2"].ConnectionString);
        dataadapter2.Fill(ds2);
        DataTable myDataTable2 = ds2.Tables[0];

        List<double> list_t_mean = new List<double>();
        List<double> list_t_max = new List<double>();
        List<string> list_t_time = new List<string>();

        foreach (DataRow dRow in myDataTable2.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE;
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_t_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));
            double tm02 = double.Parse(dRow["TM02"].ToString());
            if (double.IsNaN(tm02) || tm02 > 30)
            {
                if (list_t_mean.Count > 0)
                    tm02 = list_t_mean[list_t_mean.Count - 1];
                else
                    tm02 = 0;
            }
            list_t_mean.Add(tm02);

            double tp = double.Parse(dRow["TP"].ToString());
            if (tp > 30)
            {
                if (list_t_max.Count > 0)
                    tp = list_t_max[list_t_max.Count - 1];
                else
                    tp = 0;
            }
            list_t_max.Add(tp);
        }


        DataSet ds3 = new DataSet();
        FbDataAdapter dataadapter3 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.DIRTP, a.MAINDIR  FROM WAVES a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database2"].ConnectionString);
        dataadapter3.Fill(ds3);
        DataTable myDataTable3 = ds3.Tables[0];

        List<double> list_d_mean = new List<double>();
        List<double> list_d_max = new List<double>();
        List<string> list_d_time = new List<string>();

        foreach (DataRow dRow in myDataTable3.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());
            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_d_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            list_d_mean.Add(double.Parse(dRow["MAINNDIR"].ToString()));
            list_d_max.Add(double.Parse(dRow["DIRTP"].ToString()));

            //dir_cor = double.Parse(dRow["MAINDIR"].ToString());
            //if (dir_cor < 0) dir_cor += 360;
            //list_d_mean.Add(dir_cor);

            //dir_cor = double.Parse(dRow["DIRTP"].ToString());
            //if (dir_cor < 0) dir_cor += 360;
            //list_d_max.Add(dir_cor);
        }


        // Build meteo data object
        dataWave data = new dataWave();

        data.setHeight(list_h_sig, list_h_max, list_h_time);
        data.SetPeriod(list_t_mean, list_t_max, list_t_time);
        data.setDirection(list_d_mean, list_d_max, list_d_time);



        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;


        // return data to javascript !
        return data;
    }
}

public class dataWave
{
    public double[] H_sig;
    public double[] H_max;
    public string[] H_time;

    public double[] T_mean;
    public double[] T_peak;
    public string[] T_time;

    public double[] D_mean;
    public double[] D_peak;
    public string[] D_time;

    public void setHeight(List<double> sig, List<double> max, List<string> time)
    {
        H_sig = sig.ToArray();
        H_max = max.ToArray();
        H_time = time.ToArray();
    }

    public void SetPeriod(List<double> mean, List<double> peak, List<string> time)
    {
        T_mean = mean.ToArray();
        T_peak = peak.ToArray();
        T_time = time.ToArray();
    }

    public void setDirection(List<double> mean, List<double> peak, List<string> time)
    {
        D_mean = mean.ToArray();
        D_peak = peak.ToArray();
        D_time = time.ToArray();
    }
}