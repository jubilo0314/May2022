using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public static class ExtensionDemo
    {
        public static string EvenOrOdd(this int number)
        {
            if (number % 2 == 0)
            {
                return "Even";
            }
            return "Odd";
        }
    }
}
