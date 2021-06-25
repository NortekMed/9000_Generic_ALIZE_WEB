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

public partial class Spectrum1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is connected
        if (WebConfigurationManager.AppSettings["loginNeeded"] == "true" && !Request.IsAuthenticated)
            Response.Redirect("~/Login.aspx");
    }

    [System.Web.Services.WebMethod]
    public static dataSpectrum1 GetValues(string begin, string end, string hour, int Xlength)
    {

        DateTime stdate;
        DateTime endate;

        // last 24 hours !
        if (begin == "lastday" && end == "")
        {
            endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
            stdate = endate.AddDays(-1.0);
        }
        // last few hours !
        else if (begin == "lasthours" && end == "")
        {
            endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
            stdate = endate.AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["NbHoursRealtime"]));
        }
        // last hour !
        else if (begin == "lasthour" && end == "")
        {
            endate = DateTime.UtcNow.AddDays(double.Parse(WebConfigurationManager.AppSettings["DayOffset"]));
            stdate = endate.AddHours(-1);

            //            stdate = stdate.AddHours(-1);
            //            endate = endate.AddHours(-1);
        }
        else if (begin != "" && end == "" && hour !="")
        {
            stdate = Convert.ToDateTime(begin).AddHours(-1*double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            stdate = stdate.AddHours(int.Parse(hour));
            endate = stdate.AddHours(1);
        }
        else
        {
            // begin and end are value in local time (user expected!)
            // TIME_REC in database is UTC
            stdate = Convert.ToDateTime(begin).AddHours(-1*double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            endate = Convert.ToDateTime(end).AddHours(-1*double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
        }



        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";
        string mySelectQuery = "SELECT a.TIME_REC , a.TIEROCT  FROM PTP_SEL a " + timestampsrequest + " order by a.TIME_REC";
        string conectionstring = ConfigurationManager.ConnectionStrings["hydro_db"].ConnectionString;

        FbConnection myConnection = new FbConnection(conectionstring);
        myConnection.Open();
        FbTransaction myTxn = myConnection.BeginTransaction();
        FbCommand myCommand = new FbCommand(mySelectQuery, myConnection, myTxn);
        FbDataReader myReader;
        myReader = myCommand.ExecuteReader();

        //DataSet ds = new DataSet();
        //FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC , a.TIEROCT  FROM PTP_SEL a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1_data"].ConnectionString);
        ////FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_REC , a.TIEROCT  FROM PTP_SEL a order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1_data"].ConnectionString);

        //dataadapter.Fill(ds);
        //DataTable myDataTable = ds.Tables[0];



        int compteur = 0;
        List<string> list_time = new List<string>();
        List<byte[]> list_tieroctByte = new List<byte[]>();
        List<double[]> list_tieroct = new List<double[]>();


        List<double> list_sel = new List<double>();

        //foreach (DataRow dRow in myDataTable.Rows)
        //foreach (DataRow dRow in 100)
        while (myReader.Read())
        {
            // Read date and format date !
            DateTime date = myReader.GetDateTime(0).AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            //DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

            list_time.Add(date.ToString("yyyy-MM-ddTHH:mm:ss"));


            list_sel.Add(myReader.GetDouble(1));

            // Read bytes
            byte[] data = new byte[66];
            try
            {
                myReader.GetBytes(1, 0, data, 0, 66);
                //for (int i = 0; i < 66; i++)
                //{
                //    data[i] = Convert.ToByte(dRow["TIEROCT"].ToString());
                //}
            }
            catch
            {
                for (int i = 0; i < 66; i++)
                {
                    data[i] = 0;
                }
            }
            list_tieroctByte.Add(data);
            compteur += 1;
        }


        int count = 0;

        for (int i = 0; i < compteur; i++)
        {
            double[] tieroct = new double[33];

            byte[] data1 = new byte[66];
            data1 = list_tieroctByte[i].ToArray();

            for (int j = 0; j < 33; j++)
            {
                UInt16 value = BitConverter.ToUInt16(data1, j * 2);
                tieroct[j] = value / 100f;
            }

            list_tieroct.Add(tieroct);
           

        }


        // On refait des liste avec uniquement les maxium de valeur, longueur des listes = Xlength
        List<string> list_time2 = new List<string>();
        List<double[]> list_tieroct2 = new List<double[]>();
        double[] tieroct2 = new double[33];

        for (int j = 0; j < 33; j++)
            tieroct2[j] = double.MinValue;

        for (int i = 0; i < compteur; i++)
        {

            for (int j = 0; j < 33; j++)
                if (list_tieroct[i][j] > tieroct2[j])
                    tieroct2[j] = list_tieroct[i][j];

            if ((compteur < Xlength) || (Xlength == -1) || (count % (int)(compteur / Xlength) == 0))
            {
                list_time2.Add(list_time[i]);
                list_tieroct2.Add((double[])tieroct2.Clone());

                for (int j = 0; j < 33; j++)
                    tieroct2[j] = double.MinValue;
            }
            count++;
        }


        // Build spectrum data object
        dataSpectrum1 dataTieroctave = new dataSpectrum1();
        dataTieroctave.set(list_tieroct2, list_time2, list_sel); 

        // return meteo data to javascript !
        return dataTieroctave;
    }
}

public class dataSpectrum1
{
    public double[][] tieroct_value;
    public string[] tieroct_time;
    public double[] acoustic_sel;
    public double meanTimeInterval = 0.0;

    public double[] tieroct_freq = {13, 16, 20, 25,32,40,50,63,79,99,125,157,198,250,315,397,500,630,794,1000,1260,1588,2001,2521,3176,4002, 5042 ,6353, 8004,10084,12705,16007, 23000};

    public void set(List<double[]> list_tieroct, List<string> time, List<double> l_sel)
    {
        tieroct_value = list_tieroct.ToArray();
        tieroct_time = time.ToArray();
        acoustic_sel = l_sel.ToArray();

        for (int i = 1; i < tieroct_time.Length; i++)
            meanTimeInterval += (Convert.ToDateTime(tieroct_time[i]) - Convert.ToDateTime(tieroct_time[i - 1])).TotalMilliseconds;

        meanTimeInterval = meanTimeInterval / (tieroct_time.Length - 1);
    }
}