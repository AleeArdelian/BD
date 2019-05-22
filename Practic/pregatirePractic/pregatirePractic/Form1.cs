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

namespace pregatirePractic
{
    public partial class Form1 : Form
    {

        SqlConnection connection;
        DataSet dataSet;
        SqlDataAdapter daChild, daParent;
        DataRelation relation;


        public Form1()
        {
            InitializeComponent();
            getData();
        }


        void getData()
        {
            connection = new SqlConnection(@"Data Source = DESKTOP-CDPS71M\SQLEXPRESS; Initial Catalog = Management ; Integrated Security = true");
            dataSet = new DataSet();

            daChild = new SqlDataAdapter("select * from tasks", connection);
            daChild.Fill(dataSet, "tasks");


            daParent = new SqlDataAdapter("select * from developers", connection);
            daParent.Fill(dataSet, "developers");


            relation = new DataRelation("FK_Dev_Tasks", dataSet.Tables["developers"].Columns["devId"], dataSet.Tables["tasks"].Columns["devId"]);

            dataSet.Relations.Add(relation);

            BindingSource bsParent = new BindingSource();
            bsParent.DataSource = dataSet.Tables["developers"];

            BindingSource bsChild = new BindingSource(bsParent, "FK_Dev_Tasks");

            childGrid.DataSource = bsChild;
            parentGrid.DataSource = bsParent;
        }


        private void button1_Click(object sender, EventArgs e)
        {
            SqlCommandBuilder builder = new SqlCommandBuilder(daChild);
            daChild.Update(dataSet.Tables["tasks"]);
            builder.DataAdapter = daParent;
            daParent.Update(dataSet.Tables["developers"]);
        }
    }
}
