using System;

namespace Entities
{
  public class User {
    public long id{get;set;}
    public string username{get;set;}
    public string passwordHash{get;set;}
    public string displayName{get;set;}
    public string role{get;set;}
    public bool isActive{get;set;}
    public DateTime? lastLoginAt{get;set;}
    public DateTime createdAt{get;set;}
    public DateTime? updatedAt{get;set;}
  }
}