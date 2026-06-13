<%@ Application Language="C#" %>
<%@ Import Namespace="Helpers" %>

<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
    }

    void Application_BeginRequest(object sender, EventArgs e)
    {
        // 每 10 次请求清理一次过期 Token
        var count = Application["ReqCount"] as int? ?? 0;
        count++;
        if (count >= 10)
        {
            TokenHelper.RemoveExpiredTokens();
            Application["ReqCount"] = 0;
        }
        else
        {
            Application["ReqCount"] = count;
        }
    }
</script>
