using System.Web.Optimization;

namespace Bundle
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
             bundles.Add(new ScriptBundle("~/bundles/WebFormsJs").Include(
                  "~/Scripts/jquery-3.1.1.min.js",
                  "~/Scripts/jquery-ui.js",                   
                    "~/Scripts/shortcut.js",
                    "~/Scripts/jquery.slimscroll.min.js",
                    "~/Scripts/MarcTooltips.js",
                    "~/Scripts/toastr.min.js",
                    "~/Scripts/Common.js",
                    "~/Scripts/chosen.jquery.js",
                    "~/Scripts/Master-Js/Master.js",                    
                    "~/Scripts/select2.min.js",
                     "~/Scripts/class2context.js",
                    "~/Scripts/PostReportScript.js",
                    "~/Scripts/jquery.alphanum.js",
                    "~/Scripts/SignalR/jquery.signalR-2.4.1.min.js",
                    "~/signalr/hubs"));

            bundles.Add(new ScriptBundle("~/bundles/MsAjaxJs").Include(
                  "~/Scripts/jquery.extensions.js"));

             bundles.Add(new ScriptBundle("~/bundles/handsontable").Include(
                  "~/Scripts/handsontable/handsontable.full.min.js"));


             bundles.Add(new ScriptBundle("~/bundles/JQueryStore").Include(
                 "~/Scripts/jquery.multiple.select.js",
                 "~/Scripts/fancybox/jquery.fancybox.pack.js"));

         
            bundles.Add(new ScriptBundle("~/bundles/ResultEntry").Include(
               "~/Scripts/Jcrop-Master/js/jquery.Jcrop.min.js",
               "~/Scripts/uploadify/jquery.uploadify.js",
               "~/Scripts/fancybox/jquery.fancybox.pack.js",
               "~/Scripts/ResultEntryJS.js"));
 
             bundles.Add(new ScriptBundle("~/bundles/PostReportScript").Include(
                "~/Scripts/PostReportScript.js"));

             bundles.Add(new ScriptBundle("~/bundles/confirmMinJS").Include(
                  "~/Scripts/jquery-confirm.min.js"));


             bundles.Add(new ScriptBundle("~/bundles/JQueryUIJs").Include(
             "~/Scripts/jquery-ui.js"));

             bundles.Add(new ScriptBundle("~/bundles/Chosen").Include(
                           "~/Scripts/chosen.jquery.js"));
             bundles.Add(new ScriptBundle("~/bundles/FormsJs").Include(
                  "~/Scripts/jquery-3.1.1.min.js"));
        }
    }
}