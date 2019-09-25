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

public partial class _Register : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.IsAuthenticated)
        {
            Response.Redirect("~/Default.aspx");
        }

    }

    private static Random random = new Random();
    protected string RandomString(int length)
    {
        //const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        const string chars = "0123456789";
        return new string(Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)]).ToArray());
    }

    protected void Register_OnClick(object Source, EventArgs e)
    {
        int id = 0;
        string username = userName.Value;
        string email = userEmail.Value;
        string pwd = userPwd.Value;


        if (userPwd.Value != userPwdConfirm.Value)
        {
            LabelWarning.Text = "Les champs \"Mot de passe\" et \"Confirmer mdp\" sont différents";
            LabelWarning.ForeColor = System.Drawing.Color.Red;
            return;
        }

        if (username.Length < 6 || pwd.Length < 6)
        {
            string script = "alert(\"identifiant et mot de passe : 6 caractères minimum\");";
            ScriptManager.RegisterStartupScript(this, GetType(),
                                  "ServerControlScript", script, true);
            return;
        }

        try
        {
            /////////////////////////////////////////////////////////////////////
            // VERIF USERNAME

            DataSet ds = new DataSet();
            FbDataAdapter dataadapter = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT * FROM CLIENT WHERE USERNAME = '" + username + "'", ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            dataadapter.Fill(ds);
            DataTable myDataTable = ds.Tables[0];

            if (myDataTable.Rows.Count != 0)
            {
                // user already use...
                LabelWarning.Text = "identifiant déjà utilisé";
                LabelWarning.ForeColor = System.Drawing.Color.Red;
                return;
            }

            /////////////////////////////////////////////////////////////////////
            // VERIF EMAIL

            DataSet ds1 = new DataSet();
            FbDataAdapter dataadapter1 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT * FROM CLIENT WHERE EMAIL = '" + email + "'", ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            dataadapter1.Fill(ds1);
            DataTable myDataTable1 = ds1.Tables[0];

            if (myDataTable1.Rows.Count != 0)
            {
                // user already use...
                LabelWarning.Text = "email déjà utilisé";
                LabelWarning.ForeColor = System.Drawing.Color.Red;
                return;
            }

            /////////////////////////////////////////////////////////////////////
            // DETERMINE ID
            DataSet ds2 = new DataSet();
            FbDataAdapter dataadapter2 = new FirebirdSql.Data.FirebirdClient.FbDataAdapter("SELECT * FROM CLIENT ORDER BY ID DESC", ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            dataadapter2.Fill(ds2);
            DataTable myDataTable2 = ds2.Tables[0];

            if (myDataTable2.Rows.Count != 0)
            {
                id = (int)ds2.Tables[0].Rows[0].ItemArray.GetValue(0) + 1;
            }
            else
            {
                id = 1;
            }


            string validationCode = RandomString(4);


            /////////////////////////////////////////////////////////////////////
            // AJOUT USER BDD

            FbConnection myConnection = new FbConnection(ConfigurationManager.ConnectionStrings["database_client"].ConnectionString);
            myConnection.Open();

            
                FbTransaction myTransaction = myConnection.BeginTransaction();
                FbCommand cmd = new FbCommand();
                cmd.Connection = myConnection;
                cmd.Transaction = myTransaction;
                cmd.CommandText = "insert into client (ID,USERNAME,EMAIL,PWD,VALID,VALIDCODE,LOGCOUNT,REGISTER_DATE) values (@id,@username,@email,@pwd,@valid,@validcode,@logcount,@register_date)";
                cmd.Parameters.Add("@ID", FbDbType.Integer);
                cmd.Parameters.Add("@USERNAME", FbDbType.Text);
                cmd.Parameters.Add("@EMAIL", FbDbType.Text);
                cmd.Parameters.Add("@PWD", FbDbType.Text);
            cmd.Parameters.Add("@VALID", FbDbType.Integer);
            cmd.Parameters.Add("@VALIDCODE", FbDbType.Text);
            cmd.Parameters.Add("@LOGCOUNT", FbDbType.Integer);
            cmd.Parameters.Add("@REGISTER_DATE", FbDbType.TimeStamp);

            cmd.Parameters[0].Value = id;
            cmd.Parameters[1].Value = username;
            cmd.Parameters[2].Value = email;
            cmd.Parameters[3].Value = pwd;
            cmd.Parameters[4].Value = 0;        // Compte non valide par défault
            cmd.Parameters[5].Value = validationCode;
            cmd.Parameters[6].Value = 0;
            cmd.Parameters[7].Value = DateTime.Now;

            cmd.ExecuteNonQuery();
            myTransaction.Commit();
            cmd.Dispose();
            myConnection.Close();
            
            string siteurl = WebConfigurationManager.AppSettings["SiteUrl"] + "/Register/RegisterValidation.aspx";
            string body = string.Format("Pour valider voter compte :\n- ouvrez le lien suivant {0}\n- entrez votre adresse email et le code d'activation : {1}", siteurl, validationCode);
            body += "\n\nSi vous rencontrez des difficultés pour vous connecter, contactez nous à info@nortekmed.com";
            body += "\n\nCeci est mail automatique, veuillez ne pas y répondre";


            // Command line argument must the the SMTP host.
            SmtpClient client = new SmtpClient();
            client.Port = 587;
            client.Host = "smtp.mail.yahoo.com";
            client.EnableSsl = true;
            client.Timeout = 5000;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential("nortekmed@yahoo.fr", "continental21");

            MailMessage mm = new MailMessage("nortekmed@yahoo.fr", email, "activation de votre compte", body);
            //mm.BodyEncoding = UTF8Encoding.UTF8;
            mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(mm);

        }
        catch (Exception ex)
        {
            LabelWarning.Text = "Une erreur est survenue lors de l'inscription, veuillez reessayer ultérieurement";
            LabelWarning.ForeColor = System.Drawing.Color.Red;
            return;
        }
        Response.Redirect("~/Register/RegisterOK.aspx");
    }
}