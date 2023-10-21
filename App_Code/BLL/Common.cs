using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

/// <summary>
/// Summary description for Common
/// </summary>
public class Common
{
   
    public void ScriptMsg(string str, Page webpageinstance)
    {

        string strScript = string.Format("<script language=JavaScript runat=server> window.alert('{0}')</script>", str);
        if (!webpageinstance.ClientScript.IsStartupScriptRegistered("clientScript"))
        {
            webpageinstance.ClientScript.RegisterStartupScript(typeof(Page), "clientScript", strScript);
        }
    }

    public void ScriptMsgForAjax(string str, Page webpageinstance)
    {
        string strScript = string.Format("window.alert('{0}');", str);
        ScriptManager.RegisterStartupScript(webpageinstance, this.GetType(), "clientScript", strScript, true);
    }
    public static string Encrypt(string encryptText)
    {
        const string EncryptionKey = "ShaT2S@DeL#85270ItDOsE$";
        byte[] clearBytes = Encoding.Unicode.GetBytes(encryptText.Replace("+",""));
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                }
                encryptText = Convert.ToBase64String(ms.ToArray());
            }
        }
        return encryptText;
    }
    public static string Decrypt(string decryptText)
    {
        const string EncryptionKey = "ShaT2S@DeL#85270ItDOsE$";
		
        byte[] cipherBytes = Convert.FromBase64String(decryptText.Replace(" ","+"));
	   
	  
	   
	   
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                decryptText = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
        return decryptText;
    }

    public  static List<T> ConvertDataTable<T>(DataTable dt)
    {
        List<T> data = new List<T>();
        foreach (DataRow row in dt.Rows)
        {
            T item = GetItem<T>(row);
            data.Add(item);
        }
        return data;
    }
    private static T GetItem<T>(DataRow dr)
    {
        Type temp = typeof(T);
        T obj = Activator.CreateInstance<T>();

        foreach (DataColumn column in dr.Table.Columns)
        {
            foreach (PropertyInfo pro in temp.GetProperties())
            {
                if (pro.Name == column.ColumnName)
                    pro.SetValue(obj, dr[column.ColumnName], null);
                else
                    continue;
            }
        }
        return obj;
    }
    public static string EncryptRijndael(string encryptText)
    {
        var aesAlg = RijndaelManaged();
        var encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
        using (var msEncrypt = new MemoryStream())
        {
            using (var csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
            using (var swEncrypt = new StreamWriter(csEncrypt))
            {
                swEncrypt.Write(encryptText);
            }
            return Convert.ToBase64String(msEncrypt.ToArray());
        }
    }
    public static string DecryptRijndael(string decryptText)
    {
        string text;
        var aesAlg = RijndaelManaged();
        var decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
        var cipher = Convert.FromBase64String(decryptText);
        using (var msDecrypt = new MemoryStream(cipher))
        {
            using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
            {
                using (var srDecrypt = new StreamReader(csDecrypt))
                {
                    text = srDecrypt.ReadToEnd();
                }
            }
        }
        return text;
    }
    public static RijndaelManaged RijndaelManaged()
    {
        var saltBytes = Encoding.ASCII.GetBytes("Shat05#206$0I!@");
        var key = new Rfc2898DeriveBytes("SHAtRu0gh-202$-4@F0-A@E#-897f!&!TdOSe", saltBytes);
        var aesAlg = new RijndaelManaged();
        aesAlg.Mode = CipherMode.ECB;
        aesAlg.Padding = PaddingMode.PKCS7;
        aesAlg.KeySize = 0x80;
        aesAlg.BlockSize = 0x80;
        aesAlg.Key = key.GetBytes(aesAlg.KeySize / 8);
        aesAlg.IV = key.GetBytes(aesAlg.BlockSize / 8);
        return aesAlg;
    }
}