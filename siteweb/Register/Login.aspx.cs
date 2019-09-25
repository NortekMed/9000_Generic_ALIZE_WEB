using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Web;
using System.Web.UI;
using Nortekmed2015;
using System.Web.Security;
using System.Web.Configuration;
using System.Configuration;
using FirebirdSql.Data.FirebirdClient;
using System.Data;

public partial class Account_Login : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void LoginUser_Authenticate(object sender, System.Web.UI.WebControls.AuthenticateEventArgs e)
    {
        e.Authenticated = false;

        try
        {

            DataSet ds = new DataSet();
            string debug = ConfigurationManager.ConnectionStrings["database_client"].ConnectionString;
            FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT * FROM CLIENT WHERE USERNAME = '" + Login1.UserName + "'", ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            dataadapter.Fill(ds);
            DataTable myDataTable = ds.Tables[0];

            if (myDataTable.Rows.Count == 1)
            {
                // Client trouvé dans la base !
                if (Login1.Password.Equals(myDataTable.Rows[0]["PWD"]))
                {

                    // update count connection
                    int count = (int)myDataTable.Rows[0]["LOGCOUNT"];

                    count += 1;

                    FbConnection myConnection = new FbConnection(ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
                    myConnection.Open();


                    FbTransaction myTransaction = myConnection.BeginTransaction();
                    FbCommand cmd = new FbCommand();
                    cmd.Connection = myConnection;
                    cmd.Transaction = myTransaction;
                    cmd.CommandText = string.Format("update client set logcount={0} where username='{1}'", count, Login1.UserName);
                    cmd.ExecuteNonQuery();

                    myTransaction.Commit();

                    cmd.Dispose();

                    myConnection.Close();


                    e.Authenticated = true;
                    Session["user"] = true;
                    FormsAuthentication.SetAuthCookie(Login1.UserName, false);

                    Response.Redirect("~/Default");
                }
                else
                {
                    // Mauvais mdp !

                }
            }
        }
        catch (Exception ex) { }
        
    }
}