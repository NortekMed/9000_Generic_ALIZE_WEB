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

public partial class SIG_Current : System.Web.UI.Page
{

    public static data_SIG_Current downloaddata;

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
    static string param5_name = "";
    static string param5_unit = "";
    static string param5_label = "";
    static string param6_name = "";
    static string param6_unit = "";
    static string param6_label = "";

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
            DownloadCsv("currentSIG_" + interval + ".csv", output);
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

        param4name = new HiddenField();
        param4label = new HiddenField();
        param4unit = new HiddenField();

        param5name = new HiddenField();
        param5label = new HiddenField();
        param5unit = new HiddenField();

        param6name = new HiddenField();
        param6label = new HiddenField();
        param6unit = new HiddenField();

        msg_info_0 = new HiddenField();

        direction_label = new HiddenField();
        direction_unit = new HiddenField();
        speed_label = new HiddenField();
        profdir_label = new HiddenField();
        profspeed_label = new HiddenField();

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
        equipname.Value = Resources.CurrentSIG.equip_name.ToString();

        param0name.Value = Resources.CurrentSIG.param0name.ToString();
        param0label.Value = Resources.CurrentSIG.param0label.ToString();
        param0unit.Value = Resources.CurrentSIG.param0unit.ToString();

        param1name.Value = Resources.CurrentSIG.param1name.ToString();
        param1label.Value = Resources.CurrentSIG.param1label.ToString();
        param1unit.Value = Resources.CurrentSIG.param1unit.ToString();

        param2name.Value = Resources.CurrentSIG.param2name.ToString();
        param2label.Value = Resources.CurrentSIG.param2label.ToString();
        param2unit.Value = Resources.CurrentSIG.param2unit.ToString();

        param3name.Value = Resources.CurrentSIG.param3name.ToString();
        param3label.Value = Resources.CurrentSIG.param3label.ToString();
        param3unit.Value = Resources.CurrentSIG.param3unit.ToString();

        param4name.Value = Resources.CurrentSIG.param4name.ToString();
        param4label.Value = Resources.CurrentSIG.param4label.ToString();
        param4unit.Value = Resources.CurrentSIG.param4unit.ToString();

        param5name.Value = Resources.CurrentSIG.param5name.ToString();
        param5label.Value = Resources.CurrentSIG.param5label.ToString();
        param5unit.Value = Resources.CurrentSIG.param5unit.ToString();

        param6name.Value = Resources.CurrentSIG.param6name.ToString();
        param6label.Value = Resources.CurrentSIG.param6label.ToString();
        param6unit.Value = Resources.CurrentSIG.param6unit.ToString();

        msg_info_0.Value = Resources.CurrentSIG.msg_info_0.ToString();

        direction_label.Value = Resources.CurrentSIG.direction_label.ToString();
        direction_unit.Value = Resources.CurrentSIG.direction_unit.ToString();
        speed_label.Value = Resources.CurrentSIG.msg_info_0.ToString();
        profdir_label.Value = Resources.CurrentSIG.profdir_label.ToString();
        profspeed_label.Value = Resources.CurrentSIG.profspeed_label.ToString();


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

        param4_name = param4name.Value;
        param4_unit = param4unit.Value;
        param4_label = param4label.Value;


        param5_name = param5name.Value;
        param5_unit = param5unit.Value;
        param5_label = param5label.Value;

        param6_name = param6name.Value;
        param6_unit = param6unit.Value;
        param6_label = param6label.Value;

    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // WEB SERVICE
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    [System.Web.Services.WebMethod]
    public static data_SIG_Current GetValuesFrom(string begin, string end)
    {
        SIG_Current test = new SIG_Current();
        test.CreateField();
        test.InitField();

        return GetValues(begin, end);
    }

    [System.Web.Services.WebMethod]
    public static data_SIG_Current GetValues(string begin, string end)
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
            stdate = Convert.ToDateTime(begin).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            endate = Convert.ToDateTime(end).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;

            endate = endate.AddDays(1);
        }

        string timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

        // AWAC / AQUADOPP

        // Generate DB request
        string DbRequest = "SELECT a.TIME_REC, a." + param0_name + ", a." + param1_name + ", a." + param2_name + ", a." + param3_name;

        for (int d = 0; d < int.Parse(WebConfigurationManager.AppSettings["nb_beam_SIG"]); d++ )
        {
            string nbeam = string.Format("{0}", (d + 1));

            for (int c = 0; c < int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]) && c < 26; c++)
            {
                string sufix = string.Format("{0}", (c + 1));

                DbRequest += (", a." + param4_name + sufix + '_' + nbeam);
            }
        }


        DbRequest += (" FROM SIGNATURE a " + timestampsrequest + " order by a.TIME_REC");


        // Get wind from database
        DataSet ds = new DataSet();
        FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(DbRequest, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        DataTable myDataTable = ds.Tables[0];



        List<double[]> list_amplitude = new List<double[]>();
        List<double[]> list_direction = new List<double[]>();
        List<string> list_time = new List<string>();

        List<double> list_pitch = new List<double>();
        List<double> list_roll = new List<double>();
        List<double> list_temp = new List<double>();
        List<double> list_press = new List<double>();


        double cell_size = double.Parse(WebConfigurationManager.AppSettings["cell_size_SIG"]) / 100;
        double blanking_dist = double.Parse(WebConfigurationManager.AppSettings["blancking_SIG"]) / 100;
        if (myDataTable.Rows.Count > 0)
        {
            //blanking_dist = (double.Parse(myDataTable.Rows[0]["BLK"].ToString()));
            //cell_size = (double.Parse(myDataTable.Rows[0]["CS"].ToString()));
        }
        foreach (DataRow dRow in myDataTable.Rows)
        {
            double[] amp = new double[int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"])];
            double[] dir = new double[int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"])];
            double dir_cor = 0;

            list_pitch.Add(double.Parse(dRow[param0_name].ToString()));
            list_roll.Add(double.Parse(dRow[param1_name].ToString()));
            list_temp.Add(double.Parse(dRow[param2_name].ToString()));
            list_press.Add(double.Parse(dRow[param3_name].ToString()));


            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());
            // UTC to Local Time
            date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            list_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            // Direction and amplitude for all cells
            for (int cell = 0; cell < int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]) && cell < 26; cell++)
            {
                // SIGNATURE 
                 
                double V_X_East = double.Parse(dRow[param4_name + (cell + 1).ToString() + "_1"].ToString());
                double V_Y_North = double.Parse(dRow[param4_name + (cell + 1).ToString() + "_2"].ToString());
                amp[cell] = Math.Round(Math.Sqrt(V_X_East * V_X_East + V_Y_North * V_Y_North),3);

                dir[cell] = Math.Round((Math.Atan2(V_X_East, V_Y_North) / (2 * Math.PI) * 360),1);
                if (dir[cell] < 0) dir[cell] += 360;


                if (amp[cell] > 20)
                    amp[cell] = 0.0;
            }

            list_amplitude.Add(amp);
            list_direction.Add(dir);
        }


        // Build current data object
        data_SIG_Current data = new data_SIG_Current();
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

public class data_SIG_Current
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