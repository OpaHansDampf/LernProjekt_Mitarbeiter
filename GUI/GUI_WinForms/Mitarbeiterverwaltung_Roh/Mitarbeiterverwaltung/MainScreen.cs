using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Text;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Mitarbeiterverwaltung
{
    public partial class MainScreen : Form
    {
        private SqlConnection databaseConnection = new SqlConnection(@"Data Source=NB323\SQLEXPRESS;Initial Catalog=MitarbeiterDB;Integrated Security=True");
        public MainScreen()
        {
            InitializeComponent();

            getGeschlecht();
        }

        private void getGeschlecht()
        {
            cb_geschlecht.Items.Clear();

            databaseConnection.Open();
            string query = "SELECT Geschlecht_Lang From Geschlecht";

            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, databaseConnection);

            DataTable dataTable = new DataTable();
            sqlDataAdapter.Fill(dataTable);

            databaseConnection.Close();

            foreach (DataRow row in dataTable.Rows)
            {
                cb_geschlecht.Items.Add(row["Geschlecht_Lang"].ToString());
            }
        } 
        private void MainScreen_Load(object sender, EventArgs e)
        {
            showMitarbeiter();
            //dgvMitarbeiter.SelectionChanged += dgvMitarbeiter_SelectionChanged;
        }

        private DataSet getMitarbeiterTable()
        {
            databaseConnection.Open();
            string query = "SELECT ID_M, M.Vorname, M.Nachname, G.Geschlecht_Lang FROM Mitarbeiter" +
                           " M inner join Geschlecht G ON G.ID_GESCHLECHT = M.ID_GESCHLECHT";


            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, databaseConnection);

            DataSet dataSet = new DataSet();
            sqlDataAdapter.Fill(dataSet);

            databaseConnection.Close();
            return dataSet;
        }

        private void showMitarbeiter()
        {
            dgvMitarbeiter.DataSource = getMitarbeiterTable().Tables[0];
            dgvMitarbeiter.Columns[0].Visible = false;
        }

        private void btn_newMitarbeiter_Click(object sender, EventArgs e)
        {
            string vorname = txt_vorname.Text;
            string nachname = txt_nachname.Text;
            int geschlecht = 0;

            if(cb_geschlecht.SelectedIndex == 0 ) {
                geschlecht = 2;
            }
            else
            {
                geschlecht = 1;
            }

            if(vorname != "" && nachname != "" && cb_geschlecht.SelectedIndex >= 0)
            {
                databaseConnection.Open();
                string query = string.Format("Insert Into Mitarbeiter(Vorname, Nachname, ID_GESCHLECHT) Values ('{0}', '{1}', '{2}' )", vorname, nachname, geschlecht);
                SqlCommand cmd = new SqlCommand(query, databaseConnection);
                cmd.ExecuteNonQuery();
                databaseConnection.Close();
            } 

            showMitarbeiter();
            clearInput();
        }

        private void clearInput()
        {
            txt_vorname.Text = "";
            txt_nachname.Text = "";
            cb_geschlecht.SelectedIndex = -1;
        }

        private void btn_clear_Click(object sender, EventArgs e)
        {
            clearInput();
        }

        

        private void dgvMitarbeiter_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            txt_vorname.Text = dgvMitarbeiter.SelectedRows[0].Cells[1].Value.ToString();
            txt_nachname.Text = dgvMitarbeiter.SelectedRows[0].Cells[2].Value.ToString();
            cb_geschlecht.Text = dgvMitarbeiter.SelectedRows[0].Cells[3].Value.ToString();
        }

        private void btn_changeMitarbeiter_Click(object sender, EventArgs e)
        {
            int id = (int)dgvMitarbeiter.SelectedRows[0].Cells[0].Value;
            string vorname = txt_vorname.Text;
            string nachname = txt_nachname.Text;
            int geschlecht = 0;


            if (cb_geschlecht.SelectedIndex == 0)
            {
                geschlecht = 2;
            }
            else
            {
                geschlecht = 1;
            }

            if (vorname != "" && nachname != "" && cb_geschlecht.SelectedIndex >= 0)
            {
                databaseConnection.Open();
                
                string query = string.Format("Update Mitarbeiter SET Vorname = '{0}', Nachname = '{1}', ID_GESCHLECHT = '{2}' WHERE ID_M = '{3}' ", vorname, nachname, geschlecht, id);
                SqlCommand cmd = new SqlCommand(query, databaseConnection);
                cmd.ExecuteNonQuery();
                databaseConnection.Close();
            }

            showMitarbeiter();
        }

        private void btn_delMitarbeiter_Click(object sender, EventArgs e)
        {
            int id = (int)dgvMitarbeiter.SelectedRows[0].Cells[0].Value;
            
            if (id > 0)
            {
                databaseConnection.Open();

                string query = string.Format("Delete from Mitarbeiter WHERE ID_M = '{0}' ", id);
                SqlCommand cmd = new SqlCommand(query, databaseConnection);
                cmd.ExecuteNonQuery();
                databaseConnection.Close();
            } else
            {
                MessageBox.Show("Die ID ist ungültig.");
            }

            showMitarbeiter();
        }
    }
}
