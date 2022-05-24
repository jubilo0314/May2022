using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public abstract class Employee
    {
        public Employee()
        {

        }
        public int Id { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Address { get; set; }

        public abstract void PerformWork();
        public virtual void VirtualMethodDemo()
        {
            Console.WriteLine("This is a virtual method");
        }
    }

    public class FullTimeEmployee : Employee
    {
        public decimal BiweeklyPay { get; set; }
        public string Benefits { get; set; }
        public FullTimeEmployee()
        {

        }
        public override void PerformWork()
        {
            Console.WriteLine("Full time employees works 40 hrs a week");
        }
        public override void VirtualMethodDemo()
        {
            Console.WriteLine("I want to override the virutal method in full time employee class");
        }
    }

    public sealed class PartTimeEmployee : Employee
    {
        public decimal HourlyPay { get; set; }
        public override void PerformWork()
        {
            Console.WriteLine("Part time employees work 20 hrs a week");
        }
    }

    //public class Test : PartTimeEmployee
    //{

    //}

    public class Manager : FullTimeEmployee
    {
        public decimal ExtraBonus { get; set; }
        public void AttendMeeting()
        {
            Console.WriteLine("Managers has to attend meetings");
        }
    }
}
