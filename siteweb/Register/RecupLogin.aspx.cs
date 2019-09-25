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
using System.Linq;
using System.Net.Mail;

public partial class _RecupLogin : Page
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
        int id = 0;
        string email = userEmail.Value;
        string username = "";
        string password = "";
        try
        {
            /////////////////////////////////////////////////////////////////////
            // VERIF EMAIL

            DataSet ds = new DataSet();
            FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT ID, USERNAME, EMAIL, PWD FROM CLIENT WHERE EMAIL = '" + email + "'", ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            dataadapter.Fill(ds);
            DataTable myDataTable = ds.Tables[0];

            if (myDataTable.Rows.Count == 0)
            {
                // user already use...
                LabelWarning.Text = "aucun compte utilisateur n'est associé à cette adresse e-mail";
                LabelWarning.ForeColor = System.Drawing.Color.Red;
                return;
            }
            else
            {
                username = ds.Tables[0].Rows[0]["USERNAME"].ToString();
                password = ds.Tables[0].Rows[0]["PWD"].ToString();
            }

            string siteurl = WebConfigurationManager.AppSettings["SiteUrl"];
            string body = string.Format("Pour vous connecter au site {0}", siteurl);
            body += ("\nnom d'utilisateur : " + username);
            body += ("\nmot de passe : " + password);


            // Command line argument must the the SMTP host.
            SmtpClient client = new SmtpClient();
            client.Port = 587;
            client.Host = "smtp.mail.yahoo.com";
            client.EnableSsl = true;
            client.Timeout = 5000;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential("nortekmed@yahoo.fr", "continental21");

            MailMessage mm = new MailMessage("nortekmed@yahoo.fr", email, "Récupération des informations connexion", body);
            //mm.BodyEncoding = UTF8Encoding.UTF8;
            mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(mm);

        }
        catch (Exception ex)
        {
            LabelWarning.Text = "Une erreur est survenue lors de la récupération des informations de connexion, veuillez reessayer ultérieurement";
            LabelWarning.ForeColor = System.Drawing.Color.Red;
            return;
        }

        Response.Redirect("~/Register/RecupLoginOK.aspx");
    }
}