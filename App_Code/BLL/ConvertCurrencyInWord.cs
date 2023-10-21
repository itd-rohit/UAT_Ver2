using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

/// <summary>
/// Summary description for ConvertCurrencyInWord
/// </summary>
public static class ConvertCurrencyInWord
{
	

    public static string AmountInWord(decimal number, string Currency)
    {
        string word = string.Empty;
        CultureInfo  culInfo = new CultureInfo("en-US");
        
        
        int num1 = Convert.ToInt32(Convert.ToString(number, culInfo.NumberFormat).Split('.')[0]);

        int num2 = 0;
        if (number.ToString().Split('.').Length > 1)
        {
            num2 = Convert.ToInt32(number.ToString().Split('.')[1]);
        }

        string rupee = NumberToWords(num1);
        string paisa = string.Empty;
        if (num2 > 0)
        {
            paisa = NumberToWords(num2);
        }
        if (Currency == "USD")
        {
            word = rupee + " dollars";
            if (paisa.Length > 0)
            {
                word += string.Format(" and {0} cent", paisa);
            }
        }
        else if (Currency == "GHC" || Currency == "CEDI")
        {
            word = rupee + " cedi";
            if (paisa.Length > 0)
            {
                word += string.Format(" and {0} pesewas", paisa);
            }
        }
        else if (Currency == "EUR")
        {
            word = rupee + " pounds";
            if (paisa.Length > 0)
            {
                word += string.Format(" and {0} pence", paisa);
            }
        }
        else if (Currency == "Ringgit" || Currency=="MYR")
        {
            word = rupee + " Ringgit";
            if (paisa.Length > 0)
            {
                word += string.Format(" and {0} cent", paisa);
            }
        }
        else if (Currency == "INR" || Currency == "Rupee")
        {
            //Seprate Function use for INR
            word = ChangeNumericToWords(Convert.ToString(Math.Round(number, 0)));
        }
        return word;
    }
    public static string NumberToWords(int number)
    {
        if (number == 0)
            return "zero";

        if (number < 0)
            return "minus " + NumberToWords(Math.Abs(number));

        string words = "";

        if ((number / 1000000) > 0)
        {
            words += NumberToWords(number / 1000000) + " million ";
            number %= 1000000;
        }

        if ((number / 1000) > 0)
        {
            words += NumberToWords(number / 1000) + " thousand ";
            number %= 1000;
        }

        if ((number / 100) > 0)
        {
            words += NumberToWords(number / 100) + " hundred ";
            number %= 100;
        }

        if (number > 0)
        {
            if (words != "")
                words += "and ";

            var unitsMap = new[] { "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
            var tensMap = new[] { "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

            if (number < 20)
                words += unitsMap[number];
            else
            {
                words += tensMap[number / 10];
                if ((number % 10) > 0)
                    words += "-" + unitsMap[number % 10];
            }
        }

        return words;
    }
    public static string ChangeNumericToWords(string Amount)
    {
        decimal temp = Convert.ToDecimal(Amount);
        int number = Convert.ToInt32(Math.Round(temp));
        if (number == 0) return "Zero";
        if (number == -2147483648) return "Minus Two Hundred and Fourteen Crore Seventy Four Lakh Eighty Three Thousand Six Hundred and Forty Eight";
        int[] num = new int[4];
        int first = 0;
        int u, h, t;
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        if (number < 0)
        {
            sb.Append("Minus ");
            number = -number;
        }
        string[] words0 = {"" ,"One ", "Two ", "Three ", "Four ",
	"Five " ,"Six ", "Seven ", "Eight ", "Nine "};
        string[] words1 = {"Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ",
	"Fifteen ","Sixteen ","Seventeen ","Eighteen ", "Nineteen "};
        string[] words2 = {"Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ",
	"Seventy ","Eighty ", "Ninety "};
        string[] words3 = { "Thousand ", "Lakh ", "Crore " };
        num[0] = number % 1000; // units
        num[1] = number / 1000;
        num[2] = number / 100000;
        num[1] = num[1] - 100 * num[2]; // thousands
        num[3] = number / 10000000; // crores
        num[2] = num[2] - 100 * num[3]; // lakhs
        for (int i = 3; i > 0; i--)
        {
            if (num[i] != 0)
            {
                first = i;
                break;
            }
        }
        for (int i = first; i >= 0; i--)
        {
            if (num[i] == 0) continue;
            u = num[i] % 10; // ones
            t = num[i] / 10;
            h = num[i] / 100; // hundreds
            t = t - 10 * h; // tens
            if (h > 0) sb.Append(words0[h] + "Hundred ");
            if (u > 0 || t > 0)
            {
                if (h > 0 || i == 0) sb.Append("and ");
                if (t == 0)
                    sb.Append(words0[u]);
                else if (t == 1)
                    sb.Append(words1[u]);
                else
                    sb.Append(words2[t - 2] + words0[u]);
            }
            if (i != 0) sb.Append(words3[i - 1]);
        }
        if (number.ToString().Length < 3)
        {
            sb = sb.Replace("and", "");
        }
        return sb.ToString().TrimEnd();
    }
}