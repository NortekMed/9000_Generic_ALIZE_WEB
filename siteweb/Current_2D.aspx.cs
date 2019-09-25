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

public partial class Current : System.Web.UI.Page
{

    public static dataCurrent downloaddata;

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

    protected void DownloadCurrent(object Source, EventArgs e)
    {
        try
        {
            string[] output = new string[downloaddata.C_time.Length + 1];
            output[0] = "local datetime;marée(dBar);temperauture eau";
            for (int j = 0; j < downloaddata.C_amp[0].Length; j++)
            {
                string immersion = (downloaddata.C_blancking + downloaddata.C_cellsize * (1 + j)).ToString();
                output[0] += ";";
                output[0] += ("spd " + immersion + "m");
                output[0] += ";";
                output[0] += ("dir " + immersion + "m");
            }

            // mise en forme
            for (int i = 0; i < downloaddata.C_time.Length; i++)
            {
                output[i + 1] += downloaddata.C_time[i].Replace("T", ", ");
                output[i + 1] += ";";
                output[i + 1] += downloaddata.C_press[i].ToString("0.000", NumberFormatInfo.InvariantInfo);
                output[i + 1] += ";";
                output[i + 1] += downloaddata.C_temp[i].ToString("00.00", NumberFormatInfo.InvariantInfo);

                for (int j = 0; j < downloaddata.C_amp[i].Length; j++)
                {
                    output[i + 1] += ";";
                    output[i + 1] += downloaddata.C_amp[i][j].ToString("0.000", NumberFormatInfo.InvariantInfo);
                    output[i + 1] += ";";
                    output[i + 1] += downloaddata.C_dir[i][j].ToString("0.0", NumberFormatInfo.InvariantInfo);
                }
            }

            string interval = downloaddata.C_time[0].Split('T')[0] + "_to_" + downloaddata.C_time[downloaddata.C_time.Length - 1].Split('T')[0];

            // Créer fichier csv et Télécharger
            DownloadCsv("current_" + interval + ".csv", output);
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


    [System.Web.Services.WebMethod]
    public static dataCurrent GetValues(string begin, string end)
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
            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"]));
            endate = Convert.ToDateTime(end).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"]));

            endate = endate.AddDays(1);
        }

        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

        // AWAC / AQUADOPP

        // Generate DB request
        string DbRequest = "SELECT a.TIME_REC, a.PITCH, a.ROLL, a.TEMPERATURE, a.PRESSURE";

        for (int c = 0; c < int.Parse(WebConfigurationManager.AppSettings["nb_couche_2D"]) && c < 26; c++)
        {
            string sufix = string.Format("{0}", (c + 1));

            DbRequest += (", a.SPD" + sufix);
        }
        for (int c = 0; c < int.Parse(WebConfigurationManager.AppSettings["nb_couche_2D"]) && c < 26; c++)
        {
            string sufix = string.Format("{0}", (c + 1));

            DbRequest += (", a.DIR" + sufix);
        }


        DbRequest += (" FROM COURANT a " + timestampsrequest + " order by a.TIME_REC");


        // Get wind from database
        DataSet ds = new DataSet();
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(DbRequest, ConfigurationManager.ConnectionStrings["database3"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];



        List<double[]> list_amplitude = new List<double[]>();
        List<double[]> list_direction = new List<double[]>();
        List<string> list_time = new List<string>();

        List<double> list_pitch = new List<double>();
        List<double> list_roll = new List<double>();
        List<double> list_temp = new List<double>();
        List<double> list_press = new List<double>();


        double cell_size = double.Parse(WebConfigurationManager.AppSettings["cell_size_2D"]) / 100;
        double blanking_dist = double.Parse(WebConfigurationManager.AppSettings["blancking_2D"]) / 100;
        if (myDataTable.Rows.Count > 0)
        {
            //blanking_dist = (double.Parse(myDataTable.Rows[0]["BLK"].ToString()));
            //cell_size = (double.Parse(myDataTable.Rows[0]["CS"].ToString()));
        }
        foreach (DataRow dRow in myDataTable.Rows)
        {
            double[] amp = new double[int.Parse(WebConfigurationManager.AppSettings["nb_couche_2D"])];
            double[] dir = new double[int.Parse(WebConfigurationManager.AppSettings["nb_couche_2D"])];
            double dir_cor = 0;

            list_pitch.Add(double.Parse(dRow["PITCH"].ToString()));
            list_roll.Add(double.Parse(dRow["ROLL"].ToString()));
            list_temp.Add(double.Parse(dRow["TEMPERATURE"].ToString()));
            list_press.Add(double.Parse(dRow["PRESSURE"].ToString()));


            //DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());
            //// UTC to Local Time
            //date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            ////date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            //list_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());
            //// UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            ////date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]));
            list_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));


            // Direction and amplitude for all cells
            for (int cell = 0; cell < int.Parse(WebConfigurationManager.AppSettings["nb_couche_Caronte"]) && cell < 26; cell++)
            {
                // AWAC / AQUADOPP
                amp[cell] = Math.Round(double.Parse(dRow["SPD" + (cell + 1).ToString()].ToString()) * 1000 * 1.94384) / 1000;

                dir_cor = double.Parse(dRow["DIR" + (cell + 1).ToString()].ToString());
                if (dir_cor < 0) dir_cor += 360;
                dir[cell] = Math.Round(dir_cor, 2);


                if (amp[cell] > 20)
                    amp[cell] = 0.0;
            }

            list_amplitude.Add(amp);
            list_direction.Add(dir);
        }


        // Build current data object
        dataCurrent data = new dataCurrent();
        data.set(list_amplitude,
            list_direction,
            list_time,
            cell_size, //double.Parse(WebConfigurationManager.AppSettings["cell_size_1"])/100,
            blanking_dist,//double.Parse(WebConfigurationManager.AppSettings["blancking_1"])/100,
            list_pitch, list_roll, list_temp, list_press);

        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }
}

public class dataCurrent
{
    public double[][] C_amp;
    public double[][] C_dir;
    public string[] C_time;
    public double C_cellsize;
    public double C_blancking;
    public double[] C_pitch;
    public double[] C_roll;
    public double[] C_temp;
    public double[] C_press;


    public double meanTimeInterval = 0.0;

    public void set(List<double[]> l_amp,
        List<double[]> l_dir,
        List<string> l_time,
        double cellsize,
        double blancking,
        List<double> l_pitch,
        List<double> l_roll,
        List<double> l_temp,
        List<double> l_press)
    {

        C_amp = l_amp.ToArray();
        C_dir = l_dir.ToArray();
        C_time = l_time.ToArray();

        C_pitch = l_pitch.ToArray();
        C_roll = l_roll.ToArray();
        C_temp = l_temp.ToArray();
        C_press = l_press.ToArray();

        for (int i = 1; i < C_time.Length; i++)
            meanTimeInterval += (Convert.ToDateTime(C_time[i]) - Convert.ToDateTime(C_time[i - 1])).TotalMilliseconds;

        meanTimeInterval = meanTimeInterval / (C_time.Length - 1);

        C_cellsize = cellsize;
        C_blancking = blancking;

    }
}