using System;
using System.Security.Cryptography;
using System.Text;

namespace Helpers
{
    public class HashHelper
    {
        private const int SaltSize = 16;

        public static string HashPassword(string password)
        {
            var salt = GenerateSalt();
            var hash = ComputeSha256(password, salt);
            return $"{salt}.{hash}";
        }

        public static bool VerifyPassword(string password, string storedHash)
        {
            var parts = storedHash.Split('.');
            if (parts.Length != 2) return false;
            var salt = parts[0];
            var hash = parts[1];
            return ComputeSha256(password, salt) == hash;
        }

        private static string GenerateSalt()
        {
            var bytes = new byte[SaltSize];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(bytes);
            }
            return BitConverter.ToString(bytes).Replace("-", "").ToLower();
        }

        private static string ComputeSha256(string input, string salt)
        {
            var salted = input + salt;
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(salted));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }
    }
}
