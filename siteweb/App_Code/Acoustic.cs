using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;
using System.Data;

/// <summary>
/// Description résumée de Acoustic
/// </summary>
public class Acoustic
{
    public Acoustic()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public class dataAcoustic1
    {
        public double[] acoustic_sel;
        public double[] acoustic_ptp;
        public string[] acoustic_time;

        public void setAcoustic(List<double> sel, List<double> ptp, List<string> time)
        {
            acoustic_sel = sel.ToArray();
            acoustic_ptp = ptp.ToArray();
            acoustic_time = time.ToArray();
        }
    }

    static public dataAcoustic1 GetValues(string database, string begin, string end, int Xlength)
    {
        DateTime stdate;
        DateTime endate;

        // All
        if (begin == "all")
        {
            endate = DateTime.MaxValue;
            stdate = DateTime.MinValue;
        }
        // last 24 hours !
        else if (begin == "lastday" && end == "")
        {
            endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
            stdate = endate.AddDays(-1.0);
        }
        // last 3hours !
        else if (begin == "lasthours" && end == "")
        {
            endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
            stdate = endate.AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["NbHoursRealtime"]));
        }
        else if (begin != "" && end == "")
        {
            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            endate = stdate.AddDays(1);
        }
        else
        {
            // begin and end are value in local time (user expected!)
            // TIME_REC in database is UTC
            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])); ;
            endate = Convert.ToDateTime(end).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])); ;
        }

        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

        // Get acoustic sel/ptp from database
        DataSet ds = new DataSet();
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC, a.PTP, a.SEL  FROM PTP_SEL a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings[database].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];


        List<double> list_sel = new List<double>();
        List<double> list_ptp = new List<double>();
        List<string> list_time = new List<string>();

        List<double> list_sel2 = new List<double>();
        List<double> list_ptp2 = new List<double>();
        List<string> list_time2 = new List<string>();

        int count = 0;

        foreach (DataRow dRow in myDataTable.Rows)
        {
            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_time.Add(date.ToString("yyyy-MM-ddTHH:mm:ss"));
            list_sel.Add(double.Parse(dRow["SEL"].ToString()));
            list_ptp.Add(double.Parse(dRow["PTP"].ToString()));

            if (Xlength == -1 || myDataTable.Rows.Count < Xlength || count % (int)(myDataTable.Rows.Count / Xlength) == 0)
            {
                list_time2.Add(list_time[0]);
                list_sel2.Add(list_sel.Max());
                list_ptp2.Add(list_ptp.Max());
                list_time.Clear();
                list_sel.Clear();
                list_ptp.Clear();
            }
            count++;
        }

        // Build Acoustic1 data object
        dataAcoustic1 data = new dataAcoustic1();

        data.setAcoustic(list_sel2, list_ptp2, list_time2);

        // return Acoustic1 data to javascript !
        return data;

    }

}