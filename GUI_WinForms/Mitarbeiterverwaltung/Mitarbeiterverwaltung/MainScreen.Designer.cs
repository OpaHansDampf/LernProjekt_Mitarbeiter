namespace Mitarbeiterverwaltung
{
    partial class MainScreen
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dgvMitarbeiter = new System.Windows.Forms.DataGridView();
            this.txt_vorname = new System.Windows.Forms.TextBox();
            this.txt_nachname = new System.Windows.Forms.TextBox();
            this.cb_geschlecht = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.btn_newMitarbeiter = new System.Windows.Forms.Button();
            this.btn_changeMitarbeiter = new System.Windows.Forms.Button();
            this.btn_delMitarbeiter = new System.Windows.Forms.Button();
            this.btn_clear = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMitarbeiter)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvMitarbeiter
            // 
            this.dgvMitarbeiter.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMitarbeiter.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgvMitarbeiter.Location = new System.Drawing.Point(0, 196);
            this.dgvMitarbeiter.MultiSelect = false;
            this.dgvMitarbeiter.Name = "dgvMitarbeiter";
            this.dgvMitarbeiter.ReadOnly = true;
            this.dgvMitarbeiter.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMitarbeiter.Size = new System.Drawing.Size(800, 258);
            this.dgvMitarbeiter.TabIndex = 0;
            this.dgvMitarbeiter.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMitarbeiter_CellContentClick);
            // 
            // txt_vorname
            // 
            this.txt_vorname.Location = new System.Drawing.Point(73, 18);
            this.txt_vorname.Name = "txt_vorname";
            this.txt_vorname.Size = new System.Drawing.Size(178, 20);
            this.txt_vorname.TabIndex = 1;
            // 
            // txt_nachname
            // 
            this.txt_nachname.Location = new System.Drawing.Point(73, 44);
            this.txt_nachname.Name = "txt_nachname";
            this.txt_nachname.Size = new System.Drawing.Size(178, 20);
            this.txt_nachname.TabIndex = 2;
            // 
            // cb_geschlecht
            // 
            this.cb_geschlecht.FormattingEnabled = true;
            this.cb_geschlecht.Location = new System.Drawing.Point(73, 70);
            this.cb_geschlecht.Name = "cb_geschlecht";
            this.cb_geschlecht.Size = new System.Drawing.Size(177, 21);
            this.cb_geschlecht.TabIndex = 3;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(8, 25);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Vorname";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(8, 51);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(59, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Nachname";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(8, 78);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(61, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "Geschlecht";
            // 
            // btn_newMitarbeiter
            // 
            this.btn_newMitarbeiter.Location = new System.Drawing.Point(39, 157);
            this.btn_newMitarbeiter.Name = "btn_newMitarbeiter";
            this.btn_newMitarbeiter.Size = new System.Drawing.Size(142, 27);
            this.btn_newMitarbeiter.TabIndex = 7;
            this.btn_newMitarbeiter.Text = "speichern";
            this.btn_newMitarbeiter.UseVisualStyleBackColor = true;
            this.btn_newMitarbeiter.Click += new System.EventHandler(this.btn_newMitarbeiter_Click);
            // 
            // btn_changeMitarbeiter
            // 
            this.btn_changeMitarbeiter.Location = new System.Drawing.Point(187, 157);
            this.btn_changeMitarbeiter.Name = "btn_changeMitarbeiter";
            this.btn_changeMitarbeiter.Size = new System.Drawing.Size(142, 27);
            this.btn_changeMitarbeiter.TabIndex = 8;
            this.btn_changeMitarbeiter.Text = "bearbeiten";
            this.btn_changeMitarbeiter.UseVisualStyleBackColor = true;
            this.btn_changeMitarbeiter.Click += new System.EventHandler(this.btn_changeMitarbeiter_Click);
            // 
            // btn_delMitarbeiter
            // 
            this.btn_delMitarbeiter.Location = new System.Drawing.Point(335, 157);
            this.btn_delMitarbeiter.Name = "btn_delMitarbeiter";
            this.btn_delMitarbeiter.Size = new System.Drawing.Size(142, 27);
            this.btn_delMitarbeiter.TabIndex = 9;
            this.btn_delMitarbeiter.Text = "löschen";
            this.btn_delMitarbeiter.UseVisualStyleBackColor = true;
            this.btn_delMitarbeiter.Click += new System.EventHandler(this.btn_delMitarbeiter_Click);
            // 
            // btn_clear
            // 
            this.btn_clear.Location = new System.Drawing.Point(483, 157);
            this.btn_clear.Name = "btn_clear";
            this.btn_clear.Size = new System.Drawing.Size(142, 27);
            this.btn_clear.TabIndex = 10;
            this.btn_clear.Text = "Felder leeren";
            this.btn_clear.UseVisualStyleBackColor = true;
            this.btn_clear.Click += new System.EventHandler(this.btn_clear_Click);
            // 
            // MainScreen
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 454);
            this.Controls.Add(this.btn_clear);
            this.Controls.Add(this.btn_delMitarbeiter);
            this.Controls.Add(this.btn_changeMitarbeiter);
            this.Controls.Add(this.btn_newMitarbeiter);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cb_geschlecht);
            this.Controls.Add(this.txt_nachname);
            this.Controls.Add(this.txt_vorname);
            this.Controls.Add(this.dgvMitarbeiter);
            this.Name = "MainScreen";
            this.Text = "Hauptfenster";
            this.Load += new System.EventHandler(this.MainScreen_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMitarbeiter)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvMitarbeiter;
        private System.Windows.Forms.TextBox txt_vorname;
        private System.Windows.Forms.TextBox txt_nachname;
        private System.Windows.Forms.ComboBox cb_geschlecht;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btn_newMitarbeiter;
        private System.Windows.Forms.Button btn_changeMitarbeiter;
        private System.Windows.Forms.Button btn_delMitarbeiter;
        private System.Windows.Forms.Button btn_clear;
    }
}