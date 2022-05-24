using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class Customer
    {
        //full version of property: private data field + get and set methods
        private string name; //private data field
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        //augo-generated property
        //public string Name { get; set; }

        //public string name;

        private int id;
        public int Id
        {
            get
            {
                return id;
            }
            private set
            {
                id = value;
            }
        }

        public string Email { get; set; }
        public string Phone { get; set; }

        public Customer(int id, string name, string email)
        {
            Id = id;
            Name = name;
            Email = email;
        }


        public Customer(int id, string name, string email, string phone)
        {
            Id =id;
            Name = name;
            Phone = phone;
            Email = email;
        }

    }
}
