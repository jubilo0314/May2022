using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class ParamPassing
    {
        public void PassingByValue(int a, int b)
        {
            a = 80;
            b = 20;
            Console.WriteLine($"inside passing by value method: a = {a}, b = {b}");
        }

        public void PassingByReference(ref int a, ref int b)
        {
            a = 80;
            b = 20;
            Console.WriteLine($"inside passing by reference method: a = {a}, b = {b}");
        }

        public void AreaOfCircle(double radius, double pi = 3.14)
        {
            Console.WriteLine($"Area of circle = {pi * radius * radius}");
        }

        public bool IsAuthentic(string uname, string password, out string msg)
        {
            msg = "";
            if (uname == "rebecca" && password == "liu")
            {
                msg = "You have sucessfully verified";
                return true;
            } 
            if (uname != "rebecca")
            {
                msg = "incorrect username";
            } else if(password != "liu")
            {
                msg = "incoorect password";
            }
            return false;
        }
        [Obsolete("User AddNubmers(params int[] arr) instead", true)]
        public int AddTwoNumbers(int a, int b)
        {
            return a + b;
        }
        [Obsolete]
        public int AddThreeNumbers(int a, int b, int c)
        {
            return a + b  + c;
        }

        public int AddNumbers(params int[] arr)
        {
            int length = arr.Length;
            int sum = 0;
            for (int i = 0; i < length; i++)
            {
                sum = sum + arr[i];
            }
            return sum;
        }

    }
}
