using System.Web;

namespace Helpers
{
    public class AuthHelper
    {
        public static bool IsLogin()
        {
            if (HttpContext.Current.Session["UserId"] != null)
                return true;

            return TryTokenLogin();
        }

        private static bool TryTokenLogin()
        {
            var sessionToken = HttpContext.Current.Session["AuthToken"] as string;
            if (string.IsNullOrEmpty(sessionToken))
            {
                var cookie = HttpContext.Current.Request.Cookies["AuthToken"];
                if (cookie != null)
                    sessionToken = cookie.Value;
            }

            if (string.IsNullOrEmpty(sessionToken))
                return false;

            var info = TokenHelper.ValidateToken(sessionToken);
            if (info == null)
            {
                HttpContext.Current.Session.Remove("AuthToken");
                return false;
            }

            HttpContext.Current.Session["UserId"] = info.UserId;
            HttpContext.Current.Session["Role"] = info.Role;
            HttpContext.Current.Session["DisplayName"] = info.DisplayName;
            return true;
        }

        public static long GetUserId()
        {
            return (long)HttpContext.Current.Session["UserId"];
        }

        public static string GetRole()
        {
            var role = HttpContext.Current.Session["Role"];
            return role != null ? role.ToString() : "";
        }

        public static string GetDisplayName()
        {
            var name = HttpContext.Current.Session["DisplayName"];
            return name != null ? name.ToString() : "";
        }

        public static bool IsAdmin() { return GetRole() == "管理员"; }
        public static bool IsManager() { return GetRole() == "店长"; }
        public static bool IsStaff() { return GetRole() == "操作员"; }
        public static bool CanSeeDeleted() { return IsAdmin(); }

        public static void SetLogin(long userId, string role, string displayName)
        {
            HttpContext.Current.Session["UserId"] = userId;
            HttpContext.Current.Session["Role"] = role;
            HttpContext.Current.Session["DisplayName"] = displayName;

            var token = TokenHelper.GenerateToken();
            TokenHelper.StoreToken(token, userId, role, displayName);
        }

        public static void Logout()
        {
            var token = HttpContext.Current.Session["AuthToken"] as string;
            if (!string.IsNullOrEmpty(token))
                TokenHelper.RemoveToken(token);

            HttpContext.Current.Session.Clear();
            HttpContext.Current.Session.Abandon();
        }

        public static void RequireLogin()
        {
            if (!IsLogin())
            {
                HttpContext.Current.Response.Redirect("~/Views/Login.aspx");
            }
        }

        public static void RequireRole(string allowedRoles)
        {
            RequireLogin();
            if (!allowedRoles.Contains(GetRole()))
            {
                HttpContext.Current.Response.Redirect("Default.aspx");
            }
        }
    }
}
