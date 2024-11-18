using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace GUI_MitarbeiterVerwaltung_test
{
    internal static class Program
    {
        /// <summary>
        /// Der Haupteinstiegspunkt für die Anwendung.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainScreen());
        }
    }
}


//In Windows Forms gibt es neben der MessageBox noch mehrere Möglichkeiten, um Benutzer-Feedback anzuzeigen:

//1.NotifyIcon(Taskleisten - Benachrichtigung)
//- Zeigt eine Benachrichtigung in der Windows-Taskleiste an
//- Gut für nicht-störende Hinweise
//```csharp
//NotifyIcon notifyIcon = new NotifyIcon();
//notifyIcon.Icon = SystemIcons.Information;
//notifyIcon.Visible = true;
//notifyIcon.ShowBalloonTip(3000, "Erfolg", "Datei wurde gespeichert", ToolTipIcon.Info);
//```

//2.StatusStrip(Statusleiste)
//- Eine Leiste am unteren Fensterrand
//- Gut für temporäre Statusmeldungen
//```csharp
//statusLabel.Text = "Speichern erfolgreich";
//// Optional mit Timer zurücksetzen
//Timer timer = new Timer();
//timer.Interval = 3000;
//timer.Tick += (s, e) => { statusLabel.Text = ""; timer.Stop(); };
//timer.Start();
//```

//3.ToolTip
//- Schwebendes Informationsfenster
//- Gut für kontextbezogene Hilfe
//```csharp
//ToolTip toolTip = new ToolTip();
//toolTip.Show("Erfolgreich gespeichert!", button1, 0, -20, 2000);
//```

//4.Label mit Animation
//- Ein Label, das kurz erscheint und wieder verschwindet
//```csharp
//Label successLabel = new Label();
//successLabel.Text = "✓ Gespeichert";
//successLabel.ForeColor = Color.Green;
//// Mit Timer ausblenden
//```

//5.Eigenes Feedback - Panel
//```csharp
//Panel feedbackPanel = new Panel();
//feedbackPanel.BackColor = Color.LightGreen;
//feedbackPanel.Height = 40;
//Label feedbackLabel = new Label();
//feedbackLabel.Text = "Operation erfolgreich!";
//feedbackPanel.Controls.Add(feedbackLabel);
//// Panel nach einigen Sekunden ausblenden
//```

//6.Modern aussehende Toast-Benachrichtigung (benutzerdefiniert)
//```csharp
//public class ToastForm : Form
//{
//    public ToastForm(string message)
//    {
//        this.FormBorderStyle = FormBorderStyle.None;
//        this.BackColor = Color.FromArgb(60, 179, 113);
//        this.Size = new Size(200, 40);
//        this.StartPosition = FormStartPosition.Manual;

//        Label label = new Label();
//        label.Text = message;
//        label.ForeColor = Color.White;
//        label.Dock = DockStyle.Fill;
//        label.TextAlign = ContentAlignment.MiddleCenter;
//        this.Controls.Add(label);

//        // Position unten rechts
//        Rectangle workingArea = Screen.GetWorkingArea(this);
//        this.Location = new Point(workingArea.Right - Size.Width - 10,
//                                workingArea.Bottom - Size.Height - 10);

//        // Timer zum Ausblenden
//        Timer timer = new Timer();
//        timer.Interval = 3000;
//        timer.Tick += (s, e) => { this.Close(); };
//        timer.Start();
//    }
//}

//// Verwendung:
//new ToastForm("Erfolgreich gespeichert!").Show();
//```

//Welche Methode am besten passt, hängt von deinem spezifischen Anwendungsfall ab:
//-MessageBox: Für wichtige Meldungen, die eine Benutzerinteraktion erfordern
//- NotifyIcon: Für Hintergrund-Benachrichtigungen
//- StatusStrip: Für temporäre Statusanzeigen
//- Toast: Für moderne, nicht-störende Benachrichtigungen
//- Labels/Panels: Für in-App Feedback direkt im UI

//Möchtest du für deinen speziellen Anwendungsfall wissen, welche Option am besten passen würde?
