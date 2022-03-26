$(document).ready(function () {
    $(".item").on("click", function () {
        switch (this.id) {
            case "saps":
                location.href = "https://sapsnkra.moe.gov.my/";
                break;
            case "apdm":
                location.href = "https://apdm.moe.gov.my/";
                break;
            case "splkpm":
                location.href = "https://splkpm.moe.gov.my/i_splg/";
                break;
            case "egtukar":
                location.href = "https://epgo.moe.gov.my/";
                break;
            case "eoperasi":
                location.href = "https://eoperasi.moe.gov.my/";
                break;
            case "efiling":
                location.href = "https://ez.hasil.gov.my/CI/";
                break;
            case "emis":
                location.href = "https://emisonline.moe.gov.my/";
                break;
            case "sps":
                location.href = "https://public.moe.gov.my/";
                break;
            case "ssdm":
                location.href = "https://ssdm.moe.gov.my/";
                break;
            case "sso":
                location.href = "https://sps1.moe.gov.my/indexsso.php";
                break;
            case "anm":
                location.href = "https://epenyatagaji-laporan.anm.gov.my/Layouts/Login/Login.aspx";
                break;
            case "kpm":
                location.href = "https://www.moe.gov.my/";
                break;
            case "epangkat":
                location.href = "https://epangkat.moe.gov.my/login.php";
                break;
            case "esarana":
                location.href = "https://sarana.moe.gov.my/index.php";
                break;
            case "espbt":
                location.href = "https://espbt.moe.gov.my/";
                break;
            case "eprestasi":
                location.href = "https://eprestasi.moe.gov.my/index.cfm";
                break;
            case "sepkm":
                location.href = "https://sepkm.com/e/login/";
                break;
            case "sppat":
                location.href = "http://lp.moe.gov.my/";
                break;
            case "smpk":
                location.href = "https://smpk.moe.gov.my/";
                break;
            case "bpk":
                location.href = "http://bpk.moe.gov.my/";
                break;
            case "bph":
                location.href = "https://www.bph.gov.my/portal/en/";
                break;
            case "pajsk":
                location.href = "https://pajsk.moe.gov.my/index.php";
                break;
            case "hrmis2":
                location.href = "https://hrmis2.eghrmis.gov.my/HRMISNET/Common/Main/Login.aspx";
                break;
            case "sapsib":
                location.href = "https://sapsnkra.moe.gov.my/ibubapa2/index.php";
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
