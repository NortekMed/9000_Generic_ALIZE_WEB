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

public partial class _Register : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.IsAuthenticated)
        {
            Response.Redirect("~/Default.aspx");
        }

    }

    protected void Register_OnClick(object Source, EventArgs e)
    {
        try
        {

            string email = userEmail.Value;
            string code = userCode.Value;

            /////////////////////////////////////////////////////////////////////
            // VERIF EMAIL

            DataSet ds1 = new DataSet();
            FbDataAdapter dataadapter1 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT EMAIL, VALID, VALIDCODE FROM CLIENT WHERE EMAIL = '" + email + "'", ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            dataadapter1.Fill(ds1);
            DataTable myDataTable1 = ds1.Tables[0];

            if (myDataTable1.Rows.Count == 0)
            {
                // user already use...
                LabelWarning.Text = "adresse email inconnue";
                LabelWarning.ForeColor = System.Drawing.Color.Red;
                return;
            }
            else
            {
                string code_db = (string)ds1.Tables[0].Rows[0].ItemArray.GetValue(2);
                if (code == code_db)
                {
                    // OK!!!!

                    FbConnection myConnection = new FbConnection(ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
                    myConnection.Open();


                    FbTransaction myTransaction = myConnection.BeginTransaction();
                    FbCommand cmd = new FbCommand();
                    cmd.Connection = myConnection;
                    cmd.Transaction = myTransaction;
                    cmd.CommandText = "update client set valid=1 where email='" + email + "'";
                    cmd.ExecuteNonQuery();

                    myTransaction.Commit();

                    cmd.Dispose();

                    myConnection.Close();

                }
                else
                {
                    LabelWarning.Text = "code d'activation erroné";
                    LabelWarning.ForeColor = System.Drawing.Color.Red;
                    return;
                }

            }
        }
        catch (Exception ex)
        {
            LabelWarning.Text = "Une erreur est survenue lors de l'inscription, veuillez reessayer ultérieurement";
            LabelWarning.ForeColor = System.Drawing.Color.Red;
            return;
        }

        Response.Redirect("~/Register/RegisterValidated.aspx");
    }
}