using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Description résumée de Class2
/// </summary>
namespace GlobalVariables
{
    public static class Global
    {
        /// <summary>
        /// Global variable storing important stuff.
        /// </summary>
        public static string l_prj_name = "PROJECT NAME : ";
        public static string l_device_name = "DEVICE NAME : ";
        public static string l_location = "MEASUREMENT LOCATION :";
        public static string l_timeref = "TIMEREF : ";
        public static string l_timestamp = "TIMESTAMP : ";
        public static string l_direction = "DIRECTION : ";
        public static string l_orientation = "NORTH : ";

        public static double declination = 0;


        //public static double GetDeclination()
        //{

        //    string timestampsrequest = " WHERE a.TIME_REC<='" + endate.ToString("dd.MM.yyyy , HH:mm:ss") + "'";


        //    DataSet ds = new DataSet();
        //    FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT a.TIME_LOG, a.DECLINATION FROM SYSTEM a " + timestampsrequest + " order by a.TIME_REC", ConfigurationManager.ConnectionStrings["database1"].ConnectionString);
        //    dataadapter.Fill(ds);
        //    DataTable myDataTable = ds.Tables[0];

        //}

            /// <summary>
            /// Get or set the static important data.
            /// </summary>
            //public static string ImportantData
            //{
            //    get
            //    {
            //        return _importantData;
            //    }
            //    set
            //    {
            //        _importantData = value;
            //    }
            //}
        }
}