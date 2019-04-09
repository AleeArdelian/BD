using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace L1
{
    public partial class Form1 : Form
    {

        SqlConnection dbCon;
        SqlDataAdapter daOnline, daMuseum;  // online-child
        DataSet dataSet;
        SqlCommandBuilder comBuild;
        BindingSource bsOnline, bsMuseum;
        DataRelation relation;



        public Form1()
        {
            InitializeComponent();
            getData();
        }

        void getData()
        {
          
            String conStr = ConfigurationManager.ConnectionStrings["conString"].ConnectionString;
            dbCon = new SqlConnection(conStr);
            //dbCon = new SqlConnection(@"Data Source = DESKTOP-CDPS71M\SQLEXPRESS; Initial Catalog = Museum ; Integrated Security = true");
            dataSet = new DataSet();

            //daOnline = new SqlDataAdapter("select * from Online_Events", dbCon);
            //daOnline.Fill(dataSet, "Online_Events");
            String select1 =  ConfigurationManager.AppSettings.Get("select1");
            String parent = ConfigurationManager.AppSettings.Get("parent");
            daOnline = new SqlDataAdapter(select1, dbCon);
            daOnline.Fill(dataSet, parent);

            String select2 = ConfigurationManager.AppSettings.Get("select2");
            String child = ConfigurationManager.AppSettings.Get("child");
            daMuseum = new SqlDataAdapter(select2, dbCon);
            daMuseum.Fill(dataSet, child);
            //daMuseum = new SqlDataAdapter("select * from Museum_Events", dbCon);
            //daMuseum.Fill(dataSet, "Museum_Events");

            //relation = new DataRelation("OnlineMuseumComp", dataSet.Tables["Online_Events"].Columns["event_id"], dataSet.Tables["Museum_Events"].Columns["event_id"]);
            String fkName = ConfigurationManager.AppSettings.Get("FKName");
            String fkid = ConfigurationManager.AppSettings.Get("FKID");
            relation = new DataRelation(fkName, dataSet.Tables[parent].Columns[fkid], dataSet.Tables[child].Columns[fkid]);


            dataSet.Relations.Add(relation);

            BindingSource bsParent = new BindingSource();
            //bsParent.DataSource = dataSet.Tables["Online_Events"];
            //BindingSource bsChild = new BindingSource(bsParent, "OnlineMuseumComp");
            bsParent.DataSource = dataSet.Tables[parent];
            BindingSource bsChild = new BindingSource(bsParent, fkName);
            dataGridView1.DataSource = bsParent;
            dataGridView2.DataSource = bsChild;

        }

        private void button1_Click(object sender, EventArgs e)
        {
            String parent = ConfigurationManager.AppSettings.Get("parent");
            String child = ConfigurationManager.AppSettings.Get("child");
            SqlCommandBuilder builder = new SqlCommandBuilder(daMuseum);
            daMuseum.Update(dataSet.Tables[child]);
            builder.DataAdapter = daOnline;
            daOnline.Update(dataSet.Tables[parent]);
        }

    }
}
