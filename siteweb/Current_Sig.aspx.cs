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
using Microsoft.Ajax.Utilities;
using System.Activities.Validation;

//public static class MessageBox
//{
//    public static void Show( String Message)
//    {
//        Page.ClientScript.RegisterStartupScript(
//           Page.GetType(),
//           "MessageBox",
//           "<script language='javascript'>alert('" + Message + "');</script>"
//        );
//    }

//}

public partial class SIG_Current : System.Web.UI.Page
{

    public static data_SIG_Current downloaddata;

    static string prj_name = "";
    static string device_name = "";
    static string location;
    static string timeref;
    static string timestamp;
    static string direction;
    static string orientation;


    static string equip_name = "";

    static string pitch_name = "";
    static string pitch_unit = "";
    static string pitch_label = "";
    static string roll_name = "";
    static string roll_label = "";
    static string roll_unit = "";
    static string temp_name = "";
    static string temp_unit = "";
    static string temp_label = "";
    static string press_name = "";
    static string press_unit = "";
    static string press_label = "";
    static string volt_name = "";
    static string volt_unit = "";
    static string speed_name = "";
    static string speed_unit = "";
    static string speed_label = "";
    static string amp_name = "";
    static string amp_unit = "";
    static string amp_label = "";
    static string cor_name = "";
    static string cor_unit = "";
    static string cor_label = "";

    static string heading_name = "";
    static string heading_unit = "";
    static string heading_label = "";

    static int[] itab_layers;
    static List<int> ilist_layers;

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

        if (WebConfigurationManager.AppSettings["LightEnabled"] == "true")
        {
            light_site.Value = "true";
        }
        else
            light_site.Value = "false";

        if (WebConfigurationManager.AppSettings["Declination"] == "true")
        {
            b_decl_hd.Value = "true";
        }
        else
            b_decl_hd.Value = "false";

        ilist_layers = new List<int>();
        ilist_layers.Clear();
        if (WebConfigurationManager.AppSettings["tab_layers"] != "")
        {
            string list_layers = WebConfigurationManager.AppSettings["tab_layers"];

            if (list_layers.EndsWith(";"))
                list_layers = list_layers.Remove(list_layers.Length - 1);
            string[] stab_layers = list_layers.Split(';');
            itab_layers = new int[stab_layers.Length];

            for (int j = 0; j < stab_layers.Length; j++)
            {
                int val = 0;
                int.TryParse(stab_layers[j], out val);
                itab_layers[j] = val;
                ilist_layers.Add(val);
            }
        }
        else
        {
            int nb_c = int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]);
            itab_layers = new int[nb_c];
            for (int j = 0; j < nb_c; j++)
            {
                itab_layers[j] = j+1;
                ilist_layers.Add(j+1);
            }
        }
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


    protected void DownloadCurrent(object Source, EventArgs e)
    {
        device_name = Resources.CurrentSIG.DEVICE_0;
        List<string> output = MakeHeader(device_name);

        string s_layers = "";
        int nb_c = int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]);
        for (int j = 0; j < nb_c; j++)
        {
            if (!ilist_layers.Contains(j + 1))
                continue;

            string immersion = (downloaddata.C_blancking + downloaddata.C_cellsize * (1 + j)).ToString();
            s_layers += "C_Spd" + (j+1).ToString() + " (" + speedunit.Value + ")(-" + immersion + "m);";
            s_layers += "C_Dir" + (j+1).ToString() + " (" + direction_unit.Value + ")(-" + immersion + "m);";
            s_layers += "C_Amp" + (j+1).ToString() + " ( dB)(-" + immersion + "m);";
        }

        output.Add("UTC datetime;"  + templabel.Value + '(' + tempunit.Value + ");"
                                    + s_layers
                                    + voltname.Value + '(' + voltunit.Value + ");"
                                    + pitch_name + '(' + pitch_unit + ");"
                                    + roll_name + '(' + roll_unit + ");"
                                    + heading_name + '(' + heading_unit + ");"
                                    );


        // mise en forme
        string start_date = "";
        string end_date = "";
        for (int i = 0; i < downloaddata.C_time.Length; i++)
        {
            s_layers = "";
            for ( int j = 0; j < downloaddata.C_spd[i].Length; j++)
            {
                if (!ilist_layers.Contains(j + 1))
                    continue;

                s_layers += downloaddata.C_spd[i][j].ToString("0.000", NumberFormatInfo.InvariantInfo) + ';';
                s_layers += downloaddata.C_dir[i][j].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';';
                s_layers += downloaddata.C_snr[i][j].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';';
            }

            DateTime date = Convert.ToDateTime(downloaddata.C_time[i]).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); ;
            string s_date = date.ToString("yyyy-MM-ddTHH:mm");

            output.Add(s_date.Replace("T", ", ") + ';'
                        + downloaddata.C_temp[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + s_layers
                        + downloaddata.C_volt[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.C_pitch[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.C_roll[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        + downloaddata.C_heading[i].ToString("0.0", NumberFormatInfo.InvariantInfo) + ';'
                        );

            if (i == 0)
                start_date = s_date;
            if (i == downloaddata.C_time.Length - 1)
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

        pitchname = new HiddenField();
        pitchlabel = new HiddenField();
        pitchunit = new HiddenField();

        rollname = new HiddenField();
        rolllabel = new HiddenField();
        rollunit = new HiddenField();

        tempname = new HiddenField();
        templabel = new HiddenField();
        tempunit = new HiddenField();

        pressname = new HiddenField();
        presslabel = new HiddenField();
        pressunit = new HiddenField();

        speedname = new HiddenField();
        speedlabel = new HiddenField();
        speedunit = new HiddenField();

        ampname = new HiddenField();
        amplabel = new HiddenField();
        ampunit = new HiddenField();

        corname = new HiddenField();
        corlabel = new HiddenField();
        corunit = new HiddenField();

        headingname = new HiddenField();
        headinglabel = new HiddenField();
        headingunit = new HiddenField();

        voltname = new HiddenField();
        voltunit = new HiddenField();

        msg_info_0 = new HiddenField();

        direction_label = new HiddenField();
        direction_unit = new HiddenField();
        //speed_label = new HiddenField();
        profdir_label = new HiddenField();
        profspeed_label = new HiddenField();
        profamp_label = new HiddenField();

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
            location = WebConfigurationManager.AppSettings["LOCATION"];
            timeref = Resources.CurrentSIG.TIMEREF;
            timestamp = Resources.CurrentSIG.TIMESTAMP;
            direction = Resources.CurrentSIG.DIRECTION;

            if (WebConfigurationManager.AppSettings["DECLINATION"] == "true")
                orientation = Resources.Site.Master.orientationG + ", " + Resources.Site.Master.declination;
            else
                orientation = Resources.Site.Master.orientationM;
            //orientation = Resources.CurrentSIG.ORIENTATION;


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

            pitchname.Value = Resources.CurrentSIG.param0name.ToString();
            pitchlabel.Value = Resources.CurrentSIG.param0label.ToString();
            pitchunit.Value = Resources.CurrentSIG.param0unit.ToString();

            rollname.Value = Resources.CurrentSIG.param1name.ToString();
            rolllabel.Value = Resources.CurrentSIG.param1label.ToString();
            rollunit.Value = Resources.CurrentSIG.param1unit.ToString();

            tempname.Value = Resources.CurrentSIG.param2name.ToString();
            templabel.Value = Resources.CurrentSIG.param2label.ToString();
            tempunit.Value = Resources.CurrentSIG.param2unit.ToString();

            pressname.Value = Resources.CurrentSIG.param3name.ToString();
            presslabel.Value = Resources.CurrentSIG.param3label.ToString();
            pressunit.Value = Resources.CurrentSIG.param3unit.ToString();

            speedname.Value = Resources.CurrentSIG.param4name.ToString();
            speedlabel.Value = Resources.CurrentSIG.param4label.ToString();
            speedunit.Value = Resources.CurrentSIG.param4unit.ToString();

            ampname.Value = Resources.CurrentSIG.param5name.ToString();
            amplabel.Value = Resources.CurrentSIG.param5label.ToString();
            ampunit.Value = Resources.CurrentSIG.param5unit.ToString();

            corname.Value = Resources.CurrentSIG.param6name.ToString();
            corlabel.Value = Resources.CurrentSIG.param6label.ToString();
            corunit.Value = Resources.CurrentSIG.param6unit.ToString();

            headingname.Value = Resources.CurrentSIG.param8name.ToString();
            headinglabel.Value = Resources.CurrentSIG.param8label.ToString();
            headingunit.Value = Resources.CurrentSIG.param8unit.ToString();

            voltname.Value = Resources.CurrentSIG.param7name.ToString();
            voltunit.Value = Resources.CurrentSIG.param7unit.ToString();

            msg_info_0.Value = Resources.CurrentSIG.msg_info_0.ToString();

            direction_label.Value = Resources.CurrentSIG.direction_label.ToString();
            direction_unit.Value = Resources.CurrentSIG.direction_unit.ToString();
            //speed_label.Value = Resources.CurrentSIG.speed_label.ToString();
            profdir_label.Value = Resources.CurrentSIG.profdir_label.ToString();
            profspeed_label.Value = Resources.CurrentSIG.profspeed_label.ToString();
            profamp_label.Value = Resources.CurrentSIG.profamp_label.ToString();


            //Assigning string value
            equip_name = equipname.Value;

            pitch_name = pitchname.Value;
            pitch_unit = pitchunit.Value;
            pitch_label = pitchlabel.Value;


            roll_name = rollname.Value;
            roll_unit = rollunit.Value;
            roll_label = rolllabel.Value;

            temp_name = tempname.Value;
            temp_unit = tempunit.Value;
            temp_label = templabel.Value;

            press_name = pressname.Value;
            press_unit = pressunit.Value;
            press_label = presslabel.Value;

            volt_name = voltname.Value;
            volt_unit = voltunit.Value;

            speed_name = speedname.Value;
            speed_unit = speedunit.Value;
            speed_label = speedlabel.Value;


            amp_name = ampname.Value;
            amp_unit = ampunit.Value;
            amp_label = amplabel.Value;

            cor_name = corname.Value;
            cor_unit = corunit.Value;
            cor_label = corlabel.Value;

            heading_name = headingname.Value;
            heading_unit = headingunit.Value;
            heading_label = headinglabel.Value;

            ilist_layers = new List<int>();
            if (WebConfigurationManager.AppSettings["tab_layers"] != "")
            {
                string list_layers = WebConfigurationManager.AppSettings["tab_layers"];

                if (list_layers.EndsWith(";"))
                    list_layers = list_layers.Remove(list_layers.Length - 1);
                string[] stab_layers = list_layers.Split(';');
                itab_layers = new int[stab_layers.Length];

                for (int j = 0; j < stab_layers.Length; j++)
                {
                    int val = 0;
                    int.TryParse(stab_layers[j], out val);
                    itab_layers[j] = val;
                    ilist_layers.Add(val);
                }
            }
            else
            {
                int nb_c = int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]);
                itab_layers = new int[nb_c];
                for (int j = 0; j < nb_c; j++)
                    {
                        itab_layers[j] = j+1;
                        ilist_layers.Add(j+1);
                    }
                }
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

        string timestampsrequest;
        string DbRequest;
        DataSet ds;
        FbDataAdapter dataadapter;
        DataTable myDataTable;

        double decl = 0;
        List<double> list_decl = new List<double>();
        List<DateTime> list_time_decl = new List<DateTime>();
        ///////////////////////////////////////////////////////////////////////////
        /// Reading declination
        /// 
        if (WebConfigurationManager.AppSettings["DECLINATION"] == "true")
        {
            endate = DateTime.Now;  // using local time ( declination time registering should be in local time )

            timestampsrequest = " WHERE a.TIME_LOG<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";


            ds = new DataSet();
            dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_LOG, a.DECLINATION FROM DECLINATION a " + timestampsrequest + " order by a.TIME_LOG", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
            dataadapter.Fill(ds);
            myDataTable = ds.Tables[0];

            //List<double> list_decl = new List<double>();
            //List<DateTime> list_time_decl = new List<DateTime>();

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
        }
        ///////////////////////////////////////////////////////////////////////////

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

        if (WebConfigurationManager.AppSettings["DECLINATION"] == "true")
        {
            for (int i = 0; i < list_time_decl.Count; i++)
            {

                if (list_time_decl[i] < endate)
                {
                    decl = list_decl[i];
                }
                else
                    break;  // sql request sort list_time_decl in ascending form, so when if comparaison is false we can stop the loop 'for'
            }
        }

        //Because timerec in DB is middle of acquisition time, we want the end
        int halh_integration_time = int.Parse(WebConfigurationManager.AppSettings["integration_time_SIG"]); // in sec
        halh_integration_time /= 2;
        // modifie stdate and endate to take account half integration time
        stdate = stdate.AddSeconds(halh_integration_time);
        endate = endate.AddSeconds(halh_integration_time);



        timestampsrequest = " WHERE a.TIME_REC>='" + stdate.ToString("dd.MM.yyyy , HH:mm:ss") + "' and a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";

        // AWAC / AQUADOPP

        // Generate DB request
        DbRequest = "SELECT a.TIME_REC, a." + pitch_name + ", a." + roll_name + ", a." + temp_name + ", a." + press_name + ", a." + volt_name + ", a." + heading_name;

        for (int d = 0; d < int.Parse(WebConfigurationManager.AppSettings["nb_beam_SIG"]); d++ )
        {
            string nbeam = string.Format("{0}", (d + 1));

            for (int c = 0; c < int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]); c++)
            {
                string sufix = string.Format("{0}", (c + 1));

                DbRequest += (", a." + speed_name + sufix + '_' + nbeam);
                
                if ( nbeam == "1" )
                    DbRequest += (", a." + "Amp" + sufix + '_' + nbeam);
            }
            
        }


        DbRequest += (" FROM SIGNATURE a" + timestampsrequest + " order by a.TIME_REC");


        ds = new DataSet();
        dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(DbRequest, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        dataadapter.Fill(ds);
        myDataTable = ds.Tables[0];



        List<double[]> list_spd = new List<double[]>();
        List<double[]> list_direction = new List<double[]>();
        List<double[]> list_snr = new List<double[]>();
        List<string> list_time = new List<string>();
        List<int> list_layers = new List<int>();

        List<double> list_pitch = new List<double>();
        List<double> list_roll = new List<double>();
        List<double> list_temp = new List<double>();
        List<double> list_press = new List<double>();
        List<double> list_volt = new List<double>();
        List<double> list_heading = new List<double>();


        double cell_size = double.Parse(WebConfigurationManager.AppSettings["cell_size_SIG"]) / 100;
        double blanking_dist = double.Parse(WebConfigurationManager.AppSettings["blancking_SIG"]) / 100;
        if (myDataTable.Rows.Count > 0)
        {
            //blanking_dist = (double.Parse(myDataTable.Rows[0]["BLK"].ToString()));
            //cell_size = (double.Parse(myDataTable.Rows[0]["CS"].ToString()));
        }

        int nb_c = int.Parse(WebConfigurationManager.AppSettings["nb_couche_SIG"]);
        double utcdataoffset = double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"]);
        double systemUTCTimeOffset = double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"]);
        foreach (DataRow dRow in myDataTable.Rows)
        {
            double[] spd = new double[nb_c];
            double[] dir = new double[nb_c];
            double[] snr = new double[nb_c];
            //double dir_cor = 0;

            list_pitch.Add(double.Parse(dRow[pitch_name].ToString()));
            list_roll.Add(double.Parse(dRow[roll_name].ToString()));
            list_temp.Add(double.Parse(dRow[temp_name].ToString()));
            list_press.Add(double.Parse(dRow[press_name].ToString()));
            list_volt.Add(double.Parse(dRow[volt_name].ToString()));

            double tmp = double.Parse(dRow[heading_name].ToString());
            tmp += decl;
            if (tmp > 360) tmp -= 360.0;
            if (tmp < 0) tmp += 360.0;
            list_heading.Add(tmp);
            //list_heading.Add(double.Parse(dRow[heading_name].ToString()));


            DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());
            // UTC to Local Time
            date = date.AddHours(utcdataoffset).AddHours(-1 * systemUTCTimeOffset); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE
            // take acoount halh_integration_time
            date = date.AddSeconds(-1 * halh_integration_time);

            list_time.Add(date.ToString("yyyy-MM-ddTHH:mm"));

            // Direction and amplitude for all cells
            //for (int cell = 0; cell < nb_c && cell < 26; cell++)
            for (int cell = 0; cell < nb_c; cell++)
            {
                // SIGNATURE 
                double V_X_East = 0;
                double V_Y_North = 0;
                if (ilist_layers.Count != 0 )
                {
                    list_layers = new List<int>(ilist_layers);
                    if (ilist_layers.Contains(cell+1))
                    {
                        V_X_East = double.Parse(dRow[speed_name + (cell + 1).ToString() + "_1"].ToString());
                        V_Y_North = double.Parse(dRow[speed_name + (cell + 1).ToString() + "_2"].ToString());
                        spd[cell] = Math.Round(Math.Sqrt(V_X_East * V_X_East + V_Y_North * V_Y_North), 3);

                        dir[cell] = Math.Round((Math.Atan2(V_X_East, V_Y_North) / (2 * Math.PI) * 360), 1);
                        dir[cell] += decl;
                        if (dir[cell] > 360) dir[cell] -= 360.0;
                        if (dir[cell] < 0) dir[cell] += 360.0;

                        snr[cell] = 0.5*double.Parse(dRow["Amp" + (cell + 1).ToString() + "_1"].ToString());
                    }
                    else
                    {
                        if ( cell == 0)
                        {
                            V_X_East = 0;
                            V_Y_North = 0;
                            spd[cell] = 0;

                            snr[cell] = 0;
                        }
                        else
                        {
                            //V_X_East = 0;
                            //V_Y_North = 0;
                            spd[cell] = spd[cell-1];
                            dir[cell] = dir[cell - 1];

                            snr[cell] = snr[cell-1];
                        }
                    }


                }
                else
                {
                    V_X_East = double.Parse(dRow[speed_name + (cell + 1).ToString() + "_1"].ToString());
                    V_Y_North = double.Parse(dRow[speed_name + (cell + 1).ToString() + "_2"].ToString());
                    spd[cell] = Math.Round(Math.Sqrt(V_X_East * V_X_East + V_Y_North * V_Y_North), 3);

                    dir[cell] = Math.Round((Math.Atan2(V_X_East, V_Y_North) / (2 * Math.PI) * 360), 1);
                    dir[cell] += decl;
                    if (dir[cell] > 360) dir[cell] -= 360.0;
                    if (dir[cell] < 0) dir[cell] += 360.0;

                    snr[cell] = 0.5*double.Parse(dRow["Amp" + (cell + 1).ToString() + "_1"].ToString());

                }

                //dir[cell] = Math.Round((Math.Atan2(V_X_East, V_Y_North) / (2 * Math.PI) * 360),1);
                //if (dir[cell] < 0) dir[cell] += 360;

                //dir[cell] += decl;
                //if (dir[cell] > 360) dir[cell] -= 360.0;
                //if (dir[cell] < 0) dir[cell] += 360.0;

                //snr[cell] = double.Parse(dRow["Amp" + (cell + 1).ToString() + "_1"].ToString());

                if (spd[cell] > 20)
                    spd[cell] = 0.0;

                if (spd[cell] == 0)
                    dir[cell] = 0;
            }

            list_spd.Add(spd);
            list_direction.Add(dir);
            list_snr.Add(snr);
        }

        //List<double> list_sbe_temp = new List<double>();
        //List<double> list_sbe_sal = new List<double>();
        //List<string> list_str_sbe = new List<string>();

        //ds = new DataSet();
        //DbRequest = "SELECT a.TIME_REC, a.TEMP" + ", a.SAL"  + " FROM " + "SBE" + " a" +
        //                timestampsrequest + " order by a.TIME_REC";

        //dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter(DbRequest, ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        //dataadapter.Fill(ds);
        //myDataTable = ds.Tables[0];

        //foreach (DataRow dRow in myDataTable.Rows)
        //{
        //    DateTime date = Convert.ToDateTime(dRow["TIME_REC"].ToString());

        //    // UTC to Local Time
        //    date = date.AddHours(double.Parse(WebConfigurationManager.AppSettings["UTCdataOffset"])).AddHours(-1 * double.Parse(WebConfigurationManager.AppSettings["systemUTCTimeOffset"])); //=>>>> TIMEREC SINGATURE EN HEURE LOCALE

        //    list_str_sbe.Add(date.ToString("yyyy-MM-ddTHH:mm"));

        //    list_sbe_temp.Add(double.Parse(dRow["TEMP"].ToString()));
        //    list_sbe_sal.Add(double.Parse(dRow["SAL"].ToString()));
        //}

        // Build current data object
        data_SIG_Current data = new data_SIG_Current();
        data.set(list_spd,
            list_direction,
            list_snr,
            list_time,
            cell_size, //double.Parse(WebConfigurationManager.AppSettings["cell_size_1"])/100,
            blanking_dist,//double.Parse(WebConfigurationManager.AppSettings["blancking_1"])/100,
            list_pitch, list_roll, list_temp, list_press, list_volt, list_heading, list_layers);//, list_sbe_temp, list_sbe_sal, list_str_sbe);

        data.setDeclination(decl);


        // On garde en memoire les données affichées pour un éventuel téléchargement !!!
        downloaddata = data;

        // return meteo data to javascript !
        return data;
    }
}

public class data_SIG_Current
{
    public double[][] C_spd;
    public double[][] C_dir;
    public double[][] C_snr;
    public string[] C_time;
    public double C_cellsize;
    public double C_blancking;
    public double[] C_pitch;
    public double[] C_roll;
    public double[] C_temp;
    public double[] C_press;
    public double[] C_volt;
    public double[] C_heading;

    public double[] SBE_temp;
    public double[] SBE_sal;
    public string[] SBE_time;

    public List<int> Layers;


    public double meanTimeInterval = 0.0;

    public double declination;

    public void set(List<double[]> l_spd,
        List<double[]> l_dir,
        List<double[]> l_snr,
        List<string> l_time,
        double cellsize,
        double blancking,
        List<double> l_pitch,
        List<double> l_roll,
        List<double> l_temp,
        List<double> l_press,
        List<double> l_volt,
        List<double> l_heading,
        List<int> l_layers)
    {

        C_spd = l_spd.ToArray();
        C_dir = l_dir.ToArray();
        C_snr = l_snr.ToArray();
        C_time = l_time.ToArray();

        C_pitch = l_pitch.ToArray();
        C_roll = l_roll.ToArray();
        C_temp = l_temp.ToArray();
        C_press = l_press.ToArray();
        C_volt = l_volt.ToArray();
        C_heading = l_heading.ToArray();

        Layers = new List<int>(l_layers);


        for (int i = 1; i < C_time.Length; i++)
            meanTimeInterval += (Convert.ToDateTime(C_time[i]) - Convert.ToDateTime(C_time[i - 1])).TotalMilliseconds;

        meanTimeInterval = meanTimeInterval / (C_time.Length - 1);

        C_cellsize = cellsize;
        C_blancking = blancking;

    }
    public void setSBE(
        List<double> l_sbe_temp,
        List<double> l_sbe_sal,
        List<string> l_sbe_time)
    {

        SBE_temp = l_sbe_temp.ToArray();
        SBE_sal = l_sbe_sal.ToArray();
        SBE_time = l_sbe_time.ToArray();

    }

    public void setDeclination(double decl)
    {
        declination = decl;
    }
}