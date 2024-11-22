namespace GUI_MitarbeiterVerwaltung_test
{
    partial class MainScreen
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            this.lbl_Vorname = new System.Windows.Forms.Label();
            this.lbl_Nachname = new System.Windows.Forms.Label();
            this.lbl_Geschlecht = new System.Windows.Forms.Label();
            this.txt_Vorname = new System.Windows.Forms.TextBox();
            this.txt_Nachname = new System.Windows.Forms.TextBox();
            this.cb_Geschlecht = new System.Windows.Forms.ComboBox();
            this.dg_Mitarbeiter = new System.Windows.Forms.DataGridView();
            this.btn_Save = new System.Windows.Forms.Button();
            this.btn_Change = new System.Windows.Forms.Button();
            this.btn_Delete = new System.Windows.Forms.Button();
            this.btn_Clear = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dg_Mitarbeiter)).BeginInit();
            this.SuspendLayout();
            // 
            // lbl_Vorname
            // 
            this.lbl_Vorname.AutoSize = true;
            this.lbl_Vorname.Location = new System.Drawing.Point(43, 24);
            this.lbl_Vorname.Name = "lbl_Vorname";
            this.lbl_Vorname.Size = new System.Drawing.Size(49, 13);
            this.lbl_Vorname.TabIndex = 0;
            this.lbl_Vorname.Text = "Vorname";
            // 
            // lbl_Nachname
            // 
            this.lbl_Nachname.AutoSize = true;
            this.lbl_Nachname.Location = new System.Drawing.Point(43, 56);
            this.lbl_Nachname.Name = "lbl_Nachname";
            this.lbl_Nachname.Size = new System.Drawing.Size(59, 13);
            this.lbl_Nachname.TabIndex = 1;
            this.lbl_Nachname.Text = "Nachname";
            // 
            // lbl_Geschlecht
            // 
            this.lbl_Geschlecht.AutoSize = true;
            this.lbl_Geschlecht.Location = new System.Drawing.Point(43, 89);
            this.lbl_Geschlecht.Name = "lbl_Geschlecht";
            this.lbl_Geschlecht.Size = new System.Drawing.Size(61, 13);
            this.lbl_Geschlecht.TabIndex = 2;
            this.lbl_Geschlecht.Text = "Geschlecht";
            // 
            // txt_Vorname
            // 
            this.txt_Vorname.Location = new System.Drawing.Point(166, 24);
            this.txt_Vorname.Name = "txt_Vorname";
            this.txt_Vorname.Size = new System.Drawing.Size(161, 20);
            this.txt_Vorname.TabIndex = 3;
            this.txt_Vorname.TextChanged += new System.EventHandler(this.txt_Vorname_TextChanged);
            // 
            // txt_Nachname
            // 
            this.txt_Nachname.Location = new System.Drawing.Point(166, 56);
            this.txt_Nachname.Name = "txt_Nachname";
            this.txt_Nachname.Size = new System.Drawing.Size(161, 20);
            this.txt_Nachname.TabIndex = 4;
            this.txt_Nachname.TextChanged += new System.EventHandler(this.txt_Nachname_TextChanged);
            // 
            // cb_Geschlecht
            // 
            this.cb_Geschlecht.FormattingEnabled = true;
            this.cb_Geschlecht.Items.AddRange(new object[] {
            "weiblich",
            "männlich",
            "divers"});
            this.cb_Geschlecht.Location = new System.Drawing.Point(166, 89);
            this.cb_Geschlecht.Name = "cb_Geschlecht";
            this.cb_Geschlecht.Size = new System.Drawing.Size(161, 21);
            this.cb_Geschlecht.TabIndex = 5;
            this.cb_Geschlecht.SelectedIndexChanged += new System.EventHandler(this.cb_Geschlecht_SelectedIndexChanged);
            // 
            // dg_Mitarbeiter
            // 
            this.dg_Mitarbeiter.BackgroundColor = System.Drawing.SystemColors.ControlDark;
            this.dg_Mitarbeiter.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dg_Mitarbeiter.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dg_Mitarbeiter.Location = new System.Drawing.Point(0, 334);
            this.dg_Mitarbeiter.MultiSelect = false;
            this.dg_Mitarbeiter.Name = "dg_Mitarbeiter";
            this.dg_Mitarbeiter.ReadOnly = true;
            this.dg_Mitarbeiter.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dg_Mitarbeiter.Size = new System.Drawing.Size(1368, 518);
            this.dg_Mitarbeiter.TabIndex = 6;
            this.dg_Mitarbeiter.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dg_Mitarbeiter_CellContentClick);
            // 
            // btn_Save
            // 
            this.btn_Save.Location = new System.Drawing.Point(200, 222);
            this.btn_Save.Name = "btn_Save";
            this.btn_Save.Size = new System.Drawing.Size(75, 23);
            this.btn_Save.TabIndex = 7;
            this.btn_Save.Text = "speichern";
            this.btn_Save.UseVisualStyleBackColor = true;
            this.btn_Save.Click += new System.EventHandler(this.btn_Save_Click);
            // 
            // btn_Change
            // 
            this.btn_Change.Location = new System.Drawing.Point(378, 222);
            this.btn_Change.Name = "btn_Change";
            this.btn_Change.Size = new System.Drawing.Size(75, 23);
            this.btn_Change.TabIndex = 8;
            this.btn_Change.Text = "bearbeiten";
            this.btn_Change.UseVisualStyleBackColor = true;
            this.btn_Change.Click += new System.EventHandler(this.btn_Change_Click);
            // 
            // btn_Delete
            // 
            this.btn_Delete.Location = new System.Drawing.Point(563, 222);
            this.btn_Delete.Name = "btn_Delete";
            this.btn_Delete.Size = new System.Drawing.Size(75, 23);
            this.btn_Delete.TabIndex = 9;
            this.btn_Delete.Text = "löschen";
            this.btn_Delete.UseVisualStyleBackColor = true;
            this.btn_Delete.Click += new System.EventHandler(this.btn_Delete_Click);
            // 
            // btn_Clear
            // 
            this.btn_Clear.Location = new System.Drawing.Point(749, 222);
            this.btn_Clear.Name = "btn_Clear";
            this.btn_Clear.Size = new System.Drawing.Size(75, 23);
            this.btn_Clear.TabIndex = 10;
            this.btn_Clear.Text = "Felder leeren";
            this.btn_Clear.UseVisualStyleBackColor = true;
            this.btn_Clear.Click += new System.EventHandler(this.btn_Clear_Click);
            // 
            // MainScreen
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1368, 852);
            this.Controls.Add(this.btn_Clear);
            this.Controls.Add(this.btn_Delete);
            this.Controls.Add(this.btn_Change);
            this.Controls.Add(this.btn_Save);
            this.Controls.Add(this.dg_Mitarbeiter);
            this.Controls.Add(this.cb_Geschlecht);
            this.Controls.Add(this.txt_Nachname);
            this.Controls.Add(this.txt_Vorname);
            this.Controls.Add(this.lbl_Geschlecht);
            this.Controls.Add(this.lbl_Nachname);
            this.Controls.Add(this.lbl_Vorname);
            this.Name = "MainScreen";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.MainScreen_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dg_Mitarbeiter)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lbl_Vorname;
        private System.Windows.Forms.Label lbl_Nachname;
        private System.Windows.Forms.Label lbl_Geschlecht;
        private System.Windows.Forms.TextBox txt_Vorname;
        private System.Windows.Forms.TextBox txt_Nachname;
        private System.Windows.Forms.ComboBox cb_Geschlecht;
        private System.Windows.Forms.DataGridView dg_Mitarbeiter;
        private System.Windows.Forms.Button btn_Save;
        private System.Windows.Forms.Button btn_Change;
        private System.Windows.Forms.Button btn_Delete;
        private System.Windows.Forms.Button btn_Clear;
    }
}

