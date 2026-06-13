using System;
using System.Collections.Generic;
using System.Web;

namespace Helpers
{
    public class TokenInfo
    {
        public long UserId { get; set; }
        public string Role { get; set; }
        public string DisplayName { get; set; }
        public DateTime ExpiresAt { get; set; }
    }

    public class TokenHelper
    {
        private const int TokenExpireMinutes = 30;

        public static string GenerateToken()
        {
            return Guid.NewGuid().ToString("N");
        }

        public static void StoreToken(string token, long userId, string role, string displayName)
        {
            var info = new TokenInfo
            {
                UserId = userId,
                Role = role,
                DisplayName = displayName,
                ExpiresAt = DateTime.Now.AddMinutes(TokenExpireMinutes)
            };

            var app = HttpContext.Current.Application;
            app.Lock();
            app["Token_" + token] = info;

            var activeTokens = app["ActiveTokens"] as List<string>;
            if (activeTokens == null)
            {
                activeTokens = new List<string>();
                app["ActiveTokens"] = activeTokens;
            }
            if (!activeTokens.Contains(token))
                activeTokens.Add(token);
            app.UnLock();

            HttpContext.Current.Session["AuthToken"] = token;

            var cookie = new HttpCookie("AuthToken", token)
            {
                HttpOnly = true,
                Expires = DateTime.Now.AddMinutes(TokenExpireMinutes)
            };
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static TokenInfo ValidateToken(string token)
        {
            if (string.IsNullOrEmpty(token))
                return null;

            var app = HttpContext.Current.Application;
            app.Lock();
            var info = app["Token_" + token] as TokenInfo;
            app.UnLock();

            if (info == null)
                return null;

            if (DateTime.Now > info.ExpiresAt)
            {
                RemoveToken(token);
                return null;
            }

            return info;
        }

        public static void RemoveToken(string token)
        {
            var app = HttpContext.Current.Application;
            var session = HttpContext.Current.Session;
            app.Lock();
            app.Remove("Token_" + token);
            var activeTokens = app["ActiveTokens"] as List<string>;
            if (activeTokens != null)
                activeTokens.Remove(token);
            app.UnLock();

            if (session != null)
                session.Remove("AuthToken");

            var ctx = HttpContext.Current;
            if (ctx.Request.Cookies["AuthToken"] != null)
            {
                var cookie = new HttpCookie("AuthToken") { Expires = DateTime.Now.AddDays(-1) };
                ctx.Response.Cookies.Add(cookie);
            }
        }

        public static void RemoveExpiredTokens()
        {
            var app = HttpContext.Current.Application;
            app.Lock();
            var activeTokens = app["ActiveTokens"] as List<string>;
            if (activeTokens != null)
            {
                var expired = new List<string>();
                foreach (var token in activeTokens)
                {
                    var info = app["Token_" + token] as TokenInfo;
                    if (info == null || DateTime.Now > info.ExpiresAt)
                    {
                        app.Remove("Token_" + token);
                        expired.Add(token);
                    }
                }
                foreach (var t in expired)
                    activeTokens.Remove(t);
            }
            app.UnLock();
        }
    }
}
