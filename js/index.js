$(document).ready(function () {
    $(".item").on("click", function () {
        switch (this.id) {
            case "saps":
                window.open("https://sapsnkra.moe.gov.my/");
                break;
            case "apdm":
                window.open("https://apdm.moe.gov.my/");
                break;
            case "splkpm":
                window.open("https://splkpm.moe.gov.my/i_splg/");
                break;
            case "egtukar":
                window.open("https://epgo.moe.gov.my/");
                break;
            case "eoperasi":
                window.open("https://eoperasi.moe.gov.my/");
                break;
            case "efiling":
                window.open("https://ez.hasil.gov.my/CI/");
                break;
            case "emis":
                window.open("https://emisonline.moe.gov.my/");
                break;
            case "sps":
                window.open("https://public.moe.gov.my/");
                break;
            case "ssdm":
                window.open("https://ssdm.moe.gov.my/");
                break;
            case "sso":
                window.open("https://sps1.moe.gov.my/indexsso.php");
                break;
            case "anm":
                window.open("https://epenyatagaji-laporan.anm.gov.my/Layouts/Login/Login.aspx");
                break;
            case "kpm":
                window.open("https://www.moe.gov.my/");
                break;
            case "epangkat":
                window.open("https://epangkat.moe.gov.my/login.php");
                break;
            case "esarana":
                window.open("https://sarana.moe.gov.my/index.php");
                break;
            case "espbt":
                window.open("https://espbt.moe.gov.my/");
                break;
            case "eprestasi":
                window.open("https://eprestasi.moe.gov.my/index.cfm");
                break;
            case "sepkm":
                window.open("https://sepkm.com/e/login/");
                break;
            case "sppat":
                window.open("http://lp.moe.gov.my/");
                break;
            case "smpk":
                window.open("https://smpk.moe.gov.my/");
                break;
            case "bpk":
                window.open("http://bpk.moe.gov.my/");
                break;
            case "bph":
                window.open("https://www.bph.gov.my/portal/en/");
                break;
            case "pajsk":
                window.open("https://pajsk.moe.gov.my/index.php");
                break;
            case "hrmis2":
                window.open("https://hrmis2.eghrmis.gov.my/HRMISNET/Common/Main/Login.aspx");
                break;
            case "sapsib":
                window.open("https://sapsnkra.moe.gov.my/ibubapa2/index.php");
                break;
            case "qrscan":
                try {
                    webkit.messageHandlers.iOS.postMessage(`qrScanner|true`);
                } catch (e) {
                    Android.initQRScanner();
                }
                break;
            default:
                console.log("none");
        }
    });
});