using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Captcha : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string[] strArray = new string[36];
        strArray = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

        Random autoRand = new Random();
        string strCaptcha = string.Empty;
        for (int i = 0; i < 6; i++)
        {
            int j = Convert.ToInt32(autoRand.Next(0, 62));
            strCaptcha += strArray[j].ToString();
        }
        Session["Captcha"] = strCaptcha;
        ImageConverter converter = new ImageConverter();
        Response.BinaryWrite((byte[])converter.ConvertTo(CaptchaGeneration(strCaptcha), typeof(byte[])));
    }
    public Bitmap CaptchaGeneration(string captchatxt)
    {
        Bitmap bmp = new Bitmap(133, 48);
        using (Graphics graphics = Graphics.FromImage(bmp))
        {
            Font font = new Font("Tahoma", 14);
            graphics.FillRectangle(new SolidBrush(Color.Gray), 0, 0, bmp.Width, bmp.Height);
            graphics.DrawString(captchatxt, font, new SolidBrush(Color.Gold), 25, 10);
            graphics.Flush();
            font.Dispose();
            graphics.Dispose();
        }
        return bmp;
    }
}