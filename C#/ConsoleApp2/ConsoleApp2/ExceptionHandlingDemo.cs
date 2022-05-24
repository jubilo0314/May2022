using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class ExceptionHandlingDemo
    {
        private int Divide(int number, int divisor)
        {
            return number / divisor;
        }

        public int Calculate(int num1, int num2, string operation)
        {
            if (operation == "/")
            {
                return Divide(num1, num2);
            } else
            {
                //Console.WriteLine("Unknwon operation");
                //return 0;
                throw new ArgumentOutOfRangeException();
            }
        }
    }
}
