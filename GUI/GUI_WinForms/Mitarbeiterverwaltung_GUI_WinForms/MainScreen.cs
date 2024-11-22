using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using GUI_MitarbeiterVerwaltung_test.DB;

namespace GUI_MitarbeiterVerwaltung_test
{
    public partial class MainScreen : Form
    {
        #region Initialize
        public MainScreen()
        {
            InitializeComponent();
            getGeschlecht();
        }

        private void MainScreen_Load(object sender, EventArgs e)
        {
            showMitarbeiter();
        }
        #endregion

        #region Database Operations
        private void getGeschlecht()
        {
            cb_Geschlecht.Items.Clear();
            DataTable dataTable = DbHelper.SqlGet("SELECT Geschlecht_Lang From Geschlecht");

            foreach (DataRow row in dataTable.Rows)
            {
                cb_Geschlecht.Items.Add(row["Geschlecht_Lang"].ToString());
            }
        }

        private DataTable getMitarbeiterTable()
        {
            DataTable dt = DbHelper.SqlGet("SELECT ID_M, M.Vorname, M.Nachname, G.Geschlecht_Lang FROM Mitarbeiter M inner join Geschlecht G ON G.ID_GESCHLECHT = M.ID_GESCHLECHT");
            return dt;
        }

        private void showMitarbeiter()
        {
            dg_Mitarbeiter.DataSource = getMitarbeiterTable();
            dg_Mitarbeiter.Columns[0].Visible = false;
        }

        public void UpdateMitarbeiter(int id, string vorname, string nachname, int geschlecht)
        {
            string sqlBefehl = "UPDATE Mitarbeiter SET Vorname = @Vorname, Nachname = @Nachname, ID_GESCHLECHT = @Geschlecht WHERE ID_M = @Id";
            SqlParameter[] parameters = {
                new SqlParameter("@Vorname", vorname),
                new SqlParameter("@Nachname", nachname),
                new SqlParameter("@Geschlecht", geschlecht),
                new SqlParameter("@Id", id)
            };
            DbHelper.SqlSet(sqlBefehl, parameters);
            ShowToast("Erfolgreich gespeichert!");
        }
        #endregion

        #region Event Handlers
        private void txt_Vorname_TextChanged(object sender, EventArgs e)
        {

        }

        private void txt_Nachname_TextChanged(object sender, EventArgs e)
        {

        }

        private void cb_Geschlecht_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void btn_Save_Click(object sender, EventArgs e)
        {
            string vorname = txt_Vorname.Text;
            string nachname = txt_Nachname.Text;
            int geschlecht = 0;

            if (cb_Geschlecht.SelectedIndex == 0)
            {
                geschlecht = 1;
            }
            else
            {
                geschlecht = 2;
            }

            if (vorname != "" && nachname != "" && cb_Geschlecht.SelectedIndex >= 0)
            {
                SqlParameter[] parameters = {
                    new SqlParameter("@Vorname", vorname),
                    new SqlParameter("@Nachname", nachname),
                    new SqlParameter("@Geschlecht", geschlecht)
                };
                DbHelper.SqlSet("Insert Into Mitarbeiter(Vorname, Nachname, ID_GESCHLECHT) Values (@Vorname, @Nachname, @Geschlecht)", parameters);
            }
            ShowToast("Erfolgreich gespeichert!");

            showMitarbeiter();
            clearInput();
        }

        private void btn_Change_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(dg_Mitarbeiter.SelectedRows[0].Cells[0].Value);
            string vorname = txt_Vorname.Text;
            string nachname = txt_Nachname.Text;
            int geschlecht = 0;

            if (cb_Geschlecht.SelectedIndex == 0)
            {
                geschlecht = 1;
            }
            else
            {
                geschlecht = 2;
            }

            if (vorname != "" && nachname != "" && cb_Geschlecht.SelectedIndex >= 0)
            {
                UpdateMitarbeiter(id, vorname, nachname, geschlecht);
            }
            else
            {
                MessageBox.Show("Bitte füllen Sie alle Felder aus!");
            }

            showMitarbeiter();
        }

        private void btn_Delete_Click(object sender, EventArgs e)
        {
            if (dg_Mitarbeiter.SelectedRows.Count > 0)
            {
                int id = Convert.ToInt32(dg_Mitarbeiter.SelectedRows[0].Cells[0].Value);
                if (id > 0)
                {
                    DialogResult result = MessageBox.Show(
                        "Möchten Sie diesen Mitarbeiter wirklich löschen?",
                        "Löschen bestätigen",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Question);

                    if (result == DialogResult.Yes)
                    {
                        string sqlBefehl = "DELETE FROM Mitarbeiter WHERE ID_M = @Id";
                        SqlParameter[] parameters = {
                            new SqlParameter("@Id", id)
                        };
                        DbHelper.SqlSet(sqlBefehl, parameters);
                        showMitarbeiter();
                    }
                }
                else
                {
                    MessageBox.Show("Die ID ist ungültig.");
                }
            }
            else
            {
                MessageBox.Show("Bitte wählen Sie einen Mitarbeiter aus.");
            }
        }

        private void btn_Clear_Click(object sender, EventArgs e)
        {
            clearInput();
        }

        private void dg_Mitarbeiter_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            txt_Vorname.Text = dg_Mitarbeiter.Rows[e.RowIndex].Cells[1].Value.ToString();
            txt_Nachname.Text = dg_Mitarbeiter.Rows[e.RowIndex].Cells[2].Value.ToString();
            cb_Geschlecht.Text = dg_Mitarbeiter.Rows[e.RowIndex].Cells[3].Value.ToString();
        }
        #endregion

        #region Helper Methods
        private void clearInput()
        {
            txt_Vorname.Text = "";
            txt_Nachname.Text = "";
            cb_Geschlecht.SelectedIndex = -1;
        }
        #endregion

        #region Toast Notification
        public class ToastForm : Form
        {
            private Form parentForm;

            public ToastForm(Form parent, string message)
            {
                this.parentForm = parent;
                this.FormBorderStyle = FormBorderStyle.None;
                this.BackColor = Color.FromArgb(60, 179, 113);
                this.Size = new Size(200, 40);
                this.StartPosition = FormStartPosition.Manual;
                this.ShowInTaskbar = false;

                Label label = new Label();
                label.Text = message;
                label.ForeColor = Color.White;
                label.Dock = DockStyle.Fill;
                label.TextAlign = ContentAlignment.MiddleCenter;
                this.Controls.Add(label);

                UpdatePosition();

                parentForm.LocationChanged += ParentForm_LocationChanged;
                parentForm.SizeChanged += ParentForm_LocationChanged;

                Timer timer = new Timer();
                timer.Interval = 3000;
                timer.Tick += (s, e) => {
                    parentForm.LocationChanged -= ParentForm_LocationChanged;
                    parentForm.SizeChanged -= ParentForm_LocationChanged;
                    this.Close();
                };
                timer.Start();
            }

            private void ParentForm_LocationChanged(object sender, EventArgs e)
            {
                UpdatePosition();
            }

            private void UpdatePosition()
            {
                Point parentPoint = parentForm.PointToScreen(Point.Empty);
                this.Location = new Point(
                    parentPoint.X + parentForm.Width - this.Width - 15,
                    parentPoint.Y + parentForm.Height - this.Height - 20
                );
            }
        }

        private void ShowToast(string message)
        {
            new ToastForm(this, message).Show();
        }
        #endregion
    }
}